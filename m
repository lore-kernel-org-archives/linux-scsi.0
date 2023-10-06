Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB3BE81DF4
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 12:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjJFMzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbjJFMzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 08:55:02 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70665D6;
        Fri,  6 Oct 2023 05:55:00 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9b64b98656bso364999366b.0;
        Fri, 06 Oct 2023 05:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696596899; x=1697201699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvlLVhV61yey8O8YpbEqG2hEVjESCumTPs4mXO+vIE0=;
        b=Q+JD/vVv6FQnbQ+Ayo7EBpkxEgAkFpuHB7d2F1/Q17TYXxiTvlAXXqM4FuvRnM4vfE
         wvRP1oRjiN12I0CljIwfSkwktd1Wb3rw5ms3mzCgm25bloDe1WrVObPRmP58EQ+srj6f
         zzdqYbEYlbDwBDUyKjl2BZG45WhnVc5OUHSnSOD9GnuzSn9eiX7I+tBcFcdSInW6jYXN
         uSjlvMdCOy9Il3dePctAlolXzuirMbNQQchds0somXlTp/bc+8ituIOjoTdY5CMnOYrg
         iSuzCB4Jlmyg+1/VfwFbvrgGzB+fG0thWfzLVhdlyPXx1bm13mD/qh29jAWL5tcBrIWE
         2xTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696596899; x=1697201699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JvlLVhV61yey8O8YpbEqG2hEVjESCumTPs4mXO+vIE0=;
        b=vXGYYomkiS+q4jT6NaUzGo80Va0bksd3AzudQA6K+lkjA7wkuTmqNyKpb3Lwu2LI0n
         l0n3nDnoJKeUuEuKeY5makUsh+yoPUAX6V8lMntaoFNYdn6SqBqHxNjYVIfXXu+GAWm0
         b64Wnvdse3jdSe6ltAsVvmyFh+4Uo6lOYbw3eHPTas71FePHaSmMr+vzWVYzsSV4XELq
         UNRA2dNnPC50ulv8dUPeRwQfT0Ca1N/bvk6m1XKha2nf6+BadhYtIFTwPS8dGVI43kAb
         oOrUckW5/w2hNZETjfTn78x/I9Nc3o+vBSKyLCIJglowmFe72Nmld4tEbH+oLoQ8jQoS
         TLnA==
X-Gm-Message-State: AOJu0Ywn7VaM42NYDq7xZGuzjPWTCSj3uRFmL6UnSFejPlanb+vr+eqF
        XjWzaT5jMPL2ouhXzYKDnXCeGe+l4RVCrg==
X-Google-Smtp-Source: AGHT+IG2DczT846X90UrkoQRLIR8aD+eEYxqRpvEe0St1vVFd5QVZDc6TeKn/2cRHHcxpBsoSArQOQ==
X-Received: by 2002:a17:906:5349:b0:9b2:8b14:7a20 with SMTP id j9-20020a170906534900b009b28b147a20mr7520029ejo.45.1696596898716;
        Fri, 06 Oct 2023 05:54:58 -0700 (PDT)
Received: from sauvignon.fi.muni.cz (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709060dda00b0099bc08862b6sm2894660eji.171.2023.10.06.05.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 05:54:58 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com, jonathan.derrick@linux.dev,
        Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 5/6] usb-storage,uas,scsi: allow to pass through security commands (OPAL)
Date:   Fri,  6 Oct 2023 14:54:44 +0200
Message-ID: <20231006125445.122380-6-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231006125445.122380-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch enables pass-through OPAL command for USB-attached storage
(which does not support UAS or SCSI security commands).
All common USB/SATA or USB/NVMe adapters I tested need this patch.

USB mass storage devices that do not support SECURITY IN/OUT SCSI
commands can support ATA12 pass-thru command.

Internal kernel implementation for OPAL interface currently supports
only SCSI SECURITY IN/OUT wrapper.
USB mass storage also turns off SCSI command enumeration, so SECURITY
IN/OUT in the SCSI layer will be disabled.

Note: sedutils and some other OPAL tools already use ATA-12 pass-thru.

This patch
 - enables SCSI security flag for USB mass storage and UAS device by default.

 - adds an optional wrapper to the SCSI layer for the ATA-12 pass-thru
   command as an alternative if SECURITY IN/OUT is unavailable.

In short, the patch runs these steps:
  1) USB drives (mass-storage, UAS) enables security driver flag by default
     if not disabled by quirk
  2) SCSI device enumerates SECURITY IN/OUT support. If detected,
     SECURITY ON/OUT wrapper is used (as in the current code).
     If not, new ATA12 pass-thru wrapper is used instead.
  3) SED OPAL code tries OPAL discovery command for device. If it receives
     correct reply, OPAL is enabled for the device.

With the changes above, the TCG OPAL support works with USB adapters
that support the ATA-12 command. As kernel OPAL code runs discover
commands on initialization, on devices that do not support pass-through,
OPAL remains disabled.

The patch also adds a quirk flag to disable security commands for particular
devices if firmware is buggy.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/scsi/sd.c              | 33 +++++++++++++++++++++++++++++++--
 drivers/usb/storage/scsiglue.c |  4 ++++
 drivers/usb/storage/uas.c      |  5 +++++
 drivers/usb/storage/usb.c      |  5 ++++-
 include/linux/usb_usual.h      |  2 ++
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 83b6a3f3863b..3782556cb461 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -686,6 +686,32 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 			       &exec_args);
 	return ret <= 0 ? ret : -EIO;
 }
+
+static int sd_ata12_submit(void *data, u16 spsp, u8 secp, void *buffer,
+		size_t len, bool send)
+{
+	struct scsi_disk *sdkp = data;
+	struct scsi_device *sdev = sdkp->device;
+	u8 cdb[12] = { 0, };
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+	};
+	int ret;
+
+	cdb[0] = ATA_12;
+	cdb[1] = (send ? 5 /* ATA_PROTOCOL_PIO_DATA_IN */ : 4 /* ATA_PROTOCOL_PIO_DATA_OUT */) << 1;
+	cdb[2] = 2 /* t_length */ | (1 << 2) /* byt_blok */ | ((send ?  0 : 1) << 3) /* t_dir */;
+	cdb[3] = secp;
+	put_unaligned_le16(len / 512, &cdb[4]);
+	put_unaligned_le16(spsp, &cdb[6]);
+	cdb[9] = send ? 0x5e /* ATA_CMD_TRUSTED_SND */: 0x5c /* ATA_CMD_TRUSTED_RCV */;
+
+	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			       buffer, len, SD_TIMEOUT, sdkp->max_retries,
+			       &exec_args);
+	return ret <= 0 ? ret : -EIO;
+}
+
 #endif /* CONFIG_BLK_SED_OPAL */
 
 /*
@@ -3699,8 +3725,11 @@ static int sd_probe(struct device *dev)
 		goto out;
 	}
 
-	if (sdkp->security) {
-		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
+	if (sdp->security_supported) {
+		if (sdkp->security)
+		    sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
+		else
+		    sdkp->opal_dev = init_opal_dev(sdkp, &sd_ata12_submit);
 		if (sdkp->opal_dev)
 			sd_printk(KERN_NOTICE, sdkp, "supports TCG Opal\n");
 	}
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
index f6e293daabf4..9dfe8ea20134 100644
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
index f3a53c3eeb45..04211ac803e4 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -478,7 +478,7 @@ void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
 			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
-			US_FL_ALWAYS_SYNC);
+			US_FL_ALWAYS_SYNC | US_FL_IGNORE_OPAL);
 
 	p = quirks;
 	while (*p) {
@@ -567,6 +567,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
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

