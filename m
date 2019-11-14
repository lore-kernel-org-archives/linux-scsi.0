Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3272AC43141
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12EB0206E6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKNWAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:00:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33523 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNWAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 17:00:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so8603894wrr.0;
        Thu, 14 Nov 2019 14:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2nYHXbijHGGR0BEIUAptugfBefq3eYjRCYDcXRkf1SM=;
        b=Rw0GhS8JxD3W8Ec+9Z9A5HuC2DTsYFAdQe3A0PLTlwXesNO798dPOfYDD3iyRgBh8P
         lTxz4M3bpRPnzREYy+Xu5vk6Zmi7TsHoQHGZueBokCIY7ao7sKJDhSTgfl64IWncSg/K
         xG4DiVyC2Lu88NlFY9bI4NtvQo+IX1fZK8lyuZUZAOSU9Oibcmac6i2NqE0hz48F7KkP
         LS6fXq7r91hfqvCQrEXUlByOKOgJomkN/96oaNNTQpt4pHbOKVdAliUf+QvLOmhk2NeE
         QUQz9YOAW58LioNleL/7sjajPOJ1r1eMPvy6orD0vZr17EBXpZmHCmM/KBUyWZyJZPH1
         NQuA==
X-Gm-Message-State: APjAAAXnKYeTeky7yxYhrAmk2jRASR+xII5SOd8e4f+6xZdzwO+k2xjw
        doXJJmtc0pjmbIS+mExDVh8atESv6Wg=
X-Google-Smtp-Source: APXvYqzeIrdQIW5QA3Y3RCax0IN4li6GTPwh4UVKG94qf7uCzBKRb47a1U6+NoICQ2JYMN+o9HPJkQ==
X-Received: by 2002:adf:dc90:: with SMTP id r16mr11569089wrj.258.1573768808234;
        Thu, 14 Nov 2019 14:00:08 -0800 (PST)
Received: from localhost.localdomain (2001-1c06-18c6-e000-0cda-4949-05a4-23b4.cable.dynamic.v6.ziggo.nl. [2001:1c06:18c6:e000:cda:4949:5a4:23b4])
        by smtp.gmail.com with ESMTPSA id x11sm8764771wro.84.2019.11.14.14.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 14:00:07 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH v2 0/2] Some esp_scsi updates
Date:   Thu, 14 Nov 2019 22:59:53 +0100
Message-Id: <20191114215956.21767-1-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112185710.23988-1-jongk@linux-m68k.org>
References: <20191112185710.23988-1-jongk@linux-m68k.org>
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

Then I also discovered that the definition for the PCSCSI chip was in the wrong
place of the enum. It will probably have issues with FAST-10 SCSI targets,
because its CONFIG3 settings are wrong.

The first patch fixes this, and adds comments to the enum to hopefully prevent
this from happening again.

When discussing this on the Linux/m68k mailing list, it was suggested to
perhaps replace the dependency on ordering of the esp_rev enum by feature flags.
I did not implement this for now.

Changes since v1:
- Removed confusing comments from esp_rev enum
- Remove unneeded definitions for UID register
- Remove unneeded local uid variable

Kars de Jong (2):
  esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
  esp_scsi: Add support for FSC chip

 drivers/scsi/esp_scsi.c | 21 +++++++++++--------
 drivers/scsi/esp_scsi.h | 45 ++++++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 24 deletions(-)

-- 
2.17.1

