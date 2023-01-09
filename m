Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D339FC54EBE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbjAIXWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbjAIXWo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:44 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F3E959C
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:43 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v23so10427328pju.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7LlczTDnkakB3pGpUedpd+T6vtbUtrg+IgV8/eDmjY=;
        b=mkdOhJuVvIw/SuETm1m3RemGFCwvottlg3bF6g3dF/7T0WkdaCTO+1SfslE0p/Y7Lh
         UjLHHcn3stsFoxARCF06Y3tAZm9Er/iH3CvEt2g74DKyRLE08OiNnnjngEiqmquf/js4
         XdSUzG8CfsrsaCigZiXSuIthsaZEhjaSD4ZF6SetOBwrZlnx50f6Od/xjRUvaGvo+sL7
         CeAJzktPIfuHGHXK4cZ6/AgKQqk3Lf0TtFuS55E9BWvV3ZQE2Gaef2l0eS3a4IYQrFA2
         Iq3/ZQ92J8BkO/nclJ5mjjOhTOOR1BokaNbz2on+q3tn4I8sizr2AGGeexeZn1i2+RjN
         NAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7LlczTDnkakB3pGpUedpd+T6vtbUtrg+IgV8/eDmjY=;
        b=e4Qy8Q1DZu5l+haU5UHx6UWWXkILP4Z6VhYtzyJQ0iX+P4YY3SPv+SkaRokvmhDbcy
         nEvwDOAK7VqtEtSf3eb/aZeBCal1cbp2fEqII8750ZoTBfl3sMT/4mbfRRqkA8AglDGE
         JmI6eqSVXcNGGOm2p6lEnS8mntE8XIThA2oqLsl/tX+5ZHRLkG+ymcwXBGIkp6WmDwA/
         8vaZDPH7rVj+af7nmMbbHkSju3emJ4b3BqhkD5eM44AK2nbhvR9C+h8WZyEGkKWBGTy3
         X6M9a5ytjL9vwWUHDgXUVu7Ti7nqZ2HcSckas9JnnJ3sddMwNnengeBe4dFiecSQPUEA
         iLUA==
X-Gm-Message-State: AFqh2konSZNnGkeNlRxBrXozFuwjand7ffs27FxBSkVo80wXf8NLVM14
        YbqpkJBt2xrBCXcGbcWcRgfp2DA4uZY=
X-Google-Smtp-Source: AMrXdXsr5Oh1n2fKYmGerCEljFc+FmqcJ6h1++Cw+WPyuFcsX7wFNikQC7aFNWcqR2Onytrg6dzkmA==
X-Received: by 2002:a17:902:e5c5:b0:189:c57c:9a19 with SMTP id u5-20020a170902e5c500b00189c57c9a19mr90090502plf.58.1673306562726;
        Mon, 09 Jan 2023 15:22:42 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:42 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/12] lpfc: Resolve miscellaneous variable set but not used compiler warnings
Date:   Mon,  9 Jan 2023 15:33:08 -0800
Message-Id: <20230109233317.54737-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The local variables called curr_data are incremented, but not actually used
for anything so they are removed.

The return value of lpfc_sli4_poll_eq is not used anywhere and is not
called outside of lpfc_sli.c.  Thus, its declaration is removed from
lpfc_crtn.h  Also, lpfc_sli4_poll_eq's path argument is not used in the
routine so it is removed along with corresponding macros.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  2 --
 drivers/scsi/lpfc/lpfc_crtn.h |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c |  6 ++--
 drivers/scsi/lpfc/lpfc_sli.c  | 62 ++++++++++++++++-------------------
 4 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 9ad233b40a9e..1095595ca3a2 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1592,8 +1592,6 @@ struct lpfc_hba {
 	struct timer_list cpuhp_poll_timer;
 	struct list_head poll_list;	/* slowpath eq polling list */
 #define LPFC_POLL_HB	1		/* slowpath heartbeat */
-#define LPFC_POLL_FASTPATH	0	/* called from fastpath */
-#define LPFC_POLL_SLOWPATH	1	/* called from slowpath */
 
 	char os_host_name[MAXHOSTNAMELEN];
 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 8928f016d09e..6f63e0acf9dd 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -253,7 +253,6 @@ int lpfc_read_object(struct lpfc_hba *phba, char *s, uint32_t *datap,
 		     uint32_t len);
 
 void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba);
-int lpfc_sli4_poll_eq(struct lpfc_queue *q, uint8_t path);
 void lpfc_sli4_poll_hbtimer(struct timer_list *t);
 void lpfc_sli4_start_polling(struct lpfc_queue *q);
 void lpfc_sli4_stop_polling(struct lpfc_queue *q);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7a1563564df7..9b6580eb7ed6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1689,7 +1689,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	struct lpfc_pde6 *pde6 = NULL;
 	struct lpfc_pde7 *pde7 = NULL;
 	dma_addr_t dataphysaddr, protphysaddr;
-	unsigned short curr_data = 0, curr_prot = 0;
+	unsigned short curr_prot = 0;
 	unsigned int split_offset;
 	unsigned int protgroup_len, protgroup_offset = 0, protgroup_remainder;
 	unsigned int protgrp_blks, protgrp_bytes;
@@ -1858,7 +1858,6 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 			bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
 			num_bde++;
-			curr_data++;
 
 			if (split_offset)
 				break;
@@ -2119,7 +2118,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	struct scatterlist *sgpe = NULL; /* s/g prot entry */
 	struct sli4_sge_diseed *diseed = NULL;
 	dma_addr_t dataphysaddr, protphysaddr;
-	unsigned short curr_data = 0, curr_prot = 0;
+	unsigned short curr_prot = 0;
 	unsigned int split_offset;
 	unsigned int protgroup_len, protgroup_offset = 0, protgroup_remainder;
 	unsigned int protgrp_blks, protgrp_bytes;
@@ -2364,7 +2363,6 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 				dma_offset += dma_len;
 
 				num_sge++;
-				curr_data++;
 
 				if (split_offset) {
 					sgl++;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 182aaae60386..c21187c93a5f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11270,6 +11270,30 @@ lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 	}
 }
 
+inline void lpfc_sli4_poll_eq(struct lpfc_queue *eq)
+{
+	struct lpfc_hba *phba = eq->phba;
+
+	/*
+	 * Unlocking an irq is one of the entry point to check
+	 * for re-schedule, but we are good for io submission
+	 * path as midlayer does a get_cpu to glue us in. Flush
+	 * out the invalidate queue so we can see the updated
+	 * value for flag.
+	 */
+	smp_rmb();
+
+	if (READ_ONCE(eq->mode) == LPFC_EQ_POLL)
+		/* We will not likely get the completion for the caller
+		 * during this iteration but i guess that's fine.
+		 * Future io's coming on this eq should be able to
+		 * pick it up.  As for the case of single io's, they
+		 * will be handled through a sched from polling timer
+		 * function which is currently triggered every 1msec.
+		 */
+		lpfc_sli4_process_eq(phba, eq, LPFC_QUEUE_NOARM);
+}
+
 /**
  * lpfc_sli_issue_iocb - Wrapper function for __lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
@@ -11309,7 +11333,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
-		lpfc_sli4_poll_eq(eq, LPFC_POLL_FASTPATH);
+		lpfc_sli4_poll_eq(eq);
 	} else {
 		/* For now, SLI2/3 will still use hbalock */
 		spin_lock_irqsave(&phba->hbalock, iflags);
@@ -15625,12 +15649,11 @@ void lpfc_sli4_poll_hbtimer(struct timer_list *t)
 {
 	struct lpfc_hba *phba = from_timer(phba, t, cpuhp_poll_timer);
 	struct lpfc_queue *eq;
-	int i = 0;
 
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(eq, &phba->poll_list, _poll_list)
-		i += lpfc_sli4_poll_eq(eq, LPFC_POLL_SLOWPATH);
+		lpfc_sli4_poll_eq(eq);
 	if (!list_empty(&phba->poll_list))
 		mod_timer(&phba->cpuhp_poll_timer,
 			  jiffies + msecs_to_jiffies(LPFC_POLL_HB));
@@ -15638,33 +15661,6 @@ void lpfc_sli4_poll_hbtimer(struct timer_list *t)
 	rcu_read_unlock();
 }
 
-inline int lpfc_sli4_poll_eq(struct lpfc_queue *eq, uint8_t path)
-{
-	struct lpfc_hba *phba = eq->phba;
-	int i = 0;
-
-	/*
-	 * Unlocking an irq is one of the entry point to check
-	 * for re-schedule, but we are good for io submission
-	 * path as midlayer does a get_cpu to glue us in. Flush
-	 * out the invalidate queue so we can see the updated
-	 * value for flag.
-	 */
-	smp_rmb();
-
-	if (READ_ONCE(eq->mode) == LPFC_EQ_POLL)
-		/* We will not likely get the completion for the caller
-		 * during this iteration but i guess that's fine.
-		 * Future io's coming on this eq should be able to
-		 * pick it up.  As for the case of single io's, they
-		 * will be handled through a sched from polling timer
-		 * function which is currently triggered every 1msec.
-		 */
-		i = lpfc_sli4_process_eq(phba, eq, LPFC_QUEUE_NOARM);
-
-	return i;
-}
-
 static inline void lpfc_sli4_add_to_poll_list(struct lpfc_queue *eq)
 {
 	struct lpfc_hba *phba = eq->phba;
@@ -21276,7 +21272,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
-		lpfc_sli4_poll_eq(qp->hba_eq, LPFC_POLL_FASTPATH);
+		lpfc_sli4_poll_eq(qp->hba_eq);
 		return 0;
 	}
 
@@ -21298,7 +21294,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
-		lpfc_sli4_poll_eq(qp->hba_eq, LPFC_POLL_FASTPATH);
+		lpfc_sli4_poll_eq(qp->hba_eq);
 		return 0;
 	}
 
@@ -21328,7 +21324,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
-		lpfc_sli4_poll_eq(qp->hba_eq, LPFC_POLL_FASTPATH);
+		lpfc_sli4_poll_eq(qp->hba_eq);
 		return 0;
 	}
 	return WQE_ERROR;
-- 
2.38.0

