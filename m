Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C92C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F04613B8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348067AbhDGCFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347834AbhDGCFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:05:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5CC061756
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:05:05 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t23so5722271pjy.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VW9i8Jaj8i1lhc1Kor2JOIAw68S7QKdBpUigQ3wt8to=;
        b=dwB1gZaTCxRItz+IS2w/0WFFsPaYZM+5U3Ram0DNN7f7J0UVO2ZePeAFqm325cn4lV
         TgTHjTgr4IklttNdcVqTm+mvqtyRouH0mFABtqxVZcUXAJso4tO3hqquyOW1xbdpDmBe
         zNUfOY63Uj94XvyBDeDCnWmPX/CGaIaGz3ZYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VW9i8Jaj8i1lhc1Kor2JOIAw68S7QKdBpUigQ3wt8to=;
        b=Ef80qUdnZqd27uIUKM9KLudSf4sXEAgysddhTwlVoAak8wMy87bQ0OAU96xejSjgOA
         gKp1G2fuB1HxU6FPGTft/LxgHShOKtiSqMt6uWiXopwyUQOnWn+xzXTWtDYPsuR4b4j5
         RZUf2rJXdqMYaN/lSVlt2Lb2KRWbifdVNavI3iGmy05uP6NC4rX5OFlxja5qvyFenwyO
         jVQ0hypnJf9f/4nE4II04MZrPfk2JuMUk13iUEa8wI5iUolWzAjCVyvMkLGNunMuWB43
         cOnjr0UBgs5ZZMmiUgyx2TEyLYQoV/yQPrs0FnBZVwXeX2GIytBGTuQUKgT1fxdUdhGe
         evxw==
X-Gm-Message-State: AOAM533hp3UvoTz7ghokfe8rsEwcHmpT2oS6k/r3YhPEnN/6ZaRxIqLl
        Bysv/wDo81YVfsCbbKN29kXTsd2J0z8Zitgic3Wzstrb3CUQ9vsi/9unJugdodKGWpkBcqoxOYC
        FtkPJjjPRDbxI/O8eP6q5wk1LZs3D1EAfOlktd23EvcGEhGFQzi3TQoBF71xKXD8q6LSmCOUK+t
        arr+/H7A==
X-Google-Smtp-Source: ABdhPJwWbtsgx2uK7jYjjnR/dyaYn4F3hcgDO0KHoOYrxkOkizSekL2r00F9hfYNJu6ft27HWakHWA==
X-Received: by 2002:a17:902:fe04:b029:e9:3601:b71f with SMTP id g4-20020a170902fe04b02900e93601b71fmr893643plj.45.1617761104478;
        Tue, 06 Apr 2021 19:05:04 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:05:03 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 23/24] mpi3mr: add eedp dif dix support
Date:   Wed,  7 Apr 2021 07:34:50 +0530
Message-Id: <20210407020451.924822-24-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000feaaef05bf585bdb"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000feaaef05bf585bdb

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   9 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   7 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 303 +++++++++++++++++++++++++++++++-
 3 files changed, 312 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index db9cb11db3bf..db1482b3c32a 100644
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
- * @req_q_idx: Operational request queue index
+ * @req_q_idx: Operational request queue undex
  * @chain_idx: Chain frame index
+ * @meta_chain_idx: Chain frame index of meta data SGL
  * @mpi3mr_scsiio_req: MPI SCSI IO request
  */
-struct scmd_priv {
+struct scmd_priv {
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
index f09330bb4b8a..88069fbfa2bf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -8,6 +8,7 @@
  */
 
 #include "mpi3mr.h"
+extern int prot_mask;
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
@@ -2763,6 +2764,12 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 
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
index 5bc58a3299ac..a3610d22f67d 100644
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
@@ -1768,6 +1795,195 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 
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
+	case 512:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_512;
+		break;
+	case 520:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_520;
+		break;
+	case 4080:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4080;
+		break;
+	case 4088:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4088;
+		break;
+	case 4096:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4096;
+		break;
+	case 4104:
+		scsiio_req->SGL[0].Eedp.UserDataSize = MPI3_EEDP_UDS_4104;
+		break;
+	case 4160:
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
@@ -1930,6 +2146,11 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
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
@@ -1965,6 +2186,10 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
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
@@ -2028,6 +2253,8 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 	u8 last_chain_sgl_flags;
 	struct chain_element *chain_req;
 	struct scmd_priv *priv = NULL;
+	u32 meta_sg = le32_to_cpu(scsiio_req->Flags) &
+	    MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI;
 
 	priv = scsi_cmd_priv(scmd);
 
@@ -2038,15 +2265,27 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
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
@@ -2064,6 +2303,22 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
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
 
@@ -2081,7 +2336,10 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
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
@@ -2131,6 +2389,13 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
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
 
@@ -3197,6 +3462,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	scsiio_req->Function = MPI3_FUNCTION_SCSI_IO;
 	scsiio_req->HostTag = cpu_to_le16(host_tag);
 
+	mpi3mr_setup_eedp(mrioc, scmd, scsiio_req);
+
 	memcpy(scsiio_req->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 	scsiio_req->DataLength = cpu_to_le32(scsi_bufflen(scmd));
 	scsiio_req->DevHandle = cpu_to_le16(dev_handle);
@@ -3422,6 +3689,32 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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


--000000000000feaaef05bf585bdb
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMJ7EZ8G+/wMNJg7+/cGCsizc9Yq
ey1W5ebRDWyvsh8VMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDUwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAQgGWIY0aoxFAo1rC0gbpDm8/ro7zi06+G+tGcikF/e5Er
8+NWBPMqjOmcqoMo9KLyGNXu2T8BhHrk1DwuVb0xNygjpFdiSF/ILXRJoJQgR01Vmeoyygeh1jqs
cmTQVvpcUg06ETpaL9bTLA7u81FyANhPAB37KgVBiw1a3IDbV7tJ5laoAvWQDb0uRXGpXFkMGTA3
K767fzlZqaImBeguTM4zZ7ZQSXcNyLTh3qE7yb2zNYFBqr/Kwxx9NES8mMxAJKcGfc+1Zv0Whr49
FG0zywO8U28DqvIyCPp35SNim03ZrrByjShKYCuHuTsp74umIfF7MNjnTRmMt/dWlSdu
--000000000000feaaef05bf585bdb--
