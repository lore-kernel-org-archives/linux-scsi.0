Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA534C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBDA2240E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKSUU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 15:20:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38381 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKSUU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 15:20:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so25470896wro.5;
        Tue, 19 Nov 2019 12:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5tXeqzlMVuTGdFEOoAu09nVWIO5b7o9Kl36ozXndHXM=;
        b=jjMIax/PlKvhbfjsxZbe+/iFdjvXb5WRPtwFKcqW8xrBjD+akAUnXV6uiNpxQfRB14
         JUtgpR4oda/grO6hDiod/XTmD0ssu7xdb46zefzLidFazvZtuEZiL7gI6vtriaVyxgzI
         H//WtGnPtVpG/wZqpWiHLp+1KzzQSO/0MJOes+DyO8btdPMLpFi5BylG+2aIwl0b0T8B
         pjMgq4QtGqXPnHMEORnUhhfywkrmaZTfs+CCZ8DQoIDqyDZD/hcEmXznnSw4XxcypaY8
         LjOCwC3vbGr3NGCReZFNaIBU6g9nqO8hnPVZh7gmcxtpk5Ksyr+BVFTJBrineB61YXIB
         mEcA==
X-Gm-Message-State: APjAAAUyR4Bu+mhSaFCOi8+7GsiHXEJ4PVqyQieX7dUkoV5THFqEWVXd
        QeZySMSfAsNkr+5HAo4NV7s=
X-Google-Smtp-Source: APXvYqwGBVIAqO199zM/C6FWaUlrX286Oon8sjNZwHjA7eCC+lR3CSqcTRukHg+DExW/GAvtDLBrCw==
X-Received: by 2002:adf:f78c:: with SMTP id q12mr37696704wrp.71.1574194823816;
        Tue, 19 Nov 2019 12:20:23 -0800 (PST)
Received: from localhost.localdomain (2001-1c06-18c6-e000-0168-2a5e-b9ec-4e8e.cable.dynamic.v6.ziggo.nl. [2001:1c06:18c6:e000:168:2a5e:b9ec:4e8e])
        by smtp.gmail.com with ESMTPSA id b14sm4211055wmj.18.2019.11.19.12.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 12:20:23 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH v5 0/2] Some esp_scsi updates
Date:   Tue, 19 Nov 2019 21:20:19 +0100
Message-Id: <20191119202021.28720-1-jongk@linux-m68k.org>
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

Changes since v4:
- Fixed style issues reported by checkpatch.pl

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

 drivers/scsi/esp_scsi.c | 22 +++++++++++++---------
 drivers/scsi/esp_scsi.h | 41 +++++++++++++++++++++++++----------------
 2 files changed, 38 insertions(+), 25 deletions(-)

-- 
2.17.1

