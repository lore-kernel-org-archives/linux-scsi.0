Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19239CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1D0F2089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUsM18tz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502466AbfJRVSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:18:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46589 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390763AbfJRVSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:18:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so4597447pfg.13
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N9ZseVEmM9t+gHHV703eyBm0leXWfFeAgBEe61flxh8=;
        b=iUsM18tz0On52Vy13dRsn3udWnZVdqFnkAIkIvTrwb4SBZWeumztpD6KCywdQCPHkE
         q0DWJ9RtTxtD4z7+b+DMHLCCBONchRoedeKyyG4kZs7WvXcCHIkP4EyB38D98XCvD8x3
         XFGx/2yySNu/3PU28GAzoJNAb4v4m8fJHEGnGrvmKWvGd9TH3NKl+++gFI31vWSzGR3o
         FMJ26WwP4EC1PJjB+sCSIhY65E94XAAAi8dbDuNAYdYOjwrPPD6ngPhSeRvOunKR+tek
         sEo/bF/bit0k71a4b9R1BwmRnqX0WP4TPlz48XBYg8Gzzdrefk4wzisxbResg164bF9T
         ayLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N9ZseVEmM9t+gHHV703eyBm0leXWfFeAgBEe61flxh8=;
        b=aUogy7QTW3CYIWGHi6s98diZR0/19VffGUA0xjc71LPUTUZXRNKKzkxRQ2kxruJ+TQ
         NRpY5Ts/nqxzDdlMM8TaLwv0HpyDBNPFTxFkXQSyw73KHlft9kk5REw6ydpTCKP6uzr/
         e4mdD0uaWXtKPOqBWPsdf2HFFzQwTWnj5k6OJIZcFUwkFIJVSsfWZ07XxndY6Bxn8tuT
         Uido9mmhxSDNKkOGKvRmf7CVl52PGuDbj/0kbXeCK62a8M+lSszDw1aDAWJ7lOKwefkx
         kNczoHg6cvdAA/+dspB59ez4Eb/35D/jCRqfdEzbQenDCAksu8wkhXyiBL1pSiLeuE8S
         h+SA==
X-Gm-Message-State: APjAAAXF8lazjyOYZXmYmIHiqc+1/sshULSwrLW413PIt4vZLjfPcBPk
        83qaTHspKgDKPNvn0CtEf9yNoxwS
X-Google-Smtp-Source: APXvYqzsZAZdRkqIsBz0ygRdMeK1nAWPNsaIE5lOWGjLFamjB8PEQGJy5GF0Oo3XdhUgYUq+uuMlrg==
X-Received: by 2002:a17:90a:ac06:: with SMTP id o6mr13548270pjq.133.1571433533054;
        Fri, 18 Oct 2019 14:18:53 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.18.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:18:52 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/16] lpfc: Fix reporting of read-only fw error errors
Date:   Fri, 18 Oct 2019 14:18:18 -0700
Message-Id: <20191018211832.7917-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the adapter FW is administratively set to
RO mode, a FW update triggered by the driver's sysfs
attribute will fail. Currently, the driver's logging
mechanism does not properly parse the adapter return
codes and print a meaningful message.  This oversite
prevents quick diagnosis in the field.

Parse the adapter return codes for Write_Object
and write an appropriate message to the system console.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 69 ++++++++++++++++++++++++++++++-------------
 2 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 6095e3cfddd3..1cd3016f7783 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2320,6 +2320,7 @@ struct lpfc_mbx_redisc_fcf_tbl {
 #define ADD_STATUS_OPERATION_ALREADY_ACTIVE		0x67
 #define ADD_STATUS_FW_NOT_SUPPORTED			0xEB
 #define ADD_STATUS_INVALID_REQUEST			0x4B
+#define ADD_STATUS_FW_DOWNLOAD_HW_DISABLED              0x58
 
 struct lpfc_mbx_sli4_config {
 	struct mbox_header header;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d2cb3b0d1849..1d14aa22f973 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12320,35 +12320,57 @@ lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba)
 }
 
 
-static void
+static int
 lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	uint32_t magic_number, uint32_t ftype, uint32_t fid, uint32_t fsize,
 	const struct firmware *fw)
 {
-	if ((offset == ADD_STATUS_FW_NOT_SUPPORTED) ||
+	int rc;
+
+	/* Three cases:  (1) FW was not supported on the detected adapter.
+	 * (2) FW update has been locked out administratively.
+	 * (3) Some other error during FW update.
+	 * In each case, an unmaskable message is written to the console
+	 * for admin diagnosis.
+	 */
+	if (offset == ADD_STATUS_FW_NOT_SUPPORTED ||
 	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
 	     magic_number != MAGIC_NUMER_G6) ||
 	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC &&
-	     magic_number != MAGIC_NUMER_G7))
+	     magic_number != MAGIC_NUMER_G7)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3030 This firmware version is not supported on "
-			"this HBA model. Device:%x Magic:%x Type:%x "
-			"ID:%x Size %d %zd\n",
-			phba->pcidev->device, magic_number, ftype, fid,
-			fsize, fw->size);
-	else
+				"3030 This firmware version is not supported on"
+				" this HBA model. Device:%x Magic:%x Type:%x "
+				"ID:%x Size %d %zd\n",
+				phba->pcidev->device, magic_number, ftype, fid,
+				fsize, fw->size);
+		rc = -EINVAL;
+	} else if (offset == ADD_STATUS_FW_DOWNLOAD_HW_DISABLED) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3021 Firmware downloads have been prohibited "
+				"by a system configuration setting on "
+				"Device:%x Magic:%x Type:%x ID:%x Size %d "
+				"%zd\n",
+				phba->pcidev->device, magic_number, ftype, fid,
+				fsize, fw->size);
+		rc = -EACCES;
+	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3022 FW Download failed. Device:%x Magic:%x Type:%x "
-			"ID:%x Size %d %zd\n",
-			phba->pcidev->device, magic_number, ftype, fid,
-			fsize, fw->size);
+				"3022 FW Download failed. Add Status x%x "
+				"Device:%x Magic:%x Type:%x ID:%x Size %d "
+				"%zd\n",
+				offset, phba->pcidev->device, magic_number,
+				ftype, fid, fsize, fw->size);
+		rc = -EIO;
+	}
+	return rc;
 }
 
-
 /**
  * lpfc_write_firmware - attempt to write a firmware image to the port
  * @fw: pointer to firmware image returned from request_firmware.
- * @phba: pointer to lpfc hba data structure.
+ * @context: pointer to firmware image returned from request_firmware.
+ * @ret: return value this routine provides to the caller.
  *
  **/
 static void
@@ -12417,8 +12439,12 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 			rc = lpfc_wr_object(phba, &dma_buffer_list,
 				    (fw->size - offset), &offset);
 			if (rc) {
-				lpfc_log_write_firmware_error(phba, offset,
-					magic_number, ftype, fid, fsize, fw);
+				rc = lpfc_log_write_firmware_error(phba, offset,
+								   magic_number,
+								   ftype,
+								   fid,
+								   fsize,
+								   fw);
 				goto release_out;
 			}
 		}
@@ -12438,9 +12464,12 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	}
 	release_firmware(fw);
 out:
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3024 Firmware update done: %d.\n", rc);
-	return;
+	if (rc < 0)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3062 Firmware update error, status %d.\n", rc);
+	else
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3024 Firmware update success: size %d.\n", rc);
 }
 
 /**
-- 
2.13.7

