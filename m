Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7BEC77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbjDFLwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbjDFLv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:51:57 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ECCC156;
        Thu,  6 Apr 2023 04:48:12 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id br6so50416418lfb.11;
        Thu, 06 Apr 2023 04:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hL6vKKlAcCQuDQvOTLeI2NShllETqWRBpGOfrTugoHE=;
        b=KNYEPkWJY88K7C6LsCAFeMU/Bvlhh10t+lHq9ZtVvBOMcy1KJOs87tJ79pyIiRsRby
         07IoYafV/iUZhXyGxBANbBXJKz6Q0mZpRY/7MXiooX6hKHrMGJvdBmLAzYtNMUmoWJTw
         ITyEwRZIJjOtTILyr0YLa6laWz69wdKWqwNBweLDRUuXqEIaXG/e7C6rv2+9zldAnaqs
         0Ce5mtwuP8loi678lvjqWcpagIXc3oquRVT+wDleCLWW3CadceVP1Z3nh0NIN2JepeiX
         GjjxHIVoOyC+tEoYHxUAicpjXr7gFjWDHkC028dUGOmxHYcQTH2ozWxLPV0Jg9Yf6ZLy
         U6gA==
X-Gm-Message-State: AAQBX9dm6YuDUYhtVwIX38seMPvc7wEj4pPkjzIXBc7ZpqyqUeV3vdhG
        1CaKID1KRV/rONmCnsiT0w2RMVXPY3mgKQ==
X-Google-Smtp-Source: AKy350aO3QDzj7naWzpDU/C4AYwwRSM1GS2zx2Ehppvte+cCRefYzyj5Qxy/przlCuGs6IJcDKWvsg==
X-Received: by 2002:a2e:86da:0:b0:2a6:16b5:c65b with SMTP id n26-20020a2e86da000000b002a616b5c65bmr3059869ljj.46.1680781125393;
        Thu, 06 Apr 2023 04:38:45 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id q6-20020a2e9146000000b002a5f554d263sm252962ljg.46.2023.04.06.04.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:38:45 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 46DAC666; Thu,  6 Apr 2023 13:38:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781124; bh=VQc2yCNjhXN6NvsuvJhWU3KLSSjWiq7Re2qaCSxBEjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhZFJL3YjrH2snsmGuD/VxR7GfEdHxQd5B7L0VOFHSxfQ+sc3tOHNcyhcJjzjlixn
         2Vy+ncIknGTmSnWYeocHZdDEQNbW8s4LQd5Nje1Br8wBGWz6LSdBObb6lX4L3N+hPk
         WVLzqsucjHdEMtg93VVV7kVi/GGCpkQuvP1U43es=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 23F00944;
        Thu,  6 Apr 2023 13:33:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780791; bh=VQc2yCNjhXN6NvsuvJhWU3KLSSjWiq7Re2qaCSxBEjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpCN8eyX7mKzzcL7neTN23vY0lxAwhEsUfPRXbJILRrIEvlbg2wyChXn4ezMLjZKG
         9p8WxrHAcA846ZFo2mU8UHM+aFmZSI/VV03XKyYLHU7Up9S1odi6qdRdTMi6SIekud
         uk0Oex1kohmRjZIyP0fjlkNTWdj31bkAAsto9h8s=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 07/19] scsi: support service action in scsi_report_opcode()
Date:   Thu,  6 Apr 2023 13:32:36 +0200
Message-Id: <20230406113252.41211-8-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

The REPORT_SUPPORTED_OPERATION_CODES command allows checking for support
of commands that have the same opcode but different service actions,
such as READ 32 and WRITE 32. However, the current implementation of
scsi_report_opcode() only allows checking an operation code without a
service action differentiation.

Add the "sa" argument to scsi_report_opcode() to allow passing a service
action. If a non-zero service action is specified, the reporting
options field value is set to 3 to have the service action field taken
into account by the device. If no service action field is specified
(zero), the reporting options field is set to 1 as before.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c        | 28 +++++++++++++++++++---------
 drivers/scsi/sd.c          | 10 +++++-----
 include/scsi/scsi_device.h |  5 +++--
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 09ef0b31dfc0..62d9472e08e9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -504,18 +504,22 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 }
 
 /**
- * scsi_report_opcode - Find out if a given command opcode is supported
+ * scsi_report_opcode - Find out if a given command is supported
  * @sdev:	scsi device to query
  * @buffer:	scratch buffer (must be at least 20 bytes long)
  * @len:	length of buffer
- * @opcode:	opcode for command to look up
- *
- * Uses the REPORT SUPPORTED OPERATION CODES to look up the given
- * opcode. Returns -EINVAL if RSOC fails, 0 if the command opcode is
- * unsupported and 1 if the device claims to support the command.
+ * @opcode:	opcode for the command to look up
+ * @sa:		service action for the command to look up
+ *
+ * Uses the REPORT SUPPORTED OPERATION CODES to check support for the
+ * command identified with @opcode and @sa. If the command does not
+ * have a service action, @sa must be 0. Returns -EINVAL if RSOC fails,
+ * 0 if the command is not supported and 1 if the device claims to
+ * support the command.
  */
 int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
-		       unsigned int len, unsigned char opcode)
+		       unsigned int len, unsigned char opcode,
+		       unsigned short sa)
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
@@ -539,8 +543,14 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	memset(cmd, 0, 16);
 	cmd[0] = MAINTENANCE_IN;
 	cmd[1] = MI_REPORT_SUPPORTED_OPERATION_CODES;
-	cmd[2] = 1;		/* One command format */
-	cmd[3] = opcode;
+	if (!sa) {
+		cmd[2] = 1;	/* One command format */
+		cmd[3] = opcode;
+	} else {
+		cmd[2] = 3;	/* One command format with service action */
+		cmd[3] = opcode;
+		put_unaligned_be16(sa, &cmd[4]);
+	}
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2de4b27cedc5..2dc4223a4c97 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3057,7 +3057,7 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY, 0) < 0) {
 		struct scsi_vpd *vpd;
 
 		sdev->no_report_opcodes = 1;
@@ -3073,10 +3073,10 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		rcu_read_unlock();
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16, 0) == 1)
 		sdkp->ws16 = 1;
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME, 0) == 1)
 		sdkp->ws10 = 1;
 }
 
@@ -3088,9 +3088,9 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
-			SECURITY_PROTOCOL_IN) == 1 &&
+			SECURITY_PROTOCOL_IN, 0) == 1 &&
 	    scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
-			SECURITY_PROTOCOL_OUT) == 1)
+			SECURITY_PROTOCOL_OUT, 0) == 1)
 		sdkp->security = 1;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c146cc807d44..c93c5aaf637e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -433,8 +433,9 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
-extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
-			      unsigned int len, unsigned char opcode);
+int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
+		       unsigned int len, unsigned char opcode,
+		       unsigned short sa);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
2.39.2

