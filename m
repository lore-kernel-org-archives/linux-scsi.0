Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B710FC43141
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98CF2222B6
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKSUIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 15:08:20 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55713 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfKSUIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 15:08:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so4603298wmb.5;
        Tue, 19 Nov 2019 12:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=et8ruKE6tdEQ+GnFJXyGSNLAQ+fnsnbu7vqzhtbpQpE=;
        b=cQT50DosYWvd1IaK3E6fD5ZyccuZ2odjARQ7fzEBUWqKAZvBTkjmIa54sFL4+mRHKd
         8wgQJT/IcXNgbfuec42ZDifazjv75eMRD5BU/23QMjP/RQ0aBp+XnD+/E7flyuMweUCM
         lJ2sZN6YXFWIESGXayJfeJX+tBJP3Q6IFGW6f1s+pfdjZMYKhuANAobd15JwdQPC/GqJ
         Ok1JArKg7u2/VrqC4v7j/mAnc0yBu4BeeXMdFQkn/sSWKrKN+t1MqUT52Yx7Ce1Nwv6+
         AeAreiEZDkXMmO2k4zsh0xuMFMaPVsqZ6dGO6Pse07ynBVbAIjFDc7Y5qXSJB+gpPAZF
         t16g==
X-Gm-Message-State: APjAAAWGej+OYm/YoI9ZOuagVylKiyOgfiyrGVtsndkxB/b3dKeRBgLm
        dQencXCgYL/IkoA3O4WB/AA=
X-Google-Smtp-Source: APXvYqwK0zvIuu1Ep3N+/WHJJ78XGFxLAH3fcKxIZ5Zz16Jq2a4nJ0Qe9Y/9M9IUvHJH7vkn4Yrx2g==
X-Received: by 2002:a05:600c:218c:: with SMTP id e12mr8022392wme.30.1574194097313;
        Tue, 19 Nov 2019 12:08:17 -0800 (PST)
Received: from localhost.localdomain (2001-1c06-18c6-e000-0168-2a5e-b9ec-4e8e.cable.dynamic.v6.ziggo.nl. [2001:1c06:18c6:e000:168:2a5e:b9ec:4e8e])
        by smtp.gmail.com with ESMTPSA id q5sm4114445wmc.27.2019.11.19.12.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 12:08:16 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH v4 0/2] Some esp_scsi updates
Date:   Tue, 19 Nov 2019 21:08:03 +0100
Message-Id: <20191119200805.28319-1-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When trying kernel 5.4.0-rc5 on my Amiga, I experienced data transfer failures
when reading from my FAST-10 SCSI disk. I have a Blizzard 12x0 IV SCSI
controller which uses a Symbios Logic SYM53CF94-2 "FSC" chip.

This used to work with the old generic NCR53C9x driver, so I investigated the
issue.

It turned out to be caused by lacking detection of FSC silicon in the new
driver.

The second patch in this series adds support for the FSC.

When adding support for the chip, I found out the hard way that the esp_rev
enum is ordered (I just added it to the end of the enum).

Then I also discovered that the definition for the PCSCSI chip was in the
wrong place of the enum. It will probably have issues with FAST-10 SCSI
targets, because its CONFIG3 settings are wrong.

The first patch fixes this, and adds comments to the enum to hopefully prevent
this from happening again.

When discussing this on the Linux/m68k mailing list, it was suggested to
perhaps replace the dependency on ordering of the esp_rev enum by feature flags.
I did not implement this for now.

Changes since v3:
- Reduce scope of family_code variable
- Remove some redundant comments
- Explicitly show the NCR/Symbios Logic part code instead of FSC, which is
  only used in the data manual

Changes since v2:
- Fixed merge conflict in second patch

Changes since v1:
- Removed confusing comments from esp_rev enum
- Remove unneeded definitions for UID register
- Remove unneeded local uid variable

Kars de Jong (2):
  esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
  esp_scsi: Add support for FSC chip

 drivers/scsi/esp_scsi.c | 20 +++++++++++---------
 drivers/scsi/esp_scsi.h | 41 +++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 25 deletions(-)

-- 
2.17.1

