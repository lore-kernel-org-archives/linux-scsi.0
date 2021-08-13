Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA58C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15B161038
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhHMCJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbhHMCJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB1BC061756
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bo18so13185339pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GGdOX/OswSVFo3hmSz8Mv9xR/mWnzPB45uvX1NWHtnA=;
        b=r4A9XTVKe9IsS12xnoNlEqXjn5VKrqquSMKcx1+BNBGS4IIvQgVAANJiUnt5V66C41
         dRX1fPdU86hPYNibgHmOywy0vS1sl9GkzNJy7tm6Zpduch85skCOwp0qG+KZC7m7wUj8
         qU74VJSYJ6QQIBweynIrjVu7nYSYL3aCULUuKgD7CPLfR2f/4VMJaW9V6N9AF/cPNgxe
         zooC2UE4vCiijxvqarVYxQkcrESjqqcnu2I5JKNpodhPIfInaxav9C/cECu8iAJ7RTPc
         PdVUW8NxzsPsblOMhXUBqGnL5Z0tLgCj6mCvZ9blyfi8E3DFz0TA0cYF+ObYi0G5Ojk9
         terw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGdOX/OswSVFo3hmSz8Mv9xR/mWnzPB45uvX1NWHtnA=;
        b=OEezY4XRoqmOH5IwS01SVS4KNJZdpI7pBCiuMZw8SWmNvcIc35OZgWPEvj8RylZ6gW
         z3wUj9qj/C1/uNh1qyc+CehN14iPFkxkaw/fMS55JHW5DElA92Mkt52Lg20/DwxnVrT3
         fUf0fCf+FsDBrenYguyz9I0zpj5U/EWOAS8e0Kr2TxUHQ8rr0EaR2h2AlP5JO5C99O7p
         tdEhphW9oAdzL46GhYwn3MeSNvbZ3bbDvfeiP9n7Wqp0KDZcDciYfBBTiHu4TrZMlcfd
         ZYmUZCWOGexDB+eS1znK92Hbgl7GbvRKIGSaLQooKGpxUxKmjpyIaL4RuoAZF7xlXfzi
         iemw==
X-Gm-Message-State: AOAM5303IwfiJ0Xpxkggptsw2UXnN5cfQYqnQHe3yZlxSQWBKctZB3d1
        9TWcIxhBpXm9ImKwRyAShIAh2h0WK8A=
X-Google-Smtp-Source: ABdhPJw91tjqrKrvJaXL3BJS+kXeEGoXtss2RAYrmDYCFDS3BY2I/TU/Aff/aHZgDwJSMEXprV+Yqw==
X-Received: by 2002:a17:90a:73cb:: with SMTP id n11mr169078pjk.24.1628820530251;
        Thu, 12 Aug 2021 19:08:50 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/16] lpfc: Add MIB feature enablement support
Date:   Thu, 12 Aug 2021 19:07:59 -0700
Message-Id: <20210813020812.99014-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813020812.99014-1-jsmart2021@gmail.com>
References: <20210813020812.99014-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

MIB support is currently limited to detecting support in the adapter
and ensuring FDMI support is enabled if present.  For the new framework
MIB support also requires active enablement of support via the
SET_FEATURES command with the firmware.

Rework the MIB detection and enablement for the following:
- Move detection away from the get_sli4_parameters routine, and into the
  hba_setup path. get_sli4_parameters is only called once at attachment
  while hba_setup is called as part of any sli port reset path. This
  ensures detection after fw download.
- Update SET_FEATURES mbx command for the MIB enablement feature and
  add support for the feature.
- Create the cmf_setup routine to encapsulate the detection of MIB
  support and perform the enablement of the MIB support feature.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c     |  15 +++--
 drivers/scsi/lpfc/lpfc_hw4.h    |   7 +++
 drivers/scsi/lpfc/lpfc_init.c   |  15 -----
 drivers/scsi/lpfc/lpfc_logmsg.h |   3 +
 drivers/scsi/lpfc/lpfc_sli.c    | 103 ++++++++++++++++++++++++++++++++
 5 files changed, 123 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index a1c85fa135a9..435349f893ad 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2332,24 +2332,29 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		break;
 	case SLI_MGMT_RPA:
 		if (vport->port_type == LPFC_PHYSICAL_PORT &&
-		    phba->cfg_enable_mi &&
-		    phba->sli4_hba.pc_sli4_params.mi_ver > LPFC_MIB1_SUPPORT) {
+		    phba->sli4_hba.pc_sli4_params.mi_ver) {
 			/* mi is only for the phyical port, no vports */
 			if (phba->link_flag & LS_CT_VEN_RPA) {
 				lpfc_printf_vlog(vport, KERN_INFO,
-						 LOG_DISCOVERY | LOG_ELS,
+						 LOG_DISCOVERY | LOG_ELS |
+						 LOG_CGN_MGMT,
 						 "6449 VEN RPA FDMI Success\n");
 				phba->link_flag &= ~LS_CT_VEN_RPA;
 				break;
 			}
 
+			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+					"6210 Issue Vendor MI FDMI %x\n",
+					phba->sli4_hba.pc_sli4_params.mi_ver);
+
+			/* CGN is only for the physical port, no vports */
 			if (lpfc_fdmi_cmd(vport, ndlp, cmd,
 					  LPFC_FDMI_VENDOR_ATTR_mi) == 0)
 				phba->link_flag |= LS_CT_VEN_RPA;
 			lpfc_printf_log(phba, KERN_INFO,
 					LOG_DISCOVERY | LOG_ELS,
 					"6458 Send MI FDMI:%x Flag x%x\n",
-					phba->sli4_hba.pc_sli4_params.mi_value,
+					phba->sli4_hba.pc_sli4_params.mi_ver,
 					phba->link_flag);
 		} else {
 			lpfc_printf_log(phba, KERN_INFO,
@@ -3348,7 +3353,7 @@ lpfc_fdmi_vendor_attr_mi(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 256);
 	sprintf(mibrevision, "ELXE2EM:%04d",
-		phba->sli4_hba.pc_sli4_params.mi_value);
+		phba->sli4_hba.pc_sli4_params.mi_ver);
 	strncpy(ae->un.AttrString, &mibrevision[0], sizeof(ae->un.AttrString));
 	len = strnlen(ae->un.AttrString, sizeof(ae->un.AttrString));
 	len += (len & 3) ? (4 - (len & 3)) : 4;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 658b9c558237..fdc22e5d5fac 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3393,6 +3393,7 @@ struct lpfc_sli4_parameters {
 #define LPFC_SET_UE_RECOVERY		0x10
 #define LPFC_SET_MDS_DIAGS		0x12
 #define LPFC_SET_DUAL_DUMP		0x1e
+#define LPFC_SET_ENABLE_MI		0x21
 struct lpfc_mbx_set_feature {
 	struct mbox_header header;
 	uint32_t feature;
@@ -3416,6 +3417,12 @@ struct lpfc_mbx_set_feature {
 #define LPFC_DISABLE_DUAL_DUMP		0
 #define LPFC_ENABLE_DUAL_DUMP		1
 #define LPFC_QUERY_OP_DUAL_DUMP		2
+#define lpfc_mbx_set_feature_mi_SHIFT		0
+#define lpfc_mbx_set_feature_mi_MASK		0x0000ffff
+#define lpfc_mbx_set_feature_mi_WORD		word6
+#define lpfc_mbx_set_feature_milunq_SHIFT	16
+#define lpfc_mbx_set_feature_milunq_MASK	0x0000ffff
+#define lpfc_mbx_set_feature_milunq_WORD	word6
 	uint32_t word7;
 #define lpfc_mbx_set_feature_UERP_SHIFT 0
 #define lpfc_mbx_set_feature_UERP_MASK  0x0000ffff
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2c0aaa0a301d..6e75471525eb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12350,21 +12350,6 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->nsler = 0;
 
-	/* Save PB info for use during HBA setup */
-	sli4_params->mi_ver = bf_get(cfg_mi_ver, mbx_sli4_parameters);
-	sli4_params->mib_bde_cnt = bf_get(cfg_mib_bde_cnt, mbx_sli4_parameters);
-	sli4_params->mib_size = mbx_sli4_parameters->mib_size;
-	sli4_params->mi_value = LPFC_DFLT_MIB_VAL;
-
-	/* Next we check for Vendor MIB support */
-	if (sli4_params->mi_ver && phba->cfg_enable_mi)
-		phba->cfg_fdmi_on = LPFC_FDMI_SUPPORT;
-
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"6461 MIB attr %d  enable %d  FDMI %d buf %d:%d\n",
-			sli4_params->mi_ver, phba->cfg_enable_mi,
-			sli4_params->mi_value, sli4_params->mib_bde_cnt,
-			sli4_params->mib_size);
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 5660a8729462..d719a16c0f96 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -44,6 +44,9 @@
 #define LOG_NVME_DISC   0x00200000      /* NVME Discovery/Connect events. */
 #define LOG_NVME_ABTS   0x00400000      /* NVME ABTS events. */
 #define LOG_NVME_IOERR  0x00800000      /* NVME IO Error events. */
+#define LOG_RSVD1	0x01000000	/* Reserved */
+#define LOG_RSVD2	0x02000000	/* Reserved */
+#define LOG_CGN_MGMT    0x04000000	/* Congestion Mgmt events */
 #define LOG_TRACE_EVENT 0x80000000	/* Dmp the DBG log on this err */
 #define LOG_ALL_MSG	0x7fffffff	/* LOG all messages */
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9ff4abb966af..5489cc7d06d5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6447,6 +6447,14 @@ lpfc_set_features(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
 		mbox->u.mqe.un.set_feature.feature = LPFC_SET_DUAL_DUMP;
 		mbox->u.mqe.un.set_feature.param_len = 4;
 		break;
+	case LPFC_SET_ENABLE_MI:
+		mbox->u.mqe.un.set_feature.feature = LPFC_SET_ENABLE_MI;
+		mbox->u.mqe.un.set_feature.param_len = 4;
+		bf_set(lpfc_mbx_set_feature_milunq, &mbox->u.mqe.un.set_feature,
+		       phba->pport->cfg_lun_queue_depth);
+		bf_set(lpfc_mbx_set_feature_mi, &mbox->u.mqe.un.set_feature,
+		       phba->sli4_hba.pc_sli4_params.mi_ver);
+		break;
 	}
 
 	return;
@@ -7499,6 +7507,99 @@ static void lpfc_sli4_dip(struct lpfc_hba *phba)
 	}
 }
 
+/**
+ * lpfc_cmf_setup - Initialize idle_stat tracking
+ * @phba: Pointer to HBA context object.
+ *
+ * This is called from HBA setup during driver load or when the HBA
+ * comes online. this does all the initialization to support CMF and MI.
+ **/
+static int
+lpfc_cmf_setup(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mqe *mqe;
+	struct lpfc_pc_sli4_params *sli4_params;
+	struct lpfc_sli4_parameters *mbx_sli4_parameters;
+	int length;
+	int rc, mi_ver;
+
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+	mqe = &mboxq->u.mqe;
+
+	/* Read the port's SLI4 Config Parameters */
+	length = (sizeof(struct lpfc_mbx_get_sli4_parameters) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS,
+			 length, LPFC_SLI4_MBX_EMBED);
+
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (unlikely(rc)) {
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return rc;
+	}
+
+	/* Gather info on MI support */
+	sli4_params = &phba->sli4_hba.pc_sli4_params;
+	mbx_sli4_parameters = &mqe->un.get_sli4_parameters.sli4_parameters;
+	sli4_params->mi_ver = bf_get(cfg_mi_ver, mbx_sli4_parameters);
+
+	/* Are we forcing MI off via module parameter? */
+	if (!phba->cfg_enable_mi)
+		sli4_params->mi_ver = 0;
+
+	/* Always try to enable MI feature if we can */
+	if (sli4_params->mi_ver) {
+		lpfc_set_features(phba, mboxq, LPFC_SET_ENABLE_MI);
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		mi_ver = bf_get(lpfc_mbx_set_feature_mi,
+				 &mboxq->u.mqe.un.set_feature);
+
+		if (rc == MBX_SUCCESS) {
+			if (mi_ver) {
+				lpfc_printf_log(phba,
+						KERN_WARNING, LOG_CGN_MGMT,
+						"6215 MI is enabled\n");
+				sli4_params->mi_ver = mi_ver;
+			} else {
+				lpfc_printf_log(phba,
+						KERN_WARNING, LOG_CGN_MGMT,
+						"6338 MI is disabled\n");
+				sli4_params->mi_ver = 0;
+			}
+		} else {
+			/* mi_ver is already set from GET_SLI4_PARAMETERS */
+			lpfc_printf_log(phba, KERN_INFO,
+					LOG_CGN_MGMT | LOG_INIT,
+					"6245 Enable MI Mailbox x%x (x%x/x%x) "
+					"failed, rc:x%x mi:x%x\n",
+					bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+					lpfc_sli_config_mbox_subsys_get
+						(phba, mboxq),
+					lpfc_sli_config_mbox_opcode_get
+						(phba, mboxq),
+					rc, sli4_params->mi_ver);
+		}
+	} else {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT,
+				"6217 MI is disabled\n");
+	}
+
+	/* Ensure FDMI is enabled for MI if enable_mi is set */
+	if (sli4_params->mi_ver)
+		phba->cfg_fdmi_on = LPFC_FDMI_SUPPORT;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"6470 Setup MI version %d\n",
+			sli4_params->mi_ver);
+
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return 0;
+}
+
 static int
 lpfc_set_host_tm(struct lpfc_hba *phba)
 {
@@ -7637,6 +7738,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
 			"6468 Set host date / time: Status x%x:\n", rc);
 
+	lpfc_cmf_setup(phba);
+
 	/*
 	 * Continue initialization with default values even if driver failed
 	 * to read FCoE param config regions, only read parameters if the
-- 
2.26.2

