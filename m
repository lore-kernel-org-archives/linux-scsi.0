From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 7/7] mptfusion: mptfc Adding Stub Driver - Fiber Channel
Date: Wed, 20 Apr 2005 11:44:07 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C020C4364@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C545D0.8D024EE0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51417 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261774AbVDTRoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 13:44:16 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j3KHfD6U013283
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:41:13 -0700 (PDT)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j3KHiDin020906
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:44:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C545D0.8D024EE0
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 7/7:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.00/

Changelog:

(1) mptfc.c: This driver is having module_init, module_exit, and probe.
(2) mptfc.c: Registering for Fibre Channel pci ids are done from this
module.
(3) mptfc.c: Convert MODULE_PARM to module_param

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_000_01C545D0.8D024EE0
Content-Type: application/octet-stream;
	name="patch-7-mptfc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-7-mptfc.patch"

--- b/drivers/message/fusion/mptfc.c	1969-12-31 17:00:00.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptfc.c	2005-04-19 14:14:12.000000000 =
-0600=0A=
@@ -0,0 +1,428 @@=0A=
+/*=0A=
+ *  linux/drivers/message/fusion/mptfc.c=0A=
+ *      For use with LSI Logic PCI chip/adapter(s)=0A=
+ *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
+ *=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
+ *  (mailto:mpt_linux_developer@lsil.com)=0A=
+ *=0A=
+ */=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+    This program is free software; you can redistribute it and/or =
modify=0A=
+    it under the terms of the GNU General Public License as published =
by=0A=
+    the Free Software Foundation; version 2 of the License.=0A=
+=0A=
+    This program is distributed in the hope that it will be useful,=0A=
+    but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
+    GNU General Public License for more details.=0A=
+=0A=
+    NO WARRANTY=0A=
+    THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES =
OR=0A=
+    CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, =
WITHOUT=0A=
+    LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, =
NON-INFRINGEMENT,=0A=
+    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each =
Recipient is=0A=
+    solely responsible for determining the appropriateness of using =
and=0A=
+    distributing the Program and assumes all risks associated with =
its=0A=
+    exercise of rights under this Agreement, including but not limited =
to=0A=
+    the risks and costs of program errors, damage to or loss of =
data,=0A=
+    programs or equipment, and unavailability or interruption of =
operations.=0A=
+=0A=
+    DISCLAIMER OF LIABILITY=0A=
+    NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY =
FOR ANY=0A=
+    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+    DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER =
CAUSED AND=0A=
+    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, =
OR=0A=
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF =
THE=0A=
+    USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED=0A=
+    HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES=0A=
+=0A=
+    You should have received a copy of the GNU General Public =
License=0A=
+    along with this program; if not, write to the Free Software=0A=
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  =
02111-1307  USA=0A=
+*/=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+#include "linux_compat.h"	/* linux-2.6 tweaks */=0A=
+#include <linux/module.h>=0A=
+#include <linux/kernel.h>=0A=
+#include <linux/init.h>=0A=
+#include <linux/errno.h>=0A=
+#include <linux/kdev_t.h>=0A=
+#include <linux/blkdev.h>=0A=
+#include <linux/delay.h>	/* for mdelay */=0A=
+#include <linux/interrupt.h>	/* needed for in_interrupt() proto */=0A=
+#include <linux/reboot.h>	/* notifier code */=0A=
+#include <linux/sched.h>=0A=
+#include <linux/workqueue.h>=0A=
+=0A=
+#include <scsi/scsi.h>=0A=
+#include <scsi/scsi_cmnd.h>=0A=
+#include <scsi/scsi_device.h>=0A=
+#include <scsi/scsi_host.h>=0A=
+#include <scsi/scsi_tcq.h>=0A=
+=0A=
+#include "mptbase.h"=0A=
+#include "mptscsih.h"=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+#define my_NAME		"Fusion MPT FC Host driver"=0A=
+#define my_VERSION	MPT_LINUX_VERSION_COMMON=0A=
+#define MYNAM		"mptfc"=0A=
+=0A=
+MODULE_AUTHOR(MODULEAUTHOR);=0A=
+MODULE_DESCRIPTION(my_NAME);=0A=
+MODULE_LICENSE("GPL");=0A=
+=0A=
+/* Command line args */=0A=
+static int mpt_pq_filter =3D 0;=0A=
+module_param(mpt_pq_filter, int, 0);=0A=
+MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: =
enable=3D1  (default=3D0)");=0A=
+=0A=
+static int	mptfcDoneCtx =3D -1;=0A=
+static int	mptfcTaskCtx =3D -1;=0A=
+static int	mptfcInternalCtx =3D -1; /* Used only for internal commands =
*/=0A=
+=0A=
+static struct device_attribute mptfc_queue_depth_attr =3D {=0A=
+	.attr =3D {=0A=
+		.name =3D 	"queue_depth",=0A=
+		.mode =3D		S_IWUSR,=0A=
+	},=0A=
+	.store =3D mptscsih_store_queue_depth,=0A=
+};=0A=
+=0A=
+static struct device_attribute *mptfc_dev_attrs[] =3D {=0A=
+	&mptfc_queue_depth_attr,=0A=
+	NULL,=0A=
+};=0A=
+=0A=
+static struct scsi_host_template mptfc_driver_template =3D {=0A=
+	.proc_name			=3D "mptfc",=0A=
+	.proc_info			=3D mptscsih_proc_info,=0A=
+	.name				=3D "MPT FC Host",=0A=
+	.info				=3D mptscsih_info,=0A=
+	.queuecommand			=3D mptscsih_qcmd,=0A=
+	.slave_alloc			=3D mptscsih_slave_alloc,=0A=
+	.slave_configure		=3D mptscsih_slave_configure,=0A=
+	.slave_destroy			=3D mptscsih_slave_destroy,=0A=
+	.eh_abort_handler		=3D mptscsih_abort,=0A=
+	.eh_device_reset_handler	=3D mptscsih_dev_reset,=0A=
+	.eh_bus_reset_handler		=3D mptscsih_bus_reset,=0A=
+	.eh_host_reset_handler		=3D mptscsih_host_reset,=0A=
+	.bios_param			=3D mptscsih_bios_param,=0A=
+	.can_queue			=3D MPT_FC_CAN_QUEUE,=0A=
+	.this_id			=3D -1,=0A=
+	.sg_tablesize			=3D MPT_SCSI_SG_DEPTH,=0A=
+	.max_sectors			=3D 8192,=0A=
+	.cmd_per_lun			=3D 7,=0A=
+	.use_clustering			=3D ENABLE_CLUSTERING,=0A=
+	.sdev_attrs			=3D mptfc_dev_attrs,=0A=
+};=0A=
+=0A=
+/**********************************************************************=
******=0A=
+ * Supported hardware=0A=
+ */=0A=
+=0A=
+static struct pci_device_id mptfc_pci_table[] =3D {=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC909,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919X,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929X,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{0}	/* Terminating entry */=0A=
+};=0A=
+MODULE_DEVICE_TABLE(pci, mptfc_pci_table);=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+ *	mptfc_probe - Installs scsi devices per bus.=0A=
+ *	@pdev: Pointer to pci_dev structure=0A=
+ *=0A=
+ *	Returns 0 for success, non-zero for failure.=0A=
+ *=0A=
+ */=0A=
+static int=0A=
+mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)=0A=
+{=0A=
+	struct Scsi_Host	*sh;=0A=
+	MPT_SCSI_HOST		*hd;=0A=
+	MPT_ADAPTER 		*ioc;=0A=
+	unsigned long		 flags;=0A=
+	int			 sz, ii;=0A=
+	int			 numSGE =3D 0;=0A=
+	int			 scale;=0A=
+	int			 ioc_cap;=0A=
+	u8			*mem;=0A=
+	int			error=3D0;=0A=
+	int			r;=0A=
+		=0A=
+	if ((r =3D mpt_attach(pdev,id)) !=3D 0)=0A=
+		return r;=0A=
+	=0A=
+	ioc =3D pci_get_drvdata(pdev);=0A=
+=0A=
+	/*  Added sanity check on readiness of the MPT adapter.=0A=
+	 */=0A=
+	if (ioc->last_state !=3D MPI_IOC_STATE_OPERATIONAL) {=0A=
+		printk(MYIOC_s_WARN_FMT=0A=
+		  "Skipping because it's not operational!\n",=0A=
+		  ioc->name);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+=0A=
+	if (!ioc->active) {=0A=
+		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",=0A=
+		  ioc->name);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+=0A=
+	/*  Sanity check - ensure at least 1 port is INITIATOR capable=0A=
+	 */=0A=
+	ioc_cap =3D 0;=0A=
+	for (ii=3D0; ii < ioc->facts.NumberOfPorts; ii++) {=0A=
+		if (ioc->pfacts[ii].ProtocolFlags &=0A=
+		    MPI_PORTFACTS_PROTOCOL_INITIATOR)=0A=
+			ioc_cap ++;=0A=
+	}=0A=
+=0A=
+	if (!ioc_cap) {=0A=
+		printk(MYIOC_s_WARN_FMT=0A=
+			"Skipping ioc=3D%p because SCSI Initiator mode is NOT =
enabled!\n",=0A=
+			ioc->name, ioc);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+=0A=
+	sh =3D scsi_host_alloc(&mptfc_driver_template, =
sizeof(MPT_SCSI_HOST));=0A=
+=0A=
+	if (!sh) {=0A=
+		printk(MYIOC_s_WARN_FMT=0A=
+			"Unable to register controller with SCSI subsystem\n",=0A=
+			ioc->name);=0A=
+                return -1;=0A=
+        }=0A=
+=0A=
+	spin_lock_irqsave(&ioc->FreeQlock, flags);=0A=
+=0A=
+	/* Attach the SCSI Host to the IOC structure=0A=
+	 */=0A=
+	ioc->sh =3D sh;=0A=
+=0A=
+	sh->io_port =3D 0;=0A=
+	sh->n_io_port =3D 0;=0A=
+	sh->irq =3D 0;=0A=
+=0A=
+	/* set 16 byte cdb's */=0A=
+	sh->max_cmd_len =3D 16;=0A=
+=0A=
+	sh->max_id =3D MPT_MAX_FC_DEVICES<256 ? MPT_MAX_FC_DEVICES : 255;=0A=
+=0A=
+	sh->max_lun =3D MPT_LAST_LUN + 1;=0A=
+	sh->max_channel =3D 0;=0A=
+	sh->this_id =3D ioc->pfacts[0].PortSCSIID;=0A=
+=0A=
+	/* Required entry.=0A=
+	 */=0A=
+	sh->unique_id =3D ioc->id;=0A=
+=0A=
+	/* Verify that we won't exceed the maximum=0A=
+	 * number of chain buffers=0A=
+	 * We can optimize:  ZZ =3D req_sz/sizeof(SGE)=0A=
+	 * For 32bit SGE's:=0A=
+	 *  numSGE =3D 1 + (ZZ-1)*(maxChain -1) + ZZ=0A=
+	 *               + (req_sz - 64)/sizeof(SGE)=0A=
+	 * A slightly different algorithm is required for=0A=
+	 * 64bit SGEs.=0A=
+	 */=0A=
+	scale =3D ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));=0A=
+	if (sizeof(dma_addr_t) =3D=3D sizeof(u64)) {=0A=
+		numSGE =3D (scale - 1) *=0A=
+		  (ioc->facts.MaxChainDepth-1) + scale +=0A=
+		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +=0A=
+		  sizeof(u32));=0A=
+	} else {=0A=
+		numSGE =3D 1 + (scale - 1) *=0A=
+		  (ioc->facts.MaxChainDepth-1) + scale +=0A=
+		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +=0A=
+		  sizeof(u32));=0A=
+	}=0A=
+=0A=
+	if (numSGE < sh->sg_tablesize) {=0A=
+		/* Reset this value */=0A=
+		dprintk((MYIOC_s_INFO_FMT=0A=
+		  "Resetting sg_tablesize to %d from %d\n",=0A=
+		  ioc->name, numSGE, sh->sg_tablesize));=0A=
+		sh->sg_tablesize =3D numSGE;=0A=
+	}=0A=
+=0A=
+	/* Set the pci device pointer in Scsi_Host structure.=0A=
+	 */=0A=
+	scsi_set_device(sh, &ioc->pcidev->dev);=0A=
+=0A=
+	spin_unlock_irqrestore(&ioc->FreeQlock, flags);=0A=
+=0A=
+	hd =3D (MPT_SCSI_HOST *) sh->hostdata;=0A=
+	hd->ioc =3D ioc;=0A=
+=0A=
+	/* SCSI needs scsi_cmnd lookup table!=0A=
+	 * (with size equal to req_depth*PtrSz!)=0A=
+	 */=0A=
+	sz =3D ioc->req_depth * sizeof(void *);=0A=
+	mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
+	if (mem =3D=3D NULL) {=0A=
+		error =3D -ENOMEM;=0A=
+		goto mptfc_probe_failed;=0A=
+	}=0A=
+=0A=
+	memset(mem, 0, sz);=0A=
+	hd->ScsiLookup =3D (struct scsi_cmnd **) mem;=0A=
+=0A=
+	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=3D%d\n",=0A=
+		 ioc->name, hd->ScsiLookup, sz));=0A=
+=0A=
+	/* Allocate memory for the device structures.=0A=
+	 * A non-Null pointer at an offset=0A=
+	 * indicates a device exists.=0A=
+	 * max_id =3D 1 + maximum id (hosts.h)=0A=
+	 */=0A=
+	sz =3D sh->max_id * sizeof(void *);=0A=
+	mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
+	if (mem =3D=3D NULL) {=0A=
+		error =3D -ENOMEM;=0A=
+		goto mptfc_probe_failed;=0A=
+	}=0A=
+=0A=
+	memset(mem, 0, sz);=0A=
+	hd->Targets =3D (VirtDevice **) mem;=0A=
+=0A=
+	dprintk((KERN_INFO=0A=
+	  "  Targets @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
+=0A=
+	/* Clear the TM flags=0A=
+	 */=0A=
+	hd->tmPending =3D 0;=0A=
+	hd->tmState =3D TM_STATE_NONE;=0A=
+	hd->resetPending =3D 0;=0A=
+	hd->abortSCpnt =3D NULL;=0A=
+=0A=
+	/* Clear the pointer used to store=0A=
+	 * single-threaded commands, i.e., those=0A=
+	 * issued during a bus scan, dv and=0A=
+	 * configuration pages.=0A=
+	 */=0A=
+	hd->cmdPtr =3D NULL;=0A=
+=0A=
+	/* Initialize this SCSI Hosts' timers=0A=
+	 * To use, set the timer expires field=0A=
+	 * and add_timer=0A=
+	 */=0A=
+	init_timer(&hd->timer);=0A=
+	hd->timer.data =3D (unsigned long) hd;=0A=
+	hd->timer.function =3D mptscsih_timer_expired;=0A=
+=0A=
+	ioc->DoneCtx =3D mptfcDoneCtx;=0A=
+	ioc->TaskCtx =3D mptfcTaskCtx;=0A=
+	ioc->InternalCtx =3D mptfcInternalCtx;=0A=
+=0A=
+	hd->mpt_pq_filter =3D mpt_pq_filter;=0A=
+=0A=
+	ddvprintk((MYIOC_s_INFO_FMT=0A=
+		"mpt_pq_filter %x\n",=0A=
+		ioc->name, =0A=
+		mpt_pq_filter));=0A=
+=0A=
+	init_waitqueue_head(&hd->scandv_waitq);=0A=
+	hd->scandv_wait_done =3D 0;=0A=
+	hd->last_queue_full =3D 0;=0A=
+=0A=
+	error =3D scsi_add_host (sh, &ioc->pcidev->dev);=0A=
+	if(error) {=0A=
+		dprintk((KERN_ERR MYNAM=0A=
+		  "scsi_add_host failed\n"));=0A=
+		goto mptfc_probe_failed;=0A=
+	}=0A=
+=0A=
+	scsi_scan_host(sh);=0A=
+	return 0;=0A=
+=0A=
+mptfc_probe_failed:=0A=
+=0A=
+	mptscsih_remove(pdev);=0A=
+	return error;=0A=
+}=0A=
+=0A=
+static struct pci_driver mptfc_driver =3D {=0A=
+	.name		=3D "mptfc",=0A=
+	.id_table	=3D mptfc_pci_table,=0A=
+	.probe		=3D mptfc_probe,=0A=
+	.remove		=3D __devexit_p(mptscsih_remove),=0A=
+	.driver         =3D {=0A=
+		.shutdown =3D mptscsih_shutdown,=0A=
+        },=0A=
+#ifdef CONFIG_PM=0A=
+	.suspend	=3D mptscsih_suspend,=0A=
+	.resume		=3D mptscsih_resume,=0A=
+#endif=0A=
+};=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/**=0A=
+ *	mptfc_init - Register MPT adapter(s) as SCSI host(s) with=0A=
+ *	linux scsi mid-layer.=0A=
+ *=0A=
+ *	Returns 0 for success, non-zero for failure.=0A=
+ */=0A=
+static int __init=0A=
+mptfc_init(void)=0A=
+{=0A=
+=0A=
+	show_mptmod_ver(my_NAME, my_VERSION);=0A=
+=0A=
+	mptfcDoneCtx =3D mpt_register(mptscsih_io_done, MPTFC_DRIVER);=0A=
+	mptfcTaskCtx =3D mpt_register(mptscsih_taskmgmt_complete, =
MPTFC_DRIVER);=0A=
+	mptfcInternalCtx =3D mpt_register(mptscsih_scandv_complete, =
MPTFC_DRIVER);=0A=
+=0A=
+	if (mpt_event_register(mptfcDoneCtx, mptscsih_event_process) =3D=3D =
0) {=0A=
+		devtprintk((KERN_INFO MYNAM=0A=
+		  ": Registered for IOC event notifications\n"));=0A=
+	}=0A=
+=0A=
+	if (mpt_reset_register(mptfcDoneCtx, mptscsih_ioc_reset) =3D=3D 0) =
{=0A=
+		dprintk((KERN_INFO MYNAM=0A=
+		  ": Registered for IOC reset notifications\n"));=0A=
+	}=0A=
+=0A=
+	return pci_register_driver(&mptfc_driver);=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/**=0A=
+ *	mptfc_exit - Unregisters MPT adapter(s)=0A=
+ *=0A=
+ */=0A=
+static void __exit=0A=
+mptfc_exit(void)=0A=
+{=0A=
+	pci_unregister_driver(&mptfc_driver);=0A=
+	=0A=
+	mpt_reset_deregister(mptfcDoneCtx);=0A=
+	dprintk((KERN_INFO MYNAM=0A=
+	  ": Deregistered for IOC reset notifications\n"));=0A=
+=0A=
+	mpt_event_deregister(mptfcDoneCtx);=0A=
+	dprintk((KERN_INFO MYNAM=0A=
+	  ": Deregistered for IOC event notifications\n"));=0A=
+=0A=
+	mpt_deregister(mptfcInternalCtx);=0A=
+	mpt_deregister(mptfcTaskCtx);=0A=
+	mpt_deregister(mptfcDoneCtx);=0A=
+}=0A=
+=0A=
+module_init(mptfc_init);=0A=
+module_exit(mptfc_exit);=0A=

------_=_NextPart_000_01C545D0.8D024EE0--
