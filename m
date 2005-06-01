From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 1/4] fusion - sas support
Date: Wed, 1 Jun 2005 10:47:30 -0600
Message-ID: <200506011047.30607.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iaenCzi9Jw7e+FK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52965 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261361AbVFAQus (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 12:50:48 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j51GlRo7007754
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:47:27 -0700 (PDT)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id j51GolOD005797
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:50:47 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_iaenCzi9Jw7e+FK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mptfusion patch 1/4:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.03/


Changelog:
* adding support for new module in Kconfig and Makefile
* adding mptsas.c module 

Signed-off-by: Eric.Moore<Eric.Moore@lsil.com>

--Boundary-00=_iaenCzi9Jw7e+FK
Content-Type: text/x-diff;
  charset="us-ascii";
  name="sas_upates1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sas_upates1.patch"

--- b/drivers/message/fusion/Kconfig	2005-05-10 15:01:27.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2005-05-11 13:09:30.000000000 -0600
@@ -35,6 +35,22 @@
 	  LSIFC929X
 	  LSIFC929XL
 
+config FUSION_SAS
+	tristate "Fusion MPT ScsiHost drivers for SAS"
+	depends on PCI && SCSI
+	select FUSION
+	---help---
+	  SCSI HOST support for a SAS host adapters.
+
+	  List of supported controllers:
+
+	  LSISAS1064
+	  LSISAS1066
+	  LSISAS1068
+	  LSISAS1064E
+	  LSISAS1066E
+	  LSISAS1068E
+
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
 	depends on FUSION
--- b/drivers/message/fusion/Makefile	2005-05-05 10:19:45.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2005-05-31 10:35:50.000000000 -0600
@@ -34,5 +34,6 @@
 
 obj-$(CONFIG_FUSION_SPI)	+= mptbase.o mptscsih.o mptspi.o
 obj-$(CONFIG_FUSION_FC)		+= mptbase.o mptscsih.o mptfc.o
+obj-$(CONFIG_FUSION_SAS)	+= mptbase.o mptscsih.o mptsas.o
 obj-$(CONFIG_FUSION_CTL)	+= mptctl.o
 obj-$(CONFIG_FUSION_LAN)	+= mptlan.o
--- b/drivers/message/fusion/mptsas.c	1969-12-31 17:00:00.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2005-06-01 10:03:45.000000000 -0600
@@ -0,0 +1,467 @@
+/*
+ *  linux/drivers/message/fusion/mptsas.c
+ *      For use with LSI Logic PCI chip/adapter(s)
+ *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *
+ *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  (mailto:mpt_linux_developer@lsil.com)
+ *
+ */
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 of the License.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    NO WARRANTY
+    THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+    CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+    LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+    solely responsible for determining the appropriateness of using and
+    distributing the Program and assumes all risks associated with its
+    exercise of rights under this Agreement, including but not limited to
+    the risks and costs of program errors, damage to or loss of data,
+    programs or equipment, and unavailability or interruption of operations.
+
+    DISCLAIMER OF LIABILITY
+    NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+    DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+    USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+    HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kdev_t.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>	/* for mdelay */
+#include <linux/interrupt.h>	/* needed for in_interrupt() proto */
+#include <linux/reboot.h>	/* notifier code */
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+
+#include "mptbase.h"
+#include "mptscsih.h"
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+#define my_NAME		"Fusion MPT SAS Host driver"
+#define my_VERSION	MPT_LINUX_VERSION_COMMON
+#define MYNAM		"mptsas"
+
+MODULE_AUTHOR(MODULEAUTHOR);
+MODULE_DESCRIPTION(my_NAME);
+MODULE_LICENSE("GPL");
+
+/* Command line args */
+static int mpt_pq_filter = 0;
+module_param(mpt_pq_filter, int, 0);
+MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
+
+static int mpt_pt_clear = 0;
+module_param(mpt_pt_clear, int, 0);
+MODULE_PARM_DESC(mpt_pt_clear, " Clear persistency table: enable=1  (default=MPTSCSIH_PT_CLEAR=0)");
+
+static int	mptsasDoneCtx = -1;
+static int	mptsasTaskCtx = -1;
+static int	mptsasInternalCtx = -1; /* Used only for internal commands */
+
+static struct device_attribute mptsas_queue_depth_attr = {
+	.attr = {
+		.name = 	"queue_depth",
+		.mode =		S_IWUSR,
+	},
+	.store = mptscsih_store_queue_depth,
+};
+
+static struct device_attribute *mptsas_dev_attrs[] = {
+	&mptsas_queue_depth_attr,
+	NULL,
+};
+
+/* Show the ioc state for this card */
+static ssize_t
+mptsas_show_iocstate(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(class_dev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+
+	return snprintf(buf, 8, "%u\n", (hd->ioc->last_state >> MPI_IOC_STATE_SHIFT));
+}
+
+/* Create sysfs 'iocnum' entry */
+static struct class_device_attribute mptsas_host_iocstate_attr = {
+        .attr = {
+                .name =         "iocstate",
+                .mode =         S_IRUSR,
+        },
+        .show = mptsas_show_iocstate
+};
+
+/* Host attributes initializer */
+static struct class_device_attribute *mptsas_host_attrs[] = {
+        &mptsas_host_iocstate_attr,
+        NULL,
+};
+
+static struct scsi_host_template mptsas_driver_template = {
+	.proc_name			= "mptsas",
+	.proc_info			= mptscsih_proc_info,
+	.name				= "MPT SPI Host",
+	.info				= mptscsih_info,
+	.queuecommand			= mptscsih_qcmd,
+	.slave_alloc			= mptscsih_slave_alloc,
+	.slave_configure		= mptscsih_slave_configure,
+	.slave_destroy			= mptscsih_slave_destroy,
+	.eh_abort_handler		= mptscsih_abort,
+	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_bus_reset_handler		= mptscsih_bus_reset,
+	.eh_host_reset_handler		= mptscsih_host_reset,
+	.bios_param			= mptscsih_bios_param,
+	.can_queue			= MPT_FC_CAN_QUEUE,
+	.this_id			= -1,
+	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
+	.max_sectors			= 8192,
+	.cmd_per_lun			= 7,
+	.use_clustering			= ENABLE_CLUSTERING,
+	.sdev_attrs			= mptsas_dev_attrs,
+	.shost_attrs			= mptsas_host_attrs,
+};
+
+
+/****************************************************************************
+ * Supported hardware
+ */
+
+static struct pci_device_id mptsas_pci_table[] = {
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1066,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1068,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064E,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1066E,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1068E,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{0}	/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, mptsas_pci_table);
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *	mptsas_probe - Installs scsi devices per bus.
+ *	@pdev: Pointer to pci_dev structure
+ *
+ *	Returns 0 for success, non-zero for failure.
+ *
+ */
+static int
+mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct Scsi_Host	*sh;
+	MPT_SCSI_HOST		*hd;
+	MPT_ADAPTER 		*ioc;
+	unsigned long		 flags;
+	int			 sz, ii;
+	int			 numSGE = 0;
+	int			 scale;
+	int			 ioc_cap;
+	u8			*mem;
+	int			error=0;
+	int			r;
+
+	if ((r = mpt_attach(pdev,id)) != 0)
+		return r;
+
+	ioc = pci_get_drvdata(pdev);
+	ioc->DoneCtx = mptsasDoneCtx;
+	ioc->TaskCtx = mptsasTaskCtx;
+	ioc->InternalCtx = mptsasInternalCtx;
+
+	/*  Added sanity check on readiness of the MPT adapter.
+	 */
+	if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
+		printk(MYIOC_s_WARN_FMT
+		  "Skipping because it's not operational!\n",
+		  ioc->name);
+		return -ENODEV;
+	}
+
+	if (!ioc->active) {
+		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",
+		  ioc->name);
+		return -ENODEV;
+	}
+
+	/*  Sanity check - ensure at least 1 port is INITIATOR capable
+	 */
+	ioc_cap = 0;
+	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
+		if (ioc->pfacts[ii].ProtocolFlags &
+		    MPI_PORTFACTS_PROTOCOL_INITIATOR)
+			ioc_cap ++;
+	}
+
+	if (!ioc_cap) {
+		printk(MYIOC_s_WARN_FMT
+			"Skipping ioc=%p because SCSI Initiator mode is NOT enabled!\n",
+			ioc->name, ioc);
+		return -ENODEV;
+	}
+
+	sh = scsi_host_alloc(&mptsas_driver_template, sizeof(MPT_SCSI_HOST));
+
+	if (!sh) {
+		printk(MYIOC_s_WARN_FMT
+			"Unable to register controller with SCSI subsystem\n",
+			ioc->name);
+                return -1;
+        }
+
+	spin_lock_irqsave(&ioc->FreeQlock, flags);
+
+	/* Attach the SCSI Host to the IOC structure
+	 */
+	ioc->sh = sh;
+
+	sh->io_port = 0;
+	sh->n_io_port = 0;
+	sh->irq = 0;
+
+	/* set 16 byte cdb's */
+	sh->max_cmd_len = 16;
+
+	sh->max_id = ioc->pfacts->MaxDevices + 1;
+
+	sh->max_lun = MPT_LAST_LUN + 1;
+	sh->max_channel = 0;
+	sh->this_id = ioc->pfacts[0].PortSCSIID;
+
+	/* Required entry.
+	 */
+	sh->unique_id = ioc->id;
+
+	/* Verify that we won't exceed the maximum
+	 * number of chain buffers
+	 * We can optimize:  ZZ = req_sz/sizeof(SGE)
+	 * For 32bit SGE's:
+	 *  numSGE = 1 + (ZZ-1)*(maxChain -1) + ZZ
+	 *               + (req_sz - 64)/sizeof(SGE)
+	 * A slightly different algorithm is required for
+	 * 64bit SGEs.
+	 */
+	scale = ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
+		numSGE = (scale - 1) *
+		  (ioc->facts.MaxChainDepth-1) + scale +
+		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +
+		  sizeof(u32));
+	} else {
+		numSGE = 1 + (scale - 1) *
+		  (ioc->facts.MaxChainDepth-1) + scale +
+		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +
+		  sizeof(u32));
+	}
+
+	if (numSGE < sh->sg_tablesize) {
+		/* Reset this value */
+		dprintk((MYIOC_s_INFO_FMT
+		  "Resetting sg_tablesize to %d from %d\n",
+		  ioc->name, numSGE, sh->sg_tablesize));
+		sh->sg_tablesize = numSGE;
+	}
+
+	/* Set the pci device pointer in Scsi_Host structure.
+	 */
+	scsi_set_device(sh, &ioc->pcidev->dev);
+
+	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+
+	hd = (MPT_SCSI_HOST *) sh->hostdata;
+	hd->ioc = ioc;
+
+	/* SCSI needs scsi_cmnd lookup table!
+	 * (with size equal to req_depth*PtrSz!)
+	 */
+	sz = ioc->req_depth * sizeof(void *);
+	mem = kmalloc(sz, GFP_ATOMIC);
+	if (mem == NULL) {
+		error = -ENOMEM;
+		goto mptsas_probe_failed;
+	}
+
+	memset(mem, 0, sz);
+	hd->ScsiLookup = (struct scsi_cmnd **) mem;
+
+	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=%d\n",
+		 ioc->name, hd->ScsiLookup, sz));
+
+	/* Allocate memory for the device structures.
+	 * A non-Null pointer at an offset
+	 * indicates a device exists.
+	 * max_id = 1 + maximum id (hosts.h)
+	 */
+	sz = sh->max_id * sizeof(void *);
+	mem = kmalloc(sz, GFP_ATOMIC);
+	if (mem == NULL) {
+		error = -ENOMEM;
+		goto mptsas_probe_failed;
+	}
+
+	memset(mem, 0, sz);
+	hd->Targets = (VirtDevice **) mem;
+
+	dprintk((KERN_INFO
+	  "  Targets @ %p, sz=%d\n", hd->Targets, sz));
+
+	/* Clear the TM flags
+	 */
+	hd->tmPending = 0;
+	hd->tmState = TM_STATE_NONE;
+	hd->resetPending = 0;
+	hd->abortSCpnt = NULL;
+
+	/* Clear the pointer used to store
+	 * single-threaded commands, i.e., those
+	 * issued during a bus scan, dv and
+	 * configuration pages.
+	 */
+	hd->cmdPtr = NULL;
+
+	/* Initialize this SCSI Hosts' timers
+	 * To use, set the timer expires field
+	 * and add_timer
+	 */
+	init_timer(&hd->timer);
+	hd->timer.data = (unsigned long) hd;
+	hd->timer.function = mptscsih_timer_expired;
+
+	hd->mpt_pq_filter = mpt_pq_filter;
+	ioc->sas_data.ptClear = mpt_pt_clear;
+
+	if(ioc->sas_data.ptClear==1) {
+		mptbase_sas_persist_operation(
+		    ioc, MPI_SAS_OP_CLEAR_ALL_PERSISTENT);
+	}
+
+	ddvprintk((MYIOC_s_INFO_FMT
+		"mpt_pq_filter %x mpt_pq_filter %x\n",
+		ioc->name,
+		mpt_pq_filter,
+		mpt_pq_filter));
+
+	init_waitqueue_head(&hd->scandv_waitq);
+	hd->scandv_wait_done = 0;
+	hd->last_queue_full = 0;
+
+	error = scsi_add_host (sh, &ioc->pcidev->dev);
+	if(error) {
+		dprintk((KERN_ERR MYNAM
+		  "scsi_add_host failed\n"));
+		goto mptsas_probe_failed;
+	}
+
+	scsi_scan_host(sh);
+	return 0;
+
+mptsas_probe_failed:
+
+	mptscsih_remove(pdev);
+	return error;
+}
+
+static struct pci_driver mptsas_driver = {
+	.name		= "mptsas",
+	.id_table	= mptsas_pci_table,
+	.probe		= mptsas_probe,
+	.remove		= __devexit_p(mptscsih_remove),
+	.driver         = {
+		.shutdown = mptscsih_shutdown,
+        },
+#ifdef CONFIG_PM
+	.suspend	= mptscsih_suspend,
+	.resume		= mptscsih_resume,
+#endif
+};
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptsas_init - Register MPT adapter(s) as SCSI host(s) with
+ *	linux scsi mid-layer.
+ *
+ *	Returns 0 for success, non-zero for failure.
+ */
+static int __init
+mptsas_init(void)
+{
+
+	show_mptmod_ver(my_NAME, my_VERSION);
+
+	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
+	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
+	mptsasInternalCtx = mpt_register(mptscsih_scandv_complete, MPTSPI_DRIVER);
+
+	if (mpt_event_register(mptsasDoneCtx, mptscsih_event_process) == 0) {
+		devtprintk((KERN_INFO MYNAM
+		  ": Registered for IOC event notifications\n"));
+	}
+
+	if (mpt_reset_register(mptsasDoneCtx, mptscsih_ioc_reset) == 0) {
+		dprintk((KERN_INFO MYNAM
+		  ": Registered for IOC reset notifications\n"));
+	}
+
+	return pci_register_driver(&mptsas_driver);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptsas_exit - Unregisters MPT adapter(s)
+ *
+ */
+static void __exit
+mptsas_exit(void)
+{
+	pci_unregister_driver(&mptsas_driver);
+
+	mpt_reset_deregister(mptsasDoneCtx);
+	dprintk((KERN_INFO MYNAM
+	  ": Deregistered for IOC reset notifications\n"));
+
+	mpt_event_deregister(mptsasDoneCtx);
+	dprintk((KERN_INFO MYNAM
+	  ": Deregistered for IOC event notifications\n"));
+
+	mpt_deregister(mptsasInternalCtx);
+	mpt_deregister(mptsasTaskCtx);
+	mpt_deregister(mptsasDoneCtx);
+}
+
+module_init(mptsas_init);
+module_exit(mptsas_exit);

--Boundary-00=_iaenCzi9Jw7e+FK--
