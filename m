From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Mon, 1 Oct 2007 14:12:47 -0600
Message-ID: <20071001201247.GN12049@parisc-linux.org>
References: <20070420204114.GL31947@austin.ibm.com>
	<20070420204720.GM31947@austin.ibm.com>
	<20070926150216.GH3899@parisc-linux.org>
	<20070927220022.GC18686@austin.ibm.com>
	<20070927221031.GY3899@parisc-linux.org>
	<20070927233437.GF18686@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20070927233437.GF18686@austin.ibm.com>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2007 at 06:34:37PM -0500, Linas Vepstas wrote:
> Good catch. But no ... and I had to study this a bit. Bear with me:

I agree with the analysis which I've now snipped.

> I think the race you describe above is harmless. The first time
> that sym_eh_handler() will run, it will be with SYM_EH_ABORT, 
> in it doesn't matter if we lose that, since the device is hosed
> anyway. At some later time, it will run with SYM_EH_DEVICE_RESET
> and then SYM_EH_BUS_RESET and then SYM_EH_HOST_RESET, and we won't 
> miss those, since, by now, sym2_io_error_detected() will have run.
> 
> So, by my reading, I'd say that init_completion() in
> sym2_io_error_detected() has to stay (although perhaps
> it should be replaced by the INIT_COMPLETION() macro.)
> Removing it will prevent correct operation on the second 
> and subsequent errors.

I think the fundamental problem is that completions aren't really
supposed to be used like this.  Here's one attempt at using completions
perhaps a little more the way they're supposed to be used, although now
I've written it, I wonder if we shouldn't just use a waitqueue instead.

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e8a4361..b425b89 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -602,6 +602,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
 	struct Scsi_Host *host = cmd->device->host;
+	struct pci_dev *pdev = np->s.device;
 	SYM_QUEHEAD *qp;
 	int cmd_queued = 0;
 	int sts = -1;
@@ -616,9 +617,19 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	 * point in hurrying; take a leisurely wait.
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
-	if (pci_channel_offline(np->s.device)) {
-		int finished_reset = wait_for_completion_timeout(
-			&np->s.io_reset_wait, WAIT_FOR_PCI_RECOVERY*HZ);
+	if (pci_channel_offline(pdev)) {
+		struct host_data *hostdata = shost_priv(host);
+		int finished_reset = 0;
+		init_completion(&eh_done);
+		spin_lock_irq(host->host_lock);
+		if (!hostdata->io_reset)
+			hostdata->io_reset = &eh_done;
+		if (!pci_channel_offline(pdev))
+			finished_reset = 1;
+		spin_unlock_irq(host->host_lock);
+		if (!finished_reset)
+			finished_reset = wait_for_completion_timeout(
+				hostdata->io_reset, WAIT_FOR_PCI_RECOVERY*HZ);
 		if (!finished_reset)
 			return SCSI_FAILED;
 	}
@@ -1396,7 +1407,6 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	np->maxoffs	= dev->chip.offset_max;
 	np->maxburst	= dev->chip.burst_max;
 	np->myaddr	= dev->host_id;
-	init_completion(&np->s.io_reset_wait);
 
 	/*
 	 *  Edit its name.
@@ -1842,15 +1852,12 @@ static void __devexit sym2_remove(struct pci_dev *pdev)
 static pci_ers_result_t sym2_io_error_detected(struct pci_dev *pdev,
                                          enum pci_channel_state state)
 {
-	struct sym_hcb *np = pci_get_drvdata(pdev);
-
 	/* If slot is permanently frozen, turn everything off */
 	if (state == pci_channel_io_perm_failure) {
 		sym2_remove(pdev);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	init_completion(&np->s.io_reset_wait);
 	disable_irq(pdev->irq);
 	pci_disable_device(pdev);
 
@@ -1912,7 +1919,7 @@ static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
 	          sym_name(np));
 
 	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR "%s: Unable to enable afer PCI reset\n",
+		printk(KERN_ERR "%s: Unable to enable after PCI reset\n",
 		        sym_name(np));
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
@@ -1953,7 +1960,14 @@ static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
 static void sym2_io_resume(struct pci_dev *pdev)
 {
 	struct sym_hcb *np = pci_get_drvdata(pdev);
-	complete_all(&np->s.io_reset_wait);
+	struct Scsi_Host *shost = np->s.host;
+	struct host_data *hostdata = shost_priv(shost);
+
+	spin_lock_irq(shost->host_lock);
+	if (hostdata->io_reset)
+		complete_all(hostdata->io_reset);
+	hostdata->io_reset = NULL;
+	spin_unlock_irq(shost->host_lock);
 }
 
 static void sym2_get_signalling(struct Scsi_Host *shost)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index a172cc5..b961f70 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -180,9 +180,6 @@ struct sym_shcb {
 	char		chip_name[8];
 	struct pci_dev	*device;
 
-	/* Waiter for clearing of frozen PCI bus */
-	struct completion io_reset_wait;
-
 	struct Scsi_Host *host;
 
 	void __iomem *	ioaddr;		/* MMIO kernel io address	*/
@@ -223,6 +220,7 @@ struct sym_device {
  */
 struct host_data {
 	struct sym_hcb *ncb;
+	struct completion *io_reset;		/* PCI error handling */
 };
 
 static inline struct sym_hcb * sym_get_hcb(struct Scsi_Host *host)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
