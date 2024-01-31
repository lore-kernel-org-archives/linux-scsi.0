Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC8D23B0
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660526; cv=none; b=tQUchL+HhwCAeaQXiJp1e1T5JsTQKF98Mh7iWbNW1BbkmEoPf56hR5vlzBeA5VPVT8PEbC/v3ds4jknkXJs/3cOd8VqOaFZL10omZpync03WUR6XawKlAaCXoMPhQhHomfSMXWwfhFe5iBxFJABRrcgknsBDPI3JDHOnZ114pX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660526; c=relaxed/simple;
	bh=4xr7WPicJN10pS9EQD4s6enA2nDgYY6ZpacHNfKvYFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=joq7dW0EvgKBBLakXi8hOlFRqC+f5ObJLjBqz4uzUsdvUWKVBLrof4M0IF5693m1SkwkSPiK8QkzrBErj3t5bzv0V2UxJfPi0fL38w2mI8/Z7/VzdatJbr3wgKq5M6w2U1fYH8GdutWpsDPFXAwPRnEsC+mRVo26cw2L5YfI5xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSmHejyD; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSmHejyD"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7d3216781c5so495122241.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660523; x=1707265323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r3iKVWNddEXClj3c75KKVn/Hi5mWlR2RBYFLzISj66k=;
        b=iSmHejyD/9GrkmRqkbxWPvPc6O+qIIpE/Q9dO/Fb3P4RTp3+xQZtx1KM7KIeUCPFrE
         8EjPKNPr2QwDwu8UYnVBIUUbdiPRMggDn/7qVf2jxm3Ubn/TzuR3ieH+5/eM+b0ZolN6
         E8n2wiwRRZTDpKms4nYlgwT/t6sIbyFvNRptltk9GyQSDKZzNqB/kPpvmoe2vkVULz1A
         uVB1zTLEUKhQWUdcCuc9Wrb2i5L5O6RjSrbALyJZG41Fx8mEhrt1cf0TdMbeohA4UIZq
         vBDymqDe1822XtwvyXgCWsDhcNotcgdF9n7wa/+FoUg03MN1azI5k31S/iDvfi6QK119
         D8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660523; x=1707265323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r3iKVWNddEXClj3c75KKVn/Hi5mWlR2RBYFLzISj66k=;
        b=hXLRdEOIEE3h82Ekq8JTtMcr1jVZ98qsd8dWsr4Mei6IHU5p4Suwk0MJm1PV6pCmWb
         uz4YZQapu1yJ7scWwPkxV/ipuv9XxYcQTVF1B/ubw/HKR5wS5EYKInu7dtUoSkMFhjUy
         jHLFaBepuWQTmYVIXt1IXDyvNDIuAGp4SZxgIMoa9YWywZj8UIbdNMYP26Kh6jBb7B5P
         /ckl6bSxwd6Dz8P23jAtIxkIhTGHgLMLBITpd9XAZP52of7jI4sJybudKgc3doXNT0Wi
         wqiMRUDWB7pceogNmbfPLxRan1BSC5EPeUKrMgCOeAJ0Q7+MCfFHZ5RZkDsD/wUy0b1v
         AgLA==
X-Gm-Message-State: AOJu0Yz5dTBv1yURXYT46FcTpEscJ02GCY2l5gTpEY3PzRon/05U6Azq
	4V2TgICVP7s1bEQbJEiLyNqs1oyqiaRNTeLIpPfshX/seT6Wbjs4l6cN59vd
X-Google-Smtp-Source: AGHT+IHiMsFIcw8cpk10VjjWiKPFKgGDfDDgyIHBHtqPTrZNyHZzTlYopylGjLcf0gykwXkWmgxB2g==
X-Received: by 2002:a05:6102:54a9:b0:46c:a882:cd12 with SMTP id bk41-20020a05610254a900b0046ca882cd12mr979914vsb.3.1706660523450;
        Tue, 30 Jan 2024 16:22:03 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.22.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:22:03 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 13/17] lpfc: Protect vport fc_nodes list with an explicit spin lock
Date: Tue, 30 Jan 2024 16:35:45 -0800
Message-Id: <20240131003549.147784-14-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In attempt to reduce the amount of unnecessary shost_lock acquisitions in
the lpfc driver, replace shost_lock with an explicit fc_nodes_list_lock
spinlock when accessing vport->fc_nodes lists.  Although vport memory
region is owned by shost->hostdata, it is driver private memory and an
explicit fc_nodes list lock for fc_nodes list mutations is more appropriate
than locking the entire shost.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_attr.c    | 35 +++++++++++-----------
 drivers/scsi/lpfc/lpfc_ct.c      |  7 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c | 50 ++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_init.c    |  2 +-
 6 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8f3cac09a381..da9f87f89941 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -587,6 +587,7 @@ struct lpfc_vport {
 #define FC_CT_RPRT_DEFER	0x20	 /* Defer issuing FDMI RPRT */
 
 	struct list_head fc_nodes;
+	spinlock_t fc_nodes_list_lock; /* spinlock for fc_nodes list */
 
 	/* Keep counters for the number of entries in each list. */
 	atomic_t fc_plogi_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 142c90eb210f..023f4f2c62a6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -344,6 +344,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	struct lpfc_fc4_ctrl_stat *cstat;
 	uint64_t data1, data2, data3;
 	uint64_t totin, totout, tot;
+	unsigned long iflags;
 	char *statep;
 	int i;
 	int len = 0;
@@ -543,7 +544,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
 		goto buffer_done;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
@@ -617,7 +618,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
 			goto unlock_buf_done;
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 
 	if (!lport)
 		goto buffer_done;
@@ -681,7 +682,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	goto buffer_done;
 
  unlock_buf_done:
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 
  buffer_done:
 	len = strnlen(buf, PAGE_SIZE);
@@ -3765,15 +3766,14 @@ lpfc_nodev_tmo_init(struct lpfc_vport *vport, int val)
 static void
 lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 {
-	struct Scsi_Host  *shost;
 	struct lpfc_nodelist  *ndlp;
+	unsigned long iflags;
 #if (IS_ENABLED(CONFIG_NVME_FC))
 	struct lpfc_nvme_rport *rport;
 	struct nvme_fc_remote_port *remoteport = NULL;
 #endif
 
-	shost = lpfc_shost_from_vport(vport);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (ndlp->rport)
 			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
@@ -3788,7 +3788,7 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 						       vport->cfg_devloss_tmo);
 #endif
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 }
 
 /**
@@ -3974,8 +3974,8 @@ lpfc_vport_param_init(tgt_queue_depth, LPFC_MAX_TGT_QDEPTH,
 static int
 lpfc_tgt_queue_depth_set(struct lpfc_vport *vport, uint val)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
+	unsigned long iflags;
 
 	if (!lpfc_rangecheck(val, LPFC_MIN_TGT_QDEPTH, LPFC_MAX_TGT_QDEPTH))
 		return -EINVAL;
@@ -3983,14 +3983,13 @@ lpfc_tgt_queue_depth_set(struct lpfc_vport *vport, uint val)
 	if (val == vport->cfg_tgt_queue_depth)
 		return 0;
 
-	spin_lock_irq(shost->host_lock);
 	vport->cfg_tgt_queue_depth = val;
 
 	/* Next loop thru nodelist and change cmd_qdepth */
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp)
 		ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
-
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	return 0;
 }
 
@@ -5236,8 +5235,8 @@ lpfc_vport_param_show(max_scsicmpl_time);
 static int
 lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp, *next_ndlp;
+	unsigned long iflags;
 
 	if (val == vport->cfg_max_scsicmpl_time)
 		return 0;
@@ -5245,13 +5244,13 @@ lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
 		return -EINVAL;
 	vport->cfg_max_scsicmpl_time = val;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 		ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	return 0;
 }
 lpfc_vport_param_store(max_scsicmpl_time);
@@ -6853,17 +6852,19 @@ lpfc_get_node_by_target(struct scsi_target *starget)
 	struct Scsi_Host  *shost = dev_to_shost(starget->dev.parent);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_nodelist *ndlp;
+	unsigned long iflags;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	/* Search for this, mapped, target ID */
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
 		    starget->id == ndlp->nlp_sid) {
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irqrestore(&vport->fc_nodes_list_lock,
+					       iflags);
 			return ndlp;
 		}
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	return NULL;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 315db836404a..633b8ba25bc3 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1853,11 +1853,10 @@ static uint32_t
 lpfc_find_map_node(struct lpfc_vport *vport)
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
-	struct Scsi_Host  *shost;
+	unsigned long iflags;
 	uint32_t cnt = 0;
 
-	shost = lpfc_shost_from_vport(vport);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
 		if (ndlp->nlp_type & NLP_FABRIC)
 			continue;
@@ -1865,7 +1864,7 @@ lpfc_find_map_node(struct lpfc_vport *vport)
 		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE))
 			cnt++;
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	return cnt;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ea9b42225e62..03abc401c5f2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -806,10 +806,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 {
 	int len = 0;
 	int i, iocnt, outio, cnt;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 	unsigned char *statep;
+	unsigned long iflags;
 	struct nvme_fc_local_port *localport;
 	struct nvme_fc_remote_port *nrport = NULL;
 	struct lpfc_nvme_rport *rport;
@@ -818,7 +818,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	outio = 0;
 
 	len += scnprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		iocnt = 0;
 		if (!cnt) {
@@ -908,7 +908,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 					 ndlp->nlp_defer_did);
 		len +=  scnprintf(buf+len, size-len, "\n");
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 
 	len += scnprintf(buf + len, size - len,
 			"\nOutstanding IO x%x\n",  outio);
@@ -940,8 +940,6 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	if (!localport)
 		goto out_exit;
 
-	spin_lock_irq(shost->host_lock);
-
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
 		statep = "ONLINE";
@@ -953,6 +951,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 			localport->port_id, statep);
 
 	len += scnprintf(buf + len, size - len, "\tRport List:\n");
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		/* local short-hand pointer. */
 		spin_lock(&ndlp->lock);
@@ -1006,8 +1005,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		/* Terminate the string. */
 		len +=  scnprintf(buf + len, size - len, "\n");
 	}
-
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
  out_exit:
 	return len;
 }
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 7c4356d87730..08acd5d398aa 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4860,10 +4860,10 @@ void
 lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		   int state)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	int  old_state = ndlp->nlp_state;
 	int node_dropped = ndlp->nlp_flag & NLP_DROPPED;
 	char name1[16], name2[16];
+	unsigned long iflags;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 			 "0904 NPort state transition x%06x, %s -> %s\n",
@@ -4890,9 +4890,9 @@ lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 
 	if (list_empty(&ndlp->nlp_listp)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	} else if (old_state)
 		lpfc_nlp_counters(vport, old_state, -1);
 
@@ -4904,26 +4904,26 @@ lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 void
 lpfc_enqueue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	unsigned long iflags;
 
 	if (list_empty(&ndlp->nlp_listp)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	}
 }
 
 void
 lpfc_dequeue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	unsigned long iflags;
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
 		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 	list_del_init(&ndlp->nlp_listp);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
 				NLP_STE_UNUSED_NODE);
 }
@@ -5421,8 +5421,8 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phba)
 {
 	struct lpfc_vport **vports;
 	struct lpfc_nodelist *ndlp;
-	struct Scsi_Host *shost;
 	int i;
+	unsigned long iflags;
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (!vports) {
@@ -5431,17 +5431,18 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phba)
 		return;
 	}
 	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-		shost = lpfc_shost_from_vport(vports[i]);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irqsave(&vports[i]->fc_nodes_list_lock, iflags);
 		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
 			if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 				/* The mempool_alloc might sleep */
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock,
+						       iflags);
 				lpfc_unreg_rpi(vports[i], ndlp);
-				spin_lock_irq(shost->host_lock);
+				spin_lock_irqsave(&vports[i]->fc_nodes_list_lock,
+						  iflags);
 			}
 		}
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock, iflags);
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
 }
@@ -5683,12 +5684,11 @@ lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 struct lpfc_nodelist *
 lpfc_findnode_mapped(struct lpfc_vport *vport)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
 	uint32_t data1;
 	unsigned long iflags;
 
-	spin_lock_irqsave(shost->host_lock, iflags);
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
@@ -5697,7 +5697,8 @@ lpfc_findnode_mapped(struct lpfc_vport *vport)
 				 ((uint32_t)ndlp->nlp_xri << 16) |
 				 ((uint32_t)ndlp->nlp_type << 8) |
 				 ((uint32_t)ndlp->nlp_rpi & 0xff));
-			spin_unlock_irqrestore(shost->host_lock, iflags);
+			spin_unlock_irqrestore(&vport->fc_nodes_list_lock,
+					       iflags);
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE_VERBOSE,
 					 "2025 FIND node DID MAPPED "
 					 "Data: x%px x%x x%x x%x x%px\n",
@@ -5707,7 +5708,7 @@ lpfc_findnode_mapped(struct lpfc_vport *vport)
 			return ndlp;
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, iflags);
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
 
 	/* FIND node did <did> NOT FOUND */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
@@ -6742,7 +6743,7 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 	struct lpfc_vport **vports;
 	int i, ret = 0;
 	struct lpfc_nodelist *ndlp;
-	struct Scsi_Host  *shost;
+	unsigned long iflags;
 
 	vports = lpfc_create_vport_work_array(phba);
 
@@ -6751,8 +6752,6 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 		return 1;
 
 	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-		shost = lpfc_shost_from_vport(vports[i]);
-		spin_lock_irq(shost->host_lock);
 		/*
 		 * IF the CVL_RCVD bit is not set then we have sent the
 		 * flogi.
@@ -6760,15 +6759,16 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 		 * unreg the fcf.
 		 */
 		if (!(vports[i]->fc_flag & FC_VPORT_CVL_RCVD)) {
-			spin_unlock_irq(shost->host_lock);
 			ret =  1;
 			goto out;
 		}
+		spin_lock_irqsave(&vports[i]->fc_nodes_list_lock, iflags);
 		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
 			if (ndlp->rport &&
 			  (ndlp->rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
 				ret = 1;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock,
+						       iflags);
 				goto out;
 			} else if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 				ret = 1;
@@ -6780,7 +6780,7 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 						ndlp->nlp_flag);
 			}
 		}
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock, iflags);
 	}
 out:
 	lpfc_destroy_vport_work_array(phba, vports);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1285a7bbdced..c43118fab4aa 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3829,7 +3829,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 			vports[i]->fc_flag &= ~FC_VFI_REGISTERED;
 			spin_unlock_irq(shost->host_lock);
 
-			shost =	lpfc_shost_from_vport(vports[i]);
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
 						 nlp_listp) {
@@ -4833,6 +4832,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
+	spin_lock_init(&vport->fc_nodes_list_lock);
 	INIT_LIST_HEAD(&vport->rcv_buffer_list);
 	spin_lock_init(&vport->work_port_lock);
 
-- 
2.38.0

