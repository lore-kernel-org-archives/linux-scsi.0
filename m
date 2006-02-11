From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 09/15] libata: Improved ata_exec_internal timeout handling
Date: Sat, 11 Feb 2006 19:56:04 +0900
Message-ID: <20060211105604.GA27161@htj.dyndns.org>
References: <200602061542.k16FgYf0002182@d01av01.pok.ibm.com> <43E9D328.7020109@gmail.com> <43EA256B.5050000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.198]:17865 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751064AbWBKK4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 05:56:09 -0500
Received: by zproxy.gmail.com with SMTP id j2so600383nzf
        for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 02:56:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <43EA256B.5050000@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Feb 08, 2006 at 11:07:55AM -0600, Brian King wrote:
> Tejun Heo wrote:
> > brking@us.ibm.com wrote:
> >> Currently ata_exec_internal does very minimal cleanup if
> >> the executing command times out. This works for most usage
> >> scenarios, but can cause problems for hosts that set
> >> ATA_FLAG_PIO_DMA. For these users, the DMA buffer gets unmapped
> >> while the timed out out command is still active, which has
> >> the potential to cause PCI DMA errors if the command is
> >> still in progress. The following patch modifies ata_exec_internal
> >> to invoke eng_timeout on a timeout to allow for the timed out
> >> command to be cleaned up better before proceeding further.
> >> This patch is also in preparation for SAS attached SATA devices.
> >>
> > 
> > Hello, again.
> > 
> > ata_exec_internal() will be used during EH, so if you call error handler
> > from ata_exec_internal()....  In my pending EH patchset, there's a patch
> > to implement ->post_internal() callback which cleans up after an
> > internal command (successful or not).  Hopefully, it will be merged in
> > not too distant future.  Can ata_exec_internal() timeout handling wait
> > till then?
> 
> Do you have a pointer to this patchset? I did a quick search for
> post_internal on the archive and didn't find anything.
> 

Hello, Brian.

Sorry it took long.  Here's the patch against the current upstream.
I've just cut & pasted related part from my working tree and as
earlier bits of EH changes aren't in the upstream, the following patch
doesn't compile, let alone work.  But it should give enough idea about
->post_internal().

Thanks.

diff --git a/drivers/scsi/ahci.c b/drivers/scsi/ahci.c
index 81ba5f5..87ffd80 100644
--- a/drivers/scsi/ahci.c
+++ b/drivers/scsi/ahci.c
@@ -193,6 +193,7 @@ static irqreturn_t ahci_interrupt (int i
 static int ahci_probe_reset(struct ata_port *ap, unsigned int *classes);
 static void ahci_irq_clear(struct ata_port *ap);
 static void ahci_eng_timeout(struct ata_port *ap);
+static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
 static void ahci_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
@@ -235,6 +236,7 @@ static const struct ata_port_operations 
 	.qc_issue		= ahci_qc_issue,
 
 	.eng_timeout		= ahci_eng_timeout,
+	.post_internal_cmd	= ahci_post_internal_cmd,
 
 	.irq_handler		= ahci_interrupt,
 	.irq_clear		= ahci_irq_clear,
@@ -827,6 +829,20 @@ static void ahci_eng_timeout(struct ata_
 	ata_eh_qc_complete(qc);
 }
 
+static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ahci_port_priv *pp = qc->ap->private_data;
+
+	if (!qc->err_mask)
+		return;
+
+	if (qc->err_mask & AC_ERR_PSEUDO && pp->eh_irq_stat & PORT_IRQ_TF_ERR)
+		qc->err_mask |= AC_ERR_DEV;
+
+	ahci_stop_engine(qc->ap);
+	ahci_start_engine(qc->ap);
+}
+
 static inline int ahci_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 {
 	void __iomem *mmio = ap->host_set->mmio_base;
diff --git a/drivers/scsi/ata_piix.c b/drivers/scsi/ata_piix.c
index f312ea9..a81b38e 100644
--- a/drivers/scsi/ata_piix.c
+++ b/drivers/scsi/ata_piix.c
@@ -215,6 +215,7 @@ static const struct ata_port_operations 
 	.qc_issue		= ata_qc_issue_prot,
 
 	.eng_timeout		= ata_eng_timeout,
+	.post_internal_cmd	= ata_std_post_internal_cmd,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
diff --git a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
index f6511bd..53550fd 100644
--- a/drivers/scsi/libata-core.c
+++ b/drivers/scsi/libata-core.c
@@ -1214,6 +1214,9 @@ ata_exec_internal(struct ata_port *ap, s
 		spin_unlock_irqrestore(&ap->host_set->lock, flags);
 	}
 
+	if (qc->ap->ops->post_internal_cmd)
+		qc->ap->ops->post_internal_cmd(qc);
+
 	*tf = qc->tf;
 	err_mask = qc->err_mask;
 
@@ -5471,6 +5474,38 @@ int ata_ratelimit(void)
 	return rc;
 }
 
+/**
+ *	ata_std_post_internal_cmd - Clean up after an internal command
+ *	@qc: Internal command to clean up
+ *
+ *	Stock ->post_internal_cmd handler.  It's supposed to clean up
+ *	after an internal command which could have succeeded or not.
+ *	This function cleans up BMDMA status after a failed internal
+ *	command.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void ata_std_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	if (!qc->err_mask)
+		return;
+
+	ata_flush_pio_tasks(ap);
+
+	/* Stop DMA engine */
+	if (qc && (qc->tf.protocol == ATA_PROT_DMA ||
+		   qc->tf.protocol == ATA_PROT_ATAPI_DMA))
+		ap->ops->bmdma_stop(qc);
+
+	/* clear irq and ack bmdma irq events */
+	ata_altstatus(ap);
+	ata_chk_status(ap);
+	ap->ops->irq_clear(ap);
+}
+
 /*
  * libata is essentially a library of internal helper functions for
  * low-level ATA host controller drivers.  As such, the API/ABI is
@@ -5487,6 +5522,7 @@ EXPORT_SYMBOL_GPL(ata_sg_init_one);
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_issue_prot);
 EXPORT_SYMBOL_GPL(ata_eng_timeout);
+EXPORT_SYMBOL_GPL(ata_std_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_tf_load);
 EXPORT_SYMBOL_GPL(ata_tf_read);
 EXPORT_SYMBOL_GPL(ata_noop_dev_select);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index f4cd1eb..f0e6ba7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -439,6 +439,8 @@ struct ata_port_operations {
 
 	void (*eng_timeout) (struct ata_port *ap);
 
+	void (*post_internal_cmd) (struct ata_queued_cmd *qc);
+
 	irqreturn_t (*irq_handler)(int, void *, struct pt_regs *);
 	void (*irq_clear) (struct ata_port *);
 
@@ -553,6 +555,7 @@ extern u8   ata_bmdma_status(struct ata_
 extern void ata_bmdma_irq_clear(struct ata_port *ap);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eng_timeout(struct ata_port *ap);
+extern void ata_std_post_internal_cmd(struct ata_queued_cmd *qc);
 extern void ata_scsi_simulate(struct ata_port *ap, struct ata_device *dev,
 			      struct scsi_cmnd *cmd,
 			      void (*done)(struct scsi_cmnd *));
