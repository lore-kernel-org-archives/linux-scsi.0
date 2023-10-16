Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EF7CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 07:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjJPH0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 03:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjJPH0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 03:26:24 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB02E3;
        Mon, 16 Oct 2023 00:26:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9b1ebc80d0aso644385566b.0;
        Mon, 16 Oct 2023 00:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697441178; x=1698045978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKEonLkFv7flAIkFjaxuLAbAMwome4P+GcLKsO3pvRg=;
        b=LkHVELcENYEuD66PF4as0i61MUwXe0vYHeWRMDUalDBkgA6EF9TKG1Ps+hJLp+t1fd
         Wk7lQan00yKW9soXGBwxdHrMBvakt1YvH41Hf7XJL/cPOWJ1ewFtx6cpecddTWmh0pq9
         Z+zibzdGR/G0JpPFwa+oHfhWcS6Z+pqkV3D+vYvLtxLu1tC5GciA0TBwwlducEXbxXbJ
         lmFYGaa5m120idt7FIIzaMyP+9nJmYefNOSl792f2nN2/24mTgtgk9RRUbU64OzCFM1n
         fu6rvtDK0gCHxKYPFpw20khSWKgQJM85A0RqzUma4ElAZa2yF9suF4rL18KTh7UKTjHn
         TAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697441178; x=1698045978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AKEonLkFv7flAIkFjaxuLAbAMwome4P+GcLKsO3pvRg=;
        b=MFuiHyod/aaYqii15qvf5ORWnrOOrRgzTDmP2MHDpRaOodost8WKsfy4ngp0B3j9uc
         d77cQGfbZJy19jcCmOOE1LMuxkQApjZzmYuZFu5aekny4nH5Jcb6/Eh/c/Kg2/UnRXFJ
         9MiaDmAA0VUWen4JnYZkwp7fE3sME2WcmQ24ZqOsNT/jtrITOuLahJB0g0YOj4HNjBst
         5jGj8FgNrWfGOgC+AbAZ+vDnIbZ325sY2m4/j6z/7o96e5ZxiuvNaPHhBmnfGB2YqaiW
         PWUyi0yV58ss/eZOG+owGMKHZNqAoY0rBnim6TGctLCmqn+i9iwPCNG7Wu10fhGH3HlR
         scNw==
X-Gm-Message-State: AOJu0YxC7itaSf6EeLmYki0KRo7li74UUDFP2e+0tF3A8Y3VA/wPNHKG
        sE30uhJcFQlBdMR2uw3TP34hqdTkP9IXVQ==
X-Google-Smtp-Source: AGHT+IHdmnwLce4qtarN1rGmGRlcyujEaX4lm1wqfQv8yqEMT6/tV7Pw2rgJvyZae9i6xgGyA9fHVg==
X-Received: by 2002:a17:906:db08:b0:9bd:bb63:49db with SMTP id xj8-20020a170906db0800b009bdbb6349dbmr7432298ejb.7.1697441178436;
        Mon, 16 Oct 2023 00:26:18 -0700 (PDT)
Received: from sauvignon.fi.muni.cz ([2001:718:801:22c:bdcb:518:be8f:6a76])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090673d900b0099297782aa9sm3399980ejl.49.2023.10.16.00.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 00:26:18 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        oneukum@suse.com, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 6/7] usb-storage,uas: enable security commands for USB-attached storage
Date:   Mon, 16 Oct 2023 09:26:03 +0200
Message-ID: <20231016072604.40179-7-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016072604.40179-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch enables security commands (currently mostly OPAL hardware
encryption) for UAS and usb-storage drivers.

The SCSI layer uses security commands for the initial OPAL support
check (discovery command) and for in-kernel sed-ioctl interface.

Some adapters support these commands, but firmware can be buggy or
implemented incorrectly; the patch also adds a new quirk IGNORE_OPAL
to disable security commands for particular devices.

If adapters do not implement needed commands (ATA-12 pass-thru),
the commands are rejected, and OPAL support remains disabled.
(This is how it already works if OPAL command is sent from userspace
directly, like in sedutils.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 ++
 drivers/usb/storage/scsiglue.c                  | 4 ++++
 drivers/usb/storage/uas.c                       | 5 +++++
 drivers/usb/storage/usb.c                       | 5 ++++-
 include/linux/usb_usual.h                       | 2 ++
 5 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0a1731a0f0ef..e3f072cbb833 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6885,6 +6885,8 @@
 				y = ALWAYS_SYNC (issue a SYNCHRONIZE_CACHE
 					even if the device claims no cache,
 					not on uas)
+				z = IGNORE_OPAL (the device security commands
+					(OPAL) are broken, do not enable them);
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
 	user_debug=	[KNL,ARM]
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index c54e9805da53..ef93813a2049 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -209,6 +209,10 @@ static int slave_configure(struct scsi_device *sdev)
 		/* Do not attempt to use WRITE SAME */
 		sdev->no_write_same = 1;
 
+		/* Allow security commands (OPAL) passthrough */
+		if (!(us->fflags & US_FL_IGNORE_OPAL))
+			sdev->security_supported = 1;
+
 		/*
 		 * Some disks return the total number of blocks in response
 		 * to READ CAPACITY rather than the highest block number.
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 8a1c4449dcc9..8967767d6753 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -865,6 +865,11 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	/* Some disks cannot handle WRITE_SAME */
 	if (devinfo->flags & US_FL_NO_SAME)
 		sdev->no_write_same = 1;
+
+	/* Allow security commands (OPAL) passthrough */
+	if (!(devinfo->flags & US_FL_IGNORE_OPAL))
+		sdev->security_supported = 1;
+
 	/*
 	 * Some disks return the total number of blocks in response
 	 * to READ CAPACITY rather than the highest block number.
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index bb48ab1bd461..3facc80292d7 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -477,7 +477,7 @@ void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
 			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
-			US_FL_ALWAYS_SYNC);
+			US_FL_ALWAYS_SYNC | US_FL_IGNORE_OPAL);
 
 	p = quirks;
 	while (*p) {
@@ -566,6 +566,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
 		case 'y':
 			f |= US_FL_ALWAYS_SYNC;
 			break;
+		case 'z':
+			f |= US_FL_IGNORE_OPAL;
+			break;
 		/* Ignore unrecognized flag characters */
 		}
 	}
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 712363c7a2e8..0181c94d7d91 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -88,6 +88,8 @@
 		/* Cannot handle WRITE_SAME */			\
 	US_FLAG(SENSE_AFTER_SYNC, 0x80000000)			\
 		/* Do REQUEST_SENSE after SYNCHRONIZE_CACHE */	\
+	US_FLAG(IGNORE_OPAL, 0x100000000)			\
+		/* Security commands (OPAL) are broken */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.42.0

