From: Stefan Fausser <kernel_tk@real-time-systems.com>
Subject: isci, INTx mode, race condition
Date: Wed, 19 Aug 2015 18:01:35 +0200
Message-ID: <55D4A85F.1080304@real-time-systems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040807030507020504090507"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, JBottomley@odin.com, linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040807030507020504090507
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear all,

attached are two patches for the "isci" module (CONFIG_SCSI_ISCI).

Both patches apply to the current Linux kernel, retrieved by GIT 
(4.2.0-rc7).

The first patch (init.patch) is for reproducing the problem with the 
"Intel(R) C600 SAS Controller" in INTx Mode, see below. The second patch 
(host.patch) is for fixing this problem.

The problem:

By applying the first patch "init.patch", the "Intel(R) C600 SAS 
Controller" (now abbreviated by SAS) generates level-triggered INTx 
Interrupts instead of (edge-triggered) MSI-X Interrupts.

In the ISR (isci_intx_isr), the controller determines if the interrupt 
is due to a normal operation (normal interrrupt) or an error. In the 
case of a normal interrupt, a tasklet is scheduled that should handle 
the normal interrupt. However, in the ISR, the interrupts are left 
unmasked and the SAS device may trigger the next interrupt after the ISR 
has left and before the tasklet has been scheduled.

Thus, with this patch "init.patch" and on my system (Intel C600 chipset 
series), the SAS device repeatedly level-triggers the interrupt and the 
tasklet to handle the interrupt never gets scheduled. This will result 
in a soft-lockup on the executing core.

In my investigations, the above described problem occurs in all Linux 
kernel version starting from 3.5 and up to to-day.

The fix:

By applying the second patch "host.patch", the interrupts are masked in 
the INTx ISR in case of a normal interrupt. Thus, the scheduler has 
enough time to schedule the handling tasklet. In the tasklet (see 
sci_controller_completion_handler), the interrupts are unmasked again.

Please let me know if you need any other information.

Kind Regards,

Stefan


--------------040807030507020504090507
Content-Type: text/x-patch;
 name="host.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="host.patch"

Signed-off-by: Stefan Fausser <info@real-time-systems.com>

--- linux/drivers/scsi/isci/host.c.orig	2015-08-19 15:23:28.000000000 +0200
+++ linux/drivers/scsi/isci/host.c	2015-08-19 16:08:30.000000000 +0200
@@ -612,6 +612,7 @@ irqreturn_t isci_intx_isr(int vec, void 
 
 	if (sci_controller_isr(ihost)) {
 		writel(SMU_ISR_COMPLETION, &ihost->smu_registers->interrupt_status);
+		writel(0xFF000000, &ihost->smu_registers->interrupt_mask);
 		tasklet_schedule(&ihost->completion_tasklet);
 		ret = IRQ_HANDLED;
 	} else if (sci_controller_error_isr(ihost)) {

--------------040807030507020504090507
Content-Type: text/x-patch;
 name="init.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="init.patch"

Signed-off-by: Stefan Fausser <info@real-time-systems.com>

--- linux/drivers/scsi/isci/init.c.orig	2015-08-19 15:23:36.000000000 +0200
+++ linux/drivers/scsi/isci/init.c	2015-08-19 15:47:47.000000000 +0200
@@ -345,6 +345,7 @@ static int isci_setup_interrupts(struct 
 	struct isci_host *ihost;
 	struct isci_pci_info *pci_info = to_pci_info(pdev);
 
+	goto intx;
 	/*
 	 *  Determine the number of vectors associated with this
 	 *  PCI function.

--------------040807030507020504090507--
