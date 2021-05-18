Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9921BC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 05:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63FBA6108B
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 05:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhERFSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 01:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241360AbhERFS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 01:18:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DBFC061760
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 22:16:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso914172pji.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 22:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=/XYbnaiWd+M9/YEqPERWex0IpNj7qPdMmrkibpRe4Kg=;
        b=D1pQnLuoP6VL1r+tRr7nzpC4smUKhGP8kDg8XT7GV7jn8CCv/14x16beoGQsn8CH9V
         6lKbvvS9pryby+t2yYPLUSncQtdRa3hgTvMqojJlvxNH8QuF7g8h53cLdBEYspS30++M
         hnZIHyRXCOX4rI50P8XPr1XWixeLM9G4mcdT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=/XYbnaiWd+M9/YEqPERWex0IpNj7qPdMmrkibpRe4Kg=;
        b=kI9UO0/dfnjNDDNbCb4ZnNqWttNkkXEnAnBucFoc61FEKLAcRJDCBbhPRH1h0bUuuz
         JHam/lytia2ucCoPFCQl7YxMDhd667zh4zlhrWeXHBMgOQduf7n/YXG6ghLDDSbtsZ1w
         PmeN6yKaitcZyyJWCjcGW9z0gbv6MWIJi97OlOKhc7LtoePo0l89G1yHONvbniyOjIko
         CJKIHLFyCpjvGfjFjna4fm1VcxZPPwhH4EUvaxdJfaGSjgNKykivl0xcr7t9UdjCiBOk
         ljtfZQBD+w53RgsqO4FDVW7ovz51CdVHCpxyCurj11phENLoJSAOtIZWc9ajvA06Q4DS
         Aecg==
X-Gm-Message-State: AOAM533zIKwnsvFITGZ/qXWnQdgbZoHy+3UNc9XCzdrOvDHBpaVGamzm
        YD0iMXNScjIv5bVVqzsWoAZcRooySGL/Nh1tLhP3efXmNXcOnPvxazhbnLaGEeJJGvxlRQqx/cq
        1yNL4JXj7icd6qNz4IjFv/IaSXCkW+9pIENFxgd926sjsni9r9wDBXSK73Cbfv8iDP7Sy/7hxfH
        UPkEFci59dUt7ycpDYlJT6
X-Google-Smtp-Source: ABdhPJymhmwfxW7QF56+0/dTM939ttXR8G+Zdx2a2sT2KHLW1+FD0kxPFKxxdBr9jUknC/8fH6NACQ==
X-Received: by 2002:a17:90a:fc8f:: with SMTP id ci15mr3420118pjb.147.1621315004012;
        Mon, 17 May 2021 22:16:44 -0700 (PDT)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id hk15sm437556pjb.53.2021.05.17.22.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:16:43 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [Patch 2/3] mpt3sas: Handle FW faults during first half of IOC  init
Date:   Tue, 18 May 2021 10:46:24 +0530
Message-Id: <20210518051625.1596742-3-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
References: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ed94cf05c293d051"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ed94cf05c293d051
Content-Transfer-Encoding: 8bit

Currently during first half of IOC initialization (i.e.
before going for device scanning), if any firmware faults
occurs then driver is aborting the IOC initialization
operation.

Through this patch, now the driver will issue diag reset
operation to recover IOC from fault state and will
reinitialize the IOC.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 253 ++++++++++++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.h   |   7 +
 drivers/scsi/mpt3sas/mpt3sas_config.c |  18 +-
 3 files changed, 201 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 68fde05..97e63a5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3365,14 +3365,14 @@ static int
 _base_diag_reset(struct MPT3SAS_ADAPTER *ioc);
 
 /**
- * _base_check_for_fault_and_issue_reset - check if IOC is in fault state
+ * mpt3sas_base_check_for_fault_and_issue_reset - check if IOC is in fault state
  *     and if it is in fault state then issue diag reset.
  * @ioc: per adapter object
  *
  * Return: 0 for success, non-zero for failure.
  */
-static int
-_base_check_for_fault_and_issue_reset(struct MPT3SAS_ADAPTER *ioc)
+int
+mpt3sas_base_check_for_fault_and_issue_reset(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
 	int rc = -EFAULT;
@@ -3386,12 +3386,14 @@ _base_check_for_fault_and_issue_reset(struct MPT3SAS_ADAPTER *ioc)
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		mpt3sas_print_fault_code(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
+		mpt3sas_base_mask_interrupts(ioc);
 		rc = _base_diag_reset(ioc);
 	} else if ((ioc_state & MPI2_IOC_STATE_MASK) ==
 	    MPI2_IOC_STATE_COREDUMP) {
 		mpt3sas_print_coredump_info(ioc, ioc_state &
 		     MPI2_DOORBELL_DATA_MASK);
 		mpt3sas_base_wait_for_coredump_completion(ioc, __func__);
+		mpt3sas_base_mask_interrupts(ioc);
 		rc = _base_diag_reset(ioc);
 	}
 
@@ -3473,7 +3475,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_get_ioc_facts(ioc);
 	if (r) {
-		rc = _base_check_for_fault_and_issue_reset(ioc);
+		rc = mpt3sas_base_check_for_fault_and_issue_reset(ioc);
 		if (rc || (_base_get_ioc_facts(ioc)))
 			goto out_fail;
 	}
@@ -4454,7 +4456,7 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 	Mpi26ComponentImageHeader_t *cmp_img_hdr;
 	Mpi25FWUploadRequest_t *mpi_request;
 	Mpi2FWUploadReply_t mpi_reply;
-	int r = 0;
+	int r = 0, issue_diag_reset = 0;
 	u32  package_version = 0;
 	void *fwpkg_data = NULL;
 	dma_addr_t fwpkg_data_dma;
@@ -4504,7 +4506,7 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 				sizeof(Mpi25FWUploadRequest_t)/4);
-		r = -ETIME;
+		issue_diag_reset = 1;
 	} else {
 		memset(&mpi_reply, 0, sizeof(Mpi2FWUploadReply_t));
 		if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID) {
@@ -4544,6 +4546,13 @@ out:
 	if (fwpkg_data)
 		dma_free_coherent(&ioc->pdev->dev, data_length, fwpkg_data,
 				fwpkg_data_dma);
+	if (issue_diag_reset) {
+		if (ioc->drv_internal_flags & MPT_DRV_INERNAL_FIRST_PE_ISSUED)
+			return -EFAULT;
+		if (mpt3sas_base_check_for_fault_and_issue_reset(ioc))
+			return -EFAULT;
+		r = -EAGAIN;
+	}
 	return r;
 }
 
@@ -4751,15 +4760,19 @@ out:
  *    according to performance mode.
  * @ioc : per adapter object
  *
- * Return: nothing.
+ * Return: zero on success; otherwise return EAGAIN error code asking the
+ * caller to retry.
  */
-static void
+static int
 _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2IOCPage1_t ioc_pg1;
 	Mpi2ConfigReply_t mpi_reply;
+	int rc;
 
-	mpt3sas_config_get_ioc_pg1(ioc, &mpi_reply, &ioc->ioc_pg1_copy);
+	rc = mpt3sas_config_get_ioc_pg1(ioc, &mpi_reply, &ioc->ioc_pg1_copy);
+	if (rc)
+		return rc;
 	memcpy(&ioc_pg1, &ioc->ioc_pg1_copy, sizeof(Mpi2IOCPage1_t));
 
 	switch (perf_mode) {
@@ -4781,9 +4794,11 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
 			 */
 			ioc_pg1.ProductSpecific = cpu_to_le32(0x80000000 |
 			    ((1 << MPT3SAS_HIGH_IOPS_REPLY_QUEUES/8) - 1));
-			mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply, &ioc_pg1);
+			rc = mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply, &ioc_pg1);
+			if (rc)
+				return rc;
 			ioc_info(ioc, "performance mode: balanced\n");
-			return;
+			return 0;
 		}
 		fallthrough;
 	case MPT_PERF_MODE_LATENCY:
@@ -4794,7 +4809,9 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
 		ioc_pg1.CoalescingTimeout = cpu_to_le32(0xa);
 		ioc_pg1.Flags |= cpu_to_le32(MPI2_IOCPAGE1_REPLY_COALESCING);
 		ioc_pg1.ProductSpecific = 0;
-		mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply, &ioc_pg1);
+		rc = mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply, &ioc_pg1);
+		if (rc)
+			return rc;
 		ioc_info(ioc, "performance mode: latency\n");
 		break;
 	case MPT_PERF_MODE_IOPS:
@@ -4806,9 +4823,12 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
 		    le32_to_cpu(ioc_pg1.CoalescingTimeout));
 		ioc_pg1.Flags |= cpu_to_le32(MPI2_IOCPAGE1_REPLY_COALESCING);
 		ioc_pg1.ProductSpecific = 0;
-		mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply, &ioc_pg1);
+		rc = mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply, &ioc_pg1);
+		if (rc)
+			return rc;
 		break;
 	}
+	return 0;
 }
 
 /**
@@ -4818,7 +4838,7 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
  *
  * Return: nothing.
  */
-static void
+static int
 _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi26DriverTriggerPage2_t trigger_pg2;
@@ -4832,7 +4852,7 @@ _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	r = mpt3sas_config_get_driver_trigger_pg2(ioc, &mpi_reply,
 	    &trigger_pg2);
 	if (r)
-		return;
+		return r;
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
@@ -4841,7 +4861,7 @@ _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 		    ioc_err(ioc,
 		    "%s: Failed to get trigger pg2, ioc_status(0x%04x)\n",
 		   __func__, ioc_status));
-		return;
+		return 0;
 	}
 
 	if (le16_to_cpu(trigger_pg2.NumMPIEventTrigger)) {
@@ -4860,6 +4880,7 @@ _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 			mpi_event_tg++;
 		}
 	}
+	return 0;
 }
 
 /**
@@ -4867,9 +4888,9 @@ _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return: nothing.
+ * Return: 0 on success; otherwise return failure status.
  */
-static void
+static int
 _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi26DriverTriggerPage3_t trigger_pg3;
@@ -4883,7 +4904,7 @@ _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	r = mpt3sas_config_get_driver_trigger_pg3(ioc, &mpi_reply,
 	    &trigger_pg3);
 	if (r)
-		return;
+		return r;
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
@@ -4892,7 +4913,7 @@ _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 		    ioc_err(ioc,
 		    "%s: Failed to get trigger pg3, ioc_status(0x%04x)\n",
 		    __func__, ioc_status));
-		return;
+		return 0;
 	}
 
 	if (le16_to_cpu(trigger_pg3.NumSCSISenseTrigger)) {
@@ -4911,6 +4932,7 @@ _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 			mpi_scsi_tg++;
 		}
 	}
+	return 0;
 }
 
 /**
@@ -4918,9 +4940,9 @@ _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return: nothing.
+ * Return: 0 on success; otherwise return failure status.
  */
-static void
+static int
 _base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi26DriverTriggerPage4_t trigger_pg4;
@@ -4934,7 +4956,7 @@ _base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	r = mpt3sas_config_get_driver_trigger_pg4(ioc, &mpi_reply,
 	    &trigger_pg4);
 	if (r)
-		return;
+		return r;
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
@@ -4943,7 +4965,7 @@ _base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 		    ioc_err(ioc,
 		    "%s: Failed to get trigger pg4, ioc_status(0x%04x)\n",
 		    __func__, ioc_status));
-		return;
+		return 0;
 	}
 
 	if (le16_to_cpu(trigger_pg4.NumIOCStatusLogInfoTrigger)) {
@@ -4964,6 +4986,7 @@ _base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 			mpi_status_tg++;
 		}
 	}
+	return 0;
 }
 
 /**
@@ -4973,7 +4996,7 @@ _base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
  *
  * Return: nothing.
  */
-static void
+static int
 _base_get_master_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi26DriverTriggerPage1_t trigger_pg1;
@@ -4984,7 +5007,7 @@ _base_get_master_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	r = mpt3sas_config_get_driver_trigger_pg1(ioc, &mpi_reply,
 	    &trigger_pg1);
 	if (r)
-		return;
+		return r;
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
@@ -4993,25 +5016,30 @@ _base_get_master_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 		    ioc_err(ioc,
 		    "%s: Failed to get trigger pg1, ioc_status(0x%04x)\n",
 		   __func__, ioc_status));
-		return;
+		return 0;
 	}
 
 	if (le16_to_cpu(trigger_pg1.NumMasterTrigger))
 		ioc->diag_trigger_master.MasterData |=
 		    le32_to_cpu(
 		    trigger_pg1.MasterTriggers[0].MasterTriggerFlags);
+	return 0;
 }
 
 /**
  * _base_check_for_trigger_pages_support - checks whether HBA FW supports
  *					driver trigger pages or not
  * @ioc : per adapter object
+ * @trigger_flags : address where trigger page0's TriggerFlags value is copied
+ *
+ * Return: trigger flags mask if HBA FW supports driver trigger pages;
+ * otherwise returns %-EFAULT if driver trigger pages are not supported by FW or
+ * return EAGAIN if diag reset occurred due to FW fault and asking the
+ * caller to retry the command.
  *
- * Return: trigger flags mask if HBA FW supports driver trigger pages,
- * otherwise returns %-EFAULT.
  */
 static int
-_base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
+_base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc, u32 *trigger_flags)
 {
 	Mpi26DriverTriggerPage0_t trigger_pg0;
 	int r = 0;
@@ -5021,14 +5049,15 @@ _base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
 	r = mpt3sas_config_get_driver_trigger_pg0(ioc, &mpi_reply,
 	    &trigger_pg0);
 	if (r)
-		return -EFAULT;
+		return r;
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 		return -EFAULT;
 
-	return le16_to_cpu(trigger_pg0.TriggerFlags);
+	*trigger_flags = le16_to_cpu(trigger_pg0.TriggerFlags);
+	return 0;
 }
 
 /**
@@ -5036,12 +5065,14 @@ _base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
  *				persistent pages.
  * @ioc : per adapter object
  *
- * Return: nothing.
+ * Return: zero on success; otherwise return EAGAIN error codes
+ * asking the caller to retry.
  */
-static void
+static int
 _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
 	int trigger_flags;
+	int r;
 
 	/*
 	 * Default setting of master trigger.
@@ -5049,9 +5080,16 @@ _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	ioc->diag_trigger_master.MasterData =
 	    (MASTER_TRIGGER_FW_FAULT + MASTER_TRIGGER_ADAPTER_RESET);
 
-	trigger_flags = _base_check_for_trigger_pages_support(ioc);
-	if (trigger_flags < 0)
-		return;
+	r = _base_check_for_trigger_pages_support(ioc, &trigger_flags);
+	if (r) {
+		if (r == -EAGAIN)
+			return r;
+		/*
+		 * Don't go for error handling when FW doesn't support
+		 * driver trigger pages.
+		 */
+		return 0;
+	}
 
 	ioc->supports_trigger_pages = 1;
 
@@ -5060,31 +5098,44 @@ _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	 * if master trigger bit enabled in TriggerFlags.
 	 */
 	if ((u16)trigger_flags &
-	    MPI26_DRIVER_TRIGGER0_FLAG_MASTER_TRIGGER_VALID)
-		_base_get_master_diag_triggers(ioc);
+	    MPI26_DRIVER_TRIGGER0_FLAG_MASTER_TRIGGER_VALID) {
+		r = _base_get_master_diag_triggers(ioc);
+		if (r)
+			return r;
+	}
 
 	/*
 	 * Retrieve event diag trigger values from driver trigger pg2
 	 * if event trigger bit enabled in TriggerFlags.
 	 */
 	if ((u16)trigger_flags &
-	    MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID)
-		_base_get_event_diag_triggers(ioc);
+	    MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID) {
+		r = _base_get_event_diag_triggers(ioc);
+		if (r)
+			return r;
+	}
 
 	/*
 	 * Retrieve scsi diag trigger values from driver trigger pg3
 	 * if scsi trigger bit enabled in TriggerFlags.
 	 */
 	if ((u16)trigger_flags &
-	    MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID)
-		_base_get_scsi_diag_triggers(ioc);
+	    MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID) {
+		r = _base_get_scsi_diag_triggers(ioc);
+		if (r)
+			return r;
+	}
 	/*
 	 * Retrieve mpi error diag trigger values from driver trigger pg4
 	 * if loginfo trigger bit enabled in TriggerFlags.
 	 */
 	if ((u16)trigger_flags &
-	    MPI26_DRIVER_TRIGGER0_FLAG_LOGINFO_TRIGGER_VALID)
-		_base_get_mpi_diag_triggers(ioc);
+	    MPI26_DRIVER_TRIGGER0_FLAG_LOGINFO_TRIGGER_VALID) {
+		r = _base_get_mpi_diag_triggers(ioc);
+		if (r)
+			return r;
+	}
+	return 0;
 }
 
 /**
@@ -5120,23 +5171,33 @@ _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
  * _base_static_config_pages - static start of day config pages
  * @ioc: per adapter object
  */
-static void
+static int
 _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2ConfigReply_t mpi_reply;
 	u32 iounit_pg1_flags;
 	int tg_flags = 0;
+	int rc;
 	ioc->nvme_abort_timeout = 30;
-	mpt3sas_config_get_manufacturing_pg0(ioc, &mpi_reply, &ioc->manu_pg0);
-	if (ioc->ir_firmware)
-		mpt3sas_config_get_manufacturing_pg10(ioc, &mpi_reply,
-		    &ioc->manu_pg10);
 
+	rc = mpt3sas_config_get_manufacturing_pg0(ioc, &mpi_reply,
+	    &ioc->manu_pg0);
+	if (rc)
+		return rc;
+	if (ioc->ir_firmware) {
+		rc = mpt3sas_config_get_manufacturing_pg10(ioc, &mpi_reply,
+		    &ioc->manu_pg10);
+		if (rc)
+			return rc;
+	}
 	/*
 	 * Ensure correct T10 PI operation if vendor left EEDPTagMode
 	 * flag unset in NVDATA.
 	 */
-	mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
+	rc = mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply,
+	    &ioc->manu_pg11);
+	if (rc)
+		return rc;
 	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
 		    ioc->name);
@@ -5175,12 +5236,24 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 			ioc_warn(ioc,
 			    "TimeSync Interval in Manuf page-11 is not enabled. Periodic Time-Sync will be disabled\n");
 	}
-	mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
-	mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
-	mpt3sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
-	mpt3sas_config_get_iounit_pg0(ioc, &mpi_reply, &ioc->iounit_pg0);
-	mpt3sas_config_get_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
-	mpt3sas_config_get_iounit_pg8(ioc, &mpi_reply, &ioc->iounit_pg8);
+	rc = mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
+	if (rc)
+		return rc;
+	rc = mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
+	if (rc)
+		return rc;
+	rc = mpt3sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
+	if (rc)
+		return rc;
+	rc = mpt3sas_config_get_iounit_pg0(ioc, &mpi_reply, &ioc->iounit_pg0);
+	if (rc)
+		return rc;
+	rc = mpt3sas_config_get_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
+	if (rc)
+		return rc;
+	rc = mpt3sas_config_get_iounit_pg8(ioc, &mpi_reply, &ioc->iounit_pg8);
+	if (rc)
+		return rc;
 	_base_display_ioc_capabilities(ioc);
 
 	/*
@@ -5196,16 +5269,23 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 		iounit_pg1_flags |=
 		    MPI2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING;
 	ioc->iounit_pg1.Flags = cpu_to_le32(iounit_pg1_flags);
-	mpt3sas_config_set_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
+	rc = mpt3sas_config_set_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
+	if (rc)
+		return rc;
 
 	if (ioc->iounit_pg8.NumSensors)
 		ioc->temp_sensors_count = ioc->iounit_pg8.NumSensors;
-	if (ioc->is_aero_ioc)
-		_base_update_ioc_page1_inlinewith_perf_mode(ioc);
+	if (ioc->is_aero_ioc) {
+		rc = _base_update_ioc_page1_inlinewith_perf_mode(ioc);
+		if (rc)
+			return rc;
+	}
 	if (ioc->is_gen35_ioc) {
-		if (ioc->is_driver_loading)
-			_base_get_diag_triggers(ioc);
-		else {
+		if (ioc->is_driver_loading) {
+			rc = _base_get_diag_triggers(ioc);
+			if (rc)
+				return rc;
+		} else {
 			/*
 			 * In case of online HBA FW update operation,
 			 * check whether updated FW supports the driver trigger
@@ -5217,7 +5297,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 			 *   and new FW doesn't support them then disable
 			 *   support_trigger_pages flag.
 			 */
-			tg_flags = _base_check_for_trigger_pages_support(ioc);
+			_base_check_for_trigger_pages_support(ioc, &tg_flags);
 			if (!ioc->supports_trigger_pages && tg_flags != -EFAULT)
 				_base_update_diag_trigger_pages(ioc);
 			else if (ioc->supports_trigger_pages &&
@@ -5225,6 +5305,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 				ioc->supports_trigger_pages = 0;
 		}
 	}
+	return 0;
 }
 
 /**
@@ -6481,6 +6562,17 @@ mpt3sas_wait_for_ioc(struct MPT3SAS_ADAPTER *ioc, int timeout)
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 		if (ioc_state == MPI2_IOC_STATE_OPERATIONAL)
 			break;
+
+		/*
+		 * Watchdog thread will be started after IOC Initialization, so
+		 * no need to wait here for IOC state to become operational
+		 * when IOC Initialization is on. Instead the driver will
+		 * return ETIME status, so that calling function can issue
+		 * diag reset operation and retry the command.
+		 */
+		if (ioc->is_driver_loading)
+			return -ETIME;
+
 		ssleep(1);
 		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
 				__func__, ++wait_state_count);
@@ -7214,7 +7306,7 @@ mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc)
 		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		return -EAGAIN;
 	}
-
+	ioc->drv_internal_flags |= MPT_DRV_INERNAL_FIRST_PE_ISSUED;
 	ioc->port_enable_cmds.status = MPT3_CMD_PENDING;
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->port_enable_cmds.smid = smid;
@@ -7312,7 +7404,7 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2EventNotificationRequest_t *mpi_request;
 	u16 smid;
 	int r = 0;
-	int i;
+	int i, issue_diag_reset = 0;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -7346,10 +7438,19 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 		if (ioc->base_cmds.status & MPT3_CMD_RESET)
 			r = -EFAULT;
 		else
-			r = -ETIME;
+			issue_diag_reset = 1;
+
 	} else
 		dinitprintk(ioc, ioc_info(ioc, "%s: complete\n", __func__));
 	ioc->base_cmds.status = MPT3_CMD_NOT_USED;
+
+	if (issue_diag_reset) {
+		if (ioc->drv_internal_flags & MPT_DRV_INERNAL_FIRST_PE_ISSUED)
+			return -EFAULT;
+		if (mpt3sas_base_check_for_fault_and_issue_reset(ioc))
+			return -EFAULT;
+		r = -EAGAIN;
+	}
 	return r;
 }
 
@@ -7713,7 +7814,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 		if (!ioc->is_driver_loading)
 			return r;
 
-		rc = _base_check_for_fault_and_issue_reset(ioc);
+		rc = mpt3sas_base_check_for_fault_and_issue_reset(ioc);
 		if (rc || (_base_send_ioc_init(ioc)))
 			return r;
 	}
@@ -7747,7 +7848,10 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 			return r;
 	}
 
-	_base_static_config_pages(ioc);
+	rc = _base_static_config_pages(ioc);
+	if (r)
+		return r;
+
 	r = _base_event_notification(ioc);
 	if (r)
 		return r;
@@ -7852,7 +7956,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	pci_set_drvdata(ioc->pdev, ioc->shost);
 	r = _base_get_ioc_facts(ioc);
 	if (r) {
-		rc = _base_check_for_fault_and_issue_reset(ioc);
+		rc = mpt3sas_base_check_for_fault_and_issue_reset(ioc);
 		if (rc || (_base_get_ioc_facts(ioc)))
 			goto out_free_resources;
 	}
@@ -7924,7 +8028,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
 		r = _base_get_port_facts(ioc, i);
 		if (r) {
-			rc = _base_check_for_fault_and_issue_reset(ioc);
+			rc = mpt3sas_base_check_for_fault_and_issue_reset(ioc);
 			if (rc || (_base_get_port_facts(ioc, i)))
 				goto out_free_resources;
 		}
@@ -8050,8 +8154,11 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		}
 	}
 	r = _base_make_ioc_operational(ioc);
-	if (r)
-		goto out_free_resources;
+	if (r == -EAGAIN) {
+		r = _base_make_ioc_operational(ioc);
+		if (r)
+			goto out_free_resources;
+	}
 
 	/*
 	 * Copy current copy of IOCFacts in prev_fw_facts
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 98558d9..a8100a9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1175,6 +1175,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @schedule_dead_ioc_flush_running_cmds: callback to flush pending commands
  * @thresh_hold: Max number of reply descriptors processed
  *				before updating Host Index
+ * @drv_internal_flags: Bit map internal to driver
  * @drv_support_bitmap: driver's supported feature bit map
  * @use_32bit_dma: Flag to use 32 bit consistent dma mask
  * @scsi_io_cb_idx: shost generated commands
@@ -1370,6 +1371,7 @@ struct MPT3SAS_ADAPTER {
 	bool            msix_load_balance;
 	u16		thresh_hold;
 	u8		high_iops_queues;
+	u32             drv_internal_flags;
 	u32		drv_support_bitmap;
 	u32             dma_mask;
 	bool		enable_sdev_max_qd;
@@ -1615,6 +1617,8 @@ struct mpt3sas_debugfs_buffer {
 #define MPT_DRV_SUPPORT_BITMAP_MEMMOVE 0x00000001
 #define MPT_DRV_SUPPORT_BITMAP_ADDNLQUERY	0x00000002
 
+#define MPT_DRV_INERNAL_FIRST_PE_ISSUED		0x00000001
+
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 
@@ -1709,6 +1713,9 @@ void mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 	u16 device_missing_delay, u8 io_missing_delay);
 
+int mpt3sas_base_check_for_fault_and_issue_reset(
+	struct MPT3SAS_ADAPTER *ioc);
+
 int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
 
 void
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 55cd329..3b2c4f1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -359,8 +359,11 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	}
 
 	r = mpt3sas_wait_for_ioc(ioc, MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (r)
+	if (r) {
+		if (r == -ETIME)
+			issue_host_reset = 1;
 		goto free_mem;
+	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->config_cb_idx);
 	if (!smid) {
@@ -395,7 +398,6 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		    MPT3_CMD_RESET) || ioc->pci_error_recovery)
 			goto retry_config;
 		issue_host_reset = 1;
-		r = -EFAULT;
 		goto free_mem;
 	}
 
@@ -486,8 +488,16 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	ioc->config_cmds.status = MPT3_CMD_NOT_USED;
 	mutex_unlock(&ioc->config_cmds.mutex);
 
-	if (issue_host_reset)
-		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+	if (issue_host_reset) {
+		if (ioc->drv_internal_flags & MPT_DRV_INERNAL_FIRST_PE_ISSUED) {
+			mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+			r = -EFAULT;
+		} else {
+			if (mpt3sas_base_check_for_fault_and_issue_reset(ioc))
+				return -EFAULT;
+			r = -EAGAIN;
+		}
+	}
 	return r;
 }
 
-- 
2.27.0


--000000000000ed94cf05c293d051
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBXAwggRYoAMCAQICDCAc2j96+IoHW5040jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjQzNTVaFw0yMjA5MTUxMTMwMjdaMIGm
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xITAfBgNVBAMTGFN1Z2FuYXRoIFByYWJ1IFN1YnJhbWFuaTE0
MDIGCSqGSIb3DQEJARYlc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJp3W6i+yVqwmKTbucNHNrAD35AKBa4GklrnUcWS
As4Yz62jxfJOu+dcysfahgpi3JcAhTe/eRMLc5on8ReYZAYCMNJ+jpNKRuf1Abgh6nfhcNf+cuGb
S83CJlqxdJjbnimwwbueitA/edWTFjcULNUDZZEmAPJkbHXmlTlJD8TMdR0ezem/d4niexc4RCyt
YMUhnlcyFg+2OR0MKuT2Q714Ka0IamXFyyXhX5wD9B+ITo5hu+ZtXV2RuOXy0U2bIEQzFPVJ7QA9
hUD4z7+jEN/0xIbuF8EJZMsb6XAT+CFOjnizM5yvGFfmupDlyQ4JuVb86R8v2AEDpXmbdnS1tDkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUH
MAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3Nn
Y2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
SQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29u
YWxzaWduMmNhMjAyMC5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk
1b5I3qGPzzAdBgNVHQ4EFgQURmgYmHXuw9VrKqnEjPBuviQS0CEwDQYJKoZIhvcNAQELBQADggEB
AAp1Yt9kkxViI/9B/AQxLFmuC9wWruix0ajjegaJ/HZ6C1ky/V9QvI1MwweIhBiuk2jttOzO4h87
rADIQnEI3bf5ccaw61CJNqc6Cb4LiEIjPF7py8f6+rHL928xCUnKqeCO2sC0A+k39bCiyHaGo432
eXxWNXxGrLg6/2TuwgOtvbil0hWwK/Wf5ql2YiZXy8wRo9IhHoY/4cJLS/Fay8yKX8IdhEc3pNbu
dDLaJg39U0ikF3NHtNMaXXHgh6TMs3OsWhH4+zlvkC0eSC6dvasGxmpPQPQe/0huBB8gDbzGrRg/
cRn2ctMmNHxZO4EBJ5SzsV/lHimTk+5K39lzkzYxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQ
ZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwgHNo/eviKB1udONIwDQYJYIZIAWUDBAIBBQCggdQwLwYJ
KoZIhvcNAQkEMSIEIJzsUBjxSXKL0MVPB2e79JEan10wq4h8mHypzEeDuRzRMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUxODA1MTY0NFowaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAa
+XuBvicaZvSoo9ZtKqHNYGbTKGm9iTX3NfX4Dh+SA5kpLc1QEZFV9OcmtE+GmIF1o4zz2NfcvXw3
C/Ng0lu84Wk+0DDPrf76MljDdtm26Ec5MRImlTAQ601stqjuF4RmofEcXUko5wGkklu0qokwk9m3
UrOBA/h5IKCvm2+UlsIi7uwCMGIFH4EqOX6pp9uceJcC56nEWMEglpenHA9Mh2y45jazLt//UycI
aS7aYW4di3dJ0KSixesePolLiubsmqBMq8buJoAQ5acGrKqWUC+/LbeMLYrQJ24aCWUxWmg+AhL/
Du8LTwiQJDVFA2/+N2M6J511aG7RlO8N3znj
--000000000000ed94cf05c293d051--
