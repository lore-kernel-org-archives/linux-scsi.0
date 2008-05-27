From: Maarten Vanraes <maarten@ba.be>
Subject: Re: megaraid_sata vs megasr
Date: Tue, 27 May 2008 11:55:57 +0200
Message-ID: <200805271155.57577.maarten@ba.be>
References: <200805261005.31015.maarten@ba.be> <483AEF3E.5010309@garzik.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tq9OItTZTn+VaGU"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757153AbYE0J4S@vger.kernel.org>
In-Reply-To: <483AEF3E.5010309@garzik.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_tq9OItTZTn+VaGU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

link where i downloaded the driver:

http://www.lsi.com/storage_home/products_home/internal_raid/megaraid_sas/megaraid_sas_8204elp/index.html?locale=EN&remote=1

i downloaded the 09.32_RedHat5.zip , there are, next to the binaries, also an 
open_source directory, where you can compile the driver. however, this driver 
doesn't work on recent kernels. I made a patch to let it work on 2.6.21 (it 
may not be clean).

there is a CPU soft lockup warning at boot time, when the module is used, (but 
that was there even on RH5 with the old kernel and binary driver. so, i doubt 
it was my doing.)

In the megaraid_sata (i've looked at it), there's 2 versions: xscale and ppc 
or something; which should i use?

and lastly: mpt fusion? that sounds like a totally different driver, any 
reason as why to use that one?

We have 2 identical machines to be used as xen hosts, which both have the same 
card. the first one is already in production, since we saw the iowait problem 
much later, the second one is empty for now, and i keep it that way for now, 
so i can test out on it. Of course, time is ticking away, since there are 
virtual machines being sold :-/ . You know how management works...

Sincerely,

Maarten Vanraes
PS: i just saw that there is a newer driver, but i suspect the source didn't 
change, it's probably a recompile for the new RH5 kernel. However, i'll see 
if there are any diff in it, and if so, i'll test it out this week.

Op maandag 26 mei 2008 19:11, schreef Jeff Garzik:
> Maarten Vanraes wrote:
> > Hello, (can you CC me? i'm not on the list)
> >
> > I have a LSI MegaRAID SAS 8204ELP card, and since it wasn't recognized by
> > any driver, i tried using the megasr driver supplied by LSI (it also
> > supplies open_source code with it), i had to modify the code a bit to get
> > it to boot with kernel-2.6.21 . but there's a very high iowait on it. i'm
> > wondering if the megaraid_sas driver is meant to be the driver for the
> > same hardware as megasr? would it help if i just added another PCI ID to
> > the module and try that one?
> >
> > Sincerely,
> >
> > Maarten Vanraes
> >
> > [] # lspci -s 08:00.0 -vvvn
> > 08:00.0 0100: 1000:0059 (rev 08)
> >         Subsystem: 1000:3002
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr+ Stepping- SERR+ FastB2B- DisINTx-
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR+ <PERR- INTx-
> >         Latency: 0, Cache Line Size: 32 bytes
> >         Interrupt: pin A routed to IRQ 18
> >         Region 0: I/O ports at 3000 [size=256]
> >         Region 1: Memory at d8410000 (64-bit, non-prefetchable)
> > [size=16K] Region 3: Memory at d8400000 (64-bit, non-prefetchable)
> > [size=64K] [virtual] Expansion ROM at d8000000 [disabled] [size=2M]
> > Capabilities: [50] Power Management version 2
> >         Capabilities: [68] Express (v1) Endpoint, MSI 00
> >         Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+
> >         Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
> >         Capabilities: [100] Advanced Error Reporting <?>
>
> Yeah you can try drivers/scsi/megaraid/megaraid_sas.c or
> drivers/message/fusion/mptsas.c.
>
> A URL to the megasr driver would be nice.
>
> Also, please keep linux-scsi in CC (I added it), that's where this sort
> of things is usually discussed.
>
> 	Jeff

-- 
Maarten Vanraes
BA NV: IT & Security

--Boundary-00=_tq9OItTZTn+VaGU
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="kernel_2.6.20.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel_2.6.20.patch"

--- open_source/osl/lin/linux_osl.c	2008-02-07 17:23:36.000000000 +0000
+++ open_source/osl/lin/linux_osl.c	2008-04-10 14:13:10.000000000 +0000
@@ -66,7 +66,7 @@
 
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
- module_param(dbglvl_g, uint, DRIVER_DBG_LEVEL);
+ module_param(dbglvl_g, uint, 0);
 #else 
 #ifdef MODULE
  MODULE_PARM			(dbglvl_g, "i");
@@ -90,7 +90,7 @@
 #endif
 
 /* Function Prototypes */
-static LSI_RAID_IRQRETURN_T lsraid_isr(int irq, void *devp, struct pt_regs *regs);
+static LSI_RAID_IRQRETURN_T lsraid_isr(int irq, void *devp);
 
 /* helper functions */
 static int __devinit lsraid_probe_one(struct pci_dev*, 
@@ -556,9 +556,10 @@
  * This is a tasklet, Linux guarantees, we are not running on more than one CPU at the
  * same time.
  **/
-static void megasr_linux_build_io(void *devp)
+
+static void megasr_linux_build_io(struct work_struct *work)
 {
-	linux_adp_t				*linux_adp = (linux_adp_t *) devp;
+	linux_adp_t				*linux_adp = container_of(work, linux_adp_t, work_build_io_in);
 	rcl_packet_public_t			*rclp;
 	rcl_packet_public_t			*rclp_tmp;
 	struct scsi_cmnd		*scp;
@@ -634,9 +635,9 @@
  * counterpart for the "sleepy" build IO routine. We complete the scsi commands to the mid-layer
  * These commands are those for which virtual mapping, using kmap(), was obtained.
  **/
-static void megasr_linux_dpc_complete_cmd(void *devp)
+static void megasr_linux_dpc_complete_cmd(struct work_struct *work)
 {
-	linux_adp_t				*linux_adp = (linux_adp_t *)devp;
+	linux_adp_t				*linux_adp = container_of(work, linux_adp_t, work_build_io_out);
 	rcl_packet_public_t			*rclp;
 	rcl_packet_public_t			*rclp_tmp;
 	struct scsi_cmnd		*scp;
@@ -961,8 +962,7 @@
  *@remarks
  * This is a driver entry function 
  */
-static LSI_RAID_IRQRETURN_T lsraid_isr(int irq, void* os_cxt, 
-		struct pt_regs* regs)
+static LSI_RAID_IRQRETURN_T lsraid_isr(int irq, void* os_cxt)
 {
 	int				ret_val = LSI_FALSE;
 	unsigned long	flags;
@@ -1073,9 +1073,8 @@
 	// setup work queues for DPC
 	megasr_clist_setup(&lxadp->build_io_list_in);
 	megasr_clist_setup(&lxadp->build_io_list_out);
-	INIT_WORK(&lxadp->work_build_io_in, megasr_linux_build_io, lxadp);
-	INIT_WORK(&lxadp->work_build_io_out, megasr_linux_dpc_complete_cmd,
-	lxadp);
+	INIT_WORK(&lxadp->work_build_io_in, megasr_linux_build_io);
+	INIT_WORK(&lxadp->work_build_io_out, megasr_linux_dpc_complete_cmd);
 #endif
 
 #ifdef __LP64__
--- open_source/osl/lin/linux_osl.h	2008-02-07 17:23:36.000000000 +0000
+++ open_source/osl/lin/linux_osl.h	2008-04-10 12:47:36.000000000 +0000
@@ -111,7 +111,8 @@
 #define LSI_RAID_SCP2_LUN(scp)		(scp)->device->lun		/* LUN */
 #define LSI_RAID_IRQRETURN_T 		irqreturn_t
 
-#define LSI_RAID_HOST_SET_LOCK(host, lock) scsi_assign_lock(host, lock)
+//#define LSI_RAID_HOST_SET_LOCK(host, lock) scsi_assign_lock(host, lock)
+#define LSI_RAID_HOST_SET_LOCK(host, lock) host->host_lock = lock;
 #define LSI_RAID_CURRENT_TIME_IN_SEC (CURRENT_TIME.tv_sec)
 
 #else
Alleen in test/open_source/osl/lin: linux_osl.o
Alleen in test/open_source/osl/lin: .linux_osl.o.cmd
Alleen in test/open_source/osl/lin: osl_char.o
Alleen in test/open_source/osl/lin: .osl_char.o.cmd
Alleen in test/open_source/oss/lin: lin_oss.o
Alleen in test/open_source/oss/lin: .lin_oss.o.cmd

--Boundary-00=_tq9OItTZTn+VaGU--
