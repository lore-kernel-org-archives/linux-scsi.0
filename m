Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430D4C48BE5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 11:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2676260FE5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 11:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhFHLiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 07:38:25 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:43158 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231952AbhFHLiV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 07:38:21 -0400
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 782A63C15F;
        Tue,  8 Jun 2021 04:28:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 782A63C15F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1623151718;
        bh=g7xXFYGYw/A2NaL1oMe9RdX9vnMu0psPecoHKQUtLhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuA2vXfa0Vt3d6fbfA2Gj4Y+C44Mm2K0VZk7byE0JG1ROZdBlrDtAbU/1MHs9Xo5K
         Ca4S9tyClfo/RUDJQuz27TYYxL9dKHtJaG4/bCAElY56T3he9cQS1C377VMDe/VSK/
         2d+JgJdvt1TMBYeslUC1U/XTJWFXEc6qQdfsWrDs=
From:   Muneendra Kumar <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v11 13/13] lpfc: vmid: Introducing vmid in io path.
Date:   Tue,  8 Jun 2021 10:05:56 +0530
Message-Id: <20210608043556.274139-14-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210608043556.274139-1-muneendra.kumar@broadcom.com>
References: <20210608043556.274139-1-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

The patch introduces the vmid in the io path. It checks if the vmid is
enabled and if io belongs to a vm or not and acts accordingly. Other
supporing APIs are also included in the patch.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v11:
No change

v10:
Remove redundant code and function name correction

v9:
Added changes related to locking and new hashtable implementation

v8:
Added proper error codes
updated logic while handling vmid

v7:
No change

v6:
No change

v5:
No change

v4:
No change

v3:
Replaced blkcg_get_app_identifier with blkcg_get_fc_appid

v2:
Ported the patch on top of 5.10/scsi-queue
Added a fix for issuing QFPA command which was not included in the
last submit
---
 drivers/scsi/lpfc/lpfc_scsi.c | 174 ++++++++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 65637d85f9bb..1cf271bee126 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5296,6 +5296,160 @@ static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
 	}
 }
 
+/*
+ * lpfc_vmid_get_appid- get the vmid associated with the uuid
+ * @vport: The virtual port for which this call is being executed.
+ * @uuid: uuid associated with the VE
+ * @cmd: address of scsi cmmd descriptor
+ * @tag: VMID tag
+ * Returns status of the function
+ */
+static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
+			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag)
+{
+	struct lpfc_vmid *vmp = NULL;
+	int hash, len, rc, i;
+
+	/* check if QFPA is complete */
+	if (lpfc_vmid_is_type_priority_tag(vport) && !(vport->vmid_flag &
+	      LPFC_VMID_QFPA_CMPL)) {
+		vport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
+		return -EAGAIN;
+	}
+
+	/* search if the uuid has already been mapped to the vmid */
+	len = strlen(uuid);
+	hash = lpfc_vmid_hash_fn(uuid, len);
+
+	/* search for the VMID in the table */
+	read_lock(&vport->vmid_lock);
+	vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
+
+	/* if found, check if its already registered  */
+	if (vmp  && vmp->flag & LPFC_VMID_REGISTERED) {
+		read_unlock(&vport->vmid_lock);
+		lpfc_vmid_update_entry(vport, cmd, vmp, tag);
+		rc = 0;
+	} else if (vmp && (vmp->flag & LPFC_VMID_REQ_REGISTER ||
+			   vmp->flag & LPFC_VMID_DE_REGISTER)) {
+		/* else if register or dereg request has already been sent */
+		/* Hence vmid tag will not be added for this IO */
+		read_unlock(&vport->vmid_lock);
+		rc = -EBUSY;
+	} else {
+		/* The vmid was not found in the hashtable. At this point, */
+		/* drop the read lock first before proceeding further */
+		read_unlock(&vport->vmid_lock);
+		/* start the process to obtain one as per the */
+		/* type of the vmid indicated */
+		write_lock(&vport->vmid_lock);
+		vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
+
+		/* while the read lock was released, in case the entry was */
+		/* added by other context or is in process of being added */
+		if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
+			lpfc_vmid_update_entry(vport, cmd, vmp, tag);
+			write_unlock(&vport->vmid_lock);
+			return 0;
+		} else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
+			write_unlock(&vport->vmid_lock);
+			return -EBUSY;
+		}
+
+		/* else search and allocate a free slot in the hash table */
+		if (vport->cur_vmid_cnt < vport->max_vmid) {
+			for (i = 0; i < vport->max_vmid; i++) {
+				vmp = vport->vmid + i;
+				if (vmp->flag == LPFC_VMID_SLOT_FREE)
+					break;
+			}
+			if (i == vport->max_vmid)
+				vmp = NULL;
+		} else {
+			vmp = NULL;
+		}
+
+		if (!vmp) {
+			write_unlock(&vport->vmid_lock);
+			return -ENOMEM;
+		}
+
+		/* Add the vmid and register  */
+		lpfc_put_vmid_in_hashtable(vport, hash, vmp);
+		vmp->vmid_len = len;
+		memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
+		vmp->io_rd_cnt = 0;
+		vmp->io_wr_cnt = 0;
+		vmp->flag = LPFC_VMID_SLOT_USED;
+
+		vmp->delete_inactive =
+			vport->vmid_inactivity_timeout ? 1 : 0;
+
+		/* if type priority tag, get next available vmid */
+		if (lpfc_vmid_is_type_priority_tag(vport))
+			lpfc_vmid_assign_cs_ctl(vport, vmp);
+
+		/* allocate the per cpu variable for holding */
+		/* the last access time stamp only if vmid is enabled */
+		if (!vmp->last_io_time)
+			vmp->last_io_time = __alloc_percpu(sizeof(u64),
+							   __alignof__(struct
+							   lpfc_vmid));
+		if (!vmp->last_io_time) {
+			hash_del(&vmp->hnode);
+			vmp->flag = LPFC_VMID_SLOT_FREE;
+			write_unlock(&vport->vmid_lock);
+			return -EIO;
+		}
+
+		write_unlock(&vport->vmid_lock);
+
+		/* complete transaction with switch */
+		if (lpfc_vmid_is_type_priority_tag(vport))
+			rc = lpfc_vmid_uvem(vport, vmp, true);
+		else
+			rc = lpfc_vmid_cmd(vport, SLI_CTAS_RAPP_IDENT, vmp);
+		if (!rc) {
+			write_lock(&vport->vmid_lock);
+			vport->cur_vmid_cnt++;
+			vmp->flag |= LPFC_VMID_REQ_REGISTER;
+			write_unlock(&vport->vmid_lock);
+		} else {
+			write_lock(&vport->vmid_lock);
+			hash_del(&vmp->hnode);
+			vmp->flag = LPFC_VMID_SLOT_FREE;
+			free_percpu(vmp->last_io_time);
+			write_unlock(&vport->vmid_lock);
+			return -EIO;
+		}
+
+		/* finally, enable the idle timer once */
+		if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
+			mod_timer(&vport->phba->inactive_vmid_poll,
+				  jiffies +
+				  msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
+			vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
+		}
+	}
+	return rc;
+}
+
+/*
+ * lpfc_is_command_vm_io - get the uuid from blk cgroup
+ * @cmd:Pointer to scsi_cmnd data structure
+ * Returns uuid if present if not null
+ */
+static char *lpfc_is_command_vm_io(struct scsi_cmnd *cmd)
+{
+	char *uuid = NULL;
+
+	if (cmd->request) {
+		if (cmd->request->bio)
+			uuid = blkcg_get_fc_appid(cmd->request->bio);
+	}
+	return uuid;
+}
+
 /**
  * lpfc_queuecommand - scsi_host_template queuecommand entry point
  * @shost: kernel scsi host pointer.
@@ -5321,6 +5475,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	int err, idx;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0L;
+	u8 *uuid = NULL;
 
 	if (phba->ktime_on)
 		start = ktime_get_ns();
@@ -5448,6 +5603,25 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	}
 
 
+	/* check the necessary and sufficient condition to support VMID */
+	if (lpfc_is_vmid_enabled(phba) &&
+	    (ndlp->vmid_support ||
+	     phba->pport->vmid_priority_tagging ==
+	     LPFC_VMID_PRIO_TAG_ALL_TARGETS)) {
+		/* is the IO generated by a VM, get the associated virtual */
+		/* entity id */
+		uuid = lpfc_is_command_vm_io(cmnd);
+
+		if (uuid) {
+			err = lpfc_vmid_get_appid(vport, uuid, cmnd,
+				(union lpfc_vmid_io_tag *)
+					&lpfc_cmd->cur_iocbq.vmid_tag);
+			if (!err)
+				lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_VMID;
+		}
+	}
+
+	atomic_inc(&ndlp->cmd_pending);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
 		this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
-- 
2.26.2

