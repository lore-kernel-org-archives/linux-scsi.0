Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033CBC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB098613E6
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhEMIff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhEMIfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:35:13 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E57C061574
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:52 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b21so14019758plz.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WValWtMMf53XaJCzC6qbWZqGhbiwImRGackulX7DChI=;
        b=aFoqyhDb3OYaTIWU1wdCzs4G9xdlx5oF59Njtah7zEL3P6IDy4aROwq+Hon2snxBdG
         x/JpW23sIPyCwIE2l9oIQsfggoh3tDN+0iqlNt3wmb860xjZSKaXgHRveCg4xosGYXOd
         jO2HIiYQ4yt45aOcgdU481M/HluGT0Sdk3Ct4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WValWtMMf53XaJCzC6qbWZqGhbiwImRGackulX7DChI=;
        b=EnDg0QrZAWkNwkn4LKKH9hB6vWH7zYTPg7N7ExNbENzX3W14elcDfqBFTXGrvyAsGy
         kS/szVp4sLNW2r2SnanFUmLbkzmhZs27g0lJaAZdWV5+oQfB0LwyFBLb3pSTPHihDHkW
         d/4SNyPEpUdX/ck3gCMr571oU5uFbsPmJvl1IqXA5dNfWxl9f03p5mOG8MacW4tRJBG9
         DRqX4Nz//kNEF3XePhON6q0KfDK0ItFYiFrjDOCIPHNCS0KEAbFq/iqo2nYRH+51yMOx
         kGJNWuMBV51G2AMOwGctcxkQPiJ4JUGlIoEj7tXQ1IekXPMWU1pwY620w099hIdqgzvB
         9P1w==
X-Gm-Message-State: AOAM533f6QORm9KxzvjQfY36qcUrKnDDWFnw7xrJxx0y6yQyzIgSWFQl
        SfOSlgSZPghfvDt7v+X6alAgqOJSMFp71PFgklsjHyu8/FV2Hf5vOEWKLygDBp+U29u2vHQAU6o
        u+Vlk5jI6Niw30cnRTRVznvm4fSxRguRNpXxOBwwDhHI/YHsYUiLjL8eP2VRAg2f7mrMFJ5MX6H
        q0VSJacg==
X-Google-Smtp-Source: ABdhPJxoAX/DfQVPTkVfMjPA5FBM6V6v0FHpqIRlsh49E6vT+ku02JbijZSlkLUcrTMvg0n/RyhucA==
X-Received: by 2002:a17:902:ec06:b029:ef:9dcb:1793 with SMTP id l6-20020a170902ec06b02900ef9dcb1793mr1484861pld.38.1620894831048;
        Thu, 13 May 2021 01:33:51 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i123sm1632468pfc.53.2021.05.13.01.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:33:50 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v5 23/24] mpi3mr: add eedp dif dix support
Date:   Thu, 13 May 2021 14:06:07 +0530
Message-Id: <20210513083608.2243297-24-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a897e905c231fc4d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a897e905c231fc4d

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   5 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   7 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 301 +++++++++++++++++++++++++++++++-
 3 files changed, 308 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 35defe6e095c..ed5830c88f34 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -118,6 +118,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_SENSEBUF_SZ	256
 #define MPI3MR_SENSEBUF_FACTOR	3
 #define MPI3MR_CHAINBUF_FACTOR	3
+#define MPI3MR_CHAINBUFDIX_FACTOR	2
 
 /* Invalid target device handle */
 #define MPI3MR_INVALID_DEV_HANDLE	0xFFFF
@@ -557,17 +558,21 @@ struct chain_element {
  *
  * @host_tag: Host tag specific to operational queue
  * @in_lld_scope: Command in LLD scope or not
+ * @meta_sg_valid: DIX command with meta data SGL or not
  * @scmd: SCSI Command pointer
  * @req_q_idx: Operational request queue index
  * @chain_idx: Chain frame index
+ * @meta_chain_idx: Chain frame index of meta data SGL
  * @mpi3mr_scsiio_req: MPI SCSI IO request
  */
 struct scmd_priv {
 	u16 host_tag;
 	u8 in_lld_scope;
+	u8 meta_sg_valid;
 	struct scsi_cmnd *scmd;
 	u16 req_q_idx;
 	int chain_idx;
+	int meta_chain_idx;
 	u8 mpi3mr_scsiio_req[MPI3MR_ADMIN_REQ_FRAME_SZ];
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 34372dc4eb3f..93d9ed155a91 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -9,6 +9,7 @@
 
 #include "mpi3mr.h"
 #include <linux/io-64-nonatomic-lo-hi.h>
+extern int prot_mask;
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
@@ -2749,6 +2750,12 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 
 	num_chains = mrioc->max_host_ios / MPI3MR_CHAINBUF_FACTOR;
 
+	if (prot_mask & (SHOST_DIX_TYPE0_PROTECTION
+	    | SHOST_DIX_TYPE1_PROTECTION
+	    | SHOST_DIX_TYPE2_PROTECTION
+	    | SHOST_DIX_TYPE3_PROTECTION))
+		num_chains += (num_chains / MPI3MR_CHAINBUFDIX_FACTOR);
+
 	mrioc->chain_buf_count = num_chains;
 	sz = sizeof(struct chain_element) * num_chains;
 	mrioc->chain_sgl_list = kzalloc(sz, GFP_KERNEL);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7dbc4ae4a4f0..ba7ce324ed87 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -21,6 +21,13 @@ MODULE_LICENSE(MPI3MR_DRIVER_LICENSE);
 MODULE_VERSION(MPI3MR_DRIVER_VERSION);
 
 /* Module parameters*/
+int prot_mask = -1;
+module_param(prot_mask, int, 0);
+MODULE_PARM_DESC(prot_mask, "Host protection capabilities mask, def=0x07");
+
+int prot_guard_mask = 3;
+module_param(prot_guard_mask, int, 0);
+MODULE_PARM_DESC(prot_guard_mask, " Host protection guard mask, def=3");
 int logging_level;
 module_param(logging_level, int, 0);
 MODULE_PARM_DESC(logging_level,
@@ -59,7 +66,9 @@ static u16 mpi3mr_host_tag_for_scmd(struct mpi3mr_ioc *mrioc,
 	priv->scmd = scmd;
 	priv->in_lld_scope = 1;
 	priv->req_q_idx = hw_queue;
+	priv->meta_chain_idx = -1;
 	priv->chain_idx = -1;
+	priv->meta_sg_valid = 0;
 	return priv->host_tag;
 }
 
@@ -119,10 +128,15 @@ static void mpi3mr_clear_scmd_priv(struct mpi3mr_ioc *mrioc,
 	priv->req_q_idx = 0xFFFF;
 	priv->scmd = NULL;
 	priv->in_lld_scope = 0;
+	priv->meta_sg_valid = 0;
 	if (priv->chain_idx >= 0) {
 		clear_bit(priv->chain_idx, mrioc->chain_bitmap);
 		priv->chain_idx = -1;
 	}
+	if (priv->meta_chain_idx >= 0) {
+		clear_bit(priv->meta_chain_idx, mrioc->chain_bitmap);
+		priv->meta_chain_idx = -1;
+	}
 }
 
 static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
@@ -388,6 +402,9 @@ static bool mpi3mr_flush_scmd(struct request *rq,
 		if (!priv->in_lld_scope)
 			goto out;
 
+		if (priv->meta_sg_valid)
+			dma_unmap_sg(&mrioc->pdev->dev, scsi_prot_sglist(scmd),
+			    scsi_prot_sg_count(scmd), scmd->sc_data_direction);
 		mpi3mr_clear_scmd_priv(mrioc, scmd);
 		scsi_dma_unmap(scmd);
 		scmd->result = DID_RESET << 16;
@@ -785,6 +802,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 {
 	u16 flags = 0;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	u8 prot_mask = 0;
 
 	tgtdev->perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	tgtdev->dev_handle = le16_to_cpu(dev_pg0->dev_handle);
@@ -849,6 +867,15 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		if ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
 		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE)
 			tgtdev->is_hidden = 1;
+		if (mrioc->shost)
+			prot_mask = scsi_host_get_prot(mrioc->shost);
+		if (prot_mask & SHOST_DIX_TYPE0_PROTECTION) {
+			scsi_host_set_prot(mrioc->shost, prot_mask & 0x77);
+			ioc_info(mrioc,
+			    "%s : Disabling DIX0 prot capability\n", __func__);
+			ioc_info(mrioc,
+			    "because HBA does not support DIX0 operation on NVME drives\n");
+		}
 		break;
 	}
 	case MPI3_DEVICE_DEVFORM_VD:
@@ -1752,6 +1779,194 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * mpi3mr_setup_eedp - Setup EEDP information in MPI3 SCSI IO
+ * @mrioc: Adapter instance reference
+ * @scmd: SCSI command reference
+ * @scsiio_req: MPI3 SCSI IO request
+ *
+ * Identifies the protection information flags from the SCSI
+ * command and set appropriate flags in the MPI3 SCSI IO
+ * request.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
+	struct scsi_cmnd *scmd, struct _mpi3_scsi_io_request *scsiio_req)
+{
+	u16 eedp_flags = 0;
+	unsigned char prot_op = scsi_get_prot_op(scmd);
+	unsigned char prot_type = scsi_get_prot_type(scmd);
+
+	switch (prot_op) {
+	case SCSI_PROT_NORMAL:
+		return;
+	case SCSI_PROT_READ_STRIP:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REMOVE;
+		break;
+	case SCSI_PROT_WRITE_INSERT:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_INSERT;
+		break;
+	case SCSI_PROT_READ_INSERT:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_INSERT;
+		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	case SCSI_PROT_WRITE_STRIP:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REMOVE;
+		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	case SCSI_PROT_READ_PASS:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
+		    MPI3_EEDPFLAGS_CHK_REF_TAG | MPI3_EEDPFLAGS_CHK_APP_TAG |
+		    MPI3_EEDPFLAGS_CHK_GUARD;
+		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+		if (scsi_host_get_guard(scmd->device->host)
+		    & SHOST_DIX_GUARD_IP) {
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN |
+			    MPI3_EEDPFLAGS_CHK_APP_TAG |
+			    MPI3_EEDPFLAGS_CHK_GUARD |
+			    MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+			scsiio_req->sgl[0].eedp.application_tag_translation_mask =
+			    0xffff;
+		} else {
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
+			    MPI3_EEDPFLAGS_CHK_REF_TAG |
+			    MPI3_EEDPFLAGS_CHK_APP_TAG |
+			    MPI3_EEDPFLAGS_CHK_GUARD;
+		}
+		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	default:
+		return;
+	}
+
+	if (scsi_host_get_guard(scmd->device->host) & SHOST_DIX_GUARD_IP)
+		eedp_flags |= MPI3_EEDPFLAGS_HOST_GUARD_IP_CHKSUM;
+
+	switch (prot_type) {
+	case SCSI_PROT_DIF_TYPE0:
+		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+		scsiio_req->cdb.eedp32.primary_reference_tag =
+		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		break;
+	case SCSI_PROT_DIF_TYPE1:
+	case SCSI_PROT_DIF_TYPE2:
+		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG |
+		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE |
+		    MPI3_EEDPFLAGS_CHK_GUARD;
+		scsiio_req->cdb.eedp32.primary_reference_tag =
+		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		break;
+	case SCSI_PROT_DIF_TYPE3:
+		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD |
+		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE;
+		break;
+
+	default:
+		scsiio_req->msg_flags &= ~(MPI3_SCSIIO_MSGFLAGS_METASGL_VALID);
+		return;
+	}
+
+	switch (scmd->device->sector_size) {
+	case 512:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_512;
+		break;
+	case 520:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_520;
+		break;
+	case 4080:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_4080;
+		break;
+	case 4088:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_4088;
+		break;
+	case 4096:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_4096;
+		break;
+	case 4104:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_4104;
+		break;
+	case 4160:
+		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_4160;
+		break;
+	default:
+		break;
+	}
+
+	scsiio_req->sgl[0].eedp.eedp_flags = cpu_to_le16(eedp_flags);
+	scsiio_req->sgl[0].eedp.flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED;
+}
+
+
+/**
+ * mpi3mr_build_sense_buffer - Map sense information
+ * @desc: Sense type
+ * @buf: Sense buffer to populate
+ * @key: Sense key
+ * @asc: Additional sense code
+ * @ascq: Additional sense code qualifier
+ *
+ * Maps the given sense information into either descriptor or
+ * fixed format sense data.
+ *
+ * Return: Nothing
+ */
+static inline void mpi3mr_build_sense_buffer(int desc, u8 *buf, u8 key,
+	u8 asc, u8 ascq)
+{
+	if (desc) {
+		buf[0] = 0x72;	/* descriptor, current */
+		buf[1] = key;
+		buf[2] = asc;
+		buf[3] = ascq;
+		buf[7] = 0;
+	} else {
+		buf[0] = 0x70;	/* fixed, current */
+		buf[2] = key;
+		buf[7] = 0xa;
+		buf[12] = asc;
+		buf[13] = ascq;
+	}
+}
+
+/**
+ * mpi3mr_map_eedp_error - Map EEDP errors from IOC status
+ * @scmd: SCSI command reference
+ * @ioc_status: status of MPI3 request
+ *
+ * Maps the EEDP error status of the SCSI IO request to sense
+ * data.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_map_eedp_error(struct scsi_cmnd *scmd,
+	u16 ioc_status)
+{
+	u8 ascq = 0;
+
+	switch (ioc_status) {
+	case MPI3_IOCSTATUS_EEDP_GUARD_ERROR:
+		ascq = 0x01;
+		break;
+	case MPI3_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		ascq = 0x02;
+		break;
+	case MPI3_IOCSTATUS_EEDP_REF_TAG_ERROR:
+		ascq = 0x03;
+		break;
+	default:
+		ascq = 0x00;
+		break;
+	}
+
+	mpi3mr_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+	    0x10, ascq);
+	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
+	    SAM_STAT_CHECK_CONDITION;
+}
+
 /**
  * mpi3mr_process_op_reply_desc - reply descriptor handler
  * @mrioc: Adapter instance reference
@@ -1914,6 +2129,11 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		else if (scsi_state & MPI3_SCSI_STATE_TERMINATED)
 			scmd->result = DID_RESET << 16;
 		break;
+	case MPI3_IOCSTATUS_EEDP_GUARD_ERROR:
+	case MPI3_IOCSTATUS_EEDP_REF_TAG_ERROR:
+	case MPI3_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		mpi3mr_map_eedp_error(scmd, ioc_status);
+		break;
 	case MPI3_IOCSTATUS_SCSI_PROTOCOL_ERROR:
 	case MPI3_IOCSTATUS_INVALID_FUNCTION:
 	case MPI3_IOCSTATUS_INVALID_SGL:
@@ -1949,6 +2169,10 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		}
 	}
 out_success:
+	if (priv->meta_sg_valid) {
+		dma_unmap_sg(&mrioc->pdev->dev, scsi_prot_sglist(scmd),
+		    scsi_prot_sg_count(scmd), scmd->sc_data_direction);
+	}
 	mpi3mr_clear_scmd_priv(mrioc, scmd);
 	scsi_dma_unmap(scmd);
 	scmd->scsi_done(scmd);
@@ -2012,6 +2236,8 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	u8 last_chain_sgl_flags;
 	struct chain_element *chain_req;
 	struct scmd_priv *priv = NULL;
+	u32 meta_sg = le32_to_cpu(scsiio_req->flags) &
+	    MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI;
 
 	priv = scsi_cmd_priv(scmd);
 
@@ -2022,15 +2248,27 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	last_chain_sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN |
 	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
 
-	sg_local = &scsiio_req->sgl;
+	if (meta_sg)
+		sg_local = &scsiio_req->sgl[MPI3_SCSIIO_METASGL_INDEX];
+	else
+		sg_local = &scsiio_req->sgl;
 
-	if (!scsiio_req->data_length) {
+	if (!scsiio_req->data_length && !meta_sg) {
 		mpi3mr_build_zero_len_sge(sg_local);
 		return 0;
 	}
 
-	sg_scmd = scsi_sglist(scmd);
-	sges_left = scsi_dma_map(scmd);
+	if (meta_sg) {
+		sg_scmd = scsi_prot_sglist(scmd);
+		sges_left = dma_map_sg(&mrioc->pdev->dev,
+		    scsi_prot_sglist(scmd),
+		    scsi_prot_sg_count(scmd),
+		    scmd->sc_data_direction);
+		priv->meta_sg_valid = 1; /* To unmap meta sg DMA */
+	} else {
+		sg_scmd = scsi_sglist(scmd);
+		sges_left = scsi_dma_map(scmd);
+	}
 
 	if (sges_left < 0) {
 		sdev_printk(KERN_ERR, scmd->device,
@@ -2048,6 +2286,22 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	sges_in_segment = (mrioc->facts.op_req_sz -
 	    offsetof(struct _mpi3_scsi_io_request, sgl)) / sizeof(struct _mpi3_sge_common);
 
+	if (scsiio_req->sgl[0].eedp.flags ==
+	    MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED && !meta_sg) {
+		sg_local += sizeof(struct _mpi3_sge_common);
+		sges_in_segment--;
+		/* Reserve 1st segment (scsiio_req->sgl[0]) for eedp */
+	}
+
+	if (scsiio_req->msg_flags ==
+	    MPI3_SCSIIO_MSGFLAGS_METASGL_VALID && !meta_sg) {
+		sges_in_segment--;
+		/* Reserve last segment (scsiio_req->sgl[3]) for meta sg */
+	}
+
+	if (meta_sg)
+		sges_in_segment = 1;
+
 	if (sges_left <= sges_in_segment)
 		goto fill_in_last_segment;
 
@@ -2065,7 +2319,10 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	if (chain_idx < 0)
 		return -1;
 	chain_req = &mrioc->chain_sgl_list[chain_idx];
-	priv->chain_idx = chain_idx;
+	if (meta_sg)
+		priv->meta_chain_idx = chain_idx;
+	else
+		priv->chain_idx = chain_idx;
 
 	chain = chain_req->addr;
 	chain_dma = chain_req->dma_addr;
@@ -2115,6 +2372,13 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
 	if (ret)
 		return ret;
 
+	if (scsiio_req->msg_flags == MPI3_SCSIIO_MSGFLAGS_METASGL_VALID) {
+		/* There is a valid meta sg */
+		scsiio_req->flags |=
+		    cpu_to_le32(MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI);
+		ret = mpi3mr_prepare_sg_scmd(mrioc, scmd, scsiio_req);
+	}
+
 	return ret;
 }
 
@@ -3122,6 +3386,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	scsiio_req->function = MPI3_FUNCTION_SCSI_IO;
 	scsiio_req->host_tag = cpu_to_le16(host_tag);
 
+	mpi3mr_setup_eedp(mrioc, scmd, scsiio_req);
+
 	memcpy(scsiio_req->cdb.cdb32, scmd->cmnd, scmd->cmd_len);
 	scsiio_req->data_length = cpu_to_le32(scsi_bufflen(scmd));
 	scsiio_req->dev_handle = cpu_to_le16(dev_handle);
@@ -3345,6 +3611,31 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_channel = 1;
 	shost->max_id = 0xFFFFFFFF;
 
+	if (prot_mask >= 0)
+		scsi_host_set_prot(shost, prot_mask);
+	else {
+		prot_mask = SHOST_DIF_TYPE1_PROTECTION
+		    | SHOST_DIF_TYPE2_PROTECTION
+		    | SHOST_DIF_TYPE3_PROTECTION;
+		scsi_host_set_prot(shost, prot_mask);
+	}
+
+	ioc_info(mrioc,
+	    "%s :host protection capabilities enabled %s%s%s%s%s%s%s\n",
+	    __func__,
+	    (prot_mask & SHOST_DIF_TYPE1_PROTECTION) ? " DIF1" : "",
+	    (prot_mask & SHOST_DIF_TYPE2_PROTECTION) ? " DIF2" : "",
+	    (prot_mask & SHOST_DIF_TYPE3_PROTECTION) ? " DIF3" : "",
+	    (prot_mask & SHOST_DIX_TYPE0_PROTECTION) ? " DIX0" : "",
+	    (prot_mask & SHOST_DIX_TYPE1_PROTECTION) ? " DIX1" : "",
+	    (prot_mask & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
+	    (prot_mask & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
+
+	if (prot_guard_mask)
+		scsi_host_set_guard(shost, (prot_guard_mask & 3));
+	else
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+
 	snprintf(mrioc->fwevt_worker_name, sizeof(mrioc->fwevt_worker_name),
 	    "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
 	mrioc->fwevt_worker_thread = alloc_ordered_workqueue(
-- 
2.18.1


--000000000000a897e905c231fc4d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIO7GjN/Vd1XTogRsd+QzjEtSbFIz
SiHkzKCSWL7CNRujMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMzA4MzM1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQApijmJYrVr3MTwTsV+mc59EJGjZ9yXyEILUrV76Nhgmhe+
rsTYe4WF1zPboBlUDOqG43TyBmZU5/JsZuiqHihBW69DosImf/jFbuMAyYY9k+tjmaTPUayUupj1
XClqdEF/ropGiH8DOMC80DoP0DCkSfUkYGOB3ioIZe0i4VLfBRU2aek8dM6f3iMN22fkFFSfsbtr
74KHTES6QWXFNe6lXRLU9WyvS9d5+4UiVKoeAbysMSbb4tI8KT+WR5GtKgowI66mOuqVFR/49BX/
LG8XnINL591B5zA/pLJ9mbWMmwfwcurk81W+A1m5fz+qqZsGfUw7FuZvnPRy0cB0yBrJ
--000000000000a897e905c231fc4d--
