Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D445C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E43BE24679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zyb6Duqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfLTKcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:46 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33597 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKcq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:46 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so4739475pgk.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4MmlPl8Py5nKlNFKXDj7fuL4G57xgETN+yKIqgFSCl8=;
        b=Zyb6Duqokz+wcV/YTWzqzbjWK63PsuNy5/O1iPyqfpImPI5Nq2wIeH3dId4bZUfRdb
         fUHFUEJAuZ8fJpjkydnf/bXr6w5C1FyS/sPsRTbD/CGs/l45UI6Ing18LI6aDUgVtG/q
         3dBtM7ILnb+4T1hBpJUg1h1rgW1VTGTjaQU1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4MmlPl8Py5nKlNFKXDj7fuL4G57xgETN+yKIqgFSCl8=;
        b=WNRRa2eVs64B6p5jQoYwhlh8AJLSfFQ+2u0KFcC1a1IkKFjvX7+jidfppDOI87hQco
         yGmF3EFYQRzJkadXH97tq8acBB4NcS7bJFIY1VUdTk6k4K0sgbnc4R8HQRWNfvg61Kh7
         GTV39QHlO7QpLrCJkmnm8LfCWahqrJTPJ3M6m23ygapXL0JW7I1mbcHKMcP8n3MD1au+
         SkisIJnRURHfA2CFlKcGd+wdB4K3EM+7+PANCRytFQWbS7etJrBrbrIQArsD8+7Y8I09
         FOfv5VdFfsNdlfcaXyKM9/QBVVn1fZVZlUMzfZm9ciqZoEEA9JKvwHBcgT+w7aPpyZXi
         ORSQ==
X-Gm-Message-State: APjAAAXPGM58vOJeZIOz3S/w0l+GdkrGrWu1xI+sty1/L5+QL/E4eZDY
        wAd9yUDwDf3N6YDzZrifXp7jv4UbYaHbAjPv8whsC1oZ/OlllnEhUaXGe47T7m35jL2BeOADkLZ
        lvckJIcklln+B+cbsBcUrTTXMaMYCb7ymgkGV3sqswjks9yrx7aoZhb9ts9GMEZdC34FFZ8ERpX
        aICJnDVFvAbuMPhJnq8A==
X-Google-Smtp-Source: APXvYqwJKNbMHCmdCK5reFlzEMhN3lBMszqExx5onifSmOfJBrTx2QCvt8+FCBp3knUQjEgyp29q6w==
X-Received: by 2002:a62:1944:: with SMTP id 65mr15633159pfz.151.1576837964788;
        Fri, 20 Dec 2019 02:32:44 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:44 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 07/10] mpt3sas: Optimize mpt3sas driver logging.
Date:   Fri, 20 Dec 2019 05:32:07 -0500
Message-Id: <20191220103210.43631-8-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This improves mpt3sas driver default debug
information collection and allows for a higher
percentage of issues being able to be resolved
with a first-time data capture.
However, this improvement to balance the amount of
debug data captured with the performance of driver.

Enabled below print messages with out affecting
the IO performance,

1. When task abort TM is received then print IO commands's
timeout value and how much time this command has been
outstanding.
2. Whenever hard reset occurs then print from where
this hard reset is been issued.
3. Failure message should be displayed for failure
scenarios without any logging level.
4. Added a print after driver successfully register or
unregistered a target drive with the SML. This print will be
useful for debugging the issue where the drive addition
or deletion is hanging at SML.
5. During driver load time print request, reply, sense and
config page pool's information such as it's address,
length and size. Also printed sg_tablesize information.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 94 ++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_config.c    | 32 +++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  9 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 42 +++++++----
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 11 +--
 5 files changed, 110 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4bc57c1..3b6e13d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3203,6 +3203,8 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	 */
 	if (!ioc->combined_reply_queue &&
 	    ioc->hba_mpi_version_belonged != MPI2_VERSION) {
+		ioc_info(ioc,
+		    "combined ReplyQueue is off, Enabling msix load balance\n");
 		ioc->msix_load_balance = true;
 	}
 
@@ -3215,9 +3217,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_alloc_irq_vectors(ioc);
 	if (r < 0) {
-		dfailprintk(ioc,
-			    ioc_info(ioc, "pci_alloc_irq_vectors failed (r=%d) !!!\n",
-				     r));
+		ioc_info(ioc, "pci_alloc_irq_vectors failed (r=%d) !!!\n", r);
 		goto try_ioapic;
 	}
 
@@ -3385,7 +3385,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->chip == NULL) {
-		ioc_err(ioc, "unable to map adapter memory! or resource not found\n");
+		ioc_err(ioc,
+		    "unable to map adapter memory! or resource not found\n");
 		r = -EINVAL;
 		goto out_fail;
 	}
@@ -3424,8 +3425,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 		     ioc->combined_reply_index_count,
 		     sizeof(resource_size_t *), GFP_KERNEL);
 		if (!ioc->replyPostRegisterIndex) {
-			dfailprintk(ioc,
-				    ioc_warn(ioc, "allocation for reply Post Register Index failed!!!\n"));
+			ioc_err(ioc,
+			    "allocation for replyPostRegisterIndex failed!\n");
 			r = -ENOMEM;
 			goto out_fail;
 		}
@@ -4370,7 +4371,8 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 	fwpkg_data = dma_alloc_coherent(&ioc->pdev->dev, data_length,
 			&fwpkg_data_dma, GFP_KERNEL);
 	if (!fwpkg_data) {
-		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		ioc_err(ioc,
+		    "Memory allocation for fwpkg data failed at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
 		return -ENOMEM;
 	}
@@ -5100,12 +5102,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 	}
 
-	dinitprintk(ioc,
-		    ioc_info(ioc, "scatter gather: sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), chains_per_io(%d)\n",
-			     ioc->max_sges_in_main_message,
-			     ioc->max_sges_in_chain_message,
-			     ioc->shost->sg_tablesize,
-			     ioc->chains_needed_per_io));
+	ioc_info(ioc,
+	    "scatter gather: sge_in_main_msg(%d), sge_per_chain(%d), "
+	    "sge_per_io(%d), chains_per_io(%d)\n",
+	    ioc->max_sges_in_main_message,
+	    ioc->max_sges_in_chain_message,
+	    ioc->shost->sg_tablesize,
+	    ioc->chains_needed_per_io);
 
 	/* reply post queue, 16 byte align */
 	reply_post_free_sz = ioc->reply_post_queue_depth *
@@ -5215,15 +5218,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->internal_dma = ioc->hi_priority_dma + (ioc->hi_priority_depth *
 	    ioc->request_sz);
 
-	dinitprintk(ioc,
-		    ioc_info(ioc, "request pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB)\n",
-			     ioc->request, ioc->hba_queue_depth,
-			     ioc->request_sz,
-			     (ioc->hba_queue_depth * ioc->request_sz) / 1024));
+	ioc_info(ioc,
+	    "request pool(0x%p) - dma(0x%llx): "
+	    "depth(%d), frame_size(%d), pool_size(%d kB)\n",
+	    ioc->request, (unsigned long long) ioc->request_dma,
+	    ioc->hba_queue_depth, ioc->request_sz,
+	    (ioc->hba_queue_depth * ioc->request_sz) / 1024);
 
-	dinitprintk(ioc,
-		    ioc_info(ioc, "request pool: dma(0x%llx)\n",
-			     (unsigned long long)ioc->request_dma));
 	total_sz += sz;
 
 	dinitprintk(ioc,
@@ -5409,13 +5410,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			goto out;
 		}
 	}
-	dinitprintk(ioc,
-		    ioc_info(ioc, "sense pool(0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
-			     ioc->sense, ioc->scsiio_depth,
-			     SCSI_SENSE_BUFFERSIZE, sz / 1024));
-	dinitprintk(ioc,
-		    ioc_info(ioc, "sense_dma(0x%llx)\n",
-			     (unsigned long long)ioc->sense_dma));
+	ioc_info(ioc,
+	    "sense pool(0x%p)- dma(0x%llx): depth(%d),"
+	    "element_size(%d), pool_size(%d kB)\n",
+	    ioc->sense, (unsigned long long)ioc->sense_dma, ioc->scsiio_depth,
+	    SCSI_SENSE_BUFFERSIZE, sz / 1024);
+
 	total_sz += sz;
 
 	/* reply pool, 4 byte align */
@@ -5493,12 +5493,10 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		ioc_err(ioc, "config page: dma_pool_alloc failed\n");
 		goto out;
 	}
-	dinitprintk(ioc,
-		    ioc_info(ioc, "config page(0x%p): size(%d)\n",
-			     ioc->config_page, ioc->config_page_sz));
-	dinitprintk(ioc,
-		    ioc_info(ioc, "config_page_dma(0x%llx)\n",
-			     (unsigned long long)ioc->config_page_dma));
+
+	ioc_info(ioc, "config page(0x%p) - dma(0x%llx): size(%d)\n",
+	    ioc->config_page, (unsigned long long)ioc->config_page_dma,
+	    ioc->config_page_sz);
 	total_sz += ioc->config_page_sz;
 
 	ioc_info(ioc, "Allocated physical memory: size(%d kB)\n",
@@ -5918,7 +5916,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 		mfp = (__le32 *)reply;
 		pr_info("\toffset:data\n");
 		for (i = 0; i < reply_bytes/4; i++)
-			pr_info("\t[0x%02x]:%08x\n", i*4,
+			ioc_info(ioc, "\t[0x%02x]:%08x\n", i*4,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
@@ -6368,9 +6366,9 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 		int i;
 
 		mfp = (__le32 *)&mpi_request;
-		pr_info("\toffset:data\n");
+		ioc_info(ioc, "\toffset:data\n");
 		for (i = 0; i < sizeof(Mpi2IOCInitRequest_t)/4; i++)
-			pr_info("\t[0x%02x]:%08x\n", i*4,
+			ioc_info(ioc, "\t[0x%02x]:%08x\n", i*4,
 			    le32_to_cpu(mfp[i]));
 	}
 
@@ -6740,8 +6738,11 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		/* wait 100 msec */
 		msleep(100);
 
-		if (count++ > 20)
+		if (count++ > 20) {
+			ioc_info(ioc,
+			    "Stop writing magic sequence after 20 retries\n");
 			goto out;
+		}
 
 		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
 		drsprintk(ioc,
@@ -6765,8 +6766,11 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 
 		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
 
-		if (host_diagnostic == 0xFFFFFFFF)
+		if (host_diagnostic == 0xFFFFFFFF) {
+			ioc_info(ioc,
+			    "Invalid host diagnostic register value\n");
 			goto out;
+		}
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;
 
@@ -6853,7 +6857,7 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 		return 0;
 
 	if (ioc_state & MPI2_DOORBELL_USED) {
-		dhsprintk(ioc, ioc_info(ioc, "unexpected doorbell active!\n"));
+		ioc_info(ioc, "unexpected doorbell active!\n");
 		goto issue_diag_reset;
 	}
 
@@ -7123,8 +7127,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->cpu_msix_table = kzalloc(ioc->cpu_msix_table_sz, GFP_KERNEL);
 	ioc->reply_queue_count = 1;
 	if (!ioc->cpu_msix_table) {
-		dfailprintk(ioc,
-			    ioc_info(ioc, "allocation for cpu_msix_table failed!!!\n"));
+		ioc_info(ioc, "Allocation for cpu_msix_table failed!!!\n");
 		r = -ENOMEM;
 		goto out_free_resources;
 	}
@@ -7133,8 +7136,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->reply_post_host_index = kcalloc(ioc->cpu_msix_table_sz,
 		    sizeof(resource_size_t *), GFP_KERNEL);
 		if (!ioc->reply_post_host_index) {
-			dfailprintk(ioc,
-				    ioc_info(ioc, "allocation for reply_post_host_index failed!!!\n"));
+			ioc_info(ioc, "Allocation for reply_post_host_index failed!!!\n");
 			r = -ENOMEM;
 			goto out_free_resources;
 		}
@@ -7693,9 +7695,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 		_base_reset_done_handler(ioc);
 
  out:
-	dtmprintk(ioc,
-		  ioc_info(ioc, "%s: %s\n",
-			   __func__, r == 0 ? "SUCCESS" : "FAILED"));
+	ioc_info(ioc, "%s: %s\n", __func__, r == 0 ? "SUCCESS" : "FAILED");
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	ioc->shost_recovery = 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 14a1a27..9912ea4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -101,9 +101,6 @@ _config_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	Mpi2ConfigRequest_t *mpi_request;
 	char *desc = NULL;
 
-	if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
-		return;
-
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	switch (mpi_request->Header.PageType & MPI2_CONFIG_PAGETYPE_MASK) {
 	case MPI2_CONFIG_PAGETYPE_IO_UNIT:
@@ -269,7 +266,8 @@ mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 		    mpi_reply->MsgLength*4);
 	}
 	ioc->config_cmds.status &= ~MPT3_CMD_PENDING;
-	_config_display_some_debug(ioc, smid, "config_done", mpi_reply);
+	if (ioc->logging_level & MPT_DEBUG_CONFIG)
+		_config_display_some_debug(ioc, smid, "config_done", mpi_reply);
 	ioc->config_cmds.smid = USHRT_MAX;
 	complete(&ioc->config_cmds.done);
 	return 1;
@@ -378,11 +376,15 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	config_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->config_cmds.smid = smid;
 	memcpy(config_request, mpi_request, sizeof(Mpi2ConfigRequest_t));
-	_config_display_some_debug(ioc, smid, "config_request", NULL);
+	if (ioc->logging_level & MPT_DEBUG_CONFIG)
+		_config_display_some_debug(ioc, smid, "config_request", NULL);
 	init_completion(&ioc->config_cmds.done);
 	ioc->put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->config_cmds.done, timeout*HZ);
 	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
+		if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
+			_config_display_some_debug(ioc,
+			    smid, "config_request", NULL);
 		mpt3sas_base_check_cmd_timeout(ioc,
 			ioc->config_cmds.status, mpi_request,
 			sizeof(Mpi2ConfigRequest_t)/4);
@@ -404,8 +406,11 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		/* Reply Frame Sanity Checks to workaround FW issues */
 		if ((mpi_request->Header.PageType & 0xF) !=
 		    (mpi_reply->Header.PageType & 0xF)) {
+			if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
+				_config_display_some_debug(ioc,
+				    smid, "config_request", NULL);
 			_debug_dump_mf(mpi_request, ioc->request_sz/4);
-			_debug_dump_reply(mpi_reply, ioc->request_sz/4);
+			_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
 			panic("%s: %s: Firmware BUG: mpi_reply mismatch: Requested PageType(0x%02x) Reply PageType(0x%02x)\n",
 			      ioc->name, __func__,
 			      mpi_request->Header.PageType & 0xF,
@@ -415,8 +420,11 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		if (((mpi_request->Header.PageType & 0xF) ==
 		    MPI2_CONFIG_PAGETYPE_EXTENDED) &&
 		    mpi_request->ExtPageType != mpi_reply->ExtPageType) {
+			if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
+				_config_display_some_debug(ioc,
+				    smid, "config_request", NULL);
 			_debug_dump_mf(mpi_request, ioc->request_sz/4);
-			_debug_dump_reply(mpi_reply, ioc->request_sz/4);
+			_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
 			panic("%s: %s: Firmware BUG: mpi_reply mismatch: Requested ExtPageType(0x%02x) Reply ExtPageType(0x%02x)\n",
 			      ioc->name, __func__,
 			      mpi_request->ExtPageType,
@@ -439,8 +447,11 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		if (p) {
 			if ((mpi_request->Header.PageType & 0xF) !=
 			    (p[3] & 0xF)) {
+				if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
+					_config_display_some_debug(ioc,
+					    smid, "config_request", NULL);
 				_debug_dump_mf(mpi_request, ioc->request_sz/4);
-				_debug_dump_reply(mpi_reply, ioc->request_sz/4);
+				_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
 				_debug_dump_config(p, min_t(u16, mem.sz,
 				    config_page_sz)/4);
 				panic("%s: %s: Firmware BUG: config page mismatch: Requested PageType(0x%02x) Reply PageType(0x%02x)\n",
@@ -452,8 +463,11 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 			if (((mpi_request->Header.PageType & 0xF) ==
 			    MPI2_CONFIG_PAGETYPE_EXTENDED) &&
 			    (mpi_request->ExtPageType != p[6])) {
+				if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
+					_config_display_some_debug(ioc,
+					    smid, "config_request", NULL);
 				_debug_dump_mf(mpi_request, ioc->request_sz/4);
-				_debug_dump_reply(mpi_reply, ioc->request_sz/4);
+				_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
 				_debug_dump_config(p, min_t(u16, mem.sz,
 				    config_page_sz)/4);
 				panic("%s: %s: Firmware BUG: config page mismatch: Requested ExtPageType(0x%02x) Reply ExtPageType(0x%02x)\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 4e726ef..7a9df9c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -180,6 +180,12 @@ _ctl_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	case MPI2_FUNCTION_SMP_PASSTHROUGH:
 		desc = "smp_passthrough";
 		break;
+	case MPI2_FUNCTION_TOOLBOX:
+		desc = "toolbox";
+		break;
+	case MPI2_FUNCTION_NVME_ENCAPSULATED:
+		desc = "nvme_encapsulated";
+		break;
 	}
 
 	if (!desc)
@@ -1326,7 +1332,8 @@ _ctl_do_reset(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 				 __func__));
 
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
-	ioc_info(ioc, "host reset: %s\n", ((!retval) ? "SUCCESS" : "FAILED"));
+	ioc_info(ioc,
+	    "Ioctl: host reset: %s\n", ((!retval) ? "SUCCESS" : "FAILED"));
 	return 0;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ec80eed..68f40e3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1606,7 +1606,12 @@ scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 		max_depth = 1;
 	if (qdepth > max_depth)
 		qdepth = max_depth;
-	return scsi_change_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
+	sdev_printk(KERN_INFO, sdev,
+	    "qdepth(%d), tagged(%d), scsi_level(%d), cmd_que(%d)\n",
+	    sdev->queue_depth, sdev->tagged_supported,
+	    sdev->scsi_level, ((sdev->inquiry[7] & 2) >> 1));
+	return sdev->queue_depth;
 }
 
 /**
@@ -2933,15 +2938,17 @@ scsih_abort(struct scsi_cmnd *scmd)
 
 	u8 timeout = 30;
 	struct _pcie_device *pcie_device = NULL;
-	sdev_printk(KERN_INFO, scmd->device,
-		"attempting task abort! scmd(%p)\n", scmd);
+	sdev_printk(KERN_INFO, scmd->device, "attempting task abort!"
+	    "scmd(0x%p), outstanding for %u ms & timeout %u ms\n",
+	    scmd, jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc),
+	    (scmd->request->timeout / HZ) * 1000);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
 	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
-			"device been deleted! scmd(%p)\n", scmd);
+		    "device been deleted! scmd(0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
@@ -2950,6 +2957,8 @@ scsih_abort(struct scsi_cmnd *scmd)
 
 	/* check for completed command */
 	if (st == NULL || st->cb_idx == 0xFF) {
+		sdev_printk(KERN_INFO, scmd->device, "No reference found at "
+		    "driver, assuming scmd(0x%p) might have completed\n", scmd);
 		scmd->result = DID_RESET << 16;
 		r = SUCCESS;
 		goto out;
@@ -2978,7 +2987,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	if (r == SUCCESS && st->cb_idx != 0xFF)
 		r = FAILED;
  out:
-	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
+	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(0x%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 	if (pcie_device)
 		pcie_device_put(pcie_device);
@@ -3007,14 +3016,14 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
 
 	sdev_printk(KERN_INFO, scmd->device,
-		"attempting device reset! scmd(%p)\n", scmd);
+	    "attempting device reset! scmd(0x%p)\n", scmd);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
 	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
-			"device been deleted! scmd(%p)\n", scmd);
+		    "device been deleted! scmd(0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
@@ -3054,7 +3063,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
 		r = FAILED;
  out:
-	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
+	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 
 	if (sas_device)
@@ -3085,15 +3094,15 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 	struct scsi_target *starget = scmd->device->sdev_target;
 	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
 
-	starget_printk(KERN_INFO, starget, "attempting target reset! scmd(%p)\n",
-		scmd);
+	starget_printk(KERN_INFO, starget,
+	    "attempting target reset! scmd(0x%p)\n", scmd);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
 	    ioc->remove_host) {
-		starget_printk(KERN_INFO, starget, "target been deleted! scmd(%p)\n",
-			scmd);
+		starget_printk(KERN_INFO, starget,
+		    "target been deleted! scmd(0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		r = SUCCESS;
@@ -3132,7 +3141,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 	if (r == SUCCESS && atomic_read(&starget->target_busy))
 		r = FAILED;
  out:
-	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
+	starget_printk(KERN_INFO, starget, "target reset: %s scmd(0x%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 
 	if (sas_device)
@@ -3155,7 +3164,7 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	int r, retval;
 
-	ioc_info(ioc, "attempting host reset! scmd(%p)\n", scmd);
+	ioc_info(ioc, "attempting host reset! scmd(0x%p)\n", scmd);
 	scsi_print_command(scmd);
 
 	if (ioc->is_driver_loading || ioc->remove_host) {
@@ -3167,7 +3176,7 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
 out:
-	ioc_info(ioc, "host reset: %s scmd(%p)\n",
+	ioc_info(ioc, "host reset: %s scmd(0x%p)\n",
 		 r == SUCCESS ? "SUCCESS" : "FAILED", scmd);
 
 	return r;
@@ -10872,7 +10881,7 @@ scsih_resume(struct pci_dev *pdev)
 	r = mpt3sas_base_map_resources(ioc);
 	if (r)
 		return r;
-
+	ioc_info(ioc, "Issuing Hard Reset as part of OS Resume\n");
 	mpt3sas_base_hard_reset_handler(ioc, SOFT_RESET);
 	scsi_unblock_requests(shost);
 	mpt3sas_base_start_watchdog(ioc);
@@ -10941,6 +10950,7 @@ scsih_pci_slot_reset(struct pci_dev *pdev)
 	if (rc)
 		return PCI_ERS_RESULT_DISCONNECT;
 
+	ioc_info(ioc, "Issuing Hard Reset as part of PCI Slot Reset\n");
 	rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 
 	ioc_warn(ioc, "hard reset: %s\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 5324662..6ec5b7f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -719,11 +719,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		sas_device_put(sas_device);
 	}
 
-	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-		dev_printk(KERN_INFO, &rphy->dev,
-			"add: handle(0x%04x), sas_addr(0x%016llx)\n",
-			handle, (unsigned long long)
-		    mpt3sas_port->remote_identify.sas_address);
+	dev_info(&rphy->dev,
+	    "add: handle(0x%04x), sas_addr(0x%016llx)\n", handle,
+	    (unsigned long long)mpt3sas_port->remote_identify.sas_address);
+
 	mpt3sas_port->rphy = rphy;
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_add_tail(&mpt3sas_port->port_list, &sas_node->sas_port_list);
@@ -813,6 +812,8 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	}
 	if (!ioc->remove_host)
 		sas_port_delete(mpt3sas_port->port);
+	ioc_info(ioc, "%s: removed: sas_addr(0x%016llx)\n",
+	    __func__, (unsigned long long)sas_address);
 	kfree(mpt3sas_port);
 }
 
-- 
2.18.1

