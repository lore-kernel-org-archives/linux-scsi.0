Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04641C4CEC7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5BB1206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YkDGVD2z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387523AbfIMNFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35449 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfIMNFE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id s17so8307162plp.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m5BxlXXWVtoXchtDeVJ0hdDUs/0oB6T6ue8zThb29qU=;
        b=YkDGVD2zWs+j7Jlv/vKt6/PQ8BwxSK6dobOdcMq0DhNB1W4Pkd00woUQZh6v7nzxj6
         FGgIowho2jdRtIktO+pcFUFO+tx3RitwjOBgx79dy6F12ufctsvRsp1d3WFfHVb3cO6v
         k3rlIzLos5jU/LB8LtdhfWrJ2oobNegcVMD58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m5BxlXXWVtoXchtDeVJ0hdDUs/0oB6T6ue8zThb29qU=;
        b=meUnu/DelfyYwZO0uGI8iZlgnx2nZAXFZQaOBgGgyDwycR6qpeZvU2KxwS350z0H8a
         PMc8wg5EkYFsyLX4oidrJyuRXnrouy1gEBbQHcs9dzc6AUocW5JvfPAVlSgLwDI30T0x
         MZCosyBsvqYO69xZ78jTg/pmRuq/a5k1sOASkcJW+9UL321G4Fx7rEEg4MGCtqSTSv5z
         g6SlfcdPFrHzRMqtyIE44Hf+3aH3NItMlfN1jgXY1iDJCMaucxf6LapADgXvhmW/6XvI
         pl/nsWRjb0E4d7yh9l+RwCCtny0OB5FcCWkbozN3OorhgD3ZL5GdOsPZ0Md9KMB4hX9C
         qbZg==
X-Gm-Message-State: APjAAAVgawbZJwwyR9i4ubkSf+299jbMqOvs514PwIblRGkyr/gJ+a9q
        huTKD6R5iKpAfa8+66eJk7i0ZQ==
X-Google-Smtp-Source: APXvYqxupER9LD+Tt2LhgETXM3FT79jKzeovNk2AWlJBwOyGb10FHGH8DfeuSMAZ9pfKsMuewjtBpQ==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr40842525plo.85.1568379903364;
        Fri, 13 Sep 2019 06:05:03 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:02 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 01/13] mpt3sas: Register trace buffer based on NVDATA settings
Date:   Fri, 13 Sep 2019 09:04:38 -0400
Message-Id: <1568379890-18347-2-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently if user has to enable the host trace buffer during
driver load time then user has to load the driver with module parameter
'diag_buffer_enable' set to one.

Alternatively now user can enable host trace buffer by enabling
below fields in manufacture page11 in NVDATA
(nvdata xml is used while building HBA firmware image),

 * HostTraceBufferMaxSizeKB - Maximum trace buffer size in KB
                              that host can allocate,
 * HostTraceBufferMinSizeKB - Minimum trace buffer size in KB
                              atleast host should allocate,
 * HostTraceBufferDecrementSizeKB - size by which host can reduce from
                                buffer size and retry the
                                buffer allocation when buffer allocation
                                failed with previous calculated buffer
                                size.

So that driver will register the trace buffer automatically without
any module parameter during boot time when above fields are enabled
in the manufacture page11 in HBA firmware.

Driver follows below algorithm for enabling the host trace buffer
during driver load time,

* If user has loaded the driver with module parameter 'diag_buffer_enable'
  set to one then driver allocates 2MB buffer and register this buffer
  with HBA firmware for capturing the firmware trace logs.
* Else driver reads manufacture page11 data and checks whether
  HostTraceBufferMaxSizeKB filed is zero or not?
  - if HostTraceBufferMaxSizeKB is non zero then driver tries to allocate
    HostTraceBufferMaxSizeKB size of memory. If the buffer allocation is
    successfully then it will register this buffer with HBA firmware,
    else in a loop driver will try again by reducing the current buffer
    size with HostTraceBufferDecrementSizeKB size until memory allocation
    is successful (or) buffer size falls below HostTraceBufferMinSizeKB.
    if the memory allocation is successful then the buffer will be
    registered with the firmware. Else if the buffer size falls below the
    HostTraceBufferMinSizeKB then driver won't register trace buffer with
    HBA firmware.
  - if HostTraceBufferMaxSizeKB is zero then driver won't register
    trace buffer with HBA firmware.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  9 +++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 71 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  2 +
 3 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index faca0a5..a501c25 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -391,9 +391,12 @@ struct Mpi2ManufacturingPage11_t {
 	u8	Reserved6;			/* 2Fh */
 	__le32	Reserved7[7];			/* 30h - 4Bh */
 	u8	NVMeAbortTO;			/* 4Ch */
-	u8	Reserved8;			/* 4Dh */
-	u16	Reserved9;			/* 4Eh */
-	__le32	Reserved10[4];			/* 50h - 60h */
+	u8	NumPerDevEvents;		/* 4Dh */
+	u8	HostTraceBufferDecrementSizeKB;	/* 4Eh */
+	u8	HostTraceBufferFlags;		/* 4Fh */
+	u16	HostTraceBufferMaxSizeKB;	/* 50h */
+	u16	HostTraceBufferMinSizeKB;	/* 52h */
+	__le32	Reserved10[2];			/* 54h - 5Bh */
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 7d69695..285edd7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1669,6 +1669,10 @@ void
 mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 {
 	struct mpt3_diag_register diag_register;
+	u32 ret_val;
+	u32 trace_buff_size = ioc->manu_pg11.HostTraceBufferMaxSizeKB<<10;
+	u32 min_trace_buff_size = 0;
+	u32 decr_trace_buff_size = 0;
 
 	memset(&diag_register, 0, sizeof(struct mpt3_diag_register));
 
@@ -1677,10 +1681,61 @@ mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 		ioc->diag_trigger_master.MasterData =
 		    (MASTER_TRIGGER_FW_FAULT + MASTER_TRIGGER_ADAPTER_RESET);
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_TRACE;
-		/* register for 2MB buffers  */
-		diag_register.requested_buffer_size = 2 * (1024 * 1024);
 		diag_register.unique_id = 0x7075900;
-		_ctl_diag_register_2(ioc,  &diag_register);
+
+		if (trace_buff_size != 0) {
+			diag_register.requested_buffer_size = trace_buff_size;
+			min_trace_buff_size =
+			    ioc->manu_pg11.HostTraceBufferMinSizeKB<<10;
+			decr_trace_buff_size =
+			    ioc->manu_pg11.HostTraceBufferDecrementSizeKB<<10;
+
+			if (min_trace_buff_size > trace_buff_size) {
+				/* The buff size is not set correctly */
+				ioc_err(ioc,
+				    "Min Trace Buff size (%d KB) greater than Max Trace Buff size (%d KB)\n",
+				     min_trace_buff_size>>10,
+				     trace_buff_size>>10);
+				ioc_err(ioc,
+				    "Using zero Min Trace Buff Size\n");
+				    min_trace_buff_size = 0;
+			}
+
+			if (decr_trace_buff_size == 0) {
+				/*
+				 * retry the min size if decrement
+				 * is not available.
+				 */
+				decr_trace_buff_size =
+				    trace_buff_size - min_trace_buff_size;
+			}
+		} else {
+			/* register for 2MB buffers  */
+			diag_register.requested_buffer_size = 2 * (1024 * 1024);
+		}
+
+		do {
+			ret_val = _ctl_diag_register_2(ioc,  &diag_register);
+
+			if (ret_val == -ENOMEM && min_trace_buff_size &&
+			    (trace_buff_size - decr_trace_buff_size) >=
+			    min_trace_buff_size) {
+				/* adjust the buffer size */
+				trace_buff_size -= decr_trace_buff_size;
+				diag_register.requested_buffer_size =
+				    trace_buff_size;
+			} else
+				break;
+		} while (true);
+
+		if (ret_val == -ENOMEM)
+			ioc_err(ioc,
+			    "Cannot allocate trace buffer memory. Last memory tried = %d KB\n",
+			    diag_register.requested_buffer_size>>10);
+		else if (ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE]
+		    & MPT3_DIAG_BUFFER_IS_REGISTERED)
+			ioc_err(ioc, "Trace buffer memory %d KB allocated\n",
+			    diag_register.requested_buffer_size>>10);
 	}
 
 	if (bits_to_register & 2) {
@@ -3130,7 +3185,15 @@ host_trace_buffer_enable_store(struct device *cdev,
 		memset(&diag_register, 0, sizeof(struct mpt3_diag_register));
 		ioc_info(ioc, "posting host trace buffers\n");
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_TRACE;
-		diag_register.requested_buffer_size = (1024 * 1024);
+
+		if (ioc->manu_pg11.HostTraceBufferMaxSizeKB != 0 &&
+		    ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE] != 0) {
+			/* post the same buffer allocated previously */
+			diag_register.requested_buffer_size =
+			    ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE];
+		} else
+			diag_register.requested_buffer_size = (1024 * 1024);
+
 		diag_register.unique_id = 0x7075900;
 		ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] = 0;
 		_ctl_diag_register_2(ioc,  &diag_register);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d0c2f8d..2504cd7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10194,6 +10194,8 @@ scsih_scan_start(struct Scsi_Host *shost)
 	int rc;
 	if (diag_buffer_enable != -1 && diag_buffer_enable != 0)
 		mpt3sas_enable_diag_buffer(ioc, diag_buffer_enable);
+	else if (ioc->manu_pg11.HostTraceBufferMaxSizeKB != 0)
+		mpt3sas_enable_diag_buffer(ioc, 1);
 
 	if (disable_discovery > 0)
 		return;
-- 
1.8.3.1

