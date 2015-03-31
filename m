From: Daniel Kreling <kreling@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] ipr: Reset in task context
Date: Tue, 31 Mar 2015 10:45:13 -0300
Message-ID: <551AA4E9.4080601@linux.vnet.ibm.com>
References: <201503261623.t2QGNqZe002091@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:43280 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbbCaNpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 09:45:20 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <kreling@linux.vnet.ibm.com>;
	Tue, 31 Mar 2015 07:45:19 -0600
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 7C4596E804C
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 09:37:06 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2VDjGlt27262990
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 13:45:16 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2VDjFmg014513
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 09:45:16 -0400
In-Reply-To: <201503261623.t2QGNqZe002091@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

** Adding 'Reviewed-by' tag **

The pci_set_pcie_reset_state has changed semantics to not be callable
from interrupt context, so change ipr's usage of the API to comply with
this change by ensuring this occurs from a workqueue.

Signed-off-by: Brian King
Reviewed-by: Daniel Kreling
---

  drivers/scsi/ipr.c |   91=20
+++++++++++++++++++++++++++++++++++++----------------
  drivers/scsi/ipr.h |    2 +
  2 files changed, 67 insertions(+), 26 deletions(-)


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff -puN drivers/scsi/ipr.c~ipr_reset_task drivers/scsi/ipr.c

--- linux/drivers/scsi/ipr.c~ipr_reset_task	2015-03-26=20
11:14:39.103798589 -0500

+++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 11:14:39.113798523 -050=
0

@@ -8320,8 +8320,7 @@

static=B7int=B7ipr_reset_start_bist(struct=B7i
static=B7int=B7ipr_reset_slot_reset_done(struct=B7ipr_cmnd=B7*ipr_cmd)
{
=BB ENTER;
-=BB pci_set_pcie_reset_state(ipr_cmd->ioa_cfg->pdev,=B7pcie_deassert_r=
eset);
=BB ipr_cmd->job_step=B7=3D=B7ipr_reset_bist_done;
=BB ipr_reset_start_timer(ipr_cmd,=B7IPR_WAIT_FOR_BIST_TIMEOUT);
=BB LEAVE;

@@ -8328,2 +8327,2 @@

static=B7int=B7ipr_reset_slot_reset_done(str
}


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

-		}
-
+		ipr_free_irqs(ioa_cfg);
  		pci_disable_device(ioa_cfg->pdev);
  	}
  }
diff -puN drivers/scsi/ipr.h~ipr_reset_task drivers/scsi/ipr.h

--- linux/drivers/scsi/ipr.h~ipr_reset_task	2015-03-26=20
11:14:39.107798561 -0500

+++ linux-bjking1/drivers/scsi/ipr.h	2015-03-26 11:14:39.123798456 -050=
0

@@ -1540,4 +1540,5 @@

struct=B7ipr_ioa_cfg=B7{
=BB u8=B7saved_mode_page_len;
=BB struct=B7work_struct=B7work_q;
+=BB struct=B7workqueue_struct=B7*reset_work_q;

  /**
+ * ipr_reset_reset_work - Pulse a PCIe fundamental reset
+ * @work:	work struct
+ *
+ * Description: This pulses warm reset to a slot.
+ *
+ **/
+static void ipr_reset_reset_work(struct work_struct *work)
+{
+	struct ipr_cmnd *ipr_cmd =3D container_of(work, struct ipr_cmnd, work=
);
+	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
+	struct pci_dev *pdev =3D ioa_cfg->pdev;
+	unsigned long lock_flags =3D 0;
+
+	ENTER;
+	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
+	msleep(jiffies_to_msecs(IPR_PCI_RESET_TIMEOUT));
+	pci_set_pcie_reset_state(pdev, pcie_deassert_reset);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	if (ioa_cfg->reset_cmd =3D=3D ipr_cmd)
+		ipr_reset_ioa_job(ipr_cmd);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	LEAVE;
+}
+
+/**
   * ipr_reset_slot_reset - Reset the PCI slot of the adapter.
   * @ipr_cmd:	ipr command struct
   *
@@ -8339,12 +8364,11 @@ static int ipr_reset_slot_reset_done(str
  static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
  {
  	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
-	struct pci_dev *pdev =3D ioa_cfg->pdev;
  	ENTER;
-	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
+	INIT_WORK(&ipr_cmd->work, ipr_reset_reset_work);
+	queue_work(ioa_cfg->reset_work_q, &ipr_cmd->work);
  	ipr_cmd->job_step =3D ipr_reset_slot_reset_done;
-	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
  	LEAVE;
  	return IPR_RC_JOB_RETURN;
  }
@@ -9093,26 +9117,25 @@ static void ipr_free_mem(struct ipr_ioa_
  }
  /**
- * ipr_free_all_resources - Free all allocated resources for an adapte=
r.
- * @ipr_cmd:	ipr command struct
+ * ipr_free_irqs - Free all allocated IRQs for the adapter.
+ * @ioa_cfg:	ipr cfg struct
   *
- * This function frees all allocated resources for the
+ * This function frees all allocated IRQs for the
   * specified adapter.
   *
   * Return value:
   * 	none
   **/
-static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
+static void ipr_free_irqs(struct ipr_ioa_cfg *ioa_cfg)
  {
  	struct pci_dev *pdev =3D ioa_cfg->pdev;
-	ENTER;
  	if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSI ||
  	    ioa_cfg->intr_flag =3D=3D IPR_USE_MSIX) {
  		int i;
  		for (i =3D 0; i < ioa_cfg->nvectors; i++)
  			free_irq(ioa_cfg->vectors_info[i].vec,
-				&ioa_cfg->hrrq[i]);
+				 &ioa_cfg->hrrq[i]);
  	} else
  		free_irq(pdev->irq, &ioa_cfg->hrrq[0]);
@@ -9123,7 +9146,26 @@ static void ipr_free_all_resources(struc
  		pci_disable_msix(pdev);
  		ioa_cfg->intr_flag &=3D ~IPR_USE_MSIX;
  	}
+}
+
+/**
+ * ipr_free_all_resources - Free all allocated resources for an adapte=
r.
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function frees all allocated resources for the
+ * specified adapter.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
+{
+	struct pci_dev *pdev =3D ioa_cfg->pdev;
+	ENTER;
+	ipr_free_irqs(ioa_cfg);
+	if (ioa_cfg->reset_work_q)
+		destroy_workqueue(ioa_cfg->reset_work_q);
  	iounmap(ioa_cfg->hdw_dma_regs);
  	pci_release_regions(pdev);
  	ipr_free_mem(ioa_cfg);
@@ -9943,6 +9985,14 @@ static int ipr_probe_ioa(struct pci_dev
  	    (dev_id->device =3D=3D PCI_DEVICE_ID_IBM_OBSIDIAN_E &&=20
!ioa_cfg->revid)) {
  		ioa_cfg->needs_warm_reset =3D 1;
  		ioa_cfg->reset =3D ipr_reset_slot_reset;
+
+		ioa_cfg->reset_work_q =3D alloc_ordered_workqueue("ipr_reset_%d",
+								WQ_MEM_RECLAIM, host->host_no);
+
+		if (!ioa_cfg->reset_work_q) {
+			dev_err(&pdev->dev, "Couldn't register reset workqueue\n");
+			goto out_free_irq;
+		}
  	} else
  		ioa_cfg->reset =3D ipr_reset_start_bist;
@@ -9954,6 +10004,8 @@ static int ipr_probe_ioa(struct pci_dev
  out:
  	return rc;
+out_free_irq:
+	ipr_free_irqs(ioa_cfg);
  cleanup_nolog:
  	ipr_free_mem(ioa_cfg);
  out_msi_disable:
@@ -10034,6 +10086,8 @@ static void __ipr_remove(struct pci_dev
  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
  	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
  	flush_work(&ioa_cfg->work_q);
+	if (ioa_cfg->reset_work_q)
+		flush_workqueue(ioa_cfg->reset_work_q);
  	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
  	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
@@ -10179,22 +10233,7 @@ static void ipr_shutdown(struct pci_dev
  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
  	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
  	if (ipr_fast_reboot && system_state =3D=3D SYSTEM_RESTART &&=20
ioa_cfg->sis64) {
-		if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSI ||
-		    ioa_cfg->intr_flag =3D=3D IPR_USE_MSIX) {
-			int i;
-			for (i =3D 0; i < ioa_cfg->nvectors; i++)
-				free_irq(ioa_cfg->vectors_info[i].vec,
-					 &ioa_cfg->hrrq[i]);
-		}
-
-		if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSI) {
-			pci_disable_msi(ioa_cfg->pdev);
-			ioa_cfg->intr_flag &=3D ~IPR_USE_MSI;
-		} else if (ioa_cfg->intr_flag =3D=3D IPR_USE_MSIX) {
-			pci_disable_msix(ioa_cfg->pdev);
-			ioa_cfg->intr_flag &=3D ~IPR_USE_MSIX;
  	wait_queue_head_t reset_wait_q;
  	wait_queue_head_t msi_wait_q;
@@ -1591,6 +1592,7 @@ struct ipr_cmnd {
  	struct ata_queued_cmd *qc;
  	struct completion completion;
  	struct timer_list timer;
+	struct work_struct work;
  	void (*fast_done) (struct ipr_cmnd *);
  	void (*done) (struct ipr_cmnd *);
  	int (*job_step) (struct ipr_cmnd *);
_


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
