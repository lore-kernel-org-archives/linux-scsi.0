Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89489CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 20:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjJQUss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344235AbjJQUse (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 16:48:34 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B295F9;
        Tue, 17 Oct 2023 13:48:32 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ba172c5f3dso2822699b3a.0;
        Tue, 17 Oct 2023 13:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697575712; x=1698180512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/amIXBh2OmwTU85hCgujumlTfo/mnD8IJjMcbcGdMyM=;
        b=rivGhzSeZtDCGz+2H4pjclqRkayqC4n7Q3lAH1MuWGXTiwO3oP45FJ0w1ec3RZoEyL
         7Vxvb8qkNSJ3XTA0dGaC4d5qWjdDgN83hN/NaPMnQn+zhTW1JHMIwzoJB9FS2qyyac0D
         koAl5DuGkRIY6Eabhul0QrxCI5Wvzett105B7784zb5iVOyyHvRkdWKCVzdhRhgKQh9l
         KbA4qsWGYYA56T8xO2WM1Qq6+pWE4pEQ8pVxKu9JoDEMQUBhx7uKLgO9vtM+eS2hR4Rn
         m7Tlf6mncNR7MIiD0iwt5Q6HBNXhr0mdojYIBk4v2qaja19v23nDjdgozvUkA1SdRQxv
         43JA==
X-Gm-Message-State: AOJu0YyXu6cQt/5xYs1Vm58i8V3dIKoPMKJlDGJn++T1iEclwMVNI0Ft
        jAAKXI98rLm0gNo0BXifVGI=
X-Google-Smtp-Source: AGHT+IG8H89iYb8bSQyP2l3JUs90G/z/NmytVkTWV1KBTgXA2IhnL3HAGHo39NpzPOiPU/GFHy6KTw==
X-Received: by 2002:a05:6a00:22cb:b0:690:c75e:25d7 with SMTP id f11-20020a056a0022cb00b00690c75e25d7mr3804199pfj.18.1697575711687;
        Tue, 17 Oct 2023 13:48:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8f02:2919:9600:ac09])
        by smtp.gmail.com with ESMTPSA id fa36-20020a056a002d2400b006b2e07a6235sm1874704pfb.136.2023.10.17.13.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 13:48:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 10/14] scsi_debug: Rework page code error handling
Date:   Tue, 17 Oct 2023 13:47:18 -0700
Message-ID: <20231017204739.3409052-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231017204739.3409052-1-bvanassche@acm.org>
References: <20231017204739.3409052-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of tracking whether or not the page code is valid in a boolean
variable, jump to error handling code if an unsupported page code is
encountered.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 88cba9374166..6b87d267c9c5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2327,7 +2327,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
-	bool dbd, llbaa, msense_6, is_disk, is_zbc, bad_pcode;
+	bool dbd, llbaa, msense_6, is_disk, is_zbc;
 
 	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
 	pcontrol = (cmd[2] & 0xc0) >> 6;
@@ -2391,7 +2391,6 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	bad_pcode = false;
 
 	switch (pcode) {
 	case 0x1:	/* Read-Write error recovery page, direct access */
@@ -2406,15 +2405,17 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		if (is_disk) {
 			len = resp_format_pg(ap, pcontrol, target);
 			offset += len;
-		} else
-			bad_pcode = true;
+		} else {
+			goto bad_pcode;
+		}
 		break;
 	case 0x8:	/* Caching page, direct access */
 		if (is_disk || is_zbc) {
 			len = resp_caching_pg(ap, pcontrol, target);
 			offset += len;
-		} else
-			bad_pcode = true;
+		} else {
+			goto bad_pcode;
+		}
 		break;
 	case 0xa:	/* Control Mode page, all devices */
 		len = resp_ctrl_m_pg(ap, pcontrol, target);
@@ -2467,18 +2468,17 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		break;
 	default:
-		bad_pcode = true;
-		break;
-	}
-	if (bad_pcode) {
-		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
-		return check_condition_result;
+		goto bad_pcode;
 	}
 	if (msense_6)
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
 	return fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, offset));
+
+bad_pcode:
+	mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
+	return check_condition_result;
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
