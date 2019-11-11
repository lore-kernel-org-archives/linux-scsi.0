Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E57C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 13:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 170C121E6F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 13:30:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=flameeyes-com.20150623.gappssmtp.com header.i=@flameeyes-com.20150623.gappssmtp.com header.b="eTG15Tw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfKKNaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 08:30:10 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52716 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKNaK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 08:30:10 -0500
Received: by mail-wm1-f67.google.com with SMTP id l1so1954424wme.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 05:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flameeyes-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HzxvEi6Bk6bzXwQBcp50lpBIe7VqgZxWgLfoyh6spOs=;
        b=eTG15Tw+1hSt4y3QcOB5KjixQtrKzMmCS4jYTILkhMOMGvhVsB7ik1O/kXAbtNQ6bO
         qF0BvazaU6y88KlCGqeNu+NjkexbyaNFbOUmqisJSWStAQrGYD6mjp6XGmBtJZ3Z9DtK
         3CkS2gGtX8fHXfUNlvv9M1clxD88PpltQWl2Cn1dizpzs9rq+Doaz/F+DFiqbRb9kjEH
         Ma2Cfx6MIA7SMKGDXEDUyH1uUWVsvd67vqGf0+6yn2+xojf3kXlwnwq+dW4oUd1Rll92
         klmPNBj6pMhGWFNbztoa2ZHQCRH5HLsKSd3CDjfY7EePRYQG26nOGhBpRbmjBhVJuRIo
         o+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HzxvEi6Bk6bzXwQBcp50lpBIe7VqgZxWgLfoyh6spOs=;
        b=i4O8uPRKBrf3jaSWnCskbj1qIB+inEA8Rrlk8EwbdyRYrvOu4Jltk0IGSmxv2l47hE
         YLAupqH3P5EJcTaBLSjmc9TJRgYtZFwEHwPqc2a4xm+hHdKnsIMEjn8TCHWsw2crUm0Y
         DGkZ7W2SIM4MbuoyJwoONwY6Zhv2xeJE/tr2icBe7Xm4ZJQNubbfo0CP3aB7H3gi9azB
         AKkhzZlBMv2jFbkNIMxWKWbcO7Df/1Rf8zPlBVkVNsZZdJ+0LyCOMTdopjcQDEGK1+pv
         E9af7Ix23XGhFY+zeT+n2vo1HypBvsZpHXE3xjM+OaOycteSCaKt7Mh/80aK8x0TLNbS
         SDDw==
X-Gm-Message-State: APjAAAUrSxe3Wr86gfaG70UoxCg6+jRLUUKLZCZdAPPEKxyjW+NEzpwj
        5w7QoJpyBPniAyjr/bSsbWM6dQ==
X-Google-Smtp-Source: APXvYqxBMqOxzZ2o5h3827vN719sV8U1/jPkIyfh3BHycTEpT+koWsiJndW0pu2sNQGLsMrRqMe/pQ==
X-Received: by 2002:a1c:98c5:: with SMTP id a188mr20630107wme.133.1573479007641;
        Mon, 11 Nov 2019 05:30:07 -0800 (PST)
Received: from localhost ([2a01:4b00:80c6:1000:283d:d5ff:fee6:36c5])
        by smtp.gmail.com with ESMTPSA id b14sm21725471wmj.18.2019.11.11.05.30.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:30:06 -0800 (PST)
From:   =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] cdrom: support Beurer GL50 evo CD-on-a-chip devices.
Date:   Mon, 11 Nov 2019 13:29:55 +0000
Message-Id: <20191111132955.19361-1-flameeyes@flameeyes.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Beurer GL50 evo uses a Cygnal/Cypress-manufactured CD-on-a-chip that
only accepts a subset of SCSI commands.

Most of the not-implemented commands are fine to fail, but a few,
particularly around the MMC or Audio commands, will put the device into an
unrecoverable state, so they need to be avoided at all costs.

In addition to adding a new vendor entry to sr_vendor, this required gating
a few functions in the cdrom driver to not even try sending the command
when the capability is not present.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
---
 drivers/cdrom/cdrom.c    | 13 ++++++++++++-
 drivers/scsi/sr_vendor.c | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index ac42ae4651ce..2391b5dd36a9 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -996,6 +996,12 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 	tracks->xa = 0;
 	tracks->error = 0;
 	cd_dbg(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
+
+	if (!CDROM_CAN(CDC_PLAY_AUDIO)) {
+		tracks->error = CDS_NO_INFO;
+		return;
+	}
+
 	/* Grab the TOC header so we can see how many tracks there are */
 	ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header);
 	if (ret) {
@@ -1162,7 +1168,9 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 		ret = open_for_data(cdi);
 		if (ret)
 			goto err;
-		cdrom_mmc3_profile(cdi);
+		if (CDROM_CAN(CDC_GENERIC_PACKET)) {
+			cdrom_mmc3_profile(cdi);
+		}
 		if (mode & FMODE_WRITE) {
 			ret = -EROFS;
 			if (cdrom_open_write(cdi))
@@ -2882,6 +2890,9 @@ int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
 	   it doesn't give enough information or fails. then we return
 	   the toc contents. */
 use_toc:
+	if (!CDROM_CAN(CDC_PLAY_AUDIO))
+		return -ENOSYS;
+
 	toc.cdte_format = CDROM_MSF;
 	toc.cdte_track = CDROM_LEADOUT;
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc)))
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index e3b0ce25162b..b5e76869d473 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -61,6 +61,7 @@
 #define VENDOR_NEC             2
 #define VENDOR_TOSHIBA         3
 #define VENDOR_WRITER          4	/* pre-scsi3 writers */
+#define VENDOR_CYGNAL_85ED     5	/* CD-on-a-chip */
 
 #define VENDOR_TIMEOUT	30*HZ
 
@@ -99,6 +100,23 @@ void sr_vendor_init(Scsi_CD *cd)
 	} else if (!strncmp(vendor, "TOSHIBA", 7)) {
 		cd->vendor = VENDOR_TOSHIBA;
 
+	} else if (!strncmp(vendor, "Beurer", 6) &&
+		   !strncmp(model, "Gluco Memory", 12)) {
+		/* The Beurer GL50 evo uses a Cygnal/Cypress-manufactured
+		   CD-on-a-chip that only accepts a subset of SCSI commands.
+		   Most of the not-implemented commands are fine to fail, but a
+		   few, particularly around the MMC or Audio commands, will put
+		   the device into an unrecoverable state, so they need to be
+		   avoided at all costs.
+		*/
+		cd->vendor = VENDOR_CYGNAL_85ED;
+		cd->cdi.mask |= (
+			CDC_MULTI_SESSION |
+			CDC_CLOSE_TRAY | CDC_OPEN_TRAY |
+			CDC_LOCK |
+			CDC_GENERIC_PACKET |
+			CDC_PLAY_AUDIO
+			);
 	}
 #endif
 }
-- 
2.23.0

