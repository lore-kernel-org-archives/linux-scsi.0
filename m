Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4844CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242989AbiE3XPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242837AbiE3XPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:41 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738C871A39
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:39 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id D2C0DC0AFB;
        Mon, 30 May 2022 23:15:38 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 575C4C09D0;
        Mon, 30 May 2022 23:15:38 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952538; a=rsa-sha256;
        cv=none;
        b=haO0+MFGNyrJZ3kTkW7KTWHnDbImGSf3xt7M3BHibejWEo+5/XyJG7M3vVHpvKzC8GHkw1
        9obefNgcySDMZByTbHS9AwB5/1JKaQUHkqlEKjeMLdPtgZoguKmrocO5cI6D3fFj7Afzdn
        1/NTV/uUeZEHFRlamVMI9pMApmPfX4ILiCZQumHRxxzEXksjFPAYqnHo7Svit4k0vfBn3e
        0AianFzJh4+9gFT8jTxL1ll83TjL/pNyTTZcdRG7/nhgR4v0D3nERSA625JM74sEy/5PUS
        Na+gLjJBazdenJ1FruDq8YKZHBYsk8SZGTloJ0Fygzw5B+Mvug3k74zVvv2h+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=uf6qf2HWvTld+HMpa8eqZZvyIZvxw3UdM3XxI24qYfg=;
        b=gHbjbF6Ry9VK03V0qaWT3+0N3i94SHxfUqf5lmTs7MkahhgaVuygPuUIty0/RfXA4hgQXy
        QR3zW/EPP+02s30CXHIcPQEF0w6M9+Le2fnmug0EG2uR7mIWZCC7SSzyVCWvWGleSV+lGp
        5adYt0jazPqFkg8masn4Y7nqv4he8KGonxUf3ovwPVMzHJaJ3uo5RhdqRufAqN7S4ywXUM
        E/bOe0Vvqtv2ZsuMexvgrZTaGYNLfYw5Mx1wWshe9SMPTIW3ZvBwDoqqP2exHutIBQPvLa
        SwRLH/D46lpzF058SsoQsKH1zU5tKrIn98MgbPeiAfDNhkTEWKHbdKhZcD0/KQ==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-n6vbx;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Imminent-Spot: 412687264a5ed69d_1653952538662_69224791
X-MC-Loop-Signature: 1653952538662:2015312500
X-MC-Ingress-Time: 1653952538661
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.116.106.119 (trex/6.7.1);
        Mon, 30 May 2022 23:15:38 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqY4zGsz4C;
        Mon, 30 May 2022 16:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952538;
        bh=uf6qf2HWvTld+HMpa8eqZZvyIZvxw3UdM3XxI24qYfg=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=gxOZAMwXm7bEfgwFx7ymqkBVNU2BNylFrN/m9CUZ+CA5rBr8kIF+P40ab9g7XF/Ia
         g+IzI7PBXWGqPLG6y8Fjz1EUXwXNC8vkYMxvYjsvdsXvgBCWk6mZq5v0pXmiET+XFf
         5/um80SaSN6jNTKgRUWegFqwi4X1o4iQOznhVd8yzzJ7Bt1Hw+YJtQEUB9ACS/i+ED
         V82pPJyF0WPU64QvSNDmL3ygqeeD0BAMn5gXNxoum6OAStx+4OjZOcE/gTOOJ6A6ur
         TXUqeAT9TnoQSgG8fb4dIOJaykVB9Nv2hdDnoMcZsiDjWXT997rdC2qGdqM8OC15RN
         AnFnqFkjnBB2A==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net
Subject: [PATCH 04/10] scsi/aic94xx: Replace the donelist tasklet with threaded irq
Date:   Mon, 30 May 2022 16:15:06 -0700
Message-Id: <20220530231512.9729-5-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tasklets have long been deprecated as being too heavy on the system
by running in irq context - and this is not a performance critical
path. If a higher priority process wants to run, it must wait for
the tasklet to finish before doing so. A more suitable equivalent
is to converted to threaded irq instead and deal with the processing
of donelist entries task context.

Also rename a lot of calls removing the 'tasklet' part, which
of course no longer applies.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c  | 23 ++------
 drivers/scsi/aic94xx/aic94xx_hwi.h  |  5 +-
 drivers/scsi/aic94xx/aic94xx_init.c |  5 +-
 drivers/scsi/aic94xx/aic94xx_scb.c  | 88 ++++++++---------------------
 drivers/scsi/aic94xx/aic94xx_task.c | 16 +++---
 drivers/scsi/aic94xx/aic94xx_tmf.c  | 40 ++++++-------
 6 files changed, 63 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 3dd110143471..562a59b03aa1 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -248,8 +248,6 @@ static void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List initialization ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long);
-
 static int asd_init_dl(struct asd_ha_struct *asd_ha)
 {
 	asd_ha->seq.actual_dl
@@ -261,8 +259,6 @@ static int asd_init_dl(struct asd_ha_struct *asd_ha)
 	asd_ha->seq.dl = asd_ha->seq.actual_dl->vaddr;
 	asd_ha->seq.dl_toggle = ASD_DEF_DL_TOGGLE;
 	asd_ha->seq.dl_next = 0;
-	tasklet_init(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler,
-		     (unsigned long) asd_ha);
 
 	return 0;
 }
@@ -711,7 +707,7 @@ static void asd_chip_reset(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List Routines ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long data)
+irqreturn_t asd_dl_handler(int irq, void *data)
 {
 	struct asd_ha_struct *asd_ha = (struct asd_ha_struct *) data;
 	struct asd_seq_data *seq = &asd_ha->seq;
@@ -741,26 +737,19 @@ static void asd_dl_tasklet_handler(unsigned long data)
 		seq->pending--;
 		spin_unlock_irqrestore(&seq->pend_q_lock, flags);
 	out:
-		ascb->tasklet_complete(ascb, dl);
+		ascb->complete(ascb, dl);
 
 	next_1:
 		seq->dl_next = (seq->dl_next + 1) & (ASD_DL_SIZE-1);
 		if (!seq->dl_next)
 			seq->dl_toggle ^= DL_TOGGLE_MASK;
 	}
+
+	return IRQ_HANDLED;
 }
 
 /* ---------- Interrupt Service Routines ---------- */
 
-/**
- * asd_process_donelist_isr -- schedule processing of done list entries
- * @asd_ha: pointer to host adapter structure
- */
-static void asd_process_donelist_isr(struct asd_ha_struct *asd_ha)
-{
-	tasklet_schedule(&asd_ha->seq.dl_tasklet);
-}
-
 /**
  * asd_com_sas_isr -- process device communication interrupt (COMINT)
  * @asd_ha: pointer to host adapter structure
@@ -1011,8 +1000,6 @@ irqreturn_t asd_hw_isr(int irq, void *dev_id)
 	asd_write_reg_dword(asd_ha, CHIMINT, chimint);
 	(void) asd_read_reg_dword(asd_ha, CHIMINT);
 
-	if (chimint & DLAVAIL)
-		asd_process_donelist_isr(asd_ha);
 	if (chimint & COMINT)
 		asd_com_sas_isr(asd_ha);
 	if (chimint & DEVINT)
@@ -1021,6 +1008,8 @@ irqreturn_t asd_hw_isr(int irq, void *dev_id)
 		asd_rbi_exsi_isr(asd_ha);
 	if (chimint & HOSTERR)
 		asd_hst_pcix_isr(asd_ha);
+	if (chimint & DLAVAIL)
+		return IRQ_WAKE_THREAD;
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 930e192b1cd4..e3a97b5cfab5 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -117,7 +117,7 @@ struct asd_ascb {
 	struct asd_dma_tok dma_scb;
 	struct asd_dma_tok *sg_arr;
 
-	void (*tasklet_complete)(struct asd_ascb *, struct done_list_struct *);
+	void (*complete)(struct asd_ascb *, struct done_list_struct *);
 	u8     uldd_timer:1;
 
 	/* internally generated command */
@@ -152,7 +152,6 @@ struct asd_seq_data {
 	void *tc_index_bitmap;
 	int   tc_index_bitmap_bits;
 
-	struct tasklet_struct dl_tasklet;
 	struct done_list_struct *dl; /* array of done list entries, equals */
 	struct asd_dma_tok *actual_dl; /* actual_dl->vaddr */
 	int    dl_toggle;
@@ -356,7 +355,7 @@ static inline void asd_ascb_free_list(struct asd_ascb *ascb_list)
 
 int  asd_init_hw(struct asd_ha_struct *asd_ha);
 irqreturn_t asd_hw_isr(int irq, void *dev_id);
-
+irqreturn_t asd_dl_handler(int irq, void *data);
 
 struct asd_ascb *asd_ascb_alloc_list(struct asd_ha_struct
 				     *asd_ha, int *num,
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 954d0c5ae2e2..b0c4af0e6479 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -790,8 +790,9 @@ static int asd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (use_msi)
 		pci_enable_msi(asd_ha->pcidev);
 
-	err = request_irq(asd_ha->pcidev->irq, asd_hw_isr, IRQF_SHARED,
-			  ASD_DRIVER_NAME, asd_ha);
+	err = request_threaded_irq(asd_ha->pcidev->irq, asd_hw_isr,
+				   asd_dl_handler, IRQF_SHARED,
+				   ASD_DRIVER_NAME, asd_ha);
 	if (err) {
 		asd_printk("couldn't get irq %d for %s\n",
 			   asd_ha->pcidev->irq, pci_name(asd_ha->pcidev));
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 68214a58b160..abe28d80892b 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -64,8 +64,8 @@ static void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
 		phy->sas_phy.oob_mode = SATA_OOB_MODE;
 }
 
-static void asd_phy_event_tasklet(struct asd_ascb *ascb,
-					 struct done_list_struct *dl)
+static void asd_phy_event(struct asd_ascb *ascb,
+			  struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	int phy_id = dl->status_block[0] & DL_PHY_MASK;
@@ -215,9 +215,9 @@ static void asd_deform_port(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
 }
 
-static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
-				    struct done_list_struct *dl,
-				    int edb_id, int phy_id)
+static void asd_bytes_dmaed(struct asd_ascb *ascb,
+			    struct done_list_struct *dl,
+			    int edb_id, int phy_id)
 {
 	unsigned long flags;
 	int edb_el = edb_id + ascb->edb_index;
@@ -237,9 +237,9 @@ static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
 	sas_notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
-static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
-				       struct done_list_struct *dl,
-				       int phy_id)
+static void asd_link_reset_err(struct asd_ascb *ascb,
+			       struct done_list_struct *dl,
+			       int phy_id)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
@@ -290,9 +290,9 @@ static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
 	;
 }
 
-static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
-				       struct done_list_struct *dl,
-				       int phy_id)
+static void asd_primitive_rcvd(struct asd_ascb *ascb,
+			       struct done_list_struct *dl,
+			       int phy_id)
 {
 	unsigned long flags;
 	struct sas_ha_struct *sas_ha = &ascb->ha->sas_ha;
@@ -361,7 +361,6 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
  *
  * After an EDB has been invalidated, if all EDBs in this ESCB have been
  * invalidated, the ESCB is posted back to the sequencer.
- * Context is tasklet/IRQ.
  */
 void asd_invalidate_edb(struct asd_ascb *ascb, int edb_id)
 {
@@ -396,8 +395,8 @@ void asd_invalidate_edb(struct asd_ascb *ascb, int edb_id)
 	}
 }
 
-static void escb_tasklet_complete(struct asd_ascb *ascb,
-				  struct done_list_struct *dl)
+static void escb_complete(struct asd_ascb *ascb,
+			  struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
@@ -546,21 +545,21 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 	switch (sb_opcode) {
 	case BYTES_DMAED:
 		ASD_DPRINTK("%s: phy%d: BYTES_DMAED\n", __func__, phy_id);
-		asd_bytes_dmaed_tasklet(ascb, dl, edb, phy_id);
+		asd_bytes_dmaed(ascb, dl, edb, phy_id);
 		break;
 	case PRIMITIVE_RECVD:
 		ASD_DPRINTK("%s: phy%d: PRIMITIVE_RECVD\n", __func__,
 			    phy_id);
-		asd_primitive_rcvd_tasklet(ascb, dl, phy_id);
+		asd_primitive_rcvd(ascb, dl, phy_id);
 		break;
 	case PHY_EVENT:
 		ASD_DPRINTK("%s: phy%d: PHY_EVENT\n", __func__, phy_id);
-		asd_phy_event_tasklet(ascb, dl);
+		asd_phy_event(ascb, dl);
 		break;
 	case LINK_RESET_ERROR:
 		ASD_DPRINTK("%s: phy%d: LINK_RESET_ERROR\n", __func__,
 			    phy_id);
-		asd_link_reset_err_tasklet(ascb, dl, phy_id);
+		asd_link_reset_err(ascb, dl, phy_id);
 		break;
 	case TIMER_EVENT:
 		ASD_DPRINTK("%s: phy%d: TIMER_EVENT, lost dw sync\n",
@@ -600,7 +599,7 @@ int asd_init_post_escbs(struct asd_ha_struct *asd_ha)
 	int i;
 
 	for (i = 0; i < seq->num_escbs; i++)
-		seq->escb_arr[i]->tasklet_complete = escb_tasklet_complete;
+		seq->escb_arr[i]->complete = escb_complete;
 
 	ASD_DPRINTK("posting %d escbs\n", i);
 	return asd_post_escb_list(asd_ha, seq->escb_arr[0], seq->num_escbs);
@@ -613,7 +612,7 @@ int asd_init_post_escbs(struct asd_ha_struct *asd_ha)
 			    | CURRENT_OOB_ERROR)
 
 /**
- * control_phy_tasklet_complete -- tasklet complete for CONTROL PHY ascb
+ * control_phy_complete -- complete for CONTROL PHY ascb
  * @ascb: pointer to an ascb
  * @dl: pointer to the done list entry
  *
@@ -623,8 +622,8 @@ int asd_init_post_escbs(struct asd_ha_struct *asd_ha)
  *  - if a device is connected to the LED, it is lit,
  *  - if no device is connected to the LED, is is dimmed (off).
  */
-static void control_phy_tasklet_complete(struct asd_ascb *ascb,
-					 struct done_list_struct *dl)
+static void control_phy_complete(struct asd_ascb *ascb,
+				 struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct scb *scb = ascb->scb;
@@ -758,10 +757,9 @@ static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
  *
  * This function builds a CONTROL PHY scb.  No allocation of any kind
  * is performed. @ascb is allocated with the list function.
- * The caller can override the ascb->tasklet_complete to point
+ * The caller can override the ascb->complete to point
  * to its own callback function.  It must call asd_ascb_free()
- * at its tasklet complete function.
- * See the default implementation.
+ * at its complete function. See the default implementation.
  */
 void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc)
 {
@@ -806,47 +804,9 @@ void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc)
 
 	control_phy->conn_handle = cpu_to_le16(0xFFFF);
 
-	ascb->tasklet_complete = control_phy_tasklet_complete;
+	ascb->complete = control_phy_complete;
 }
 
-/* ---------- INITIATE LINK ADM TASK ---------- */
-
-#if 0
-
-static void link_adm_tasklet_complete(struct asd_ascb *ascb,
-				      struct done_list_struct *dl)
-{
-	u8 opcode = dl->opcode;
-	struct initiate_link_adm *link_adm = &ascb->scb->link_adm;
-	u8 phy_id = link_adm->phy_id;
-
-	if (opcode != TC_NO_ERROR) {
-		asd_printk("phy%d: link adm task 0x%x completed with error "
-			   "0x%x\n", phy_id, link_adm->sub_func, opcode);
-	}
-	ASD_DPRINTK("phy%d: link adm task 0x%x: 0x%x\n",
-		    phy_id, link_adm->sub_func, opcode);
-
-	asd_ascb_free(ascb);
-}
-
-void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
-				      u8 subfunc)
-{
-	struct scb *scb = ascb->scb;
-	struct initiate_link_adm *link_adm = &scb->link_adm;
-
-	scb->header.opcode = INITIATE_LINK_ADM_TASK;
-
-	link_adm->phy_id = phy_id;
-	link_adm->sub_func = subfunc;
-	link_adm->conn_handle = cpu_to_le16(0xFFFF);
-
-	ascb->tasklet_complete = link_adm_tasklet_complete;
-}
-
-#endif  /*  0  */
-
 /* ---------- SCB timer ---------- */
 
 /**
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index ed119a3f6f2e..63e0a6db6683 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -135,10 +135,10 @@ static void asd_unmap_scatterlist(struct asd_ascb *ascb)
 			     task->num_scatter, task->data_dir);
 }
 
-/* ---------- Task complete tasklet ---------- */
+/* ---------- Task complete ---------- */
 
-static void asd_get_response_tasklet(struct asd_ascb *ascb,
-				     struct done_list_struct *dl)
+static void asd_get_response(struct asd_ascb *ascb,
+			     struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_task *task = ascb->uldd_task;
@@ -191,7 +191,7 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 	asd_invalidate_edb(escb, edb_id);
 }
 
-static void asd_task_tasklet_complete(struct asd_ascb *ascb,
+static void asd_task_complete(struct asd_ascb *ascb,
 				      struct done_list_struct *dl)
 {
 	struct sas_task *task = ascb->uldd_task;
@@ -221,7 +221,7 @@ static void asd_task_tasklet_complete(struct asd_ascb *ascb,
 	case TC_ATA_RESP:
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_PROTO_RESPONSE;
-		asd_get_response_tasklet(ascb, dl);
+		asd_get_response(ascb, dl);
 		break;
 	case TF_OPEN_REJECT:
 		ts->resp = SAS_TASK_UNDELIVERED;
@@ -394,7 +394,7 @@ static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
 			flags |= STP_AFFIL_POLICY;
 		scb->ata_task.flags = flags;
 	}
-	ascb->tasklet_complete = asd_task_tasklet_complete;
+	ascb->complete = asd_task_complete;
 
 	if (likely(!task->ata_task.device_control_reg_update))
 		res = asd_map_scatterlist(task, scb->ata_task.sg_element,
@@ -442,7 +442,7 @@ static int asd_build_smp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	scb->smp_task.conn_handle = cpu_to_le16((u16)
 						(unsigned long)dev->lldd_dev);
 
-	ascb->tasklet_complete = asd_task_tasklet_complete;
+	ascb->complete = asd_task_complete;
 
 	return 0;
 }
@@ -495,7 +495,7 @@ static int asd_build_ssp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	scb->ssp_task.data_dir = data_dir_flags[task->data_dir];
 	scb->ssp_task.retry_count = scb->ssp_task.retry_count;
 
-	ascb->tasklet_complete = asd_task_tasklet_complete;
+	ascb->complete = asd_task_complete;
 
 	res = asd_map_scatterlist(task, scb->ssp_task.sg_element, gfp_flags);
 
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 27d32b8c2987..00a148f73250 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -15,13 +15,13 @@
 /* ---------- Internal enqueue ---------- */
 
 static int asd_enqueue_internal(struct asd_ascb *ascb,
-		void (*tasklet_complete)(struct asd_ascb *,
-					 struct done_list_struct *),
+		void (*complete)(struct asd_ascb *,
+				struct done_list_struct *),
 				void (*timed_out)(struct timer_list *t))
 {
 	int res;
 
-	ascb->tasklet_complete = tasklet_complete;
+	ascb->complete = complete;
 	ascb->uldd_timer = 1;
 
 	ascb->timer.function = timed_out;
@@ -37,7 +37,7 @@ static int asd_enqueue_internal(struct asd_ascb *ascb,
 
 /* ---------- CLEAR NEXUS ---------- */
 
-struct tasklet_completion_status {
+struct completion_status {
 	int	dl_opcode;
 	int	tmf_state;
 	u8	tag_valid:1;
@@ -45,7 +45,7 @@ struct tasklet_completion_status {
 };
 
 #define DECLARE_TCS(tcs) \
-	struct tasklet_completion_status tcs = { \
+	struct completion_status tcs = { \
 		.dl_opcode = 0, \
 		.tmf_state = 0, \
 		.tag_valid = 0, \
@@ -53,10 +53,10 @@ struct tasklet_completion_status {
 	}
 
 
-static void asd_clear_nexus_tasklet_complete(struct asd_ascb *ascb,
-					     struct done_list_struct *dl)
+static void asd_clear_nexus_complete(struct asd_ascb *ascb,
+				     struct done_list_struct *dl)
 {
-	struct tasklet_completion_status *tcs = ascb->uldd_task;
+	struct completion_status *tcs = ascb->uldd_task;
 	ASD_DPRINTK("%s: here\n", __func__);
 	if (!del_timer(&ascb->timer)) {
 		ASD_DPRINTK("%s: couldn't delete timer\n", __func__);
@@ -71,7 +71,7 @@ static void asd_clear_nexus_tasklet_complete(struct asd_ascb *ascb,
 static void asd_clear_nexus_timedout(struct timer_list *t)
 {
 	struct asd_ascb *ascb = from_timer(ascb, t, timer);
-	struct tasklet_completion_status *tcs = ascb->uldd_task;
+	struct completion_status *tcs = ascb->uldd_task;
 
 	ASD_DPRINTK("%s: here\n", __func__);
 	tcs->dl_opcode = TMF_RESP_FUNC_FAILED;
@@ -98,7 +98,7 @@ static void asd_clear_nexus_timedout(struct timer_list *t)
 
 #define CLEAR_NEXUS_POST        \
 	ASD_DPRINTK("%s: POST\n", __func__); \
-	res = asd_enqueue_internal(ascb, asd_clear_nexus_tasklet_complete, \
+	res = asd_enqueue_internal(ascb, asd_clear_nexus_complete,	   \
 				   asd_clear_nexus_timedout);              \
 	if (res)                \
 		goto out_err;   \
@@ -245,14 +245,14 @@ static int asd_clear_nexus_index(struct sas_task *task)
 static void asd_tmf_timedout(struct timer_list *t)
 {
 	struct asd_ascb *ascb = from_timer(ascb, t, timer);
-	struct tasklet_completion_status *tcs = ascb->uldd_task;
+	struct completion_status *tcs = ascb->uldd_task;
 
 	ASD_DPRINTK("tmf timed out\n");
 	tcs->tmf_state = TMF_RESP_FUNC_FAILED;
 	complete(ascb->completion);
 }
 
-static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
+static int asd_get_tmf_resp(struct asd_ascb *ascb,
 				    struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
@@ -270,7 +270,7 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 	struct ssp_response_iu   *ru;
 	int res = TMF_RESP_FUNC_FAILED;
 
-	ASD_DPRINTK("tmf resp tasklet\n");
+	ASD_DPRINTK("tmf resp\n");
 
 	spin_lock_irqsave(&asd_ha->seq.tc_index_lock, flags);
 	escb = asd_tc_index_find(&asd_ha->seq,
@@ -298,21 +298,21 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 	return res;
 }
 
-static void asd_tmf_tasklet_complete(struct asd_ascb *ascb,
-				     struct done_list_struct *dl)
+static void asd_tmf_complete(struct asd_ascb *ascb,
+			     struct done_list_struct *dl)
 {
-	struct tasklet_completion_status *tcs;
+	struct completion_status *tcs;
 
 	if (!del_timer(&ascb->timer))
 		return;
 
 	tcs = ascb->uldd_task;
-	ASD_DPRINTK("tmf tasklet complete\n");
+	ASD_DPRINTK("tmf complete\n");
 
 	tcs->dl_opcode = dl->opcode;
 
 	if (dl->opcode == TC_SSP_RESP) {
-		tcs->tmf_state = asd_get_tmf_resp_tasklet(ascb, dl);
+		tcs->tmf_state = asd_get_tmf_resp(ascb, dl);
 		tcs->tag_valid = ascb->tag_valid;
 		tcs->tag = ascb->tag;
 	}
@@ -452,7 +452,7 @@ int asd_abort_task(struct sas_task *task)
 	scb->abort_task.index = cpu_to_le16((u16)tascb->tc_index);
 	scb->abort_task.itnl_to = cpu_to_le16(ITNL_TIMEOUT_CONST);
 
-	res = asd_enqueue_internal(ascb, asd_tmf_tasklet_complete,
+	res = asd_enqueue_internal(ascb, asd_tmf_complete,
 				   asd_tmf_timedout);
 	if (res)
 		goto out_free;
@@ -600,7 +600,7 @@ static int asd_initiate_ssp_tmf(struct domain_device *dev, u8 *lun,
 	if (tmf == TMF_QUERY_TASK)
 		scb->ssp_tmf.index = cpu_to_le16(index);
 
-	res = asd_enqueue_internal(ascb, asd_tmf_tasklet_complete,
+	res = asd_enqueue_internal(ascb, asd_tmf_complete,
 				   asd_tmf_timedout);
 	if (res)
 		goto out_err;
-- 
2.36.1

