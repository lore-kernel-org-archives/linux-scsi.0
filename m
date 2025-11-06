Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B339222594
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467355; cv=none; b=Wk1V3HQpxTd+DlTwnSaBIQVLYEJbRuj+dlJErc7PzeAi3+lzJxhoBR8K4No40ZinETAvEywbJowHieLTjVIMPzOuLr/J8fKLP9H8mKdIOX2aEXAROai+gLxFsykO7MzwUb+vJ77tB5Wii5UrLlICI/rw5qIaOUB84nYwhvhQnIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467355; c=relaxed/simple;
	bh=nvrCITuCt25cqDXNZWV03gQSlupo4XbgB4YIzd5CRwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=il6P12/ssAaX8OoGs/ElObX4npzXIU+iDdb9aUzPZBLtC0+PZ8dZiE8uuFabZpog0BJzQ/2burpwwvrxOiAeWXVpC0COJKDD1WzJNA1Z1mmFHaCvSprsvKA8GYFBjWg67j1UytusPrjivxrKyyllvxxFnhjqhjeKE5ud2zcARNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UcaTKnms; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UcaTKnms"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3408c9a8147so113434a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467352; x=1763072152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1z+yJ4yjiAIjDT2og3xDs1WHpSFCWKy0a/BHS5RnM2o=;
        b=UcaTKnmsFsGmpFhOA20sA4qEMUWH8IoeIGJI2BPajHBlZYUrcCL9QtWbUtHh7h2sWp
         8eG/AyUGW+zBa++9/8goIGWmjeCAdleSlljmPnrI/8g2z703ea+sSiiPkrSMClgYDA8V
         f+r7/pWhUwx6Xj34e1N/w9g8KtJ+A9yDvvvwzO4hqe+5QEzahm59uv7FMIz0tNmHc8h9
         FiQyPfX8a9WK+Vu3RKo6e96WjfKWAxyoqRpSYMlg7ypypiS/BS+I3O0mmERr1Hj7bHqa
         yxBjOnOZB1g4pFV1uBlfixTwXeNR40q8yn92++ghDvYnZvhODwdck3vjnnIGvX9DrBia
         2J0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467352; x=1763072152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1z+yJ4yjiAIjDT2og3xDs1WHpSFCWKy0a/BHS5RnM2o=;
        b=p8YPhWJ/Fp/yuVZSwndffFXeIxUeF33q5TwczctUWG6x0rfH98b/UoAfZMzIWl4BgA
         5VgbsPMGRxJcURzSDgJqT5eNSV8R0p++MMBf4iofG+it1dNuKy8G3pDJjO1XIpSnxYvS
         MzWLnjruhMWE4ihlHtlq1Maw/2qxIEjp0JViXbcwk/6vhJQ2PFKkasyIk8mSB6K42HP3
         OCQMo4ENKMYwtWEXCDJYs+aFJtqWRw97lu5wY8pR7Ai0tIGkr2CceA6hK/uFuB9ZnoGk
         /1M3Ek6s49zpuCXxA802WFUbn3ZHXzu3Wxub2l9AVUFpdZ26tuc1NW/xVFHNgzjtVH1q
         Ds9g==
X-Gm-Message-State: AOJu0YzG3Z2VaBglhS5eiUQlpXV5D//aRPl2Kk1dNVZmosg2eFwQM37M
	OygxPiPE/qnehrgOHT2EIXtIrIWJP5FfoJzvR8nhV5Bfl0S9GfA6YQPnXPskGmsD
X-Gm-Gg: ASbGncvAKoCbWX57WbXGEwxg+ADdJerYOEtUsVsSmTFS/c1fKoi4ZiJpoUFgoTkILa9
	1DYmJx4wLdOUPK1V83hokdePRF3AxvPFrvNWqxVmpnlJOyfp+XuxI7VS8ZftSJ7sm+WlDDayjBE
	MyxplM/7S8y1KVJ43nCpUD6ERqm7cMCHjAoI7aIGrmzfcLun3SlbnBrzQZ/JirpB5AUsKmNYxkd
	9MZO65o8rUV9g6J2lmLVJMaGUkCnFbbMndhQOuE2MnddVLPXiaay+kAJqgYNIf1/HA17ECIEQyT
	MOFUn0QrOCpoLICluUYolhpKXDSY5fXlWShEEttPGyUOgG7FuStWfhJzTnqL8SC1pycs03/LdDb
	HQE87KbI0dzCoqBPQ+iXvTeqQOVeNtGz1W2Mv2xIz/uakhnEqPnTlxVAaUIZ/xUGGwQqTcjWc8a
	9lUwk7Wv+rN2nYRs1e2EzO5zmsYOuib9fKE4zyckWesfMNAm4SUvRBiaAqgoKEfCynnqPvv2A=
X-Google-Smtp-Source: AGHT+IHTQkipDh7nEjbtMo3+s36OaUz1x0PUnMwH2e2nRAs6NxhmjBgTtADcvFMu4Ak7fCdcWDt7Zw==
X-Received: by 2002:a17:90a:d884:b0:343:3898:e7c7 with SMTP id 98e67ed59e1d1-3434a1ef33fmr1379904a91.12.1762467352447;
        Thu, 06 Nov 2025 14:15:52 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:52 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 09/10] lpfc: Add capability to register Platform Name ID to fabric
Date: Thu,  6 Nov 2025 14:46:38 -0800
Message-Id: <20251106224639.139176-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FC-LS and FC-GS specifications outline fields for registering a platform
name identifier (PNI) to the fabric.  The PNI assists fabrics with
identifying the physical server source of frames in the fabric.

lpfc generates a PNI based partially on the uuid specific for the system.
Initial attempts to extract a uuid are made from SMBIOS's System
Information 08h uuid entry.  If SMBIOS DMI does not exist, a PNI is not
generated and PNI registration with the fabric is skipped.

The PNI is submitted in FLOGI and FDISC frames.  After successful fabric
login, the RSPNI_PNI CT frame is submitted to the fabric to register the OS
host name tying it to the PNI.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h           |  3 ++
 drivers/scsi/lpfc/lpfc_ct.c        | 36 +++++++++++++++
 drivers/scsi/lpfc/lpfc_els.c       | 18 ++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  2 +
 drivers/scsi/lpfc/lpfc_hw.h        | 25 ++++++++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  4 --
 drivers/scsi/lpfc/lpfc_sli.c       | 70 ++++++++++++++++++++++++++++++
 7 files changed, 150 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8459cf568c12..689793d03c20 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -633,6 +633,7 @@ struct lpfc_vport {
 #define FC_CT_RSPN_ID		0x8	 /* RSPN_ID accepted by switch */
 #define FC_CT_RFT_ID		0x10	 /* RFT_ID accepted by switch */
 #define FC_CT_RPRT_DEFER	0x20	 /* Defer issuing FDMI RPRT */
+#define FC_CT_RSPNI_PNI		0x40	 /* RSPNI_PNI accepted by switch */
 
 	struct list_head fc_nodes;
 	spinlock_t fc_nodes_list_lock; /* spinlock for fc_nodes list */
@@ -1077,6 +1078,8 @@ struct lpfc_hba {
 
 	uint32_t nport_event_cnt;	/* timestamp for nlplist entry */
 
+	unsigned long pni;		/* 64-bit Platform Name Identifier */
+
 	uint8_t  wwnn[8];
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f93f8dca65bd..d3caac394291 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1742,6 +1742,28 @@ lpfc_cmpl_ct_cmd_rsnn_nn(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	return;
 }
 
+static void
+lpfc_cmpl_ct_cmd_rspni_pni(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			   struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport;
+	struct lpfc_dmabuf *outp;
+	struct lpfc_sli_ct_request *ctrsp;
+	u32 ulp_status;
+
+	vport = cmdiocb->vport;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status == IOSTAT_SUCCESS) {
+		outp = cmdiocb->rsp_dmabuf;
+		ctrsp = (struct lpfc_sli_ct_request *)outp->virt;
+		if (be16_to_cpu(ctrsp->CommandResponse.bits.CmdRsp) ==
+		    SLI_CT_RESPONSE_FS_ACC)
+			vport->ct_flags |= FC_CT_RSPNI_PNI;
+	}
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
+}
+
 static void
 lpfc_cmpl_ct_cmd_da_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  struct lpfc_iocbq *rspiocb)
@@ -1956,6 +1978,8 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		bpl->tus.f.bdeSize = RSPN_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RSNN_NN)
 		bpl->tus.f.bdeSize = RSNN_REQUEST_SZ;
+	else if (cmdcode == SLI_CTNS_RSPNI_PNI)
+		bpl->tus.f.bdeSize = RSPNI_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_DA_ID)
 		bpl->tus.f.bdeSize = DA_ID_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RFF_ID)
@@ -2077,6 +2101,18 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 			CtReq->un.rsnn.symbname, size);
 		cmpl = lpfc_cmpl_ct_cmd_rsnn_nn;
 		break;
+	case SLI_CTNS_RSPNI_PNI:
+		vport->ct_flags &= ~FC_CT_RSPNI_PNI;
+		CtReq->CommandResponse.bits.CmdRsp =
+		    cpu_to_be16(SLI_CTNS_RSPNI_PNI);
+		CtReq->un.rspni.pni = cpu_to_be64(phba->pni);
+		scnprintf(CtReq->un.rspni.symbname,
+			  sizeof(CtReq->un.rspni.symbname), "OS Host Name::%s",
+			  phba->os_host_name);
+		CtReq->un.rspni.len = strnlen(CtReq->un.rspni.symbname,
+					      sizeof(CtReq->un.rspni.symbname));
+		cmpl = lpfc_cmpl_ct_cmd_rspni_pni;
+		break;
 	case SLI_CTNS_DA_ID:
 		/* Implement DA_ID Nameserver request */
 		CtReq->CommandResponse.bits.CmdRsp =
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b066ba83ce87..02b6d31b9ad9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -650,8 +650,6 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ndlp->nlp_class_sup |= FC_COS_CLASS2;
 	if (sp->cls3.classValid)
 		ndlp->nlp_class_sup |= FC_COS_CLASS3;
-	if (sp->cls4.classValid)
-		ndlp->nlp_class_sup |= FC_COS_CLASS4;
 	ndlp->nlp_maxframe = ((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) |
 				sp->cmn.bbRcvSizeLsb;
 
@@ -1356,6 +1354,14 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		/* Can't do SLI4 class2 without support sequence coalescing */
 		sp->cls2.classValid = 0;
 		sp->cls2.seqDelivery = 0;
+
+		/* Fill out Auxiliary Parameter Data */
+		if (phba->pni) {
+			sp->aux.flags =
+				AUX_PARM_DATA_VALID | AUX_PARM_PNI_VALID;
+			sp->aux.pni = cpu_to_be64(phba->pni);
+			sp->aux.npiv_cnt = cpu_to_be16(phba->max_vpi - 1);
+		}
 	} else {
 		/* Historical, setting sequential-delivery bit for SLI3 */
 		sp->cls2.seqDelivery = (sp->cls2.classValid) ? 1 : 0;
@@ -5657,7 +5663,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			sp->cls1.classValid = 0;
 			sp->cls2.classValid = 0;
 			sp->cls3.classValid = 0;
-			sp->cls4.classValid = 0;
 
 			/* Copy our worldwide names */
 			memcpy(&sp->portName, &vport->fc_sparam.portName,
@@ -11510,6 +11515,13 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	sp->cls2.seqDelivery = 1;
 	sp->cls3.seqDelivery = 1;
 
+	/* Fill out Auxiliary Parameter Data */
+	if (phba->pni) {
+		sp->aux.flags =
+			AUX_PARM_DATA_VALID | AUX_PARM_PNI_VALID;
+		sp->aux.pni = cpu_to_be64(phba->pni);
+	}
+
 	pcmd += sizeof(uint32_t); /* CSP Word 2 */
 	pcmd += sizeof(uint32_t); /* CSP Word 3 */
 	pcmd += sizeof(uint32_t); /* CSP Word 4 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 717ae56c8e4b..bb803f32bc1b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4373,6 +4373,8 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		lpfc_ns_cmd(vport, SLI_CTNS_RNN_ID, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
+		if (phba->pni)
+			lpfc_ns_cmd(vport, SLI_CTNS_RSPNI_PNI, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
 
 		if ((vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 3bc0efa7453e..b2e353590ebb 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -168,6 +168,11 @@ struct lpfc_sli_ct_request {
 			uint8_t len;
 			uint8_t symbname[255];
 		} rspn;
+		struct rspni {	/* For RSPNI_PNI requests */
+			__be64 pni;
+			u8 len;
+			u8 symbname[255];
+		} rspni;
 		struct gff {
 			uint32_t PortId;
 		} gff;
@@ -213,6 +218,8 @@ struct lpfc_sli_ct_request {
 			  sizeof(struct da_id))
 #define  RSPN_REQUEST_SZ  (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct rspn))
+#define  RSPNI_REQUEST_SZ (offsetof(struct lpfc_sli_ct_request, un) + \
+			   sizeof(struct rspni))
 
 /*
  * FsType Definitions
@@ -309,6 +316,7 @@ struct lpfc_sli_ct_request {
 #define  SLI_CTNS_RIP_NN      0x0235
 #define  SLI_CTNS_RIPA_NN     0x0236
 #define  SLI_CTNS_RSNN_NN     0x0239
+#define  SLI_CTNS_RSPNI_PNI   0x0240
 #define  SLI_CTNS_DA_ID       0x0300
 
 /*
@@ -512,6 +520,21 @@ struct class_parms {
 	uint8_t word3Reserved2;	/* Fc Word 3, bit  0: 7 */
 };
 
+enum aux_parm_flags {
+	AUX_PARM_PNI_VALID = 0x20,	/* FC Word 0, bit 29 */
+	AUX_PARM_DATA_VALID = 0x40,	/* FC Word 0, bit 30 */
+};
+
+struct aux_parm {
+	u8 flags;	/* FC Word 0, bit 31:24 */
+	u8 ext_feat[3];	/* FC Word 0, bit 23:0 */
+
+	__be64 pni;	/* FC Word 1 and 2, platform name identifier */
+
+	__be16 rsvd;	/* FC Word 3, bit 31:16 */
+	__be16 npiv_cnt;	/* FC Word 3, bit 15:0 */
+} __packed;
+
 struct serv_parm {	/* Structure is in Big Endian format */
 	struct csp cmn;
 	struct lpfc_name portName;
@@ -519,7 +542,7 @@ struct serv_parm {	/* Structure is in Big Endian format */
 	struct class_parms cls1;
 	struct class_parms cls2;
 	struct class_parms cls3;
-	struct class_parms cls4;
+	struct aux_parm aux;
 	union {
 		uint8_t vendorVersion[16];
 		struct {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index a6da7c392405..8240d59f4120 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -432,8 +432,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ndlp->nlp_class_sup |= FC_COS_CLASS2;
 	if (sp->cls3.classValid)
 		ndlp->nlp_class_sup |= FC_COS_CLASS3;
-	if (sp->cls4.classValid)
-		ndlp->nlp_class_sup |= FC_COS_CLASS4;
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
 	/* if already logged in, do implicit logout */
@@ -1417,8 +1415,6 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		ndlp->nlp_class_sup |= FC_COS_CLASS2;
 	if (sp->cls3.classValid)
 		ndlp->nlp_class_sup |= FC_COS_CLASS3;
-	if (sp->cls4.classValid)
-		ndlp->nlp_class_sup |= FC_COS_CLASS4;
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 41eb558dd139..73d77cfab5f8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -27,6 +27,8 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/lockdep.h>
+#include <linux/dmi.h>
+#include <linux/of.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -8446,6 +8448,70 @@ lpfc_set_host_tm(struct lpfc_hba *phba)
 	return rc;
 }
 
+/**
+ * lpfc_get_platform_uuid - Attempts to extract a platform uuid
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine attempts to first read SMBIOS DMI data for the System
+ * Information structure offset 08h called System UUID.  Else, no platform
+ * UUID will be advertised.
+ **/
+static void
+lpfc_get_platform_uuid(struct lpfc_hba *phba)
+{
+	int rc;
+	const char *uuid;
+	char pni[17] = {0}; /* 16 characters + '\0' */
+	bool is_ff = true, is_00 = true;
+	u8 i;
+
+	/* First attempt SMBIOS DMI */
+	uuid = dmi_get_system_info(DMI_PRODUCT_UUID);
+	if (uuid) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2088 SMBIOS UUID %s\n",
+				uuid);
+	} else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2099 Could not extract UUID\n");
+	}
+
+	if (uuid && uuid_is_valid(uuid)) {
+		/* Generate PNI from UUID format.
+		 *
+		 * 1.) Extract lower 64 bits from UUID format.
+		 * 2.) Set 3h for NAA Locally Assigned Name Identifier format.
+		 *
+		 * e.g. xxxxxxxx-xxxx-xxxx-yyyy-yyyyyyyyyyyy
+		 *
+		 * extract the yyyy-yyyyyyyyyyyy portion
+		 * final PNI   3yyyyyyyyyyyyyyy
+		 */
+		scnprintf(pni, sizeof(pni), "3%c%c%c%s",
+			  uuid[20], uuid[21], uuid[22], &uuid[24]);
+
+		/* Sanitize the converted PNI */
+		for (i = 1; i < 16 && (is_ff || is_00); i++) {
+			if (pni[i] != '0')
+				is_00 = false;
+			if (pni[i] != 'f' && pni[i] != 'F')
+				is_ff = false;
+		}
+
+		/* Convert from char* to unsigned long */
+		rc = kstrtoul(pni, 16, &phba->pni);
+		if (!rc && !is_ff && !is_00) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2100 PNI 0x%016lx\n", phba->pni);
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2101 PNI %s generation status %d\n",
+					pni, rc);
+			phba->pni = 0;
+		}
+	}
+}
+
 /**
  * lpfc_sli4_hba_setup - SLI4 device initialization PCI function
  * @phba: Pointer to HBA context object.
@@ -8529,6 +8595,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		clear_bit(HBA_FCOE_MODE, &phba->hba_flag);
 	}
 
+	/* Obtain platform UUID, only for SLI4 FC adapters */
+	if (!test_bit(HBA_FCOE_MODE, &phba->hba_flag))
+		lpfc_get_platform_uuid(phba);
+
 	if (bf_get(lpfc_mbx_rd_rev_cee_ver, &mqe->un.read_rev) ==
 		LPFC_DCBX_CEE_MODE)
 		set_bit(HBA_FIP_SUPPORT, &phba->hba_flag);
-- 
2.38.0

