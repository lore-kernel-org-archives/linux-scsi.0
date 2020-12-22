Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2621C4332D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7EC2311D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgLVKOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLVKOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:14:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F4C061282
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:30 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lb18so1068929pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=op9q/KuhO3CAtLgGnNie25+8nuvHQFPCshirjpqOF7s=;
        b=ax+VjiIhPZ1zgZ7rrDgACYR0aijN0/QCfbCLsnH/o/xr8+nQ+KTzjsdaaV2ION/VMI
         q7CcIR4py7C8YKQfnOs9y4Ffi6qkglwwt7Nwc2atiVMw9qFD3wUGvbT/7U6nZdyKDqv2
         KcEm5EUk9Fby3fImUX+4KuKio7J599kXRQNg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=op9q/KuhO3CAtLgGnNie25+8nuvHQFPCshirjpqOF7s=;
        b=qn6Ouay1Qa7LMxlHGZ87nXHLQZulCJ+JqtODKCx7oQ6KIeJPrrTCwswwG03zQb1KHg
         V4bwsIU6EvGM1JkJ39+V+4NHcipgtrdTJCQMk+HpTT4wtR+RpgOokuTm6ej/4AY8YsVD
         210J8JNEczz6XdJbw5v0KGZ08WLt1GhiQMlnmWaG/inQ3ySF93EMUEQJIG8FSpPfVuSV
         bLpMsr4cgG7heHsGJl4BnFuEiZR5GrTp9Cbwleg18QZNNKlzkOX8Y1T2BQQ+Zg4TFWPe
         WQSdAnThqXJBuvxh9wQVpwjGKbGQzXK0uqtc5u1GTmgIsrBi5wfrz/FtmIZF12Yi8XnR
         VGqw==
X-Gm-Message-State: AOAM5304CDbyqC8tccMHW33g7zmRJ2EG9qiVbVsAoJRYCiUWHOBKhoKp
        tMXvkRZ0sYr8jiYsNMCD4rvls2mmAzmVWKZSez1PAMKTpenNjj0TGDD21gdbtyXjkmmJVxlMXi+
        NpK7/ZotgYhDknqvOraZxFBvzFMsoDvSMLD3i9pWdNNqBi2C39mbk+QlMCly41u0/37YkeDeits
        xiiWWc+qXr
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJzc6BoGrsG/rL9ybLNiemgshycfBQpja5XkwvjANwxqjw5+Ph1YRQnW2Nz6iDgdLCM2JxLo/A==
X-Received: by 2002:a17:90b:943:: with SMTP id dw3mr20911887pjb.97.1608632009172;
        Tue, 22 Dec 2020 02:13:29 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:13:28 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 23/24] mpi3mr: add eedp dif dix support
Date:   Tue, 22 Dec 2020 15:41:55 +0530
Message-Id: <20201222101156.98308-24-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008246d605b70ad32e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008246d605b70ad32e
Content-Type: text/plain; charset="US-ASCII"

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  18 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   7 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 303 +++++++++++++++++++++++++++++++-
 3 files changed, 321 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index f0ead83dc16c..acc5649bed5f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -118,6 +118,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_SENSEBUF_SZ	256
 #define MPI3MR_SENSEBUF_FACTOR	3
 #define MPI3MR_CHAINBUF_FACTOR	3
+#define MPI3MR_CHAINBUFDIX_FACTOR	2
 
 /* Invalid target device handle */
 #define MPI3MR_INVALID_DEV_HANDLE	0xFFFF
@@ -145,6 +146,15 @@ extern struct list_head mrioc_list;
 /* Default target device queue depth */
 #define MPI3MR_DEFAULT_SDEV_QD	32
 
+/* Definitions for the sector size for EEDP */
+#define MPI3_SECTOR_SIZE_512_BYTE	(512)
+#define MPI3_SECTOR_SIZE_520_BYTE	(520)
+#define MPI3_SECTOR_SIZE_4080_BYTE	(4080)
+#define MPI3_SECTOR_SIZE_4088_BYTE	(4088)
+#define MPI3_SECTOR_SIZE_4096_BYTE	(4096)
+#define MPI3_SECTOR_SIZE_4104_BYTE	(4104)
+#define MPI3_SECTOR_SIZE_4160_BYTE	(4160)
+
 /* Definitions for Threaded IRQ poll*/
 #define MPI3MR_IRQ_POLL_SLEEP			2
 #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
@@ -559,17 +569,21 @@ struct chain_element {
  *
  * @host_tag: Host tag specific to operational queue
  * @in_lld_scope: Command in LLD scope or not
+ * @meta_sg_valid: DIX command with meta data SGL or not
  * @scmd: SCSI Command pointer
- * @req_q_idx: Operational request queue index
+ * @req_q_idx: Operational request queue undex
  * @chain_idx: Chain frame index
+ * @meta_chain_idx: Chain frame index of meta data SGL
  * @mpi3mr_scsiio_req: MPI SCSI IO request
  */
-struct scmd_priv {
+struct scmd_priv{
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
index b27e44f78544..8ce715b139f2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -8,6 +8,7 @@
  */
 
 #include "mpi3mr.h"
+extern int prot_mask;
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
@@ -2759,6 +2760,12 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 
 	num_chains = mrioc->max_host_ios/MPI3MR_CHAINBUF_FACTOR;
 
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
index 57d9df6662f9..425659e8f7b4 100644
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
@@ -790,6 +807,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 {
 	u16 flags = 0;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	u8 prot_mask = 0;
 
 	tgtdev->perst_id = le16_to_cpu(dev_pg0->PersistentID);
 	tgtdev->dev_handle = le16_to_cpu(dev_pg0->DevHandle);
@@ -854,6 +872,15 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
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
@@ -1771,6 +1798,195 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 
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
+	struct scsi_cmnd *scmd, Mpi3SCSIIORequest_t *scsiio_req)
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
+		scsiio_req->MsgFlags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	case SCSI_PROT_WRITE_STRIP:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REMOVE;
+		scsiio_req->MsgFlags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	case SCSI_PROT_READ_PASS:
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
+		    MPI3_EEDPFLAGS_CHK_REF_TAG | MPI3_EEDPFLAGS_CHK_APP_TAG |
+		    MPI3_EEDPFLAGS_CHK_GUARD;
+		scsiio_req->MsgFlags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+		if (scsi_host_get_guard(scmd->device->host)
+		    & SHOST_DIX_GUARD_IP) {
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN |
+			    MPI3_EEDPFLAGS_CHK_APP_TAG |
+			    MPI3_EEDPFLAGS_CHK_GUARD |
+			    MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+			scsiio_req->SGL[0].Eedp.ApplicationTagTranslationMask
+			    = 0xffff;
+		} else {
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
+			    MPI3_EEDPFLAGS_CHK_REF_TAG |
+			    MPI3_EEDPFLAGS_CHK_APP_TAG |
+			    MPI3_EEDPFLAGS_CHK_GUARD;
+		}
+		scsiio_req->MsgFlags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
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
+		scsiio_req->CDB.EEDP32.PrimaryReferenceTag =
+		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		break;
+	case SCSI_PROT_DIF_TYPE1:
+	case SCSI_PROT_DIF_TYPE2:
+		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG |
+		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE |
+		    MPI3_EEDPFLAGS_CHK_GUARD;
+		scsiio_req->CDB.EEDP32.PrimaryReferenceTag =
+		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		break;
+	case SCSI_PROT_DIF_TYPE3:
+		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD |
+		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE;
+		break;
+
+	default:
+		scsiio_req->MsgFlags &= ~(MPI3_SCSIIO_MSGFLAGS_METASGL_VALID);
+		return;
+	}
+
+	switch (scmd->device->sector_size) {
+	case MPI3_SECTOR_SIZE_512_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_512;
+		break;
+	case MPI3_SECTOR_SIZE_520_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_520;
+		break;
+	case MPI3_SECTOR_SIZE_4080_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4080;
+		break;
+	case MPI3_SECTOR_SIZE_4088_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4088;
+		break;
+	case MPI3_SECTOR_SIZE_4096_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4096;
+		break;
+	case MPI3_SECTOR_SIZE_4104_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4104;
+		break;
+	case MPI3_SECTOR_SIZE_4160_BYTE:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4160;
+		break;
+	default:
+		break;
+	}
+
+	scsiio_req->SGL[0].Eedp.EEDPFlags = cpu_to_le16(eedp_flags);
+	scsiio_req->SGL[0].Eedp.Flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED;
+}
+
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
+ * @ioc_status: Status of MPI3 request
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
@@ -1933,6 +2149,11 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
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
@@ -1968,6 +2189,10 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
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
@@ -2031,6 +2256,8 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	u8 last_chain_sgl_flags;
 	struct chain_element *chain_req;
 	struct scmd_priv *priv = NULL;
+	u32 meta_sg = le32_to_cpu(scsiio_req->Flags) &
+	    MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI;
 
 	priv = scsi_cmd_priv(scmd);
 
@@ -2041,15 +2268,27 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	last_chain_sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN |
 	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
 
-	sg_local = &scsiio_req->SGL;
+	if (meta_sg)
+		sg_local = &scsiio_req->SGL[MPI3_SCSIIO_METASGL_INDEX];
+	else
+		sg_local = &scsiio_req->SGL;
 
-	if (!scsiio_req->DataLength) {
+	if (!scsiio_req->DataLength && !meta_sg) {
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
@@ -2067,6 +2306,22 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	sges_in_segment = (mrioc->facts.op_req_sz -
 	    offsetof(Mpi3SCSIIORequest_t, SGL))/sizeof(Mpi3SGESimple_t);
 
+	if (scsiio_req->SGL[0].Eedp.Flags ==
+	    MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED && !meta_sg) {
+		sg_local += sizeof(Mpi3SGEUnion_t);
+		sges_in_segment--;
+		/* Reserve 1st segment (scsiio_req->SGL[0]) for eedp */
+	}
+
+	if (scsiio_req->MsgFlags ==
+	    MPI3_SCSIIO_MSGFLAGS_METASGL_VALID && !meta_sg) {
+		sges_in_segment--;
+		/* Reserve last segment (scsiio_req->SGL[3]) for meta sg */
+	}
+
+	if (meta_sg)
+		sges_in_segment = 1;
+
 	if (sges_left <= sges_in_segment)
 		goto fill_in_last_segment;
 
@@ -2084,7 +2339,10 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
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
@@ -2134,6 +2392,13 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
 	if (ret)
 		return ret;
 
+	if (scsiio_req->MsgFlags == MPI3_SCSIIO_MSGFLAGS_METASGL_VALID) {
+		/* There is a valid meta sg */
+		scsiio_req->Flags |=
+		    cpu_to_le32(MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI);
+		ret = mpi3mr_prepare_sg_scmd(mrioc, scmd, scsiio_req);
+	}
+
 	return ret;
 }
 
@@ -3200,6 +3465,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	scsiio_req->Function = MPI3_FUNCTION_SCSI_IO;
 	scsiio_req->HostTag = cpu_to_le16(host_tag);
 
+	mpi3mr_setup_eedp(mrioc, scmd, scsiio_req);
+
 	memcpy(scsiio_req->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 	scsiio_req->DataLength = cpu_to_le32(scsi_bufflen(scmd));
 	scsiio_req->DevHandle = cpu_to_le16(dev_handle);
@@ -3425,6 +3692,32 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_channel = 1;
 	shost->max_id = 0xFFFFFFFF;
 
+	if (prot_mask >= 0)
+		scsi_host_set_prot(shost, prot_mask);
+	else {
+		prot_mask = SHOST_DIF_TYPE1_PROTECTION
+		    | SHOST_DIF_TYPE2_PROTECTION
+		    | SHOST_DIF_TYPE3_PROTECTION;
+		scsi_host_set_prot(shost, prot_mask);
+
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


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000008246d605b70ad32e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgTBz1/7O+
OJobZTDpfcgWoDyExo9u+l9qjuaj/nogbCIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMzI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKvmbjKUK0a398i1QCjcV83jteb3
eh+2oslBYDFg7Fokvox4H4i3f7RGY+YfIBIFQAuEzCuCF63chrhNjJTOmLLbu5ZCClV0bhcI+FuI
dG4703MUu96ipxHLrmVkPAOYwxhKZeK0x95LJHrd+t1JVcjln8n+FYHIztFffiSKFsLRpoVVP4Ga
sjp0fCX2CiubYHGBBnEmU3mbnS/pmTbTwZKF6emPvm1i4ogaKqtGJnXH56cUs2MHENiDBVKgSALi
wEvzRJufhOOX0BhJKK9UXhfanJLAUDuHnvcBefYPYh/I6oFok5OPydN3tmIO6300TFB+hL404QG+
KAp6lsJqQNM=
--0000000000008246d605b70ad32e--
