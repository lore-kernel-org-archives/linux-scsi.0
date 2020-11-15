Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5FAC63697
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB717223C7
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dp9A52RA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgKOT06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgKOT04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:26:56 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8BBC0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:26:56 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so10736254pgg.13
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=P7qvt8c5ZpCIdJU5fT5fhN/SF0maWFyMYzYKDNy0w9c=;
        b=dp9A52RACfhWcUaS49Ljw7cpNNJmItC58fxd6Jr0PNpdyuvk+Y/Ltt8KlVEUGYevZb
         i43n9wfWcO1/LhXhos5GNyP56dSW8+TmLfFSQvngyFLZ5o0PVpYrgMZloY5cwibH1MEr
         Yc7r7vPFWFVvP1m85BPzScIQdogpEEctWXuR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=P7qvt8c5ZpCIdJU5fT5fhN/SF0maWFyMYzYKDNy0w9c=;
        b=BoN9o7E3NTTlfR4miJyBojZ6J7QVXLjKXuWavaxrjdDZ1FJSO8dngTr/oxm3EoSE8U
         WvsNOlxhuKM4UckKLY4eflAZ1g1Lb/z+5bJC3G8veoSaoF9Zb6GYRZL0MD1LagcGiZCA
         N58lzhDIZVY3ObnGpeiXWeCq25S5ULbQLmR7qm0JakcwUhVsmtaUpFsAzoBmj3x/TbyS
         GwX6RlV6TK5WqljhbAGYm5TKt4XRtbK7oKTe8s2twumJiTqZ1L8KFQVHFwrP4BmpFS7L
         3FKSacWB8r6IhODDmK5JSKyKs54z/WlJS0xlSlsUOJiCEQFC0NQBMisHRi5uiYjAUAQO
         fbBw==
X-Gm-Message-State: AOAM533rjJfx1zvvPRPRglv/KQSOMK6yADYKiSuIfcoaVT1cNxqxF6fa
        8fRFwZBXMcaeraB8UjHpQYUJVdPqPwWc58Oq5Zn3i5l9rhMD3iiFrCNQ0qHPB9AynX4EQOwEfLQ
        SzwVOGuu5gZSNUO0fnPRdswe2p0oYTwHCrTVgDZbIg1B2ezxLkYi6PAhoh+XQxLtLy+R24jD3L1
        41kpo=
X-Google-Smtp-Source: ABdhPJzzhK7Rb31/6M1ZSVgFT79IAhRo30X9AhylxAkMPmZAPMxReDKUzp0X0cyumYC/5j1uwvpSrA==
X-Received: by 2002:a63:a517:: with SMTP id n23mr10099686pgf.272.1605468414584;
        Sun, 15 Nov 2020 11:26:54 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:26:53 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/17] lpfc: Rework remote port ref counting and node freeing
Date:   Sun, 15 Nov 2020 11:26:30 -0800
Message-Id: <20201115192646.12977-2-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009dced305b42a3e21"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009dced305b42a3e21
Content-Transfer-Encoding: 8bit

When a remote port is disconnected and disappears, its node structure
(ndlp) stays allocated and on a vport node list. While on the list it
can be matched, thus requires validation checks on state to be added
in numerous code paths. If the node comes back, its possible for there
to be multiple node structures for the same device on the vport node
list. There is no reason to keep the node structure around after it is
no longer in existence, and the current implementation creates problems
for itself (multiple nodes) and lots of unnecessary code for state
validation.

Additionally, the reference taking on the node structure didn't follow
the normal model used by the kernel kref api. It included lots of odd
logic to match state with reference count.  The combination of this odd
logic plus the way it was implicitly used in the discovery engine made
its reference taking implementation suspect and extremely hard to follow.

Change the driver such that the the reference taking routines are now
normal ref increments/decrements and callout on refcount=0.

With this in place, the rework can be done such that the node structure
is fully removed and deallocated when the remote port no longer exists
and all references are removed.  This removal logic, and the basic
ref counting are intrically tied, thus in a single patch.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c      |  11 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 -
 drivers/scsi/lpfc/lpfc_ct.c        |  15 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |   2 -
 drivers/scsi/lpfc/lpfc_disc.h      |  33 +--
 drivers/scsi/lpfc/lpfc_els.c       | 210 +++++--------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 321 +++++------------------------
 drivers/scsi/lpfc/lpfc_init.c      |  63 ++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  12 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  10 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  28 ++-
 drivers/scsi/lpfc/lpfc_sli.c       |  32 +--
 drivers/scsi/lpfc/lpfc_vport.c     |  57 +----
 15 files changed, 170 insertions(+), 630 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 0673d944c2a8..aba879604437 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3627,8 +3627,6 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 	shost = lpfc_shost_from_vport(vport);
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 		if (ndlp->rport)
 			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
 #if (IS_ENABLED(CONFIG_NVME_FC))
@@ -4393,7 +4391,7 @@ sysfs_drvr_stat_data_read(struct file *filp, struct kobject *kobj,
 
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp) || !ndlp->lat_data)
+		if (!ndlp->lat_data)
 			continue;
 
 		if (nport_index > 0) {
@@ -5459,8 +5457,6 @@ lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
 
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 		ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
@@ -6969,8 +6965,7 @@ lpfc_get_node_by_target(struct scsi_target *starget)
 	spin_lock_irq(shost->host_lock);
 	/* Search for this, mapped, target ID */
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (NLP_CHK_NODE_ACT(ndlp) &&
-		    ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
+		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
 		    starget->id == ndlp->nlp_sid) {
 			spin_unlock_irq(shost->host_lock);
 			return ndlp;
@@ -7045,7 +7040,7 @@ lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 	else
 		rport->dev_loss_tmo = 1;
 
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		dev_info(&rport->dev, "Cannot find remote node to "
 				      "set rport dev loss tmo, port_id x%x\n",
 				      rport->port_id);
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 5b66b8ea8363..b13e764b484f 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1522,7 +1522,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		}
 
 		/* Check if the ndlp is active */
-		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		if (!ndlp) {
 			rc = IOCB_ERROR;
 			goto issue_ct_rsp_exit;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 782f6f76f18a..903151aa6f02 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -88,8 +88,6 @@ void lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_unregister_vfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_enqueue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_dequeue_node(struct lpfc_vport *, struct lpfc_nodelist *);
-struct lpfc_nodelist *lpfc_enable_node(struct lpfc_vport *,
-					struct lpfc_nodelist *, int);
 void lpfc_nlp_set_state(struct lpfc_vport *, struct lpfc_nodelist *, int);
 void lpfc_drop_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_set_disctmo(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index b963e234d77d..32f5d8951b8f 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -740,7 +740,7 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 
 		ndlp = lpfc_setup_disc_node(vport, Did);
 
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+		if (ndlp) {
 			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 				"Parse GID_FTrsp: did:x%x flg:x%x x%x",
 				Did, ndlp->nlp_flag, vport->fc_flag);
@@ -791,7 +791,7 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 			 * Don't even bother to send GFF_ID.
 			 */
 			ndlp = lpfc_findnode_did(vport, Did);
-			if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+			if (ndlp &&
 			    (ndlp->nlp_type &
 			    (NLP_FCP_TARGET | NLP_NVME_TARGET))) {
 				if (fc4_type == FC_TYPE_FCP)
@@ -1437,7 +1437,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* This is a target port, unregistered port, or the GFF_ID failed */
 	ndlp = lpfc_setup_disc_node(vport, did);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+	if (ndlp) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0242 Process x%x GFF "
 				 "NameServer Rsp Data: x%x x%x x%x\n",
@@ -1872,8 +1872,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	int rc = 0;
 
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)
-	    || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) {
+	if (!ndlp || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) {
 		rc=1;
 		goto ns_cmd_exit;
 	}
@@ -2204,7 +2203,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_ct_free_iocb(phba, cmdiocb);
 
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		return;
 
 	/* Check for a CT LS_RJT response */
@@ -2343,7 +2342,7 @@ lpfc_fdmi_change_check(struct lpfc_vport *vport)
 		return;
 
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		return;
 
 	/* Check if system hostname changed */
@@ -3389,7 +3388,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	void (*cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 		     struct lpfc_iocbq *);
 
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		return 0;
 
 	cmpl = lpfc_cmpl_ct_disc_fdmi; /* called from discovery */
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 325081ac6553..8c2750cea082 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -895,8 +895,6 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		if (ndlp->nlp_type & NLP_NVME_INITIATOR)
 			len += scnprintf(buf + len,
 					size - len, "NVME_INITIATOR ");
-		len += scnprintf(buf+len, size-len, "usgmap:%x ",
-			ndlp->nlp_usg_map);
 		len += scnprintf(buf+len, size-len, "refcnt:%x",
 			kref_read(&ndlp->kref));
 		if (iocnt) {
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 1437e44ade80..f8ab001e4f0d 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -116,12 +116,6 @@ struct lpfc_nodelist {
 	u8		nlp_nvme_info;	        /* NVME NSLER Support */
 #define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
 
-	uint16_t        nlp_usg_map;	/* ndlp management usage bitmap */
-#define NLP_USG_NODE_ACT_BIT	0x1	/* Indicate ndlp is actively used */
-#define NLP_USG_IACT_REQ_BIT	0x2	/* Request to inactivate ndlp */
-#define NLP_USG_FREE_REQ_BIT	0x4	/* Request to invoke ndlp memory free */
-#define NLP_USG_FREE_ACK_BIT	0x8	/* Indicate ndlp memory free invoked */
-
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
 	struct lpfc_hba *phba;
 	struct fc_rport *rport;		/* scsi_transport_fc port structure */
@@ -173,6 +167,7 @@ struct lpfc_node_rrq {
 #define NLP_FCP_PRLI_RJT   0x00002000   /* Rport does not support FCP PRLI. */
 #define NLP_UNREG_INP      0x00008000	/* UNREG_RPI cmd is in progress */
 #define NLP_DEFER_RM       0x00010000	/* Remove this ndlp if no longer used */
+#define NLP_DROPPED        0x00000008	/* Init ref count has been dropped */
 #define NLP_DELAY_TMO      0x00020000	/* delay timeout is running for node */
 #define NLP_NPR_2B_DISC    0x00040000	/* node is included in num_disc_nodes */
 #define NLP_RCV_PLOGI      0x00080000	/* Rcv'ed PLOGI from remote system */
@@ -191,32 +186,6 @@ struct lpfc_node_rrq {
 #define NLP_FIRSTBURST     0x40000000	/* Target supports FirstBurst */
 #define NLP_RPI_REGISTERED 0x80000000	/* nlp_rpi is valid */
 
-
-/* ndlp usage management macros */
-#define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
-						& NLP_USG_NODE_ACT_BIT) \
-					&& \
-					!((ndlp)->nlp_usg_map \
-						& NLP_USG_FREE_ACK_BIT))
-#define NLP_SET_NODE_ACT(ndlp)		((ndlp)->nlp_usg_map \
-						|= NLP_USG_NODE_ACT_BIT)
-#define NLP_INT_NODE_ACT(ndlp)		((ndlp)->nlp_usg_map \
-						= NLP_USG_NODE_ACT_BIT)
-#define NLP_CLR_NODE_ACT(ndlp)		((ndlp)->nlp_usg_map \
-						&= ~NLP_USG_NODE_ACT_BIT)
-#define NLP_CHK_IACT_REQ(ndlp)          ((ndlp)->nlp_usg_map \
-						& NLP_USG_IACT_REQ_BIT)
-#define NLP_SET_IACT_REQ(ndlp)          ((ndlp)->nlp_usg_map \
-						|= NLP_USG_IACT_REQ_BIT)
-#define NLP_CHK_FREE_REQ(ndlp)		((ndlp)->nlp_usg_map \
-						& NLP_USG_FREE_REQ_BIT)
-#define NLP_SET_FREE_REQ(ndlp)		((ndlp)->nlp_usg_map \
-						|= NLP_USG_FREE_REQ_BIT)
-#define NLP_CHK_FREE_ACK(ndlp)		((ndlp)->nlp_usg_map \
-						& NLP_USG_FREE_ACK_BIT)
-#define NLP_SET_FREE_ACK(ndlp)		((ndlp)->nlp_usg_map \
-						|= NLP_USG_FREE_ACK_BIT)
-
 /* There are 4 different double linked lists nodelist entries can reside on.
  * The Port Login (PLOGI) list and Address Discovery (ADISC) list are used
  * when Link Up discovery or Registered State Change Notification (RSCN)
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index de3a59f2e3df..9cf0e9d55cdf 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -378,7 +378,7 @@ lpfc_issue_fabric_reglogin(struct lpfc_vport *vport)
 
 	sp = &phba->fc_fabparam;
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		err = 1;
 		goto fail;
 	}
@@ -471,7 +471,7 @@ lpfc_issue_reg_vfi(struct lpfc_vport *vport)
 	    !(phba->link_flag & LS_LOOPBACK_MODE) &&
 	    !(vport->fc_flag & FC_PT2PT)) {
 		ndlp = lpfc_findnode_did(vport, Fabric_DID);
-		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		if (!ndlp) {
 			rc = -ENODEV;
 			goto fail;
 		}
@@ -765,8 +765,6 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 */
 		list_for_each_entry_safe(np, next_np,
 					&vport->fc_nodes, nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(np))
-				continue;
 			if ((np->nlp_state != NLP_STE_NPR_NODE) ||
 				   !(np->nlp_flag & NLP_NPR_ADISC))
 				continue;
@@ -908,11 +906,6 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			ndlp = lpfc_nlp_init(vport, PT2PT_RemoteID);
 			if (!ndlp)
 				goto fail;
-		} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-			ndlp = lpfc_enable_node(vport, ndlp,
-						NLP_STE_UNUSED_NODE);
-			if(!ndlp)
-				goto fail;
 		}
 
 		memcpy(&ndlp->nlp_portname, &sp->portName,
@@ -1421,8 +1414,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 		icmd = &iocb->iocb;
 		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR) {
 			ndlp = (struct lpfc_nodelist *)(iocb->context1);
-			if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
-			    (ndlp->nlp_DID == Fabric_DID))
+			if (ndlp && (ndlp->nlp_DID == Fabric_DID))
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
 		}
 	}
@@ -1464,13 +1456,9 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 			return 0;
 		/* Set the node type */
 		ndlp->nlp_type |= NLP_FABRIC;
+
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		/* re-setup ndlp without removing from node list */
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			return 0;
 	}
 
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
@@ -1513,11 +1501,6 @@ lpfc_initial_fdisc(struct lpfc_vport *vport)
 			return 0;
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		/* re-setup ndlp without removing from node list */
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			return 0;
 	}
 
 	if (lpfc_issue_els_fdisc(vport, ndlp, 0)) {
@@ -1627,7 +1610,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
 	/* return immediately if the WWPN matches ndlp */
-	if (new_ndlp == ndlp && NLP_CHK_NODE_ACT(new_ndlp))
+	if (new_ndlp == ndlp)
 		return ndlp;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -1662,28 +1645,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 					     phba->active_rrq_pool);
 			return ndlp;
 		}
-	} else if (!NLP_CHK_NODE_ACT(new_ndlp)) {
-		rc = memcmp(&ndlp->nlp_portname, name,
-			    sizeof(struct lpfc_name));
-		if (!rc) {
-			if (active_rrqs_xri_bitmap)
-				mempool_free(active_rrqs_xri_bitmap,
-					     phba->active_rrq_pool);
-			return ndlp;
-		}
-		new_ndlp = lpfc_enable_node(vport, new_ndlp,
-						NLP_STE_UNUSED_NODE);
-		if (!new_ndlp) {
-			if (active_rrqs_xri_bitmap)
-				mempool_free(active_rrqs_xri_bitmap,
-					     phba->active_rrq_pool);
-			return ndlp;
-		}
-		keepDID = new_ndlp->nlp_DID;
-		if ((phba->sli_rev == LPFC_SLI_REV4) && active_rrqs_xri_bitmap)
-			memcpy(active_rrqs_xri_bitmap,
-			       new_ndlp->active_rrqs_xri_bitmap,
-			       phba->cfg_rrq_xri_bitmap_sz);
 	} else {
 		keepDID = new_ndlp->nlp_DID;
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
@@ -1781,16 +1742,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			lpfc_nlp_put(ndlp);
 		}
 
-		/* We shall actually free the ndlp with both nlp_DID and
-		 * nlp_portname fields equals 0 to avoid any ndlp on the
-		 * nodelist never to be used.
-		 */
-		if (ndlp->nlp_DID == 0) {
-			spin_lock_irq(&phba->ndlp_lock);
-			NLP_SET_FREE_REQ(ndlp);
-			spin_unlock_irq(&phba->ndlp_lock);
-		}
-
 		/* Two ndlps cannot have the same did on the nodelist.
 		 * Note: for this case, ndlp has a NULL WWPN so setting
 		 * the nlp_fc4_type isn't required.
@@ -1803,10 +1754,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			       active_rrqs_xri_bitmap,
 			       phba->cfg_rrq_xri_bitmap_sz);
 
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			lpfc_drop_node(vport, ndlp);
-	}
-	else {
+	} else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "3180 PLOGI confirm SWAP: %x %x\n",
 			 new_ndlp->nlp_DID, keepDID);
@@ -1856,6 +1804,14 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 				put_device(&rport->dev);
 		}
 	}
+
+	/*
+	 * If ndlp is not associated with any rport we can drop it here else
+	 * let dev_loss_tmo_callbk trigger DEVICE_RM event
+	 */
+	if (!ndlp->rport && (ndlp->nlp_state == NLP_STE_NPR_NODE))
+		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
+
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
 	    active_rrqs_xri_bitmap)
 		mempool_free(active_rrqs_xri_bitmap,
@@ -1933,7 +1889,7 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		irsp->un.elsreq64.remoteID);
 
 	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) || ndlp != rrq->ndlp) {
+	if (!ndlp || ndlp != rrq->ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "2882 RRQ completes to NPort x%x "
 				 "with no ndlp. Data: x%x x%x x%x\n",
@@ -2010,7 +1966,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		irsp->un.elsreq64.remoteID);
 
 	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0136 PLOGI completes to NPort x%x "
 				 "with no ndlp. Data: x%x x%x x%x\n",
@@ -2151,8 +2107,6 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 				ndlp->nlp_defer_did = did;
 			return 0;
 		}
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			ndlp = NULL;
 	}
 
 	/* If ndlp is not NULL, we will bump the reference count on it */
@@ -3184,10 +3138,6 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		if (!ndlp)
 			return 1;
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			return 1;
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
@@ -3287,11 +3237,6 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 			if (!ndlp)
 				return 1;
 			lpfc_enqueue_node(vport, ndlp);
-		} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-			ndlp = lpfc_enable_node(vport, ndlp,
-						NLP_STE_UNUSED_NODE);
-			if (!ndlp)
-				return 1;
 		}
 	}
 
@@ -3392,10 +3337,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 		if (!ndlp)
 			return 1;
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			return 1;
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
@@ -3425,7 +3366,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 	memcpy(&fp->RportName, &vport->fc_portname, sizeof(struct lpfc_name));
 	memcpy(&fp->RnodeName, &vport->fc_nodename, sizeof(struct lpfc_name));
 	ondlp = lpfc_findnode_did(vport, nportid);
-	if (ondlp && NLP_CHK_NODE_ACT(ondlp)) {
+	if (ondlp) {
 		memcpy(&fp->OportName, &ondlp->nlp_portname,
 		       sizeof(struct lpfc_name));
 		memcpy(&fp->OnodeName, &ondlp->nlp_nodename,
@@ -3489,10 +3430,6 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 		if (!ndlp)
 			return -ENODEV;
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			return -ENODEV;
 	}
 
 	/* RDF ELS is not required on an NPIV VN_Port.  */
@@ -3828,14 +3765,13 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		cmd = *elscmd++;
 	}
 
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp))
+	if (ndlp)
 		did = ndlp->nlp_DID;
 	else {
 		/* We should only hit this case for retrying PLOGI */
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
-		if ((!ndlp || !NLP_CHK_NODE_ACT(ndlp))
-		    && (cmd != ELS_CMD_PLOGI))
+		if (!ndlp && (cmd != ELS_CMD_PLOGI))
 			return 1;
 	}
 
@@ -4163,7 +4099,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 
 		phba->fc_stat.elsXmitRetry++;
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp) && delay) {
+		if (ndlp && delay) {
 			phba->fc_stat.elsDelayRetry++;
 			ndlp->nlp_retry = cmdiocb->retry;
 
@@ -4194,7 +4130,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_issue_els_fdisc(vport, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_PLOGI:
-			if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+			if (ndlp) {
 				ndlp->nlp_prev_state = ndlp->nlp_state;
 				lpfc_nlp_set_state(vport, ndlp,
 						   NLP_STE_PLOGI_ISSUE);
@@ -4469,20 +4405,16 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mempool_free(pmb, phba->mbox_mem_pool);
 	if (ndlp) {
 		lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-				 "0006 rpi%x DID:%x flg:%x %d map:%x x%px\n",
+				 "0006 rpi%x DID:%x flg:%x %d x%px\n",
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 				 kref_read(&ndlp->kref),
-				 ndlp->nlp_usg_map, ndlp);
-		if (NLP_CHK_NODE_ACT(ndlp)) {
-			lpfc_nlp_put(ndlp);
-			/* This is the end of the default RPI cleanup logic for
-			 * this ndlp. If no other discovery threads are using
-			 * this ndlp, free all resources associated with it.
-			 */
-			lpfc_nlp_not_used(ndlp);
-		} else {
-			lpfc_drop_node(ndlp->vport, ndlp);
-		}
+				 ndlp);
+		lpfc_nlp_put(ndlp);
+		/* This is the end of the default RPI cleanup logic for
+		 * this ndlp. If no other discovery threads are using
+		 * this ndlp, free all resources associated with it.
+		 */
+		lpfc_nlp_not_used(ndlp);
 	}
 
 	return;
@@ -4531,8 +4463,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * function can have cmdiocb->contest1 (ndlp) field set to NULL.
 	 */
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
-	    (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
+	if (ndlp && (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
 		/* A LS_RJT associated with Default RPI cleanup has its own
 		 * separate code path.
 		 */
@@ -4541,7 +4472,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 	/* Check to see if link went down during discovery */
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) || lpfc_els_chk_latt(vport)) {
+	if (!ndlp || lpfc_els_chk_latt(vport)) {
 		if (mbox) {
 			mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
 			if (mp) {
@@ -4550,8 +4481,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
-		    (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
+		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
 			if (lpfc_nlp_not_used(ndlp)) {
 				ndlp = NULL;
 				/* Indicate the node has already released,
@@ -4663,7 +4593,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		mempool_free(mbox, phba->mbox_mem_pool);
 	}
 out:
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
+	if (ndlp && shost) {
 		spin_lock_irq(shost->host_lock);
 		if (mbox)
 			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
@@ -5417,8 +5347,6 @@ lpfc_els_disc_adisc(struct lpfc_vport *vport)
 
 	/* go thru NPR nodes and issue any remaining ELS ADISCs */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
 		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
 		    (ndlp->nlp_flag & NLP_NPR_ADISC) != 0) {
@@ -5475,8 +5403,6 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 
 	/* go thru NPR nodes and issue any remaining ELS PLOGIs */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
 				(ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
 				(ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
@@ -6584,8 +6510,7 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 
 	/* Move all affected nodes by pending RSCNs to NPR state. */
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp) ||
-		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
+		if ((ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
 
@@ -6920,8 +6845,7 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 	vport->num_disc_nodes = 0;
 
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
-	    && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
+	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		/* Good ndlp, issue CT Request to NameServer.  Need to
 		 * know how many gidfts were issued.  If none, then just
 		 * flush the RSCN.  Otherwise, the outstanding requests
@@ -6939,13 +6863,8 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 	} else {
 		/* Nameserver login in question.  Revalidate. */
 		if (ndlp) {
-			ndlp = lpfc_enable_node(vport, ndlp,
-						NLP_STE_PLOGI_ISSUE);
-			if (!ndlp) {
-				lpfc_els_flush_rscn(vport);
-				return 0;
-			}
 			ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 		} else {
 			ndlp = lpfc_nlp_init(vport, NameServer_DID);
 			if (!ndlp) {
@@ -7529,7 +7448,7 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (ndlp != rrq->ndlp)
 		ndlp = rrq->ndlp;
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		return 1;
 
 	/* If ndlp is not NULL, we will bump the reference count on it */
@@ -8000,7 +7919,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 		else {
 			struct lpfc_nodelist *ndlp;
 			ndlp = __lpfc_findnode_rpi(vport, cmd->ulpContext);
-			if (ndlp && NLP_CHK_NODE_ACT(ndlp))
+			if (ndlp)
 				remote_ID = ndlp->nlp_DID;
 		}
 		list_add_tail(&piocb->dlist, &abort_list);
@@ -8227,7 +8146,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 	uint32_t *pcmd;
 
 	ndlp = cmdiocbp->context1;
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		return;
 
 	if (rspiocbp->iocb.ulpStatus == IOSTAT_LS_RJT) {
@@ -8503,20 +8422,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		newnode = 1;
 		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK)
 			ndlp->nlp_type |= NLP_FABRIC;
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		ndlp = lpfc_enable_node(vport, ndlp,
-					NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			goto dropit;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-		newnode = 1;
-		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK)
-			ndlp->nlp_type |= NLP_FABRIC;
 	} else if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
-		/* This is similar to the new node path */
-		ndlp = lpfc_nlp_get(ndlp);
-		if (!ndlp)
-			goto dropit;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		newnode = 1;
 	}
@@ -8993,13 +8899,9 @@ lpfc_start_fdmi(struct lpfc_vport *vport)
 			return;
 		}
 	}
-	if (!NLP_CHK_NODE_ACT(ndlp))
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
 
-	if (ndlp) {
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
-		lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
-	}
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
+	lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 }
 
 /**
@@ -9051,19 +8953,8 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 					 "0251 NameServer login: no memory\n");
 			return;
 		}
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp) {
-			if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
-				lpfc_disc_start(vport);
-				return;
-			}
-			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					"0348 NameServer login: node freed\n");
-			return;
-		}
 	}
+
 	ndlp->nlp_type |= NLP_FABRIC;
 
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
@@ -9425,8 +9316,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 */
 		list_for_each_entry_safe(np, next_np,
 			&vport->fc_nodes, nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp) ||
-			    (np->nlp_state != NLP_STE_NPR_NODE) ||
+			if ((np->nlp_state != NLP_STE_NPR_NODE) ||
 			    !(np->nlp_flag & NLP_NPR_ADISC))
 				continue;
 			spin_lock_irq(shost->host_lock);
@@ -10052,8 +9942,10 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
-		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport)
+		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport) {
+			lpfc_nlp_put(sglq_entry->ndlp);
 			sglq_entry->ndlp = NULL;
+		}
 	}
 	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
@@ -10096,9 +9988,13 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			sglq_entry->state = SGL_FREED;
 			spin_unlock(&phba->sli4_hba.sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
-			lpfc_set_rrq_active(phba, ndlp,
-				sglq_entry->sli4_lxritag,
-				rxid, 1);
+
+			if (ndlp) {
+				lpfc_set_rrq_active(phba, ndlp,
+					sglq_entry->sli4_lxritag,
+					rxid, 1);
+				lpfc_nlp_put(ndlp);
+			}
 
 			/* Check if TXQ queue needs to be serviced */
 			if (pring && !list_empty(&pring->txq))
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c61eb6032500..47d26917e10f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -83,7 +83,7 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
 
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
 			printk(KERN_ERR "Cannot find remote node"
 			" to terminate I/O Data x%x\n",
@@ -122,7 +122,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		return;
 
 	vport = ndlp->vport;
@@ -820,8 +820,7 @@ lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove)
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
+
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
@@ -992,8 +991,7 @@ lpfc_linkup_cleanup_nodes(struct lpfc_vport *vport)
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
+
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 		if (ndlp->nlp_type & NLP_FABRIC) {
@@ -3594,10 +3592,10 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	pmb->ctx_ndlp = NULL;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
-			 "0002 rpi:%x DID:%x flg:%x %d map:%x x%px\n",
+			 "0002 rpi:%x DID:%x flg:%x %d x%px\n",
 			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 			 kref_read(&ndlp->kref),
-			 ndlp->nlp_usg_map, ndlp);
+			 ndlp);
 	if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
 		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 
@@ -4109,10 +4107,10 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
-			 "0003 rpi:%x DID:%x flg:%x %d map%x x%px\n",
+			 "0003 rpi:%x DID:%x flg:%x %d x%px\n",
 			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 			 kref_read(&ndlp->kref),
-			 ndlp->nlp_usg_map, ndlp);
+			 ndlp);
 
 	if (vport->port_state < LPFC_VPORT_READY) {
 		/* Link up discovery requires Fabric registration. */
@@ -4437,6 +4435,7 @@ lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	int  old_state = ndlp->nlp_state;
+	int node_dropped = ndlp->nlp_flag & NLP_DROPPED;
 	char name1[16], name2[16];
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
@@ -4449,6 +4448,12 @@ lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"node statechg    did:x%x old:%d ste:%d",
 		ndlp->nlp_DID, old_state, state);
 
+	if (node_dropped && old_state == NLP_STE_UNUSED_NODE &&
+	    state != NLP_STE_UNUSED_NODE) {
+		ndlp->nlp_flag &= ~NLP_DROPPED;
+		lpfc_nlp_get(ndlp);
+	}
+
 	if (old_state == NLP_STE_NPR_NODE &&
 	    state != NLP_STE_NPR_NODE)
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
@@ -4496,15 +4501,6 @@ lpfc_dequeue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				NLP_STE_UNUSED_NODE);
 }
 
-static void
-lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
-{
-	lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
-		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
-	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
-				NLP_STE_UNUSED_NODE);
-}
 /**
  * lpfc_initialize_node - Initialize all fields of node object
  * @vport: Pointer to Virtual Port object.
@@ -4534,122 +4530,11 @@ lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_sid = NLP_NO_SID;
 	ndlp->nlp_fc4_type = NLP_FC4_NONE;
 	kref_init(&ndlp->kref);
-	NLP_INT_NODE_ACT(ndlp);
 	atomic_set(&ndlp->cmd_pending, 0);
 	ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
 	ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 }
 
-struct lpfc_nodelist *
-lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
-		 int state)
-{
-	struct lpfc_hba *phba = vport->phba;
-	uint32_t did, flag;
-	unsigned long flags;
-	unsigned long *active_rrqs_xri_bitmap = NULL;
-	int rpi = LPFC_RPI_ALLOC_ERROR;
-	uint32_t defer_did = 0;
-
-	if (!ndlp)
-		return NULL;
-
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		if (ndlp->nlp_rpi == LPFC_RPI_ALLOC_ERROR)
-			rpi = lpfc_sli4_alloc_rpi(vport->phba);
-		else
-			rpi = ndlp->nlp_rpi;
-
-		if (rpi == LPFC_RPI_ALLOC_ERROR) {
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-					 "0359 %s: ndlp:x%px "
-					 "usgmap:x%x refcnt:%d FAILED RPI "
-					 " ALLOC\n",
-					 __func__,
-					 (void *)ndlp, ndlp->nlp_usg_map,
-					 kref_read(&ndlp->kref));
-			return NULL;
-		}
-	}
-
-	spin_lock_irqsave(&phba->ndlp_lock, flags);
-	/* The ndlp should not be in memory free mode */
-	if (NLP_CHK_FREE_REQ(ndlp)) {
-		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-				"0277 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
-				kref_read(&ndlp->kref));
-		goto free_rpi;
-	}
-	/* The ndlp should not already be in active mode */
-	if (NLP_CHK_NODE_ACT(ndlp)) {
-		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-				"0278 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
-				kref_read(&ndlp->kref));
-		goto free_rpi;
-	}
-
-	/* First preserve the orginal DID, xri_bitmap and some flags */
-	did = ndlp->nlp_DID;
-	flag = (ndlp->nlp_flag & NLP_UNREG_INP);
-	if (flag & NLP_UNREG_INP)
-		defer_did = ndlp->nlp_defer_did;
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		active_rrqs_xri_bitmap = ndlp->active_rrqs_xri_bitmap;
-
-	/* Zero ndlp except of ndlp linked list pointer */
-	memset((((char *)ndlp) + sizeof (struct list_head)), 0,
-		sizeof (struct lpfc_nodelist) - sizeof (struct list_head));
-
-	/* Next reinitialize and restore saved objects */
-	lpfc_initialize_node(vport, ndlp, did);
-	ndlp->nlp_flag |= flag;
-	if (flag & NLP_UNREG_INP)
-		ndlp->nlp_defer_did = defer_did;
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		ndlp->active_rrqs_xri_bitmap = active_rrqs_xri_bitmap;
-
-	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
-		ndlp->nlp_rpi = rpi;
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-				 "0008 rpi:%x DID:%x flg:%x refcnt:%d "
-				 "map:%x x%px\n", ndlp->nlp_rpi, ndlp->nlp_DID,
-				 ndlp->nlp_flag,
-				 kref_read(&ndlp->kref),
-				 ndlp->nlp_usg_map, ndlp);
-	}
-
-
-	if (state != NLP_STE_UNUSED_NODE)
-		lpfc_nlp_set_state(vport, ndlp, state);
-	else
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-				 "0013 rpi:%x DID:%x flg:%x refcnt:%d "
-				 "map:%x x%px STATE=UNUSED\n",
-				 ndlp->nlp_rpi, ndlp->nlp_DID,
-				 ndlp->nlp_flag,
-				 kref_read(&ndlp->kref),
-				 ndlp->nlp_usg_map, ndlp);
-
-	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
-		"node enable:       did:x%x",
-		ndlp->nlp_DID, 0, 0);
-	return ndlp;
-
-free_rpi:
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		lpfc_sli4_free_rpi(vport->phba, rpi);
-		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-	}
-	return NULL;
-}
-
 void
 lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
@@ -4663,6 +4548,7 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 		return;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
+	ndlp->nlp_flag |= NLP_DROPPED;
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_cleanup_vports_rrqs(vport, ndlp);
 		lpfc_unreg_rpi(vport, ndlp);
@@ -5179,22 +5065,7 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 "Data: x%x x%x x%x\n",
 			 ndlp->nlp_DID, ndlp->nlp_flag,
 			 ndlp->nlp_state, ndlp->nlp_rpi);
-	if (NLP_CHK_FREE_REQ(ndlp)) {
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-				"0280 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
-				kref_read(&ndlp->kref));
-		lpfc_dequeue_node(vport, ndlp);
-	} else {
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-				"0281 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
-				kref_read(&ndlp->kref));
-		lpfc_disable_node(vport, ndlp);
-	}
-
+	lpfc_dequeue_node(vport, ndlp);
 
 	/* Don't need to clean up REG_LOGIN64 cmds for Default RPI cleanup */
 
@@ -5296,10 +5167,10 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		lpfc_printf_vlog(vport, KERN_INFO,
 				 LOG_NODE | LOG_DISCOVERY,
 				 "0005 Cleanup Default rpi:x%x DID:x%x flg:x%x "
-				 "ref %d map:x%x ndlp x%px\n",
+				 "ref %d ndlp x%px\n",
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 				 kref_read(&ndlp->kref),
-				 ndlp->nlp_usg_map, ndlp);
+				 ndlp);
 		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
 			!= NULL) {
 			rc = lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
@@ -5410,8 +5281,8 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 		if (lpfc_matchdid(vport, ndlp, did)) {
 			data1 = (((uint32_t)ndlp->nlp_state << 24) |
 				 ((uint32_t)ndlp->nlp_xri << 16) |
-				 ((uint32_t)ndlp->nlp_type << 8) |
-				 ((uint32_t)ndlp->nlp_usg_map & 0xff));
+				 ((uint32_t)ndlp->nlp_type << 8)
+				 );
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 					 "0929 FIND node DID "
 					 "Data: x%px x%x x%x x%x x%x x%px\n",
@@ -5500,25 +5371,6 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 				 ndlp->nlp_DID, ndlp->nlp_flag,
 				 ndlp->nlp_state, vport->fc_flag);
 
-		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
-		return ndlp;
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		if (vport->phba->nvmet_support)
-			return NULL;
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
-		if (!ndlp) {
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
-					 "0014 Could not enable ndlp\n");
-			return NULL;
-		}
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "6454 Setup Enabled Node 2B_DISC x%x "
-				 "Data:x%x x%x x%x\n",
-				 ndlp->nlp_DID, ndlp->nlp_flag,
-				 ndlp->nlp_state, vport->fc_flag);
-
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5858,8 +5710,6 @@ lpfc_disc_flush_list(struct lpfc_vport *vport)
 	if (vport->fc_plogi_cnt || vport->fc_adisc_cnt) {
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
-				continue;
 			if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
 			    ndlp->nlp_state == NLP_STE_ADISC_ISSUE) {
 				lpfc_free_tx(phba, ndlp);
@@ -5947,8 +5797,6 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 		/* Start discovery by sending FLOGI, clean up old rpis */
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
-				continue;
 			if (ndlp->nlp_state != NLP_STE_NPR_NODE)
 				continue;
 			if (ndlp->nlp_type & NLP_FABRIC) {
@@ -6000,7 +5848,7 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 				 "NameServer login\n");
 		/* Next look for NameServer ndlp */
 		ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp))
+		if (ndlp)
 			lpfc_els_abort(phba, ndlp);
 
 		/* ReStart discovery */
@@ -6173,10 +6021,10 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
-			 "0004 rpi:%x DID:%x flg:%x %d map:%x x%px\n",
+			 "0004 rpi:%x DID:%x flg:%x %d x%px\n",
 			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 			 kref_read(&ndlp->kref),
-			 ndlp->nlp_usg_map, ndlp);
+			 ndlp);
 	/*
 	 * Start issuing Fabric-Device Management Interface (FDMI) command to
 	 * 0xfffffa (FDMI well known port).
@@ -6205,10 +6053,6 @@ lpfc_filter_by_rpi(struct lpfc_nodelist *ndlp, void *param)
 {
 	uint16_t *rpi = param;
 
-	/* check for active node */
-	if (!NLP_CHK_NODE_ACT(ndlp))
-		return 0;
-
 	return ndlp->nlp_rpi == *rpi;
 }
 
@@ -6363,10 +6207,9 @@ lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 		ndlp->nlp_rpi = rpi;
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
 				 "0007 Init New ndlp x%px, rpi:x%x DID:%x "
-				 "flg:x%x refcnt:%d map:x%x\n",
+				 "flg:x%x refcnt:%d\n",
 				 ndlp, ndlp->nlp_rpi, ndlp->nlp_DID,
-				 ndlp->nlp_flag, kref_read(&ndlp->kref),
-				 ndlp->nlp_usg_map);
+				 ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 		ndlp->active_rrqs_xri_bitmap =
 				mempool_alloc(vport->phba->active_rrq_pool,
@@ -6391,8 +6234,6 @@ lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 static void
 lpfc_nlp_release(struct kref *kref)
 {
-	struct lpfc_hba *phba;
-	unsigned long flags;
 	struct lpfc_nodelist *ndlp = container_of(kref, struct lpfc_nodelist,
 						  kref);
 
@@ -6401,29 +6242,19 @@ lpfc_nlp_release(struct kref *kref)
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			"0279 %s: ndlp:x%px did %x "
-			"usgmap:x%x refcnt:%d rpi:%x\n",
-			__func__,
-			(void *)ndlp, ndlp->nlp_DID, ndlp->nlp_usg_map,
+			"0279 %s: ndlp:x%px did %x refcnt:%d rpi:%x\n",
+			__func__, (void *)ndlp, ndlp->nlp_DID,
 			kref_read(&ndlp->kref), ndlp->nlp_rpi);
 
 	/* remove ndlp from action. */
 	lpfc_nlp_remove(ndlp->vport, ndlp);
 
-	/* clear the ndlp active flag for all release cases */
-	phba = ndlp->phba;
-	spin_lock_irqsave(&phba->ndlp_lock, flags);
-	NLP_CLR_NODE_ACT(ndlp);
-	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-
 	/* free ndlp memory for final ndlp release */
-	if (NLP_CHK_FREE_REQ(ndlp)) {
-		kfree(ndlp->lat_data);
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			mempool_free(ndlp->active_rrqs_xri_bitmap,
-				     ndlp->phba->active_rrq_pool);
-		mempool_free(ndlp, ndlp->phba->nlp_mem_pool);
-	}
+	kfree(ndlp->lat_data);
+	if (ndlp->phba->sli_rev == LPFC_SLI_REV4)
+		mempool_free(ndlp->active_rrqs_xri_bitmap,
+				ndlp->phba->active_rrq_pool);
+	mempool_free(ndlp, ndlp->phba->nlp_mem_pool);
 }
 
 /* This routine bumps the reference count for a ndlp structure to ensure
@@ -6441,94 +6272,44 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 			"node get:        did:x%x flg:x%x refcnt:x%x",
 			ndlp->nlp_DID, ndlp->nlp_flag,
 			kref_read(&ndlp->kref));
+
 		/* The check of ndlp usage to prevent incrementing the
 		 * ndlp reference count that is in the process of being
 		 * released.
 		 */
 		phba = ndlp->phba;
 		spin_lock_irqsave(&phba->ndlp_lock, flags);
-		if (!NLP_CHK_NODE_ACT(ndlp) || NLP_CHK_FREE_ACK(ndlp)) {
+		if (!kref_get_unless_zero(&ndlp->kref)) {
 			spin_unlock_irqrestore(&phba->ndlp_lock, flags);
 			lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
-				"0276 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
-				kref_read(&ndlp->kref));
+				"0276 %s: ndlp:x%px refcnt:%d\n",
+				__func__, (void *)ndlp, kref_read(&ndlp->kref));
 			return NULL;
-		} else
-			kref_get(&ndlp->kref);
+		}
 		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+	} else {
+		WARN_ONCE(!ndlp, "**** %s, get ref on NULL ndlp!", __func__);
 	}
+
 	return ndlp;
 }
 
 /* This routine decrements the reference count for a ndlp structure. If the
- * count goes to 0, this indicates the the associated nodelist should be
- * freed. Returning 1 indicates the ndlp resource has been released; on the
- * other hand, returning 0 indicates the ndlp resource has not been released
- * yet.
+ * count goes to 0, this indicates the associated nodelist should be freed.
  */
 int
 lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 {
-	struct lpfc_hba *phba;
-	unsigned long flags;
-
-	if (!ndlp)
-		return 1;
-
-	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
-			"node put:        did:x%x flg:x%x refcnt:x%x",
-			ndlp->nlp_DID, ndlp->nlp_flag,
-			kref_read(&ndlp->kref));
-	phba = ndlp->phba;
-	spin_lock_irqsave(&phba->ndlp_lock, flags);
-	/* Check the ndlp memory free acknowledge flag to avoid the
-	 * possible race condition that kref_put got invoked again
-	 * after previous one has done ndlp memory free.
-	 */
-	if (NLP_CHK_FREE_ACK(ndlp)) {
-		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-		lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
-				"0274 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
-				kref_read(&ndlp->kref));
-		return 1;
-	}
-	/* Check the ndlp inactivate log flag to avoid the possible
-	 * race condition that kref_put got invoked again after ndlp
-	 * is already in inactivating state.
-	 */
-	if (NLP_CHK_IACT_REQ(ndlp)) {
-		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-		lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
-				"0275 %s: ndlp:x%px "
-				"usgmap:x%x refcnt:%d\n",
-				__func__, (void *)ndlp, ndlp->nlp_usg_map,
+	if (ndlp) {
+		lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
+				"node put:        did:x%x flg:x%x refcnt:x%x",
+				ndlp->nlp_DID, ndlp->nlp_flag,
 				kref_read(&ndlp->kref));
-		return 1;
+	} else {
+		WARN_ONCE(!ndlp, "**** %s, put ref on NULL ndlp!", __func__);
 	}
-	/* For last put, mark the ndlp usage flags to make sure no
-	 * other kref_get and kref_put on the same ndlp shall get
-	 * in between the process when the final kref_put has been
-	 * invoked on this ndlp.
-	 */
-	if (kref_read(&ndlp->kref) == 1) {
-		/* Indicate ndlp is put to inactive state. */
-		NLP_SET_IACT_REQ(ndlp);
-		/* Acknowledge ndlp memory free has been seen. */
-		if (NLP_CHK_FREE_REQ(ndlp))
-			NLP_SET_FREE_ACK(ndlp);
-	}
-	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-	/* Note, the kref_put returns 1 when decrementing a reference
-	 * count that was 1, it invokes the release callback function,
-	 * but it still left the reference count as 1 (not actually
-	 * performs the last decrementation). Otherwise, it actually
-	 * decrements the reference count and returns 0.
-	 */
-	return kref_put(&ndlp->kref, lpfc_nlp_release);
+
+	return ndlp ? kref_put(&ndlp->kref, lpfc_nlp_release) : 0;
 }
 
 /* This routine free's the specified nodelist if it is not in use
@@ -6588,7 +6369,7 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 			goto out;
 		}
 		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
-			if (NLP_CHK_NODE_ACT(ndlp) && ndlp->rport &&
+			if (ndlp->rport &&
 			  (ndlp->rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
 				ret = 1;
 				spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index aa7931a1750f..add2eb0d729b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2844,28 +2844,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_port_link_failure(vport);
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp)) {
-			ndlp = lpfc_enable_node(vport, ndlp,
-						NLP_STE_UNUSED_NODE);
-			if (!ndlp)
-				continue;
-			spin_lock_irq(&phba->ndlp_lock);
-			NLP_SET_FREE_REQ(ndlp);
-			spin_unlock_irq(&phba->ndlp_lock);
-			/* Trigger the release of the ndlp memory */
-			lpfc_nlp_put(ndlp);
-			continue;
-		}
-		spin_lock_irq(&phba->ndlp_lock);
-		if (NLP_CHK_FREE_REQ(ndlp)) {
-			/* The ndlp should not be in memory free mode already */
-			spin_unlock_irq(&phba->ndlp_lock);
-			continue;
-		} else
-			/* Indicate request for freeing ndlp memory */
-			NLP_SET_FREE_REQ(ndlp);
-		spin_unlock_irq(&phba->ndlp_lock);
-
 		if (vport->port_type != LPFC_PHYSICAL_PORT &&
 		    ndlp->nlp_DID == Fabric_DID) {
 			/* Just free up ndlp with Fabric_DID for vports */
@@ -2903,9 +2881,8 @@ lpfc_cleanup(struct lpfc_vport *vport)
 				lpfc_printf_vlog(ndlp->vport, KERN_ERR,
 						LOG_TRACE_EVENT,
 						"0282 did:x%x ndlp:x%px "
-						"usgmap:x%x refcnt:%d\n",
+						"refcnt:%d\n",
 						ndlp->nlp_DID, (void *)ndlp,
-						ndlp->nlp_usg_map,
 						kref_read(&ndlp->kref));
 			}
 			break;
@@ -3080,7 +3057,6 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
 	struct lpfc_vport **vports;
 	int i, rpi;
-	unsigned long flags;
 
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return;
@@ -3096,22 +3072,18 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 		list_for_each_entry_safe(ndlp, next_ndlp,
 					 &vports[i]->fc_nodes,
 					 nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
-				continue;
 			rpi = lpfc_sli4_alloc_rpi(phba);
 			if (rpi == LPFC_RPI_ALLOC_ERROR) {
-				spin_lock_irqsave(&phba->ndlp_lock, flags);
-				NLP_CLR_NODE_ACT(ndlp);
-				spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+				/* TODO print log? */
 				continue;
 			}
 			ndlp->nlp_rpi = rpi;
 			lpfc_printf_vlog(ndlp->vport, KERN_INFO,
 					 LOG_NODE | LOG_DISCOVERY,
 					 "0009 Assign RPI x%x to ndlp x%px "
-					 "DID:x%06x flg:x%x map:x%x\n",
+					 "DID:x%06x flg:x%x\n",
 					 ndlp->nlp_rpi, ndlp, ndlp->nlp_DID,
-					 ndlp->nlp_flag, ndlp->nlp_usg_map);
+					 ndlp->nlp_flag);
 		}
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -3510,8 +3482,7 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
 						 nlp_listp) {
-				if ((!NLP_CHK_NODE_ACT(ndlp)) ||
-				    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+				if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
 					/* Driver must assume RPI is invalid for
 					 * any unused or inactive node.
 					 */
@@ -3519,12 +3490,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					continue;
 				}
 
-				if (ndlp->nlp_type & NLP_FABRIC) {
-					lpfc_disc_state_machine(vports[i], ndlp,
-						NULL, NLP_EVT_DEVICE_RECOVERY);
-					lpfc_disc_state_machine(vports[i], ndlp,
-						NULL, NLP_EVT_DEVICE_RM);
-				}
 				spin_lock_irq(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 				spin_unlock_irq(shost->host_lock);
@@ -3537,15 +3502,20 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					lpfc_printf_vlog(ndlp->vport, KERN_INFO,
 						 LOG_NODE | LOG_DISCOVERY,
 						 "0011 Free RPI x%x on "
-						 "ndlp:x%px did x%x "
-						 "usgmap:x%x\n",
+						 "ndlp:x%px did x%x\n",
 						 ndlp->nlp_rpi, ndlp,
-						 ndlp->nlp_DID,
-						 ndlp->nlp_usg_map);
+						 ndlp->nlp_DID);
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
 					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 				}
 				lpfc_unreg_rpi(vports[i], ndlp);
+
+				if (ndlp->nlp_type & NLP_FABRIC) {
+					lpfc_disc_state_machine(vports[i], ndlp,
+						NULL, NLP_EVT_DEVICE_RECOVERY);
+					lpfc_disc_state_machine(vports[i], ndlp,
+						NULL, NLP_EVT_DEVICE_RM);
+				}
 			}
 		}
 	}
@@ -5604,11 +5574,6 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 		ndlp->nlp_type |= NLP_FABRIC;
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		/* re-setup ndlp without removing from node list */
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp)
-			return 0;
 	}
 	if ((phba->pport->port_state < LPFC_FLOGI) &&
 		(phba->pport->port_state != LPFC_VPORT_FAILED))
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 92d6e7b98770..16a37c2153ae 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1907,7 +1907,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	/* software abort if any GID_FT is outstanding */
 	if (vport->cfg_enable_fc4_type != LPFC_ENABLE_FCP) {
 		ns_ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		if (ns_ndlp && NLP_CHK_NODE_ACT(ns_ndlp))
+		if (ns_ndlp)
 			lpfc_els_abort(phba, ns_ndlp);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 69f1a0457f51..19faae83b2c1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -695,7 +695,7 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	int ret;
 	uint16_t ntype, nstate;
 
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6051 NVMEx LS REQ: Bad NDLP x%px, Failing "
 				 "LS Req\n",
@@ -1134,7 +1134,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	 * transport is still transitioning.
 	 */
 	ndlp = lpfc_ncmd->ndlp;
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6062 Ignoring NVME cmpl.  No ndlp\n");
 		goto out_err;
@@ -1316,9 +1316,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
 
-	if (!NLP_CHK_NODE_ACT(pnode))
-		return -EINVAL;
-
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use
 	 * the single mapping, or neither.
@@ -1670,7 +1667,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	 * transport is still transitioning.
 	 */
 	ndlp = rport->ndlp;
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_NVME_IOERR,
 				 "6053 Busy IO, ndlp not ready: rport x%px "
 				  "ndlp x%px, DID x%06x\n",
@@ -2503,8 +2500,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 * reference would cause a premature cleanup.
 			 */
 			if (prev_ndlp && prev_ndlp != ndlp) {
-				if ((!NLP_CHK_NODE_ACT(prev_ndlp)) ||
-				    (!prev_ndlp->nrport))
+				if (!prev_ndlp->nrport)
 					lpfc_nlp_put(prev_ndlp);
 			}
 		}
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index d4ade7cdb93a..f62ea5a8f59e 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1807,7 +1807,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		rrq_empty = list_empty(&phba->active_rrq_list);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+		if (ndlp &&
 		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
 		     ndlp->nlp_state == NLP_STE_MAPPED_NODE)) {
 			lpfc_set_rrq_active(phba, ndlp,
@@ -2597,7 +2597,7 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	}
 
 	ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	if (!ndlp ||
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -2717,7 +2717,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	}
 
 	ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	if (!ndlp ||
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	     (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -3249,7 +3249,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 
 	ndlp = lpfc_findnode_did(phba->pport, sid);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	if (!ndlp ||
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		if (tgtp)
@@ -3347,7 +3347,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 
 	ndlp = lpfc_findnode_did(phba->pport, sid);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	if (!ndlp ||
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4ffdfd2c8604..d29380184a0c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3496,7 +3496,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 	struct lpfc_nodelist *pnode = lpfc_cmd->rdata->pnode;
 	unsigned long flags;
 
-	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+	if (!pnode)
 		return;
 
 	/* If there is queuefull or busy condition send a scsi event */
@@ -3916,7 +3916,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			fast_path_evt->un.fabric_evt.subcategory =
 				(lpfc_cmd->status == IOSTAT_NPORT_BSY) ?
 				LPFC_EVENT_PORT_BUSY : LPFC_EVENT_FABRIC_BUSY;
-			if (pnode && NLP_CHK_NODE_ACT(pnode)) {
+			if (pnode) {
 				memcpy(&fast_path_evt->un.fabric_evt.wwpn,
 					&pnode->nlp_portname,
 					sizeof(struct lpfc_name));
@@ -3971,7 +3971,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			}
 			if ((lpfc_cmd->status == IOSTAT_REMOTE_STOP)
 				&& (phba->sli_rev == LPFC_SLI_REV4)
-				&& (pnode && NLP_CHK_NODE_ACT(pnode))) {
+				&& pnode) {
 				/* This IO was aborted by the target, we don't
 				 * know the rxid and because we did not send the
 				 * ABTS we cannot generate and RRQ.
@@ -3986,8 +3986,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			break;
 		}
 
-		if (!pnode || !NLP_CHK_NODE_ACT(pnode)
-		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
+		if (!pnode || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
 			cmd->result = DID_TRANSPORT_DISRUPTED << 16 |
 				      SAM_STAT_BUSY;
 	} else
@@ -4009,7 +4008,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
 		spin_lock_irqsave(shost->host_lock, flags);
-		if (pnode && NLP_CHK_NODE_ACT(pnode)) {
+		if (pnode) {
 			if (pnode->cmd_qdepth >
 				atomic_read(&pnode->cmd_pending) &&
 				(atomic_read(&pnode->cmd_pending) >
@@ -4095,7 +4094,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 	bool sli4;
 	uint32_t fcpdl;
 
-	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+	if (!pnode)
 		return;
 
 	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
@@ -4206,8 +4205,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
-	    ndlp->nlp_state != NLP_STE_MAPPED_NODE)
+	if (!ndlp || ndlp->nlp_state != NLP_STE_MAPPED_NODE)
 		return 0;
 
 	piocbq = &(lpfc_cmd->cur_iocbq);
@@ -4543,7 +4541,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
 	 */
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		goto out_tgt_busy;
 	if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
 		if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth) {
@@ -5042,7 +5040,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	int status;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
-	if (!rdata || !rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
+	if (!rdata || !rdata->pnode)
 		return FAILED;
 	pnode = rdata->pnode;
 
@@ -5146,7 +5144,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 	 */
 	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
 	while (time_after(later, jiffies)) {
-		if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+		if (!pnode)
 			return FAILED;
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
 			return SUCCESS;
@@ -5156,8 +5154,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 			return FAILED;
 		pnode = rdata->pnode;
 	}
-	if (!pnode || !NLP_CHK_NODE_ACT(pnode) ||
-	    (pnode->nlp_state != NLP_STE_MAPPED_NODE))
+	if (!pnode || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
 		return FAILED;
 	return SUCCESS;
 }
@@ -5401,8 +5398,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 		match = 0;
 		spin_lock_irq(shost->host_lock);
 		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
-				continue;
+
 			if (vport->phba->cfg_fcp2_no_tgt_reset &&
 			    (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE))
 				continue;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index eaa5fb5ea079..4974bf671063 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -860,7 +860,7 @@ lpfc_clr_rrq_active(struct lpfc_hba *phba,
 {
 	struct lpfc_nodelist *ndlp = NULL;
 
-	if ((rrq->vport) && NLP_CHK_NODE_ACT(rrq->ndlp))
+	if (rrq->vport)
 		ndlp = lpfc_findnode_did(rrq->vport, rrq->nlp_DID);
 
 	/* The target DID could have been swapped (cable swap)
@@ -1061,12 +1061,6 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		goto out;
 	}
 
-	/*
-	 * set the active bit even if there is no mem available.
-	 */
-	if (NLP_CHK_FREE_REQ(ndlp))
-		goto out;
-
 	if (ndlp->vport && (ndlp->vport->load_flag & FC_UNLOADING))
 		goto out;
 
@@ -1289,6 +1283,11 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 			(sglq->state != SGL_XRI_ABORTED)) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
 					  iflag);
+
+			/* Check if we can get a reference on ndlp */
+			if (sglq->ndlp && !lpfc_nlp_get(sglq->ndlp))
+				sglq->ndlp = NULL;
+
 			list_add(&sglq->list,
 				 &phba->sli4_hba.lpfc_abts_els_sgl_list);
 			spin_unlock_irqrestore(
@@ -2589,11 +2588,11 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					vport, KERN_INFO, LOG_MBOX | LOG_SLI,
 					 "0010 UNREG_LOGIN vpi:%x "
 					 "rpi:%x DID:%x defer x%x flg x%x "
-					 "map:%x %px\n",
+					 "%px\n",
 					 vport->vpi, ndlp->nlp_rpi,
 					 ndlp->nlp_DID, ndlp->nlp_defer_did,
 					 ndlp->nlp_flag,
-					 ndlp->nlp_usg_map, ndlp);
+					 ndlp);
 				ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 				lpfc_nlp_put(ndlp);
 
@@ -2852,7 +2851,7 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 
 	/* validate the source of the LS is logged in */
 	ndlp = lpfc_findnode_did(phba->pport, sid);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	if (!ndlp ||
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	     (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
@@ -10426,7 +10425,7 @@ lpfc_sli_abts_err_handler(struct lpfc_hba *phba,
 	if (!vport)
 		goto err_exit;
 	ndlp = lpfc_findnode_rpi(vport, rpi);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+	if (!ndlp)
 		goto err_exit;
 
 	if (iocbq->iocb.ulpStatus == IOSTAT_LOCAL_REJECT)
@@ -10459,7 +10458,7 @@ lpfc_sli4_abts_err_handler(struct lpfc_hba *phba,
 	struct lpfc_vport *vport;
 	uint32_t ext_status = 0;
 
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+	if (!ndlp) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"3115 Node Context not found, driver "
 				"ignoring abts err event\n");
@@ -17901,15 +17900,6 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 		}
 		/* Put ndlp onto pport node list */
 		lpfc_enqueue_node(vport, ndlp);
-	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
-		/* re-setup ndlp without removing from node list */
-		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
-		if (!ndlp) {
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
-					 "3275 Failed to active ndlp found "
-					 "for oxid:x%x SID:x%x\n", oxid, sid);
-			return;
-		}
 	}
 
 	/* Allocate buffer for rsp iocb */
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index aa4e451d5dc1..6ab78131b94d 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -462,7 +462,7 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	 * up and ready to FDISC.
 	 */
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+	if (ndlp &&
 	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		if (phba->link_flag & LS_NPIV_FAB_SUPPORTED) {
 			lpfc_set_disctmo(vport);
@@ -495,8 +495,7 @@ disable_vport(struct fc_vport *fc_vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
-	    && phba->link_state >= LPFC_LINK_UP) {
+	if (ndlp && phba->link_state >= LPFC_LINK_UP) {
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
@@ -510,8 +509,6 @@ disable_vport(struct fc_vport *fc_vport)
 	 * calling lpfc_cleanup_rpis(vport, 1)
 	 */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 		lpfc_disc_state_machine(vport, ndlp, NULL,
@@ -568,8 +565,7 @@ enable_vport(struct fc_vport *fc_vport)
 	 * up and ready to FDISC.
 	 */
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
-	    && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
+	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		if (phba->link_flag & LS_NPIV_FAB_SUPPORTED) {
 			lpfc_set_disctmo(vport);
 			lpfc_initial_fdisc(vport);
@@ -663,7 +659,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	 * being released.
 	 */
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+	if (ndlp) {
 		lpfc_nlp_get(ndlp);
 		ns_ndlp_referenced = true;
 	}
@@ -679,26 +675,16 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	 * can safely skip the fabric logo.
 	 */
 	if (phba->pport->load_flag & FC_UNLOADING) {
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
-		    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
+		if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 		    phba->link_state >= LPFC_LINK_UP) {
 			/* First look for the Fabric ndlp */
 			ndlp = lpfc_findnode_did(vport, Fabric_DID);
 			if (!ndlp)
 				goto skip_logo;
-			else if (!NLP_CHK_NODE_ACT(ndlp)) {
-				ndlp = lpfc_enable_node(vport, ndlp,
-							NLP_STE_UNUSED_NODE);
-				if (!ndlp)
-					goto skip_logo;
-			}
+
 			/* Remove ndlp from vport npld list */
 			lpfc_dequeue_node(vport, ndlp);
 
-			/* Indicate free memory when release */
-			spin_lock_irq(&phba->ndlp_lock);
-			NLP_SET_FREE_REQ(ndlp);
-			spin_unlock_irq(&phba->ndlp_lock);
 			/* Kick off release ndlp when it can be safely done */
 			lpfc_nlp_put(ndlp);
 		}
@@ -706,8 +692,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	}
 
 	/* Otherwise, we will perform fabric logo as needed */
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
-	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
+	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 	    phba->link_state >= LPFC_LINK_UP &&
 	    phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
@@ -728,28 +713,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 			ndlp = lpfc_nlp_init(vport, Fabric_DID);
 			if (!ndlp)
 				goto skip_logo;
-			/* Indicate free memory when release */
-			NLP_SET_FREE_REQ(ndlp);
-		} else {
-			if (!NLP_CHK_NODE_ACT(ndlp)) {
-				ndlp = lpfc_enable_node(vport, ndlp,
-						NLP_STE_UNUSED_NODE);
-				if (!ndlp)
-					goto skip_logo;
-			}
-
-			/* Remove ndlp from vport list */
-			lpfc_dequeue_node(vport, ndlp);
-			spin_lock_irq(&phba->ndlp_lock);
-			if (!NLP_CHK_FREE_REQ(ndlp))
-				/* Indicate free memory when release */
-				NLP_SET_FREE_REQ(ndlp);
-			else {
-				/* Skip this if ndlp is already in free mode */
-				spin_unlock_irq(&phba->ndlp_lock);
-				goto skip_logo;
-			}
-			spin_unlock_irq(&phba->ndlp_lock);
 		}
 
 		/*
@@ -865,8 +828,6 @@ lpfc_vport_reset_stat_data(struct lpfc_vport *vport)
 	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 		if (ndlp->lat_data)
 			memset(ndlp->lat_data, 0, LPFC_MAX_BUCKET_COUNT *
 				sizeof(struct lpfc_scsicmd_bkt));
@@ -887,8 +848,6 @@ lpfc_alloc_bucket(struct lpfc_vport *vport)
 	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 
 		kfree(ndlp->lat_data);
 		ndlp->lat_data = NULL;
@@ -921,8 +880,6 @@ lpfc_free_bucket(struct lpfc_vport *vport)
 	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (!NLP_CHK_NODE_ACT(ndlp))
-			continue;
 
 		kfree(ndlp->lat_data);
 		ndlp->lat_data = NULL;
-- 
2.26.2


--0000000000009dced305b42a3e21
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgORxymPn/ryHG8VO0
kKpydjZbcIgE9MDHmVEeAq1dGK4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNjU1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJm3zublFliiYlurKWCES2Mmwnc2pM5GDES0
TZ1/muVyD50zRR1vJMLVH642VKeRW26xSEuzI9OZhEF6Vhfq6nchhweq5p905s9dL+scPol98/Ka
S5KMEAm7oyDtfDKB9MuzJbC7fNwfbh9Nn7A4uCl1YWgUcu47/TUPBfxYfnX2sHMyTm5RJQrHw3ja
zqqQhfZhdPElbF/xNaiE3JJbUiIMzIbjS9lnAEB/DFoRgi+hGd5JD3D2IeTIuLQ8WIwtjMDEXTv8
A4ZZYssDaoUWrAc+9ylp1oo985b+qRva+ham5sGRdSbJOV+0vrXCXtAYlQ9RHn6LuYUtkgoXXg3k
ZHk=
--0000000000009dced305b42a3e21--
