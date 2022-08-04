Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640A2C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiHDNBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiHDNAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F8B6396
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 13so3439924pgc.8
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=e5auVHbMSQmrr7269SWAVVfM+pPFg+TVeK0RV3VrVVE=;
        b=Bmr8ccBOzX1duXsb/K21z81Hs1uAAIrCxecXgz/RIUXouCds4xFcSH9atnoVGkzBVm
         VMB9VPXuGaiGCmUardqWFHGhcyQwkPOf0T/+7jWnLX89A7YeQqRMiYZvkp3FCjFIr24e
         +RVTWBuXOBeZjMwgkfTiM2eVReaoUo+WsgHS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=e5auVHbMSQmrr7269SWAVVfM+pPFg+TVeK0RV3VrVVE=;
        b=V5IbYn1JVtbDUR4O1WT5nUjQ1cGlLC7pAjyIpK2x2d4KLnHQBMRRjRZ/QS/F4xi0Bv
         nUqdIkyuHGBhNVGUgqBzTzZfPye3U6oNCY8AsI6sdNGqOs782wuolpHiNTQMyLQZP2u+
         ayOFJUf0ag1EmGWUXE56Q+u99SA1iLSLN8wwLRcV8+ML6Gc4EDFpGXZpkM/otYo+PNvt
         gUr78kmKVUYmn6P6IEx/ol/BSp2bNYJ+NDQlFSu+vgI+6HRas6yptPK6mrDRPXNRGjOK
         UYEbcQc7ychYCKKazI2GY+JrmQNXnKKMaazw0oJrFhq3/PGXo2RiBcm+vMqwGCwnZ1ct
         uYBA==
X-Gm-Message-State: ACgBeo1mNw3hEL3goPQp1ItRika3cRCFQP7josIDP/E1jxXJwAEcZCjz
        qKPE//XnOQSONJ+MjNO+2198uAFGyZcRID7G0YXkxdS3A2DgC1FiZT6P4UWG+o0cNkFkXlIkgS8
        LX/7xTkS84eLQkCKFbTBMtV6NwBm+RjTMvoDMNDDD69k6ql7tsY6j6UH18GCc65lrQyQ+JAodKB
        rvp5yrovZ1
X-Google-Smtp-Source: AA6agR4vHe+tGHJeU28R0g1W0sz+zqoPgbh/Gvnhm8WJuPgGIjuIduNXZtjwYS4kx0lY/bvy8mIGkA==
X-Received: by 2002:a63:83c1:0:b0:41c:cf3d:b896 with SMTP id h184-20020a6383c1000000b0041ccf3db896mr1474986pge.341.1659618049308;
        Thu, 04 Aug 2022 06:00:49 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:48 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 12/15] mpi3mr: Add framework to issue MPT transport cmds
Date:   Thu,  4 Aug 2022 18:42:23 +0530
Message-Id: <20220804131226.16653-13-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005538b705e569f08b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005538b705e569f08b
Content-Transfer-Encoding: 8bit

Added framework to issue MPT transport commands to
controllers.
Also issued the MPT transport commands to get the
manufacturing info of sas expander device.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |   6 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  14 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c        |   2 +
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 228 +++++++++++++++++++++++++
 4 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 21ea021..a6c880c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -99,9 +99,10 @@ extern atomic64_t event_counter;
 #define MPI3MR_HOSTTAG_PEL_WAIT		4
 #define MPI3MR_HOSTTAG_BLK_TMS		5
 #define MPI3MR_HOSTTAG_CFG_CMDS		6
+#define MPI3MR_HOSTTAG_TRANSPORT_CMDS	7
 
 #define MPI3MR_NUM_DEVRMCMD		16
-#define MPI3MR_HOSTTAG_DEVRMCMD_MIN	(MPI3MR_HOSTTAG_BLK_TMS + 1)
+#define MPI3MR_HOSTTAG_DEVRMCMD_MIN	(MPI3MR_HOSTTAG_TRANSPORT_CMDS + 1)
 #define MPI3MR_HOSTTAG_DEVRMCMD_MAX	(MPI3MR_HOSTTAG_DEVRMCMD_MIN + \
 						MPI3MR_NUM_DEVRMCMD - 1)
 
@@ -279,6 +280,7 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_SYSFS_TIMEOUT = 24,
 	MPI3MR_RESET_FROM_FIRMWARE = 27,
 	MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT = 29,
+	MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT = 30,
 };
 
 /* Queue type definitions */
@@ -1004,6 +1006,7 @@ struct scmd_priv {
  * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
  * @scsi_device_channel: Channel ID for SCSI devices
+ * @transport_cmds: Command tracker for SAS transport commands
  * @sas_hba: SAS node for the controller
  * @sas_expander_list: SAS node list of expanders
  * @sas_node_lock: Lock to protect SAS node list
@@ -1188,6 +1191,7 @@ struct mpi3mr_ioc {
 
 	u8 sas_transport_enabled;
 	u8 scsi_device_channel;
+	struct mpi3mr_drv_cmd transport_cmds;
 	struct mpi3mr_sas_node sas_hba;
 	struct list_head sas_expander_list;
 	spinlock_t sas_node_lock;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 295ad8c..cbc346d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -312,6 +312,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 		return &mrioc->pel_abort_cmd;
 	case MPI3MR_HOSTTAG_PEL_WAIT:
 		return &mrioc->pel_cmds;
+	case MPI3MR_HOSTTAG_TRANSPORT_CMDS:
+		return &mrioc->transport_cmds;
 	case MPI3MR_HOSTTAG_INVALID:
 		if (def_reply && def_reply->function ==
 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
@@ -913,6 +915,7 @@ static const struct {
 	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
 	{ MPI3MR_RESET_FROM_FIRMWARE, "firmware asynchronous reset" },
 	{ MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT, "configuration request timeout"},
+	{ MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT, "timeout of a SAS transport layer request" },
 };
 
 /**
@@ -2866,6 +2869,10 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->bsg_cmds.reply)
 		goto out_failed;
 
+	mrioc->transport_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
+	if (!mrioc->transport_cmds.reply)
+		goto out_failed;
+
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
 		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->reply_sz,
 		    GFP_KERNEL);
@@ -4072,6 +4079,8 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		    sizeof(*mrioc->pel_cmds.reply));
 		memset(mrioc->pel_abort_cmd.reply, 0,
 		    sizeof(*mrioc->pel_abort_cmd.reply));
+		memset(mrioc->transport_cmds.reply, 0,
+		    sizeof(*mrioc->transport_cmds.reply));
 		for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 			memset(mrioc->dev_rmhs_cmds[i].reply, 0,
 			    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
@@ -4217,6 +4226,9 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->chain_bitmap);
 	mrioc->chain_bitmap = NULL;
 
+	kfree(mrioc->transport_cmds.reply);
+	mrioc->transport_cmds.reply = NULL;
+
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
 		kfree(mrioc->dev_rmhs_cmds[i].reply);
 		mrioc->dev_rmhs_cmds[i].reply = NULL;
@@ -4417,6 +4429,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 	cmdptr = &mrioc->pel_abort_cmd;
 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 
+	cmdptr = &mrioc->transport_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 }
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8b1b912..048c9dd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4841,6 +4841,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
 	mpi3mr_init_drv_cmd(&mrioc->bsg_cmds, MPI3MR_HOSTTAG_BSG_CMDS);
 	mpi3mr_init_drv_cmd(&mrioc->cfg_cmds, MPI3MR_HOSTTAG_CFG_CMDS);
+	mpi3mr_init_drv_cmd(&mrioc->transport_cmds,
+	    MPI3MR_HOSTTAG_TRANSPORT_CMDS);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 706c6e6..22da497 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -9,6 +9,225 @@
 
 #include "mpi3mr.h"
 
+/**
+ * mpi3mr_post_transport_req - Issue transport requests and wait
+ * @mrioc: Adapter instance reference
+ * @request: Properly populated MPI3 request
+ * @request_sz: Size of the MPI3 request
+ * @reply: Pointer to return MPI3 reply
+ * @reply_sz: Size of the MPI3 reply buffer
+ * @timeout: Timeout in seconds
+ * @ioc_status: Pointer to return ioc status
+ *
+ * A generic function for posting MPI3 requests from the SAS
+ * transport layer that uses transport command infrastructure.
+ * This blocks for the completion of request for timeout seconds
+ * and if the request times out this function faults the
+ * controller with proper reason code.
+ *
+ * On successful completion of the request this function returns
+ * appropriate ioc status from the firmware back to the caller.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_post_transport_req(struct mpi3mr_ioc *mrioc, void *request,
+	u16 request_sz, void *reply, u16 reply_sz, int timeout,
+	u16 *ioc_status)
+{
+	int retval = 0;
+
+	mutex_lock(&mrioc->transport_cmds.mutex);
+	if (mrioc->transport_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "sending transport request failed due to command in use\n");
+		mutex_unlock(&mrioc->transport_cmds.mutex);
+		goto out;
+	}
+	mrioc->transport_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->transport_cmds.is_waiting = 1;
+	mrioc->transport_cmds.callback = NULL;
+	mrioc->transport_cmds.ioc_status = 0;
+	mrioc->transport_cmds.ioc_loginfo = 0;
+
+	init_completion(&mrioc->transport_cmds.done);
+	dprint_cfg_info(mrioc, "posting transport request\n");
+	if (mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO)
+		dprint_dump(request, request_sz, "transport_req");
+	retval = mpi3mr_admin_request_post(mrioc, request, request_sz, 1);
+	if (retval) {
+		ioc_err(mrioc, "posting transport request failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->transport_cmds.done,
+	    (timeout * HZ));
+	if (!(mrioc->transport_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT);
+		ioc_err(mrioc, "transport request timed out\n");
+		retval = -1;
+		goto out_unlock;
+	}
+	*ioc_status = mrioc->transport_cmds.ioc_status &
+		MPI3_IOCSTATUS_STATUS_MASK;
+	if ((*ioc_status) != MPI3_IOCSTATUS_SUCCESS)
+		dprint_transport_err(mrioc,
+		    "transport request returned with ioc_status(0x%04x), log_info(0x%08x)\n",
+		    *ioc_status, mrioc->transport_cmds.ioc_loginfo);
+
+	if ((reply) && (mrioc->transport_cmds.state & MPI3MR_CMD_REPLY_VALID))
+		memcpy((u8 *)reply, mrioc->transport_cmds.reply, reply_sz);
+
+out_unlock:
+	mrioc->transport_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->transport_cmds.mutex);
+
+out:
+	return retval;
+}
+
+/* report manufacture request structure */
+struct rep_manu_request {
+	u8 smp_frame_type;
+	u8 function;
+	u8 reserved;
+	u8 request_length;
+};
+
+/* report manufacture reply structure */
+struct rep_manu_reply {
+	u8 smp_frame_type; /* 0x41 */
+	u8 function; /* 0x01 */
+	u8 function_result;
+	u8 response_length;
+	u16 expander_change_count;
+	u8 reserved0[2];
+	u8 sas_format;
+	u8 reserved2[3];
+	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
+	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
+	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
+	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+	u16 component_id;
+	u8 component_revision_id;
+	u8 reserved3;
+	u8 vendor_specific[8];
+};
+
+/**
+ * mpi3mr_report_manufacture - obtain SMP report_manufacture
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of the expander device
+ * @edev: SAS transport layer sas_expander_device object
+ * @port_id: ID of the HBA port
+ *
+ * Fills in the sas_expander_device with manufacturing info.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
+	u64 sas_address, struct sas_expander_device *edev, u8 port_id)
+{
+	struct mpi3_smp_passthrough_request mpi_request;
+	struct mpi3_smp_passthrough_reply mpi_reply;
+	struct rep_manu_reply *manufacture_reply;
+	struct rep_manu_request *manufacture_request;
+	int rc = 0;
+	void *psge;
+	void *data_out = NULL;
+	dma_addr_t data_out_dma;
+	dma_addr_t data_in_dma;
+	size_t data_in_sz;
+	size_t data_out_sz;
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+	u16 request_sz = sizeof(struct mpi3_smp_passthrough_request);
+	u16 reply_sz = sizeof(struct mpi3_smp_passthrough_reply);
+	u16 ioc_status;
+
+	if (mrioc->reset_in_progress) {
+		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
+		return -EFAULT;
+	}
+
+	data_out_sz = sizeof(struct rep_manu_request);
+	data_in_sz = sizeof(struct rep_manu_reply);
+	data_out = dma_alloc_coherent(&mrioc->pdev->dev,
+	    data_out_sz + data_in_sz, &data_out_dma, GFP_KERNEL);
+	if (!data_out) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	data_in_dma = data_out_dma + data_out_sz;
+	manufacture_reply = data_out + data_out_sz;
+
+	manufacture_request = data_out;
+	manufacture_request->smp_frame_type = 0x40;
+	manufacture_request->function = 1;
+	manufacture_request->reserved = 0;
+	manufacture_request->request_length = 0;
+
+	memset(&mpi_request, 0, request_sz);
+	memset(&mpi_reply, 0, reply_sz);
+	mpi_request.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi_request.function = MPI3_FUNCTION_SMP_PASSTHROUGH;
+	mpi_request.io_unit_port = (u8) port_id;
+	mpi_request.sas_address = cpu_to_le64(sas_address);
+
+	psge = &mpi_request.request_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, data_out_sz, data_out_dma);
+
+	psge = &mpi_request.response_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, data_in_sz, data_in_dma);
+
+	dprint_transport_info(mrioc,
+	    "sending report manufacturer SMP request to sas_address(0x%016llx), port(%d)\n",
+	    (unsigned long long)sas_address, port_id);
+
+	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
+		goto out;
+
+	dprint_transport_info(mrioc,
+	    "report manufacturer SMP request completed with ioc_status(0x%04x)\n",
+	    ioc_status);
+
+	if (ioc_status == MPI3_IOCSTATUS_SUCCESS) {
+		u8 *tmp;
+
+		dprint_transport_info(mrioc,
+		    "report manufacturer - reply data transfer size(%d)\n",
+		    le16_to_cpu(mpi_reply.response_data_length));
+
+		if (le16_to_cpu(mpi_reply.response_data_length) !=
+		    sizeof(struct rep_manu_reply))
+			goto out;
+
+		strscpy(edev->vendor_id, manufacture_reply->vendor_id,
+		     SAS_EXPANDER_VENDOR_ID_LEN);
+		strscpy(edev->product_id, manufacture_reply->product_id,
+		     SAS_EXPANDER_PRODUCT_ID_LEN);
+		strscpy(edev->product_rev, manufacture_reply->product_rev,
+		     SAS_EXPANDER_PRODUCT_REV_LEN);
+		edev->level = manufacture_reply->sas_format & 1;
+		if (edev->level) {
+			strscpy(edev->component_vendor_id,
+			    manufacture_reply->component_vendor_id,
+			     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+			tmp = (u8 *)&manufacture_reply->component_id;
+			edev->component_id = tmp[0] << 8 | tmp[1];
+			edev->component_revision_id =
+			    manufacture_reply->component_revision_id;
+		}
+	}
+
+out:
+	if (data_out)
+		dma_free_coherent(&mrioc->pdev->dev, data_out_sz + data_in_sz,
+		    data_out, data_out_dma);
+
+	return rc;
+}
+
 /**
  * __mpi3mr_expander_find_by_handle - expander search by handle
  * @mrioc: Adapter instance reference
@@ -1218,6 +1437,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 			mpi3mr_print_device_event_notice(mrioc, true);
 	}
 
+	/* fill in report manufacture */
+	if (mr_sas_port->remote_identify.device_type ==
+	    SAS_EDGE_EXPANDER_DEVICE ||
+	    mr_sas_port->remote_identify.device_type ==
+	    SAS_FANOUT_EXPANDER_DEVICE)
+		mpi3mr_report_manufacture(mrioc,
+		    mr_sas_port->remote_identify.sas_address,
+		    rphy_to_expander_device(rphy), hba_port->port_id);
+
 	return mr_sas_port;
 
  out_fail:
-- 
2.27.0


--0000000000005538b705e569f08b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHV86j9oCWiA0RmrmJ2J
D+OhWbhA5KdYk3Z8sVgkPHP1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDA0OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAfLge4E0OWGbOUSswRbsy6Hpfhipok4QfL64cx
ZsuFiw4mGeZxq9dGXzXOXZlve/vTVbEde4PKdCSPvVd4ACps3UBbkYftN5b0OfRvGXTgORP1vkI6
vsPl4kV5wfJOxZPnIC1g9fIGwISLArbrz4Ljlp2K/nk4KfrACxZlkGV4QMfErO2zGZyRyAscbsfO
7ixHRHYX2xdwJKl5WKc3/S+h0kqxjfAiT5YqRk77LrO1w7QZADIDM1ie+j7BTSVN1Y/MthT5+NEv
h9tKnyZzJ7HWM4eJTtms8DxFz7wVImBi59GeKTF0oPtry09bIfeFVQLD3wV8nrOf7+fMJ60nDTLG
--0000000000005538b705e569f08b--
