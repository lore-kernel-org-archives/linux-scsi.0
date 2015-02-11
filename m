From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] lpfc: Use setup_timer
Date: Wed, 11 Feb 2015 15:10:51 +0530
Message-ID: <20150211094051.GA22913@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch introduces the use of function setup_timer.

This is done using Coccinelle and semantic patch used is
as follows:

@@
expression x,y,z;
@@

- init_timer (&x);
+ setup_timer (&x, y, z);
- x.function = y;
- x.data = z;

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 67 ++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0b2c53a..ca338ad 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3287,21 +3287,16 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	INIT_LIST_HEAD(&vport->rcv_buffer_list);
 	spin_lock_init(&vport->work_port_lock);
 
-	init_timer(&vport->fc_disctmo);
-	vport->fc_disctmo.function = lpfc_disc_timeout;
-	vport->fc_disctmo.data = (unsigned long)vport;
+	setup_timer(&vport->fc_disctmo, lpfc_disc_timeout,
+		    (unsigned long)vport);
 
-	init_timer(&vport->fc_fdmitmo);
-	vport->fc_fdmitmo.function = lpfc_fdmi_tmo;
-	vport->fc_fdmitmo.data = (unsigned long)vport;
+	setup_timer(&vport->fc_fdmitmo, lpfc_fdmi_tmo, (unsigned long)vport);
 
-	init_timer(&vport->els_tmofunc);
-	vport->els_tmofunc.function = lpfc_els_timeout;
-	vport->els_tmofunc.data = (unsigned long)vport;
+	setup_timer(&vport->els_tmofunc, lpfc_els_timeout,
+		    (unsigned long)vport);
 
-	init_timer(&vport->delayed_disc_tmo);
-	vport->delayed_disc_tmo.function = lpfc_delayed_disc_tmo;
-	vport->delayed_disc_tmo.data = (unsigned long)vport;
+	setup_timer(&vport->delayed_disc_tmo, lpfc_delayed_disc_tmo,
+		    (unsigned long)vport);
 
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
@@ -4832,27 +4827,19 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	 */
 
 	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
+	setup_timer(&phba->hb_tmofunc, lpfc_hb_timeout, (unsigned long)phba);
 
 	psli = &phba->sli;
 	/* MBOX heartbeat timer */
-	init_timer(&psli->mbox_tmo);
-	psli->mbox_tmo.function = lpfc_mbox_timeout;
-	psli->mbox_tmo.data = (unsigned long) phba;
+	setup_timer(&psli->mbox_tmo, lpfc_mbox_timeout, (unsigned long)phba);
 	/* FCP polling mode timer */
-	init_timer(&phba->fcp_poll_timer);
-	phba->fcp_poll_timer.function = lpfc_poll_timeout;
-	phba->fcp_poll_timer.data = (unsigned long) phba;
+	setup_timer(&phba->fcp_poll_timer, lpfc_poll_timeout,
+		    (unsigned long)phba);
 	/* Fabric block timer */
-	init_timer(&phba->fabric_block_timer);
-	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
-	phba->fabric_block_timer.data = (unsigned long) phba;
+	setup_timer(&phba->fabric_block_timer, lpfc_fabric_block_timeout,
+		    (unsigned long)phba);
 	/* EA polling mode timer */
-	init_timer(&phba->eratt_poll);
-	phba->eratt_poll.function = lpfc_poll_eratt;
-	phba->eratt_poll.data = (unsigned long) phba;
+	setup_timer(&phba->eratt_poll, lpfc_poll_eratt, (unsigned long)phba);
 
 	/* Host attention work mask setup */
 	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
@@ -5008,30 +4995,20 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 */
 
 	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
-	init_timer(&phba->rrq_tmr);
-	phba->rrq_tmr.function = lpfc_rrq_timeout;
-	phba->rrq_tmr.data = (unsigned long)phba;
+	setup_timer(&phba->hb_tmofunc, lpfc_hb_timeout, (unsigned long)phba);
+	setup_timer(&phba->rrq_tmr, lpfc_rrq_timeout, (unsigned long)phba);
 
 	psli = &phba->sli;
 	/* MBOX heartbeat timer */
-	init_timer(&psli->mbox_tmo);
-	psli->mbox_tmo.function = lpfc_mbox_timeout;
-	psli->mbox_tmo.data = (unsigned long) phba;
+	setup_timer(&psli->mbox_tmo, lpfc_mbox_timeout, (unsigned long)phba);
 	/* Fabric block timer */
-	init_timer(&phba->fabric_block_timer);
-	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
-	phba->fabric_block_timer.data = (unsigned long) phba;
+	setup_timer(&phba->fabric_block_timer, lpfc_fabric_block_timeout,
+		    (unsigned long)phba);
 	/* EA polling mode timer */
-	init_timer(&phba->eratt_poll);
-	phba->eratt_poll.function = lpfc_poll_eratt;
-	phba->eratt_poll.data = (unsigned long) phba;
+	setup_timer(&phba->eratt_poll, lpfc_poll_eratt, (unsigned long)phba);
 	/* FCF rediscover timer */
-	init_timer(&phba->fcf.redisc_wait);
-	phba->fcf.redisc_wait.function = lpfc_sli4_fcf_redisc_wait_tmo;
-	phba->fcf.redisc_wait.data = (unsigned long)phba;
+	setup_timer(&phba->fcf.redisc_wait, lpfc_sli4_fcf_redisc_wait_tmo,
+		    (unsigned long)phba);
 
 	/*
 	 * Control structure for handling external multi-buffer mailbox
-- 
1.9.1
