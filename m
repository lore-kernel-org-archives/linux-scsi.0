From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 09:21:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210251421.g9PEL5k02007@localhost.localdomain>
References: <akpm@digeo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-14267596420"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA19609
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 07:21:28 -0700
In-Reply-To: Message from Andrew Morton <akpm@digeo.com>
   of "Thu, 24 Oct 2002 21:40:25 PDT." <3DB8CB39.AD55D84@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>

This is a multipart MIME message.

--==_Exmh_-14267596420
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

akpm@digeo.com said:
> OK, thanks.  Could someone please extract a diff which we can try out?


I've attached it, but I'd hold out low hopes.  The problem you're seeing =
is in =

command handling.  We've been playing with tidying up upper level driver =
stuff =

(and templates).

James




--==_Exmh_-14267596420
Content-Type: text/plain ; name="tmp.diff"; charset=iso-8859-1
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or high=
er.
# This patch includes the following deltas:
#	           ChangeSet	v2.5.44 -> 1.819  =

#	drivers/scsi/inia100.h	1.6     -> 1.8    =

#	drivers/scsi/qlogicisp.h	1.2     -> 1.3    =

#	drivers/scsi/scsi_error.c	1.18    -> 1.19   =

#	drivers/scsi/aic7xxx_old/aic7xxx.h	1.7     -> 1.8    =

#	drivers/scsi/hosts.c	1.16    -> 1.18   =

#	drivers/scsi/atp870u.h	1.4     -> 1.5    =

#	 drivers/scsi/eata.h	1.10    -> 1.11   =

#	  drivers/scsi/ips.h	1.12    -> 1.13   =

#	drivers/scsi/3w-xxxx.h	1.12    -> 1.13   =

#	   drivers/scsi/sr.c	1.56    -> 1.58   =

#	 drivers/scsi/scsi.h	1.29    -> 1.30   =

#	drivers/scsi/ncr53c8xx.c	1.12    -> 1.13   =

#	drivers/scsi/hosts.h	1.19    -> 1.21   =

#	drivers/scsi/ncr53c8xx.h	1.4     -> 1.5    =

#	drivers/scsi/qlogicfc.h	1.5     -> 1.6    =

#	drivers/scsi/nsp32.c	1.1     -> 1.2    =

#	drivers/scsi/cpqfcTS.h	1.4     -> 1.5    =

#	drivers/message/fusion/mptscsih.c	1.10    -> 1.11   =

#	drivers/scsi/aic7xxx/aic7xxx_linux_host.h	1.8     -> 1.9    =

#	drivers/scsi/sym53c8xx.h	1.6     -> 1.7    =

#	   drivers/scsi/sg.c	1.30    -> 1.31   =

#	drivers/scsi/BusLogic.h	1.7     -> 1.8    =

#	drivers/scsi/scsi_lib.c	1.35    -> 1.36   =

#	 drivers/scsi/scsi.c	1.48    -> 1.50   =

#	   drivers/scsi/sd.h	1.7     -> 1.8    =

#	drivers/scsi/ide-scsi.c	1.11    -> 1.12   =

#	drivers/scsi/in2000.c	1.8     -> 1.9    =

#	   drivers/scsi/sd.c	1.73    -> 1.75   =

#	drivers/scsi/scsi_scan.c	1.28    -> 1.31   =

#	drivers/scsi/Makefile	1.28    -> 1.29   =

#	drivers/scsi/scsi_merge.c	1.24    ->         (deleted)      =

#	drivers/scsi/wd7000.h	1.5     -> 1.6    =

#	drivers/scsi/qla1280.h	1.7     -> 1.8    =

#	drivers/message/fusion/mptscsih.h	1.7     -> 1.9    =

#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/10/18	torvalds@home.transmeta.com	1.808
# Linux v2.5.44
# --------------------------------------------
# 02/10/20	hch@lst.de	1.809
# [PATCH] remove dead EH methods
# =

# break at compiletime instead of runtime
# =

# =

# =3D=3D=3D=3D=3D drivers/scsi/hosts.h 1.19 vs edited =3D=3D=3D=3D=3D
# --------------------------------------------
# 02/10/20	andmike@us.ibm.com	1.810
# [PATCH] fix module unload of sg
# =

# 	It looks like sg.c was missed in the update from put_device to
# 	device_unregister.
# =

# --------------------------------------------
# 02/10/20	johnf@whitsunday.net.au	1.811
# In patch-2.5.44 Mike Anderson <andmike@us.ibm.com> made a cleanup to th=
e
# Scsi Host setup.
# =

# This caused the following errors on trying to compile.
# =

# drivers/scsi/inia100.c:98: unknown field `next' specified in initialize=
r
# drivers/scsi/inia100.c:98: warning: missing braces around initializer
# drivers/scsi/inia100.c:98: warning: (near initialization for `driver_te=
mplate.shtp_list')
# drivers/scsi/inia100.c:98: unknown field `module' specified in initiali=
zer
# drivers/scsi/inia100.c:98: unknown field `proc_name' specified in initi=
alizer
# drivers/scsi/inia100.c:98: warning: initialization from incompatible po=
inter type
# make[2]: *** [drivers/scsi/inia100.o] Error 1
# =

# Several of the drivers Mike modified only had the one-line change to re=
move
# the 'next' field.  I tried it and bingo, it works and passed my tests.
# =

# The version change is what Doug Ledford intended in patch-2.5.25 back i=
n
# June 2002.  (See inia100.c "inia100_Version")
# =

# =

# --------------------------------------------
# 02/10/21	andmike@us.ibm.com	1.812
# [PATCH] scsi_error device offline fix
# =

# This patch corrects a problem in scsi error handling.
# =

# When a device is offlined indicated by a message like ...Device offline=
d
# - not ready...
# =

# the command return status was not being updated with a failure status i=
f
# the IO was a timeout.
# =

# I tested the patch on system with ips, aic, and qlogic fc adapters, but=

# was unable to generate a satisfactory device offline test case.
# =

# I did test this fix on uml with scsi_debug and generated a device
# offline condition with verified this fix was working correctly.
# =

# -andmike
# --
# Michael Anderson
# andmike@us.ibm.com
# =

#  scsi_error.c |    8 ++++++--
#  1 files changed, 6 insertions(+), 2 deletions(-)
# --------------------------------------------
# 02/10/21	andmike@us.ibm.com	1.813
# [PATCH] scsi sync caches w/ dev offline
# =

# When a scsi device is offlined and then the system is shutdown it will
# hang during the synchronizing SCSI caches task. The error handler was
# activated during this step, but post recovery the system did not
# complete the shutdown.
# =

# This patch just adds a check for online before sending the command. The=

# better approach appeared to be to use scsi_block_when_processing_errors=
,
# but I was concerned that we might block to long in a shutdown case.
# =

# -andmike
# --
# Michael Anderson
# andmike@us.ibm.com
# =

#  sd.c |    3 +++
#  1 files changed, 3 insertions(+)
# --------------------------------------------
# 02/10/21	dledford@aladin.rdu.redhat.com	1.808.1.1
# Update for new TCQ scheme
# --------------------------------------------
# 02/10/22	hch@lst.de	1.814
# [PATCH] get rid of ->finish method for highlevel drivers
# =

# the ->finish method is a relicat from the old day were we never had
# hotplugging and allowed the driver to do fixups after all busses
# had been scanned.  Nowdays only sd and sr actually implement it,
# and both only defer actions to there that should actually happen in
# ->attach.  Change both drivers to move that code into ->attach,
# clenaup the Templates to use C99 initializers and get rid of the
# methods.
# =

# This also cleans up some very crude race-avoidable code in those
# drivers, btw..
# --------------------------------------------
# 02/10/22	jejb@mulgrave.(none)	1.815
# [SCSI] move build commandblocks to before attach so attach can send I/O=

# --------------------------------------------
# 02/10/22	dledford@aladin.rdu.redhat.com	1.808.1.2
# Fix for scsi host struct change
# --------------------------------------------
# 02/10/22	dledford@aladin.rdu.redhat.com	1.816
# Merge aladin.rdu.redhat.com:/usr/local/home/dledford/bk/scsi
# into aladin.rdu.redhat.com:/usr/src/2.5
# --------------------------------------------
# 02/10/22	dledford@aladin.rdu.redhat.com	1.817
# host struct cleanups
# --------------------------------------------
# 02/10/22	dledford@aladin.rdu.redhat.com	1.818
# Compile fixes needed due to host struct change
# --------------------------------------------
# 02/10/24	hch@lst.de	1.815.1.1
# [PATCH] remove scsi_merge.c
# =

# In 2.5.44 it contains only two functions, that both have exactly
# one caller in other files and both are entirely unrelated to
# request merging..
# --------------------------------------------
# 02/10/24	jejb@mulgrave.(none)	1.819
# Merge ssh://linux-scsi@linux-scsi.bkbits.net/scsi-misc-2.5
# into mulgrave.(none):/home/jejb/BK/scsi-misc-2.5
# --------------------------------------------
#
diff -Nru a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mp=
tscsih.c
--- a/drivers/message/fusion/mptscsih.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/message/fusion/mptscsih.c	Fri Oct 25 09:19:29 2002
@@ -1295,10 +1295,6 @@
 #endif
 				sh->this_id =3D this->pfacts[portnum].PortSCSIID;
 =

-				/* OS entry to allow host drivers to force
-				 * a queue depth on a per device basis.
-				 */
-				sh->select_queue_depths =3D mptscsih_select_queue_depths;
 				/* Required entry.
 				 */
 				sh->unique_id =3D this->id;
@@ -3668,37 +3664,20 @@
  *	Called once per device the bus scan. Use it to force the queue_depth
  *	member to 1 if a device does not support Q tags.
  */
-void
-mptscsih_select_queue_depths(struct Scsi_Host *sh, Scsi_Device *sdList)
+int
+mptscsih_slave_attach(Scsi_Device *device)
 {
-	struct scsi_device	*device;
 	VirtDevice		*pTarget;
-	MPT_SCSI_HOST		*hd;
-	int			 ii, max;
-
-	for (device =3D sdList; device !=3D NULL; device =3D device->next) {
 =

-		if (device->host !=3D sh)
-			continue;
-
-		hd =3D (MPT_SCSI_HOST *) sh->hostdata;
-		if (hd =3D=3D NULL)
-			continue;
-
-		if (hd->Targets !=3D NULL) {
-			if (hd->is_spi)
-				max =3D MPT_MAX_SCSI_DEVICES;
-			else
-				max =3D MPT_MAX_FC_DEVICES<256 ? MPT_MAX_FC_DEVICES : 255;
-
-			for (ii=3D0; ii < max; ii++) {
-				pTarget =3D hd->Targets[ii];
-				if (pTarget && !(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)) {
-					device->queue_depth =3D 1;
-				}
-			}
-		}
+	pTarget =3D device->hostdata;
+	if (!device->tagged_supported ||
+	    !(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)) {
+		scsi_adjust_queue_depth(device, 0, 1);
+	} else {
+		scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
+					       device->host->can_queue >> 1);
 	}
+	return 0;
 }
 =

 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D*/
diff -Nru a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mp=
tscsih.h
--- a/drivers/message/fusion/mptscsih.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/message/fusion/mptscsih.h	Fri Oct 25 09:19:29 2002
@@ -206,7 +206,7 @@
 #define x_scsi_dev_reset	mptscsih_dev_reset
 #define x_scsi_host_reset	mptscsih_host_reset
 #define x_scsi_bios_param	mptscsih_bios_param
-#define x_scsi_select_queue_depths	mptscsih_select_queue_depths
+#define x_scsi_slave_attach	mptscsih_slave_attach
 =

 #define x_scsi_taskmgmt_bh	mptscsih_taskmgmt_bh
 #define x_scsi_old_abort	mptscsih_old_abort
@@ -234,7 +234,7 @@
 #else
 extern	int		 x_scsi_bios_param(Disk *, kdev_t, int *);
 #endif
-extern	void		 x_scsi_select_queue_depths(struct Scsi_Host *, Scsi_Device=
 *);
+extern	int		 x_scsi_slave_attach(Scsi_Device *);
 extern	void		 x_scsi_taskmgmt_bh(void *);
 =

 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
@@ -248,20 +248,18 @@
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,5,1)
 =

 #define MPT_SCSIHOST {						\
-	next:				NULL,			\
 	PROC_SCSI_DECL						\
 	name:				"MPT SCSI Host",	\
 	detect:				x_scsi_detect,		\
 	release:			x_scsi_release,		\
 	info:				x_scsi_info,		\
-	command:			NULL,			\
 	queuecommand:			x_scsi_queuecommand,	\
-	eh_strategy_handler:		NULL,			\
 	eh_abort_handler:		x_scsi_abort,		\
 	eh_device_reset_handler:	x_scsi_dev_reset,	\
 	eh_bus_reset_handler:		x_scsi_bus_reset,	\
 	eh_host_reset_handler:		x_scsi_host_reset,	\
 	bios_param:			x_scsi_bios_param,	\
+	slave_attach:			x_scsi_slave_attach,	\
 	can_queue:			MPT_SCSI_CAN_QUEUE,	\
 	this_id:			-1,			\
 	sg_tablesize:			MPT_SCSI_SG_DEPTH,	\
@@ -274,19 +272,15 @@
 #else  /* LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,5,1) */
 =

 #define MPT_SCSIHOST {						\
-	next:				NULL,			\
 	PROC_SCSI_DECL						\
 	name:				"MPT SCSI Host",	\
 	detect:				x_scsi_detect,		\
 	release:			x_scsi_release,		\
 	info:				x_scsi_info,		\
-	command:			NULL,			\
 	queuecommand:			x_scsi_queuecommand,	\
-	eh_strategy_handler:		NULL,			\
 	eh_abort_handler:		x_scsi_abort,		\
 	eh_device_reset_handler:	x_scsi_dev_reset,	\
 	eh_bus_reset_handler:		x_scsi_bus_reset,	\
-	eh_host_reset_handler:		NULL,			\
 	bios_param:			x_scsi_bios_param,	\
 	can_queue:			MPT_SCSI_CAN_QUEUE,	\
 	this_id:			-1,			\
@@ -302,13 +296,11 @@
 #else /* MPT_SCSI_USE_NEW_EH */
 =

 #define MPT_SCSIHOST {						\
-	next:				NULL,			\
 	PROC_SCSI_DECL						\
 	name:				"MPT SCSI Host",	\
 	detect:				x_scsi_detect,		\
 	release:			x_scsi_release,		\
 	info:				x_scsi_info,		\
-	command:			NULL,			\
 	queuecommand:			x_scsi_queuecommand,	\
 	abort:				x_scsi_old_abort,	\
 	reset:				x_scsi_old_reset,	\
diff -Nru a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
--- a/drivers/scsi/3w-xxxx.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/3w-xxxx.h	Fri Oct 25 09:19:29 2002
@@ -468,25 +468,14 @@
 =

 /* Scsi_Host_Template Initializer */
 #define TWXXXX {					\
-	next : NULL,					\
-	module : NULL,					\
 	proc_name : "3w-xxxx",				\
 	proc_info : tw_scsi_proc_info,			\
 	name : "3ware Storage Controller",		\
 	detect : tw_scsi_detect,			\
 	release : tw_scsi_release,			\
-	info : NULL,					\
-	ioctl : NULL,                  			\
-	command : NULL,					\
 	queuecommand : tw_scsi_queue,			\
-	eh_strategy_handler : NULL,			\
 	eh_abort_handler : tw_scsi_eh_abort,		\
-	eh_device_reset_handler : NULL,			\
-	eh_bus_reset_handler : NULL,			\
 	eh_host_reset_handler : tw_scsi_eh_reset,	\
-	abort : NULL,					\
-	reset : NULL,					\
-	slave_attach : NULL,				\
 	bios_param : tw_scsi_biosparam,			\
 	can_queue : TW_Q_LENGTH-1,			\
 	this_id: -1,					\
diff -Nru a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
--- a/drivers/scsi/BusLogic.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/BusLogic.h	Fri Oct 25 09:19:29 2002
@@ -55,8 +55,6 @@
 extern int BusLogic_ReleaseHostAdapter(SCSI_Host_T *);
 extern int BusLogic_QueueCommand(SCSI_Command_T *,
 				 void (*CompletionRoutine)(SCSI_Command_T *));
-extern int BusLogic_AbortCommand(SCSI_Command_T *);
-extern int BusLogic_ResetCommand(SCSI_Command_T *, unsigned int);
 extern int BusLogic_BIOSDiskParameters(SCSI_Disk_T *, struct block_devic=
e *,
 				       int *);
 extern int BusLogic_ProcDirectoryInfo(char *, char **, off_t, int, int, =
int);
@@ -75,8 +73,6 @@
     release:        BusLogic_ReleaseHostAdapter,  /* Release Host Adapte=
r   */ \
     info:           BusLogic_DriverInfo,	  /* Driver Info Function   */ =
\
     queuecommand:   BusLogic_QueueCommand,	  /* Queue Command Function *=
/ \
-    abort:          BusLogic_AbortCommand,	  /* Abort Command Function *=
/ \
-    reset:          BusLogic_ResetCommand,	  /* Reset Command Function *=
/ \
     slave_attach:   BusLogic_SlaveAttach,	  /* Configure a SCSI_Device*/=
 \
     bios_param:     BusLogic_BIOSDiskParameters,  /* BIOS Disk Parameter=
s   */ \
     unchecked_isa_dma: 1,			  /* Default Initial Value  */ \
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/Makefile	Fri Oct 25 09:19:29 2002
@@ -122,8 +122,8 @@
 obj-$(CONFIG_CHR_DEV_SG)	+=3D sg.o
 =

 scsi_mod-objs	:=3D scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o \
-			scsi_proc.o scsi_error.o scsi_lib.o scsi_merge.o \
-			scsi_scan.o scsi_syms.o
+			scsi_proc.o scsi_error.o scsi_lib.o scsi_scan.o \
+			scsi_syms.o
 			=

 sd_mod-objs	:=3D sd.o
 sr_mod-objs	:=3D sr.o sr_ioctl.o sr_vendor.o
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_linux_host.h b/drivers/scsi/aic7=
xxx/aic7xxx_linux_host.h
--- a/drivers/scsi/aic7xxx/aic7xxx_linux_host.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/aic7xxx/aic7xxx_linux_host.h	Fri Oct 25 09:19:29 2002
@@ -63,22 +63,14 @@
  * to do with card config are filled in after the card is detected.
  */
 #define AIC7XXX	{						\
-	module: NULL,						\
-	proc_dir: NULL,						\
 	proc_info: ahc_linux_proc_info,				\
-	name: NULL,						\
 	detect: ahc_linux_detect,				\
 	release: ahc_linux_release,				\
 	info: ahc_linux_info,					\
-	command: NULL,						\
 	queuecommand: ahc_linux_queue,				\
-	eh_strategy_handler: NULL,				\
 	eh_abort_handler: ahc_linux_abort,			\
 	eh_device_reset_handler: ahc_linux_dev_reset,		\
 	eh_bus_reset_handler: ahc_linux_bus_reset,		\
-	eh_host_reset_handler: NULL,				\
-	abort: NULL,						\
-	reset: NULL,						\
 	slave_attach: ahc_linux_slave_attach,			\
 	bios_param: AIC7XXX_BIOSPARAM,				\
 	can_queue: 253,		/* max simultaneous cmds      */\
diff -Nru a/drivers/scsi/aic7xxx_old/aic7xxx.h b/drivers/scsi/aic7xxx_old=
/aic7xxx.h
--- a/drivers/scsi/aic7xxx_old/aic7xxx.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.h	Fri Oct 25 09:19:29 2002
@@ -35,13 +35,6 @@
 	release: aic7xxx_release,				\
 	info: aic7xxx_info,					\
 	queuecommand: aic7xxx_queue,				\
-	eh_strategy_handler: NULL,				\
-	eh_abort_handler: NULL,					\
-	eh_device_reset_handler: NULL,				\
-	eh_bus_reset_handler: NULL,				\
-	eh_host_reset_handler: NULL,				\
-	abort: aic7xxx_abort,					\
-	reset: aic7xxx_reset,					\
 	slave_attach: aic7xxx_slave_attach,			\
 	slave_detach: aic7xxx_slave_detach,			\
 	bios_param: aic7xxx_biosparam,				\
@@ -58,8 +51,6 @@
 extern int aic7xxx_biosparam(Disk *, struct block_device *, int[]);
 extern int aic7xxx_detect(Scsi_Host_Template *);
 extern int aic7xxx_command(Scsi_Cmnd *);
-extern int aic7xxx_reset(Scsi_Cmnd *, unsigned int);
-extern int aic7xxx_abort(Scsi_Cmnd *);
 extern int aic7xxx_release(struct Scsi_Host *);
 extern int aic7xxx_slave_attach(Scsi_Device *);
 extern void aic7xxx_slave_detach(Scsi_Device *);
diff -Nru a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
--- a/drivers/scsi/atp870u.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/atp870u.h	Fri Oct 25 09:19:29 2002
@@ -37,18 +37,13 @@
 extern int atp870u_proc_info(char *, char **, off_t, int, int, int);
 =

 #define ATP870U {						\
-	next: NULL,						\
-	module: NULL,						\
 	proc_info: atp870u_proc_info,				\
-	name: NULL,						\
 	detect: atp870u_detect, 				\
 	release: atp870u_release,				\
 	info: atp870u_info,					\
 	command: atp870u_command,				\
 	queuecommand: atp870u_queuecommand,			\
-	eh_strategy_handler: NULL,				\
 	eh_abort_handler: atp870u_abort, 			\
-	slave_attach: NULL,					\
 	bios_param: atp870u_biosparam,				\
 	can_queue: qcnt,	 /* max simultaneous cmds      */\
 	this_id: 7,	       /* scsi id of host adapter    */\
diff -Nru a/drivers/scsi/cpqfcTS.h b/drivers/scsi/cpqfcTS.h
--- a/drivers/scsi/cpqfcTS.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/cpqfcTS.h	Fri Oct 25 09:19:29 2002
@@ -28,8 +28,6 @@
  queuecommand:           cpqfcTS_queuecommand,   \
  eh_device_reset_handler:   cpqfcTS_eh_device_reset,   \
  eh_abort_handler:       cpqfcTS_eh_abort,       \
- reset:                  cpqfcTS_reset,          \
- abort:                  cpqfcTS_abort,		 \
  bios_param:             cpqfcTS_biosparam,      \
  can_queue:              CPQFCTS_REQ_QUEUE_LEN,  \
  this_id:                -1,                     \
diff -Nru a/drivers/scsi/eata.h b/drivers/scsi/eata.h
--- a/drivers/scsi/eata.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/eata.h	Fri Oct 25 09:19:29 2002
@@ -21,11 +21,7 @@
                 detect:                  eata2x_detect,                 =
     \
                 release:                 eata2x_release,                =
     \
                 queuecommand:            eata2x_queuecommand,           =
     \
-                abort:                   NULL,                          =
     \
-                reset:                   NULL,                          =
     \
                 eh_abort_handler:        eata2x_abort,                  =
     \
-                eh_device_reset_handler: NULL,                          =
     \
-                eh_bus_reset_handler:    NULL,                          =
     \
                 eh_host_reset_handler:   eata2x_reset,                  =
     \
                 bios_param:              eata2x_biosparam,              =
     \
 		slave_attach:		 eata2x_slave_attach,		     \
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/hosts.c	Fri Oct 25 09:19:29 2002
@@ -561,25 +561,18 @@
 			shost =3D list_entry(lh, struct Scsi_Host, sh_list);
 			for (sdev =3D shost->host_queue; sdev; sdev =3D sdev->next)
 				if (sdev->host->hostt =3D=3D shost_tp) {
+					scsi_build_commandblocks(sdev);
+					if (sdev->current_queue_depth =3D=3D 0)
+						goto out_of_space;
 					for (sdev_tp =3D scsi_devicelist;
 					     sdev_tp;
 					     sdev_tp =3D sdev_tp->next)
 						if (sdev_tp->attach)
 							(*sdev_tp->attach) (sdev);
-					if (sdev->attached) {
-						scsi_build_commandblocks(sdev);
-						if (sdev->current_queue_depth =3D=3D 0)
-							goto out_of_space;
+					if (!sdev->attached) {
+                                                scsi_release_commandbloc=
ks(sdev);
 					}
 				}
-		}
-
-		/* This does any final handling that is required. */
-		for (sdev_tp =3D scsi_devicelist; sdev_tp;
-		     sdev_tp =3D sdev_tp->next) {
-			if (sdev_tp->finish && sdev_tp->nr_dev) {
-				(*sdev_tp->finish) ();
-			}
 		}
 	}
 =

diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/hosts.h	Fri Oct 25 09:19:29 2002
@@ -168,40 +168,6 @@
      int (*eh_host_reset_handler)(Scsi_Cmnd *);
 =

     /*
-     * Since the mid level driver handles time outs, etc, we want to
-     * be able to abort the current command.  Abort returns 0 if the
-     * abortion was successful.	 The field SCpnt->abort reason
-     * can be filled in with the appropriate reason why we wanted
-     * the abort in the first place, and this will be used
-     * in the mid-level code instead of the host_byte().
-     * If non-zero, the code passed to it
-     * will be used as the return code, otherwise
-     * DID_ABORT  should be returned.
-     *
-     * Note that the scsi driver should "clean up" after itself,
-     * resetting the bus, etc.	if necessary.
-     *
-     * NOTE - this interface is depreciated, and will go away.  Use
-     * the eh_ routines instead.
-     */
-    int (* abort)(Scsi_Cmnd *);
-
-    /*
-     * The reset function will reset the SCSI bus.  Any executing
-     * commands should fail with a DID_RESET in the host byte.
-     * The Scsi_Cmnd  is passed so that the reset routine can figure
-     * out which host adapter should be reset, and also which command
-     * within the command block was responsible for the reset in
-     * the first place.	 Some hosts do not implement a reset function,
-     * and these hosts must call scsi_request_sense(SCpnt) to keep
-     * the command alive.
-     *
-     * NOTE - this interface is depreciated, and will go away.  Use
-     * the eh_ routines instead.
-     */
-    int (* reset)(Scsi_Cmnd *, unsigned int);
-
-    /*
      * Once the device has responded to an INQUIRY and we know the devic=
e
      * is online, call into the low level driver with the Scsi_Device *
      * (so that the low level driver may save it off in a safe location
@@ -583,7 +549,6 @@
     int (*detect)(Scsi_Device *); /* Returns 1 if we can attach this dev=
ice */
     int (*init)(void);		  /* Sizes arrays based upon number of devices
 		   *  detected */
-    void (*finish)(void);	  /* Perform initialization after attachment *=
/
     int (*attach)(Scsi_Device *); /* Attach devices to arrays */
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. =

diff -Nru a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/ide-scsi.c	Fri Oct 25 09:19:29 2002
@@ -860,8 +860,6 @@
 	info:		idescsi_info,
 	ioctl:		idescsi_ioctl,
 	queuecommand:	idescsi_queue,
-	abort:		idescsi_abort,
-	reset:		idescsi_reset,
 	bios_param:	idescsi_bios,
 	can_queue:	10,
 	this_id:	-1,
diff -Nru a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
--- a/drivers/scsi/in2000.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/in2000.c	Fri Oct 25 09:19:29 2002
@@ -832,7 +832,7 @@
 =

 static void in2000_intr (int irqnum, void * dev_id, struct pt_regs *ptre=
gs)
 {
-struct Scsi_Host *instance;
+struct Scsi_Host *instance =3D dev_id;
 struct IN2000_hostdata *hostdata;
 Scsi_Cmnd *patch, *cmd;
 uchar asr, sr, phs, id, lun, *ucp, msg;
@@ -842,14 +842,6 @@
 unsigned short f;
 unsigned long flags;
 =

-   for (instance =3D instance_list; instance; instance =3D instance->nex=
t) {
-      if (instance->irq =3D=3D irqnum)
-         break;
-      }
-   if (!instance) {
-      printk("*** Hmm... interrupts are screwed up! ***\n");
-      return;
-      }
    hostdata =3D (struct IN2000_hostdata *)instance->hostdata;
 =

 /* Get the spin_lock and disable further ints, for SMP */
@@ -2046,7 +2038,7 @@
       write1_io(0,IO_FIFO_READ);             /* start fifo out in read m=
ode */
       write1_io(0,IO_INTR_MASK);    /* allow all ints */
       x =3D int_tab[(switches & (SW_INT0 | SW_INT1)) >> SW_INT_SHIFT];
-      if (request_irq(x, in2000_intr, SA_INTERRUPT, "in2000", NULL)) {
+      if (request_irq(x, in2000_intr, SA_INTERRUPT, "in2000", instance))=
 {
          printk("in2000_detect: Unable to allocate IRQ.\n");
          detect_count--;
          continue;
@@ -2215,10 +2207,7 @@
 int x,i;
 static int stop =3D 0;
 =

-   for (instance=3Dinstance_list; instance; instance=3Dinstance->next) {=

-      if (instance->host_no =3D=3D hn)
-         break;
-      }
+   instance =3D scsi_host_hn_get(hn);
    if (!instance) {
       printk("*** Hmm... Can't find host #%d!\n",hn);
       return (-ESRCH);
diff -Nru a/drivers/scsi/inia100.h b/drivers/scsi/inia100.h
--- a/drivers/scsi/inia100.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/inia100.h	Fri Oct 25 09:19:29 2002
@@ -85,27 +85,14 @@
 =

 extern int inia100_biosparam(Scsi_Disk *, struct block_device *, int *);=

 =

-#define inia100_REVID "Initio INI-A100U2W SCSI device driver; Revision: =
1.02c"
+#define inia100_REVID "Initio INI-A100U2W SCSI device driver; Revision: =
1.02d"
 =

 #define INIA100	{ \
-	next:		NULL,						\
-	module:		NULL,						\
 	proc_name:	"inia100", \
-	proc_info:	NULL,				\
 	name:		inia100_REVID, \
 	detect:		inia100_detect, \
 	release:	inia100_release, \
-	info:		NULL,					\
-	command:	NULL, \
 	queuecommand:	inia100_queue, \
- 	eh_strategy_handler: NULL, \
- 	eh_abort_handler: NULL, \
- 	eh_device_reset_handler: NULL, \
- 	eh_bus_reset_handler: NULL, \
- 	eh_host_reset_handler: NULL, \
-	abort:		inia100_abort, \
-	reset:		inia100_reset, \
-	slave_attach:	NULL, \
 	bios_param:	inia100_biosparam, \
 	can_queue:	1, \
 	this_id:	1, \
diff -Nru a/drivers/scsi/ips.h b/drivers/scsi/ips.h
--- a/drivers/scsi/ips.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/ips.h	Fri Oct 25 09:19:29 2002
@@ -464,23 +464,13 @@
 }
 #else
  #define IPS {                            \
-    module : NULL,                        \
-    proc_info : NULL,                     \
-    name : NULL,                          \
     detect : ips_detect,                  \
     release : ips_release,                \
     info : ips_info,                      \
-    command : NULL,                       \
     queuecommand : ips_queue,             \
-    eh_strategy_handler : NULL,           \
     eh_abort_handler : ips_eh_abort,      \
-    eh_device_reset_handler : NULL,       \
-    eh_bus_reset_handler : NULL,          \
     eh_host_reset_handler : ips_eh_reset, \
-    abort : NULL,                         \
-    reset : NULL,                         \
     slave_attach : ips_slave_attach,      \
-    slave_detach : NULL,                  \
     bios_param : ips_biosparam,           \
     can_queue : 0,                        \
     this_id: -1,                          \
diff -Nru a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/ncr53c8xx.c	Fri Oct 25 09:19:29 2002
@@ -9125,12 +9125,9 @@
 printk("ncr53c8xx_proc_info: hostno=3D%d, func=3D%d\n", hostno, func);
 #endif
 =

-	for (host =3D first_host; host; host =3D host->next) {
-		if (host->hostt =3D=3D the_template && host->host_no =3D=3D hostno) {
-			host_data =3D (struct host_data *) host->hostdata;
-			ncb =3D host_data->ncb;
-			break;
-		}
+	if ((host =3D scsi_host_hn_get(hostno)) !=3D NULL) {
+		host_data =3D (struct host_data *) host->hostdata;
+		ncb =3D host_data->ncb;
 	}
 =

 	if (!ncb)
diff -Nru a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
--- a/drivers/scsi/ncr53c8xx.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/ncr53c8xx.h	Fri Oct 25 09:19:29 2002
@@ -76,8 +76,6 @@
 			info:           ncr53c8xx_info, 	\
 			queuecommand:   ncr53c8xx_queue_command,\
 			slave_attach:   ncr53c8xx_slave_attach, \
-			abort:          ncr53c8xx_abort,	\
-			reset:          ncr53c8xx_reset,	\
 			bios_param:     scsicam_bios_param,	\
 			can_queue:      SCSI_NCR_CAN_QUEUE,	\
 			this_id:        7,			\
diff -Nru a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/nsp32.c	Fri Oct 25 09:19:29 2002
@@ -352,7 +352,6 @@
 	.eh_device_reset_handler =3D	NULL,
 	.eh_bus_reset_handler =3D		nsp32_eh_bus_reset,
 	.eh_host_reset_handler =3D	nsp32_eh_host_reset,
-	.reset =3D			nsp32_reset,
 	.release =3D			nsp32_release,
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
 	.use_new_eh_code =3D        	1,
@@ -1575,11 +1574,7 @@
 	}
 =

 	/* search this HBA host */
-	for (host=3Dscsi_hostlist; host; host=3Dhost->next) {
-		if (host->host_no =3D=3D hostno) {
-			break;
-		}
-	}
+	host=3Dscsi_host_hn_get(hostno);
 	if (host =3D=3D NULL) {
 		return -ESRCH;
 	}
diff -Nru a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
--- a/drivers/scsi/qla1280.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/qla1280.h	Fri Oct 25 09:19:29 2002
@@ -1324,25 +1324,12 @@
  */
 =

 #define QLA1280_LINUX_TEMPLATE {				\
-	next: NULL,						\
-	module: NULL,						\
-	proc_dir: NULL,						\
 	proc_info: qla1280_proc_info,				\
 	name: "Qlogic ISP 1280/12160",				\
 	detect: qla1280_detect,					\
 	release: qla1280_release,				\
 	info: qla1280_info,					\
-	ioctl: NULL,						\
-	command: NULL,						\
 	queuecommand: qla1280_queuecommand,			\
-	eh_strategy_handler: NULL,				\
-	eh_abort_handler: NULL,					\
-	eh_device_reset_handler: NULL,				\
-	eh_bus_reset_handler: NULL,				\
-	eh_host_reset_handler: NULL,				\
-/*	use_new_eh_code: 0, */					\
-	abort: qla1280_abort,					\
-	reset: qla1280_reset,					\
 	slave_attach: qla1280_slave_attach,			\
 	bios_param: qla1280_biosparam,				\
 	can_queue: 255,		/* max simultaneous cmds      */\
diff -Nru a/drivers/scsi/qlogicfc.h b/drivers/scsi/qlogicfc.h
--- a/drivers/scsi/qlogicfc.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/qlogicfc.h	Fri Oct 25 09:19:29 2002
@@ -87,7 +87,6 @@
         info:                   isp2x00_info,                           =
   \
         queuecommand:           isp2x00_queuecommand,                   =
   \
         eh_abort_handler:       isp2x00_abort,                          =
   \
-        reset:                  isp2x00_reset,                          =
   \
         bios_param:             isp2x00_biosparam,                      =
   \
         can_queue:              QLOGICFC_REQ_QUEUE_LEN,                 =
   \
         this_id:                -1,                                     =
   \
diff -Nru a/drivers/scsi/qlogicisp.h b/drivers/scsi/qlogicisp.h
--- a/drivers/scsi/qlogicisp.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/qlogicisp.h	Fri Oct 25 09:19:29 2002
@@ -75,8 +75,6 @@
 	release:		isp1020_release,			   \
 	info:			isp1020_info,				   \
 	queuecommand:		isp1020_queuecommand,			   \
-	abort:			isp1020_abort,				   \
-	reset:			isp1020_reset,				   \
 	bios_param:		isp1020_biosparam,			   \
 	can_queue:		QLOGICISP_REQ_QUEUE_LEN,		   \
 	this_id:		-1,					   \
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/scsi.c	Fri Oct 25 09:19:29 2002
@@ -2019,33 +2019,33 @@
 	     shpnt =3D scsi_host_get_next(shpnt)) {
 		for (SDpnt =3D shpnt->host_queue; SDpnt;
 		     SDpnt =3D SDpnt->next) {
+			scsi_build_commandblocks(SDpnt);
+			if (SDpnt->current_queue_depth =3D=3D 0) {
+				out_of_space =3D 1;
+				continue;
+			}
 			if (tpnt->attach)
 				(*tpnt->attach) (SDpnt);
+
 			/*
 			 * If this driver attached to the device, and don't have any
 			 * command blocks for this device, allocate some.
 			 */
-			if (SDpnt->attached && SDpnt->current_queue_depth =3D=3D 0) {
+			if (SDpnt->attached)
 				SDpnt->online =3D TRUE;
-				scsi_build_commandblocks(SDpnt);
-				if (SDpnt->current_queue_depth =3D=3D 0)
-					out_of_space =3D 1;
-			}
+			else
+				scsi_release_commandblocks(SDpnt);
 		}
 	}
 =

-	/*
-	 * This does any final handling that is required.
-	 */
-	if (tpnt->finish && tpnt->nr_dev)
-		(*tpnt->finish) ();
 	MOD_INC_USE_COUNT;
 =

 	if (out_of_space) {
 		scsi_unregister_device(tpnt);	/* easiest way to clean up?? */
 		return 1;
-	} else
-		return 0;
+	}
+
+	return 0;
 }
 =

 int scsi_unregister_device(struct Scsi_Device_Template *tpnt)
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/scsi.h	Fri Oct 25 09:19:29 2002
@@ -446,20 +446,6 @@
 void scsi_free_sgtable(struct scatterlist *sgl, int index);
 =

 /*
- * Prototypes for functions in scsi_dma.c
- */
-void scsi_resize_dma_pool(void);
-int scsi_init_minimal_dma_pool(void);
-void *scsi_malloc(unsigned int);
-int scsi_free(void *, unsigned int);
-
-/*
- * Prototypes for functions in scsi_merge.c
- */
-extern void scsi_initialize_merge_fn(Scsi_Device *SDpnt);
-extern int scsi_init_io(Scsi_Cmnd *SCpnt);
-
-/*
  * Prototypes for functions in scsi_lib.c
  */
 extern int scsi_maybe_unblock_host(Scsi_Device * SDpnt);
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/scsi_error.c	Fri Oct 25 09:19:29 2002
@@ -1145,14 +1145,18 @@
 		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
 			continue;
 =

-		printk(KERN_INFO "%s: Device offlined - not"
+		printk(KERN_INFO "scsi: Device offlined - not"
 				" ready or command retry failed"
 				" after error recovery: host"
 				" %d channel %d id %d lun %d\n",
-				__FUNCTION__, shost->host_no,
+				shost->host_no,
 				scmd->device->channel,
 				scmd->device->id,
 				scmd->device->lun);
+
+		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_TIMEOUT))
+			scmd->result |=3D (DRIVER_TIMEOUT << 24);
+
 		scmd->device->online =3D FALSE;
 		scsi_eh_finish_cmd(scmd, shost);
 	}
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/scsi_lib.c	Fri Oct 25 09:19:29 2002
@@ -730,6 +730,92 @@
 }
 =

 /*
+ * Function:    scsi_init_io()
+ *
+ * Purpose:     SCSI I/O initialize function.
+ *
+ * Arguments:   SCpnt   - Command descriptor we wish to initialize
+ *
+ * Returns:     1 on success.
+ */
+static int scsi_init_io(Scsi_Cmnd *SCpnt)
+{
+	struct request     *req =3D SCpnt->request;
+	struct scatterlist *sgpnt;
+	int count, gfp_mask;
+
+	/*
+	 * non-sg block request. FIXME: check bouncing for isa hosts!
+	 */
+	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
+		/*
+		 * FIXME: isa bouncing
+		 */
+		if (SCpnt->host->unchecked_isa_dma)
+			goto fail;
+
+		SCpnt->request_bufflen =3D req->data_len;
+		SCpnt->request_buffer =3D req->data;
+		req->buffer =3D req->data;
+		SCpnt->use_sg =3D 0;
+		return 1;
+	}
+
+	/*
+	 * we used to not use scatter-gather for single segment request,
+	 * but now we do (it makes highmem I/O easier to support without
+	 * kmapping pages)
+	 */
+	SCpnt->use_sg =3D req->nr_phys_segments;
+
+	gfp_mask =3D GFP_NOIO;
+	if (in_interrupt()) {
+		gfp_mask &=3D ~__GFP_WAIT;
+		gfp_mask |=3D __GFP_HIGH;
+	}
+
+	/*
+	 * if sg table allocation fails, requeue request later.
+	 */
+	sgpnt =3D scsi_alloc_sgtable(SCpnt, gfp_mask);
+	if (unlikely(!sgpnt))
+		goto out;
+
+	SCpnt->request_buffer =3D (char *) sgpnt;
+	SCpnt->request_bufflen =3D req->nr_sectors << 9;
+	req->buffer =3D NULL;
+
+	/* =

+	 * Next, walk the list, and fill in the addresses and sizes of
+	 * each segment.
+	 */
+	count =3D blk_rq_map_sg(req->q, req, SCpnt->request_buffer);
+
+	/*
+	 * mapped well, send it off
+	 */
+	if (unlikely(count > SCpnt->use_sg))
+		goto incorrect;
+	SCpnt->use_sg =3D count;
+	return 1;
+
+incorrect:
+	printk(KERN_ERR "Incorrect number of segments after building list\n");
+	printk(KERN_ERR "counted %d, received %d\n", count, SCpnt->use_sg);
+	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
+			req->current_nr_sectors);
+
+	/*
+	 * kill it. there should be no leftover blocks in this request
+	 */
+fail:
+	SCpnt =3D scsi_end_request(SCpnt, 0, req->nr_sectors);
+	BUG_ON(SCpnt);
+out:
+	return 0;
+}
+
+/*
  * Function:    scsi_request_fn()
  *
  * Purpose:     Generic version of request function for SCSI hosts.
diff -Nru a/drivers/scsi/scsi_merge.c b/drivers/scsi/scsi_merge.c
--- a/drivers/scsi/scsi_merge.c	Fri Oct 25 09:19:29 2002
+++ /dev/null	Wed Dec 31 16:00:00 1969
@@ -1,168 +0,0 @@
-/*
- *  scsi_merge.c Copyright (C) 1999 Eric Youngdale
- *
- *  SCSI queueing library.
- *      Initial versions: Eric Youngdale (eric@andante.org).
- *                        Based upon conversations with large numbers
- *                        of people at Linux Expo.
- *	Support for dynamic DMA mapping: Jakub Jelinek (jakub@redhat.com).
- *	Support for highmem I/O: Jens Axboe <axboe@suse.de>
- */
-
-/*
- * This file contains queue management functions that are used by SCSI.
- * We need to ensure that commands do not grow so large that they cannot=

- * be handled all at once by a host adapter.
- */
-
-#include <linux/config.h>
-#include <linux/module.h>
-
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/stat.h>
-#include <linux/blk.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/smp_lock.h>
-
-
-#define __KERNEL_SYSCALLS__
-
-#include <linux/unistd.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
-#include <asm/io.h>
-
-#include "scsi.h"
-#include "hosts.h"
-#include <scsi/scsi_ioctl.h>
-
-/*
- * Function:    scsi_init_io()
- *
- * Purpose:     SCSI I/O initialize function.
- *
- * Arguments:   SCpnt   - Command descriptor we wish to initialize
- *
- * Returns:     1 on success.
- *
- * Lock status: =

- */
-int scsi_init_io(Scsi_Cmnd *SCpnt)
-{
-	struct request     *req =3D SCpnt->request;
-	struct scatterlist *sgpnt;
-	int count, gfp_mask;
-
-	/*
-	 * non-sg block request. FIXME: check bouncing for isa hosts!
-	 */
-	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
-		/*
-		 * FIXME: isa bouncing
-		 */
-		if (SCpnt->host->unchecked_isa_dma)
-			goto fail;
-
-		SCpnt->request_bufflen =3D req->data_len;
-		SCpnt->request_buffer =3D req->data;
-		req->buffer =3D req->data;
-		SCpnt->use_sg =3D 0;
-		return 1;
-	}
-
-	/*
-	 * we used to not use scatter-gather for single segment request,
-	 * but now we do (it makes highmem I/O easier to support without
-	 * kmapping pages)
-	 */
-	SCpnt->use_sg =3D req->nr_phys_segments;
-
-	gfp_mask =3D GFP_NOIO;
-	if (in_interrupt()) {
-		gfp_mask &=3D ~__GFP_WAIT;
-		gfp_mask |=3D __GFP_HIGH;
-	}
-
-	/*
-	 * if sg table allocation fails, requeue request later.
-	 */
-	sgpnt =3D scsi_alloc_sgtable(SCpnt, gfp_mask);
-	if (!sgpnt)
-		return 0;
-
-	SCpnt->request_buffer =3D (char *) sgpnt;
-	SCpnt->request_bufflen =3D req->nr_sectors << 9;
-	req->buffer =3D NULL;
-
-	/* =

-	 * Next, walk the list, and fill in the addresses and sizes of
-	 * each segment.
-	 */
-	count =3D blk_rq_map_sg(req->q, req, SCpnt->request_buffer);
-
-	/*
-	 * mapped well, send it off
-	 */
-	if (count <=3D SCpnt->use_sg) {
-		SCpnt->use_sg =3D count;
-		return 1;
-	}
-
-	printk("Incorrect number of segments after building list\n");
-	printk("counted %d, received %d\n", count, SCpnt->use_sg);
-	printk("req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors, req->current=
_nr_sectors);
-
-	/*
-	 * kill it. there should be no leftover blocks in this request
-	 */
-fail:
-	SCpnt =3D scsi_end_request(SCpnt, 0, req->nr_sectors);
-	BUG_ON(SCpnt);
-	return 0;
-}
-
-/*
- * Function:    scsi_initialize_merge_fn()
- *
- * Purpose:     Initialize merge function for a host
- *
- * Arguments:   SHpnt   - Host descriptor.
- *
- * Returns:     Nothing.
- *
- * Lock status: =

- *
- * Notes:
- */
-void scsi_initialize_merge_fn(Scsi_Device * SDpnt)
-{
-	struct Scsi_Host *SHpnt =3D SDpnt->host;
-	request_queue_t *q =3D &SDpnt->request_queue;
-	u64 bounce_limit;
-
-	/*
-	 * The generic merging functions work just fine for us.
-	 * Enable highmem I/O, if appropriate.
-	 */
-	bounce_limit =3D BLK_BOUNCE_HIGH;
-	if (SHpnt->highmem_io) {
-		if (!PCI_DMA_BUS_IS_PHYS)
-			/* Platforms with virtual-DMA translation
- 			 * hardware have no practical limit.
-			 */
-			bounce_limit =3D BLK_BOUNCE_ANY;
-		else if (SHpnt->pci_dev)
-			bounce_limit =3D SHpnt->pci_dev->dma_mask;
-	} else if (SHpnt->unchecked_isa_dma)
-		bounce_limit =3D BLK_BOUNCE_ISA;
-
-	blk_queue_bounce_limit(q, bounce_limit);
-}
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/scsi_scan.c	Fri Oct 25 09:19:29 2002
@@ -483,6 +483,35 @@
 }
 =

 /**
+ * scsi_initialize_merge_fn() -=C6=A3initialize merge function for a hos=
t
+ * @sd:		host descriptor
+ */
+static void scsi_initialize_merge_fn(struct scsi_device *sd)
+{
+	request_queue_t *q =3D &sd->request_queue;
+	struct Scsi_Host *sh =3D sd->host;
+	u64 bounce_limit;
+
+	if (sh->highmem_io) {
+		if (sh->pci_dev && PCI_DMA_BUS_IS_PHYS) {
+			bounce_limit =3D sh->pci_dev->dma_mask;
+		} else {
+			/*
+			 * Platforms with virtual-DMA translation
+ 			 * hardware have no practical limit.
+			 */
+			bounce_limit =3D BLK_BOUNCE_ANY;
+		}
+	} else if (sh->unchecked_isa_dma) {
+		bounce_limit =3D BLK_BOUNCE_ISA;
+	} else {
+		bounce_limit =3D BLK_BOUNCE_HIGH;
+	}
+
+	blk_queue_bounce_limit(q, bounce_limit);
+}
+
+/**
  * scsi_alloc_sdev - allocate and setup a Scsi_Device
  *
  * Description:
@@ -1995,29 +2024,28 @@
 	sdevscan->scsi_level =3D scsi_find_scsi_level(channel, id, shost);
 	res =3D scsi_probe_and_add_lun(sdevscan, &sdev, NULL);
 	scsi_free_sdev(sdevscan);
-	if (res =3D=3D SCSI_SCAN_LUN_PRESENT) {
-		BUG_ON(sdev =3D=3D NULL);
 =

-		for (sdt =3D scsi_devicelist; sdt; sdt =3D sdt->next)
-			if (sdt->init && sdt->dev_noticed)
-				(*sdt->init) ();
-
-		for (sdt =3D scsi_devicelist; sdt; sdt =3D sdt->next)
-			if (sdt->attach) {
-				(*sdt->attach) (sdev);
-				if (sdev->attached) {
-					scsi_build_commandblocks(sdev);
-					if (sdev->current_queue_depth =3D=3D 0)
-						printk(ALLOC_FAILURE_MSG,
-						       __FUNCTION__);
-				}
-			}
+	if (res !=3D SCSI_SCAN_LUN_PRESENT) =

+		return;
 =

-		for (sdt =3D scsi_devicelist; sdt; sdt =3D sdt->next)
-			if (sdt->finish && sdt->nr_dev)
-				(*sdt->finish) ();
+	BUG_ON(sdev =3D=3D NULL);
 =

+	scsi_build_commandblocks(sdev);
+	if (sdev->current_queue_depth =3D=3D 0) {
+		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		return;
 	}
+
+	for (sdt =3D scsi_devicelist; sdt; sdt =3D sdt->next)
+		if (sdt->init && sdt->dev_noticed)
+			(*sdt->init) ();
+
+	for (sdt =3D scsi_devicelist; sdt; sdt =3D sdt->next)
+		if (sdt->attach)
+			(*sdt->attach) (sdev);
+
+	if (!sdev->attached)
+		scsi_release_commandblocks(sdev);
 }
 =

 /**
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/sd.c	Fri Oct 25 09:19:29 2002
@@ -92,7 +92,6 @@
 static void sd_init_onedisk(Scsi_Disk * sdkp, struct gendisk *disk);
 =

 static int sd_init(void);
-static void sd_finish(void);
 static int sd_attach(Scsi_Device *);
 static int sd_detect(Scsi_Device *);
 static void sd_detach(Scsi_Device *);
@@ -103,23 +102,19 @@
 static struct notifier_block sd_notifier_block =3D {sd_notifier, NULL, 0=
}; =

 =

 static struct Scsi_Device_Template sd_template =3D {
-	module:THIS_MODULE,
-	name:"disk",
-	tag:"sd",
-	scsi_type:TYPE_DISK,
-	major:SCSI_DISK0_MAJOR,
-        /*
-         * Secondary range of majors that this driver handles.
-         */
-	min_major:SCSI_DISK1_MAJOR,
-	max_major:SCSI_DISK7_MAJOR,
-	blk:1,
-	detect:sd_detect,
-	init:sd_init,
-	finish:sd_finish,
-	attach:sd_attach,
-	detach:sd_detach,
-	init_command:sd_init_command,
+	.module		=3D THIS_MODULE,
+	.name		=3D "disk",
+	.tag		=3D "sd",
+	.scsi_type	=3D TYPE_DISK,
+	.major		=3D SCSI_DISK0_MAJOR,
+	.min_major	=3D SCSI_DISK1_MAJOR,
+	.max_major	=3D SCSI_DISK7_MAJOR,
+	.blk		=3D 1,
+	.detect		=3D sd_detect,
+	.init		=3D sd_init,
+	.attach		=3D sd_attach,
+	.detach		=3D sd_detach,
+	.init_command	=3D sd_init_command,
 };
 =

 static void sd_rw_intr(Scsi_Cmnd * SCpnt);
@@ -1291,38 +1286,6 @@
 }
 =

 /**
- *	sd_finish - called during driver initialization, after all
- *	the sd_attach() calls are finished.
- *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function is not called after driver initialization has completed=
=2E
- *	Specifically later device attachments invoke sd_attach() but not
- *	this function.
- **/
-static void sd_finish()
-{
-	int k;
-	Scsi_Disk * sdkp;
-
-	SCSI_LOG_HLQUEUE(3, printk("sd_finish: \n"));
-
-	for (k =3D 0; k < sd_template.dev_max; ++k) {
-		sdkp =3D sd_get_sdisk(k);
-		if (sdkp && (0 =3D=3D sdkp->capacity) && sdkp->device) {
-			sd_init_onedisk(sdkp, sd_disks[k]);
-			if (sdkp->has_been_registered)
-				continue;
-			set_capacity(sd_disks[k], sdkp->capacity);
-			sd_disks[k]->private_data =3D sdkp;
-			sd_disks[k]->queue =3D &sdkp->device->request_queue;
-			add_disk(sd_disks[k]);
-			sdkp->has_been_registered =3D 1;
-		}
-	}
-	return;
-}
-
-/**
  *	sd_detect - called at the start of driver initialization, once =

  *	for each scsi device (not just disks) present.
  *
@@ -1358,13 +1321,12 @@
  **/
 static int sd_attach(Scsi_Device * sdp)
 {
-	Scsi_Disk *sdkp;
+	Scsi_Disk *sdkp =3D NULL;	/* shut up lame gcc warning */
 	int dsk_nr;
 	unsigned long iflags;
 	struct gendisk *gd;
 =

-	if ((NULL =3D=3D sdp) ||
-	    ((sdp->type !=3D TYPE_DISK) && (sdp->type !=3D TYPE_MOD)))
+	if ((sdp->type !=3D TYPE_DISK) && (sdp->type !=3D TYPE_MOD))
 		return 0;
 =

 	gd =3D alloc_disk(16);
@@ -1373,15 +1335,16 @@
 =

 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", =

 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
+
 	if (sd_template.nr_dev >=3D sd_template.dev_max) {
-		sdp->attached--;
 		printk(KERN_ERR "sd_init: no more room for device\n");
-		put_disk(gd);
-		return 1;
+		goto out;
 	}
 =

-/* Assume sd_attach is not re-entrant (for time being) */
-/* Also think about sd_attach() and sd_detach() running coincidentally. =
*/
+	/*
+	 * Assume sd_attach is not re-entrant (for time being)
+	 * Also think about sd_attach() and sd_detach() running coincidentally.=

+	 */
 	write_lock_irqsave(&sd_dsk_arr_lock, iflags);
 	for (dsk_nr =3D 0; dsk_nr < sd_template.dev_max; dsk_nr++) {
 		sdkp =3D sd_dsk_arr[dsk_nr];
@@ -1393,15 +1356,15 @@
 	}
 	write_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
 =

-	if (dsk_nr >=3D sd_template.dev_max) {
-		/* panic("scsi_devices corrupt (sd)");  overkill */
+	if (!sdkp || dsk_nr >=3D sd_template.dev_max) {
 		printk(KERN_ERR "sd_init: sd_dsk_arr corrupted\n");
-		put_disk(gd);
-		return 1;
+		goto out;
 	}
 =

+	sd_init_onedisk(sdkp, gd);
 	sd_template.nr_dev++;
-        gd->de =3D sdp->de;
+
+	gd->de =3D sdp->de;
 	gd->major =3D SD_MAJOR(dsk_nr>>4);
 	gd->first_minor =3D (dsk_nr & 15)<<4;
 	gd->fops =3D &sd_fops;
@@ -1409,14 +1372,26 @@
 		sprintf(gd->disk_name, "sd%c%c",'a'+dsk_nr/26-1,'a'+dsk_nr%26);
 	else
 		sprintf(gd->disk_name, "sd%c",'a'+dsk_nr%26);
-        gd->flags =3D sdp->removable ? GENHD_FL_REMOVABLE : 0;
-        gd->driverfs_dev =3D &sdp->sdev_driverfs_dev;
-        gd->flags |=3D GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	gd->flags =3D sdp->removable ? GENHD_FL_REMOVABLE : 0;
+	gd->driverfs_dev =3D &sdp->sdev_driverfs_dev;
+	gd->flags |=3D GENHD_FL_DRIVERFS | GENHD_FL_DEVFS;
+	gd->private_data =3D sdkp;
+	gd->queue =3D &sdkp->device->request_queue;
+
+	set_capacity(gd, sdkp->capacity);
+	add_disk(gd);
+
 	sd_disks[dsk_nr] =3D gd;
+
 	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
 	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
 	       gd->disk_name, sdp->host->host_no, sdp->channel, sdp->id, sdp->l=
un);
 	return 0;
+
+out:
+	sdp->attached--;
+	put_disk(gd);
+	return 1;
 }
 =

 static int sd_revalidate(struct gendisk *disk)
@@ -1472,10 +1447,7 @@
 	sdkp->capacity =3D 0;
 	/* sdkp->detaching =3D 1; */
 =

-	if (sdkp->has_been_registered) {
-		sdkp->has_been_registered =3D 0;
-		del_gendisk(sd_disks[dsk_nr]);
-	}
+	del_gendisk(sd_disks[dsk_nr]);
 	sdp->attached--;
 	sd_template.dev_noticed--;
 	sd_template.nr_dev--;
@@ -1566,6 +1538,9 @@
 	Scsi_Disk *sdkp =3D sd_get_sdisk(index);
 	Scsi_Device *SDpnt =3D sdkp->device;
 	int retries, the_result;
+
+	if (!SDpnt->online)
+		return 0;
 =

 	if(verbose) {
 		char buf[16];
diff -Nru a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/sd.h	Fri Oct 25 09:19:29 2002
@@ -25,7 +25,6 @@
 	Scsi_Device *device;
 	unsigned char media_present;
 	unsigned char write_prot;
-	unsigned has_been_registered:1;
 	unsigned WCE:1;         /* state of disk WCE bit */
 	unsigned RCD:1;         /* state of disk RCD bit */
 } Scsi_Disk;
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/sg.c	Fri Oct 25 09:19:29 2002
@@ -1607,7 +1607,7 @@
 		sdp->de =3D NULL;
 		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_type);
 		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);
-		put_device(&sdp->sg_driverfs_dev);
+		device_unregister(&sdp->sg_driverfs_dev);
 		if (NULL =3D=3D sdp->headfp)
 			vfree((char *) sdp);
 	}
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/sr.c	Fri Oct 25 09:19:29 2002
@@ -63,27 +63,24 @@
 #define SR_TIMEOUT	(30 * HZ)
 =

 static int sr_init(void);
-static void sr_finish(void);
 static int sr_attach(Scsi_Device *);
 static int sr_detect(Scsi_Device *);
 static void sr_detach(Scsi_Device *);
 =

 static int sr_init_command(Scsi_Cmnd *);
 =

-static struct Scsi_Device_Template sr_template =3D
-{
-	module:THIS_MODULE,
-	name:"cdrom",
-	tag:"sr",
-	scsi_type:TYPE_ROM,
-	major:SCSI_CDROM_MAJOR,
-	blk:1,
-	detect:sr_detect,
-	init:sr_init,
-	finish:sr_finish,
-	attach:sr_attach,
-	detach:sr_detach,
-	init_command:sr_init_command
+static struct Scsi_Device_Template sr_template =3D {
+	.module		=3D THIS_MODULE,
+	.name		=3D "cdrom",
+	.tag		=3D "sr",
+	.scsi_type	=3D TYPE_ROM,
+	.major		=3D SCSI_CDROM_MAJOR,
+	.blk		=3D 1,
+	.detect		=3D sr_detect,
+	.init		=3D sr_init,
+	.attach		=3D sr_attach,
+	.detach		=3D sr_detach,
+	.init_command	=3D sr_init_command
 };
 =

 static Scsi_CD *scsi_CDs;
@@ -91,6 +88,7 @@
 static int sr_open(struct cdrom_device_info *, int);
 static void get_sectorsize(Scsi_CD *);
 static void get_capabilities(Scsi_CD *);
+static int sr_init_one(Scsi_CD *, int);
 =

 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_co=
mmand *);
@@ -473,10 +471,9 @@
 	if (SDp->type !=3D TYPE_ROM && SDp->type !=3D TYPE_WORM)
 		return 1;
 =

-	if (sr_template.nr_dev >=3D sr_template.dev_max) {
-		SDp->attached--;
-		return 1;
-	}
+	if (sr_template.nr_dev >=3D sr_template.dev_max)
+		goto fail;
+
 	for (cpnt =3D scsi_CDs, i =3D 0; i < sr_template.dev_max; i++, cpnt++)
 		if (!cpnt->device)
 			break;
@@ -484,9 +481,11 @@
 	if (i >=3D sr_template.dev_max)
 		panic("scsi_devices corrupt (sr)");
 =

-
 	scsi_CDs[i].device =3D SDp;
 =

+	if (sr_init_one(cpnt, i))
+		goto fail;
+
 	sr_template.nr_dev++;
 	if (sr_template.nr_dev > sr_template.dev_max)
 		panic("scsi_devices corrupt (sr)");
@@ -494,6 +493,10 @@
 	printk("Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n"=
,
 	       scsi_CDs[i].cdi.name, SDp->host->host_no, SDp->channel, SDp->id,=
 SDp->lun);
 	return 0;
+
+fail:
+	SDp->attached--;
+	return 1;
 }
 =

 =

@@ -744,64 +747,56 @@
 	return 1;
 }
 =

-void sr_finish()
+static int sr_init_one(Scsi_CD *cd, int first_minor)
 {
-	int i;
+	struct gendisk *disk;
 =

-	for (i =3D 0; i < sr_template.nr_dev; ++i) {
-		struct gendisk *disk;
-		Scsi_CD *cd =3D &scsi_CDs[i];
-		/* If we have already seen this, then skip it.  Comes up
-		 * with loadable modules. */
-		if (cd->disk)
-			continue;
-		disk =3D alloc_disk(1);
-		if (!disk)
-			continue;
-		if (cd->disk) {
-			put_disk(disk);
-			continue;
-		}
-		disk->major =3D MAJOR_NR;
-		disk->first_minor =3D i;
-		strcpy(disk->disk_name, cd->cdi.name);
-		disk->fops =3D &sr_bdops;
-		disk->flags =3D GENHD_FL_CD;
-		cd->disk =3D disk;
-		cd->capacity =3D 0x1fffff;
-		cd->device->sector_size =3D 2048;/* A guess, just in case */
-		cd->needs_sector_size =3D 1;
-		cd->device->changed =3D 1;	/* force recheck CD type */
+	disk =3D alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	disk->major =3D MAJOR_NR;
+	disk->first_minor =3D first_minor;
+	strcpy(disk->disk_name, cd->cdi.name);
+	disk->fops =3D &sr_bdops;
+	disk->flags =3D GENHD_FL_CD;
+	cd->disk =3D disk;
+	cd->capacity =3D 0x1fffff;
+	cd->device->sector_size =3D 2048;/* A guess, just in case */
+	cd->needs_sector_size =3D 1;
+	cd->device->changed =3D 1;	/* force recheck CD type */
 #if 0
-		/* seems better to leave this for later */
-		get_sectorsize(cd);
-		printk("Scd sectorsize =3D %d bytes.\n", cd->sector_size);
+	/* seems better to leave this for later */
+	get_sectorsize(cd);
+	printk("Scd sectorsize =3D %d bytes.\n", cd->sector_size);
 #endif
-		cd->use =3D 1;
+	cd->use =3D 1;
 =

-		cd->device->ten =3D 1;
-		cd->device->remap =3D 1;
-		cd->readcd_known =3D 0;
-		cd->readcd_cdda =3D 0;
-
-		cd->cdi.ops =3D &sr_dops;
-		cd->cdi.handle =3D cd;
-		cd->cdi.mask =3D 0;
-		cd->cdi.capacity =3D 1;
-		/*
-		 *	FIXME: someone needs to handle a get_capabilities
-		 *	failure properly ??
-		 */
-		get_capabilities(cd);
-		sr_vendor_init(cd);
-		disk->de =3D cd->device->de;
-		disk->driverfs_dev =3D &cd->device->sdev_driverfs_dev;
-		register_cdrom(&cd->cdi);
-		set_capacity(disk, cd->capacity);
-		disk->private_data =3D cd;
-		disk->queue =3D &cd->device->request_queue;
-		add_disk(disk);
-	}
+	cd->device->ten =3D 1;
+	cd->device->remap =3D 1;
+	cd->readcd_known =3D 0;
+	cd->readcd_cdda =3D 0;
+
+	cd->cdi.ops =3D &sr_dops;
+	cd->cdi.handle =3D cd;
+	cd->cdi.mask =3D 0;
+	cd->cdi.capacity =3D 1;
+
+	/*
+	 *	FIXME: someone needs to handle a get_capabilities
+	 *	failure properly ??
+	 */
+	get_capabilities(cd);
+	sr_vendor_init(cd);
+	disk->de =3D cd->device->de;
+	disk->driverfs_dev =3D &cd->device->sdev_driverfs_dev;
+	register_cdrom(&cd->cdi);
+	set_capacity(disk, cd->capacity);
+	disk->private_data =3D cd;
+	disk->queue =3D &cd->device->request_queue;
+	add_disk(disk);
+
+	return 0;
 }
 =

 static void sr_detach(Scsi_Device * SDp)
diff -Nru a/drivers/scsi/sym53c8xx.h b/drivers/scsi/sym53c8xx.h
--- a/drivers/scsi/sym53c8xx.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/sym53c8xx.h	Fri Oct 25 09:19:29 2002
@@ -91,8 +91,6 @@
 			info:           sym53c8xx_info, 	\
 			queuecommand:   sym53c8xx_queue_command,\
 			slave_attach:   sym53c8xx_slave_attach, \
-			abort:          sym53c8xx_abort,	\
-			reset:          sym53c8xx_reset,	\
 			bios_param:     scsicam_bios_param,	\
 			can_queue:      SCSI_NCR_CAN_QUEUE,	\
 			this_id:        7,			\
diff -Nru a/drivers/scsi/wd7000.h b/drivers/scsi/wd7000.h
--- a/drivers/scsi/wd7000.h	Fri Oct 25 09:19:29 2002
+++ b/drivers/scsi/wd7000.h	Fri Oct 25 09:19:29 2002
@@ -49,7 +49,6 @@
 	detect:			wd7000_detect,			\
 	command:		wd7000_command,			\
 	queuecommand:		wd7000_queuecommand,		\
-	abort:			wd7000_abort,			\
 	eh_bus_reset_handler:	wd7000_bus_reset,		\
 	eh_device_reset_handler:wd7000_device_reset,		\
 	eh_host_reset_handler:	wd7000_host_reset,		\

--==_Exmh_-14267596420--


