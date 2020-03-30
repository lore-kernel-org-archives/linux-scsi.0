Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED79C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 02:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E2D20675
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 02:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgC3CxL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Mar 2020 22:53:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45235 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728965AbgC3CxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2020 22:53:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id o26so7988783pgc.12
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2020 19:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ed6KxoBuNDpMkBKLWE4/6ll+bjGd88UTmsx5xf4g7e0=;
        b=XVaNiKp0c84RJBUEQbVaEW5hBpPx+eHvNVs4Tx/ggl+yCa7BcAebQt/meh7a5n29Qz
         5mHUCfgIgnRQ4MFqO8lUWktfmUHg5eb2t9svv4ej5rEtVvH3CaNYhtqRG7kJ8BYGzHCT
         AWzG2WagFF8dD00obT8qtrzsgxaZf5r1xl+CvRVzJOpTLkX+MnxV2JYf8Xi440spOJUl
         JpxNmbYzGAb+1cZG33bD3jhRlOTvltV5uP+Vdc+lsRaupLeYfkwp57VSsUM8QRTU4GkH
         wOQ+inadLJ1RYQKCU6Lnx02+Qhpj8fQcAHzOAMtrupAulqtvnMTSBs3cS4Dqe/6M4TBG
         vbgw==
X-Gm-Message-State: AGi0PuYYX6R1W/AkNaSYeWfV9cHXq2Beb22gyy2+jS0SY3/7GexD6SgQ
        KTqi3h+cTWeilLrZNZooidk=
X-Google-Smtp-Source: APiQypJnMk/yI/cc9Tw0goTXBf1J7UfUzzMW+fPmtqCcngQUwOw8Qj+KHcgDnkl1pHnaaBBs0VSQUg==
X-Received: by 2002:a65:498c:: with SMTP id r12mr2351553pgs.14.1585536789769;
        Sun, 29 Mar 2020 19:53:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1d21:aef6:5c03:df86])
        by smtp.gmail.com with ESMTPSA id k70sm8517344pga.91.2020.03.29.19.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 19:53:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] sr: Fix a recently introduced W=1 compiler warning
Date:   Sun, 29 Mar 2020 19:53:04 -0700
Message-Id: <20200330025304.10743-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following compiler warning:

drivers/scsi/sr.c:686:12: warning: initialized field overwritten [-Woverride-init]
  686 |  .ioctl  = sr_block_compat_ioctl,
      |            ^~~~~~~~~~~~~~~~~~~~~
drivers/scsi/sr.c:686:12: note: (near initialization for 'sr_bdops.ioctl')

Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: d320a9551e39 ("compat_ioctl: scsi: move ioctl handling into drivers")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fe0e1c721a99..9ad57a98a37f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -556,6 +556,7 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
 	mutex_unlock(&cd->lock);
 }
 
+#ifndef CONFIG_COMPAT
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			  unsigned long arg)
 {
@@ -597,8 +598,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	mutex_unlock(&cd->lock);
 	return ret;
 }
-
-#ifdef CONFIG_COMPAT
+#else /* !defined(CONFIG_COMPAT) */
 static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			  unsigned long arg)
 {
@@ -641,7 +641,7 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 	return ret;
 
 }
-#endif
+#endif /* !defined(CONFIG_COMPAT) */
 
 static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
@@ -685,8 +685,9 @@ static const struct block_device_operations sr_bdops =
 	.owner		= THIS_MODULE,
 	.open		= sr_block_open,
 	.release	= sr_block_release,
+#ifndef CONFIG_COMPAT
 	.ioctl		= sr_block_ioctl,
-#ifdef CONFIG_COMPAT
+#else
 	.ioctl		= sr_block_compat_ioctl,
 #endif
 	.check_events	= sr_block_check_events,
