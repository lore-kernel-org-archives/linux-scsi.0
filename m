Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A72C4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbjJaS7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbjJaS7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E707F1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc28719cb0so7299975ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778757; x=1699383557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bH5B+NVEOli7E5i13owgmpNxf+GKiAEfSKEwOkOdDIA=;
        b=UQaAAEacoSkoh8fFYJWoWDznWTfTkjtlXUeGc/4sfVoiPcEiOsYlBG7meJZM5IRzkS
         Mt+euOmxVSOvxOzInZBMQKW04YDhmPqp7GFFD0qM0i54t94ZnxTDL0bUbG9+TcbNLPl1
         nl9Tx46kj45R2LUvAr8arjfFlbjXkrmzRhoDfBt+M/yItG0QDn97LlULvM+NGkZDAQz/
         x/vkWNM+IXO17LQf9MBM15N5ZJe9tVTgl+wLXY47qwwmDI8qQKw+DNeY15q76LcsLgjD
         2qSVEugt/4fL1H99TrkVeV5L6jXGcvYBKGBzgnSmYmXFIj6loQNk2vU/mzo8Qyy6MLCF
         Fekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778757; x=1699383557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bH5B+NVEOli7E5i13owgmpNxf+GKiAEfSKEwOkOdDIA=;
        b=EzPSbKD1xbIc5LIWIC3+hh+8U/uVwzQdPODoziFyYQ6O0AmbsMbJinpoVQs4EqTtoS
         hIzHtd1lUL783MNAwm8wxhcz50zUWHlNAt3V5pX3g5rYfTd7X5wmmMIzDcAvtuUvEHKk
         4RS/5IFKHCuluynBiw+SnKUMmwqviLnkyreau0yrm3Z/oiGByNwATq1/cZwEclDioPoO
         AyP2vmW+zTdtHI2x8FElltnJ9IO3eHM2O8ATbIl2AbMyhvLJaiJJANuaMvYLNpXlI1AY
         Y49VnDfpWj3MVsQlAGOkjJ6mAuKumB2LLb/XqjPK11QTS7RmD4lcWIZci7Nz/azQFYdu
         4Aow==
X-Gm-Message-State: AOJu0YzRqbIH4cmoWP0mjn0THYrCFx2UU+DVHeWlcqZI8bSWJZN+Cbqf
        LOIhfmtYj/7xai5YVWuaXFj6WcVtdbE=
X-Google-Smtp-Source: AGHT+IEOBnDbJ6CEDZT2hdtNKn6Dn9FGthHfJ27mhRPHK2WOuumW+AK8uSA/qn5qj4wasPUNmDyBPg==
X-Received: by 2002:a17:902:f214:b0:1cc:27fa:1fb7 with SMTP id m20-20020a170902f21400b001cc27fa1fb7mr11602930plc.5.1698778757360;
        Tue, 31 Oct 2023 11:59:17 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:17 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/9] lpfc: Refactor and clean up mailbox command memory free
Date:   Tue, 31 Oct 2023 12:12:21 -0700
Message-Id: <20231031191224.150862-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A lot of repeated clean up code exists when freeing mailbox commands in
lpfc_mem_free_all.

Introduce a lpfc_mem_free_sli_mbox helper routine to refactor the
copy-paste code.  Additionally, reinitialize the mailbox command structure
context pointers to NULL in lpfc_sli4_mbox_cmd_free.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c |  4 +++-
 drivers/scsi/lpfc/lpfc_mem.c  | 45 ++++++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.c  |  6 +++++
 drivers/scsi/lpfc/lpfc_sli.h  |  8 ++++---
 4 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 0dfdc0c4c08c..b5ab44234f20 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1814,7 +1814,9 @@ lpfc_sli4_mbox_cmd_free(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 		dma_free_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
 				  mbox->sge_array->addr[sgentry], phyaddr);
 	}
-	/* Free the sge address array memory */
+	/* Reinitialize the context pointers to avoid stale usage. */
+	mbox->ctx_buf = NULL;
+	mbox->context3 = NULL;
 	kfree(mbox->sge_array);
 	/* Finally, free the mailbox command itself */
 	mempool_free(mbox, phba->mbox_mem_pool);
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 89cbeba06aea..ef6e5256a35e 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -48,6 +48,29 @@
 #define LPFC_RRQ_POOL_SIZE	256	/* max elements in non-DMA  pool */
 #define LPFC_MBX_POOL_SIZE	256	/* max elements in MBX non-DMA pool */
 
+/* lpfc_mbox_free_sli_mbox
+ *
+ * @phba: HBA to free memory for
+ * @mbox: mailbox command to free
+ *
+ * This routine detects the mbox type and calls the correct
+ * free routine to fully release all associated memory.
+ */
+static void
+lpfc_mem_free_sli_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
+{
+	/* Detect if the caller's mbox is an SLI4_CONFIG type.  If so, this
+	 * mailbox type requires a different cleanup routine.  Otherwise, the
+	 * mailbox is just an mbuf and mem_pool release.
+	 */
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    bf_get(lpfc_mqe_command, &mbox->u.mqe) == MBX_SLI4_CONFIG) {
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	} else {
+		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	}
+}
+
 int
 lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
 	size_t bytes;
@@ -288,27 +311,16 @@ lpfc_mem_free_all(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	LPFC_MBOXQ_t *mbox, *next_mbox;
-	struct lpfc_dmabuf   *mp;
 
 	/* Free memory used in mailbox queue back to mailbox memory pool */
 	list_for_each_entry_safe(mbox, next_mbox, &psli->mboxq, list) {
-		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
-		if (mp) {
-			lpfc_mbuf_free(phba, mp->virt, mp->phys);
-			kfree(mp);
-		}
 		list_del(&mbox->list);
-		mempool_free(mbox, phba->mbox_mem_pool);
+		lpfc_mem_free_sli_mbox(phba, mbox);
 	}
 	/* Free memory used in mailbox cmpl list back to mailbox memory pool */
 	list_for_each_entry_safe(mbox, next_mbox, &psli->mboxq_cmpl, list) {
-		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
-		if (mp) {
-			lpfc_mbuf_free(phba, mp->virt, mp->phys);
-			kfree(mp);
-		}
 		list_del(&mbox->list);
-		mempool_free(mbox, phba->mbox_mem_pool);
+		lpfc_mem_free_sli_mbox(phba, mbox);
 	}
 	/* Free the active mailbox command back to the mailbox memory pool */
 	spin_lock_irq(&phba->hbalock);
@@ -316,12 +328,7 @@ lpfc_mem_free_all(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 	if (psli->mbox_active) {
 		mbox = psli->mbox_active;
-		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
-		if (mp) {
-			lpfc_mbuf_free(phba, mp->virt, mp->phys);
-			kfree(mp);
-		}
-		mempool_free(mbox, phba->mbox_mem_pool);
+		lpfc_mem_free_sli_mbox(phba, mbox);
 		psli->mbox_active = NULL;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2cb327efd57d..bfbc23248692 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22170,6 +22170,12 @@ struct lpfc_io_buf *lpfc_get_io_buf(struct lpfc_hba *phba,
  * The data will be truncated if datasz is not large enough.
  * Version 1 is not supported with Embedded mbox cmd, so we must use version 0.
  * Returns the actual bytes read from the object.
+ *
+ * This routine is hard coded to use a poll completion.  Unlike other
+ * sli4_config mailboxes, it uses lpfc_mbuf memory which is not
+ * cleaned up in lpfc_sli4_cmd_mbox_free.  If this routine is modified
+ * to use interrupt-based completions, code is needed to fully cleanup
+ * the memory.
  */
 int
 lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index cd33dfec758c..14b8b5a3addf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -182,9 +182,11 @@ typedef struct lpfcMboxq {
 		struct lpfc_mqe mqe;
 	} u;
 	struct lpfc_vport *vport; /* virtual port pointer */
-	void *ctx_ndlp;		  /* caller ndlp information */
-	void *ctx_buf;		  /* caller buffer information */
-	void *context3;
+	void *ctx_ndlp;		  /* an lpfc_nodelist pointer */
+	void *ctx_buf;		  /* an lpfc_dmabuf pointer */
+	void *context3;           /* a generic pointer.  Code must
+				   * accommodate the actual datatype.
+				   */
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
 	uint8_t mbox_flag;
-- 
2.38.0

