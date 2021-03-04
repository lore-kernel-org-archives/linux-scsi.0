Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C434C43142
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7927964F44
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbhCDM3i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:29:38 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:40556 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240624AbhCDM3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 07:29:05 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id EA5CD22584;
        Thu,  4 Mar 2021 04:19:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com EA5CD22584
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1614860397;
        bh=4GuaDJPfm/7HhVsRNduegcN28qbXm59vhAMEhpSMEOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBDXjUp+Qxv2cjVtiLRAvhAS3v6fRVw5dqZxbXoxg86xPP4zl53VRNfUz7UQDCCNn
         0OMRZ7TJ8YE6dRdKpACd1gxbNwyPGpBsjEKZcMvqm6NBuyq3sAOYMLhHL1ld2nM3+j
         0Z7MJuo4JEJmDuK3Ftj0CocrpJnfiMSBLwAuLuLA=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v8 04/16] lpfc: vmid: Add the datastructure for supporting VMID in lpfc
Date:   Thu,  4 Mar 2021 10:57:14 +0530
Message-Id: <1614835646-16217-5-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch adds the primary datastructures needed to implement VMID in lpfc
driver. It maintains the capability, current state, hash table for the
vmid/appid along with other information.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v8:
modify structure member to uniform data type naming scheme

v7:
No change

v6:
No change

v5:
No Change

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
Removed unused variable.
---
 drivers/scsi/lpfc/lpfc.h | 97 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 6ba5fa08c47a..dccebe3aae68 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -303,6 +303,63 @@ struct lpfc_stats {
 struct lpfc_hba;
 
 
+#define LPFC_VMID_TIMER   300	/* timer interval in seconds. */
+
+#define LPFC_MAX_VMID_SIZE      256
+#define LPFC_COMPRESS_VMID_SIZE 16
+
+union lpfc_vmid_io_tag {
+	u32 app_id;	/* App Id vmid */
+	u8 cs_ctl_vmid;	/* Priority tag vmid */
+};
+
+#define JIFFIES_PER_HR	(HZ * 60 * 60)
+
+struct lpfc_vmid {
+	u8 flag;
+#define LPFC_VMID_SLOT_FREE     0x0
+#define LPFC_VMID_SLOT_USED     0x1
+#define LPFC_VMID_REQ_REGISTER  0x2
+#define LPFC_VMID_REGISTERED    0x4
+#define LPFC_VMID_DE_REGISTER   0x8
+	char host_vmid[LPFC_MAX_VMID_SIZE];
+	union lpfc_vmid_io_tag un;
+	u64 io_rd_cnt;
+	u64 io_wr_cnt;
+	u8 vmid_len;
+	u8 delete_inactive; /* Delete if inactive flag 0 = no, 1 = yes */
+	u32 hash_index;
+	u64 __percpu *last_io_time;
+};
+
+#define lpfc_vmid_is_type_priority_tag(vport)\
+	(vport->vmid_priority_tagging ? 1 : 0)
+
+#define LPFC_VMID_HASH_SIZE     256
+#define LPFC_VMID_HASH_MASK     255
+#define LPFC_VMID_HASH_SHIFT    6
+
+struct lpfc_vmid_context {
+	struct lpfc_vmid *vmp;
+	struct lpfc_nodelist *nlp;
+	u8 instantiated;
+};
+
+struct lpfc_vmid_priority_range {
+	u8 low;
+	u8 high;
+	u8 qos;
+};
+
+struct lpfc_vmid_priority_info {
+	u32 num_descriptors;
+	struct lpfc_vmid_priority_range *vmid_range;
+};
+
+#define QFPA_EVEN_ONLY 0x01
+#define QFPA_ODD_ONLY  0x02
+#define QFPA_EVEN_ODD  0x03
+
 enum discovery_state {
 	LPFC_VPORT_UNKNOWN     =  0,    /* vport state is unknown */
 	LPFC_VPORT_FAILED      =  1,    /* vport has failed */
@@ -442,6 +499,9 @@ struct lpfc_vport {
 #define WORKER_RAMP_DOWN_QUEUE         0x800	/* hba: Decrease Q depth */
 #define WORKER_RAMP_UP_QUEUE           0x1000	/* hba: Increase Q depth */
 #define WORKER_SERVICE_TXQ             0x2000	/* hba: IOCBs on the txq */
+#define WORKER_CHECK_INACTIVE_VMID     0x4000	/* hba: check inactive vmids */
+#define WORKER_CHECK_VMID_ISSUE_QFPA   0x8000	/* vport: Check if qfpa need */
+						/* to issue */
 
 	struct timer_list els_tmofunc;
 	struct timer_list delayed_disc_tmo;
@@ -452,6 +512,8 @@ struct lpfc_vport {
 #define FC_LOADING		0x1	/* HBA in process of loading drvr */
 #define FC_UNLOADING		0x2	/* HBA in process of unloading drvr */
 #define FC_ALLOW_FDMI		0x4	/* port is ready for FDMI requests */
+#define FC_ALLOW_VMID		0x8	/* Allow VMID IO's */
+#define FC_DEREGISTER_ALL_APP_ID	0x10	/* Deregister all vmid's */
 	/* Vport Config Parameters */
 	uint32_t cfg_scan_down;
 	uint32_t cfg_lun_queue_depth;
@@ -470,9 +532,36 @@ struct lpfc_vport {
 	uint32_t cfg_tgt_queue_depth;
 	uint32_t cfg_first_burst_size;
 	uint32_t dev_loss_tmo_changed;
+	/* VMID parameters */
+	u8 lpfc_vmid_host_uuid[LPFC_COMPRESS_VMID_SIZE];
+	u32 max_vmid;	/* maximum VMIDs allowed per port */
+	u32 cur_vmid_cnt;	/* Current VMID count */
+#define LPFC_MIN_VMID	4
+#define LPFC_MAX_VMID	255
+	u32 vmid_inactivity_timeout;	/* Time after which the VMID */
+						/* deregisters from switch */
+	u32 vmid_priority_tagging;
+#define LPFC_VMID_PRIO_TAG_DISABLE	0 /* Disable */
+#define LPFC_VMID_PRIO_TAG_SUP_TARGETS	1 /* Allow supported targets only */
+#define LPFC_VMID_PRIO_TAG_ALL_TARGETS	2 /* Allow all targets */
+	unsigned long *vmid_priority_range;
+#define LPFC_VMID_MAX_PRIORITY_RANGE    256
+#define LPFC_VMID_PRIORITY_BITMAP_SIZE  32
+	u8 vmid_flag;
+#define LPFC_VMID_IN_USE		0x1
+#define LPFC_VMID_ISSUE_QFPA		0x2
+#define LPFC_VMID_QFPA_CMPL		0x4
+#define LPFC_VMID_QOS_ENABLED		0x8
+#define LPFC_VMID_TIMER_ENBLD		0x10
+	struct fc_qfpa_res *qfpa_res;
 
 	struct fc_vport *fc_vport;
 
+	struct lpfc_vmid *vmid;
+	struct lpfc_vmid *hash_table[LPFC_VMID_HASH_SIZE];
+	rwlock_t vmid_lock;
+	struct lpfc_vmid_priority_info vmid_priority;
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *debug_disc_trc;
 	struct dentry *debug_nodelist;
@@ -937,6 +1026,13 @@ struct lpfc_hba {
 	struct nvmet_fc_target_port *targetport;
 	lpfc_vpd_t vpd;		/* vital product data */
 
+	u32 cfg_max_vmid;	/* maximum VMIDs allowed per port */
+	u32 cfg_vmid_app_header;
+#define LPFC_VMID_APP_HEADER_DISABLE	0
+#define LPFC_VMID_APP_HEADER_ENABLE	1
+	u32 cfg_vmid_priority_tagging;
+	u32 cfg_vmid_inactivity_timeout;	/* Time after which the VMID */
+						/*  deregisters from switch */
 	struct pci_dev *pcidev;
 	struct list_head      work_list;
 	uint32_t              work_ha;      /* Host Attention Bits for WT */
@@ -1177,6 +1273,7 @@ struct lpfc_hba {
 	struct list_head ct_ev_waiters;
 	struct unsol_rcv_ct_ctx ct_ctx[LPFC_CT_CTX_MAX];
 	uint32_t ctx_idx;
+	struct timer_list inactive_vmid_poll;
 
 	/* RAS Support */
 	struct lpfc_ras_fwlog ras_fwlog;
-- 
2.26.2

