From: "Juergen E. Fischer" <fischer@linux-buechse.de>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Thu, 30 Oct 2003 22:19:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031030211938.GA17485@linux-buechse.de>
References: <20031027155713.GA28140@lst.de> <20031027160101.76d5291b.rddunlap@osdl.org> <20031028090600.GA7370@lst.de> <20031028124536.3ce82c23.rddunlap@osdl.org> <3F9EF2B4.9030708@us.ibm.com> <20031028162610.6dcfd06e.rddunlap@osdl.org> <20031029122008.GA5903@linux-buechse.de> <1067439510.1829.4.camel@mulgrave> <20031029175621.GB5903@linux-buechse.de> <1067451264.1829.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD9ED1467.dip.t-dialin.net ([217.237.20.103]:40132 "EHLO
	linux-buechse.de") by vger.kernel.org with ESMTP id S262838AbTJ3VXN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 16:23:13 -0500
Content-Disposition: inline
In-Reply-To: <1067451264.1829.37.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, fischer@norbit.de


--kORqDWCi7qDJ0mEj
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, Oct 29, 2003 at 12:10:17 -0600, James Bottomley wrote:
> On Wed, 2003-10-29 at 11:56, Juergen E. Fischer wrote:
> > Why not?  It's a new command after all and if the initialization is
> > done correctly (ie. ->device is setup) it works the way it is now.
>=20
> The usual reason is that ACA emulation is turned around in interrupt
> context, so new memory allocations should be avoided if they can be.

ok, attached patch does it that way and also fixes two other problems I
noticed:=20

1. unloading the module with two controllers present didn't work,
2. there was a race in is_complete.


J=FCrgen


--=20
Well, let's just say, 'if your VCR is still blinking 12:00, you don't
want Linux'.
  -- Bruce Perens

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="aha152x.diff"
Content-Transfer-Encoding: quoted-printable

--- aha152x.c.orig	2003-10-29 18:53:59.000000000 +0100
+++ aha152x.c	2003-10-30 21:58:10.000000000 +0100
@@ -13,9 +13,16 @@
  * General Public License for more details.
  *
  *
- * $Id: aha152x.c,v 2.5 2002/04/14 11:24:53 fischer Exp $
+ * $Id: aha152x.c,v 2.6 2003/10/30 20:52:47 fischer Exp $
  *
  * $Log: aha152x.c,v $
+ * Revision 2.6  2003/10/30 20:52:47  fischer
+ * - interfaces changes for kernel 2.6
+ * - aha152x_probe_one introduced for pcmcia stub
+ * - fixed pnpdev handling
+ * - instead of allocation a new one, reuse command for request sense afte=
r check condition and reset
+ * - fixes race in is_complete
+ *
  * Revision 2.5  2002/04/14 11:24:53  fischer
  * - isapnp support
  * - abort fixed
@@ -330,6 +337,7 @@
 	syncneg		=3D 0x0100,	/* synchronous negotiation in progress */
 	aborting	=3D 0x0200,	/* ABORT is pending */
 	resetting	=3D 0x0400,	/* BUS DEVICE RESET is pending */
+	check_condition =3D 0x0800,	/* requesting sense after CHECK CONDITION */
 };
=20
 MODULE_AUTHOR("J=FCrgen Fischer");
@@ -450,7 +458,8 @@
 		/* host lock */
=20
 #if defined(AHA152X_DEBUG)
-	char *locker;	/* which function has the lock */
+	const char *locker;
+		/* which function has the lock */
 	int lockerl;	/* where did it get it */
=20
 	int debug;	/* current debugging setting */
@@ -516,6 +525,10 @@
=20
 	unsigned long io_port0;
 	unsigned long io_port1;
+
+#ifdef __ISAPNP__
+	struct pnp_dev *pnpdev;
+#endif
 };
=20
=20
@@ -525,7 +538,6 @@
  */
 struct aha152x_scdata {
 	Scsi_Cmnd *next;	/* next sc in queue */
-	Scsi_Cmnd *done;	/* done command */
 	struct semaphore *sem;	/* semaphore to block on */
 };
=20
@@ -578,7 +590,6 @@
=20
 #define SCDATA(SCpnt)		((struct aha152x_scdata *) (SCpnt)->host_scribble)
 #define SCNEXT(SCpnt)		SCDATA(SCpnt)->next
-#define SCDONE(SCpnt)		SCDATA(SCpnt)->done
 #define SCSEM(SCpnt)		SCDATA(SCpnt)->sem
=20
 #define SG_ADDRESS(buffer)	((char *) (page_address((buffer)->page)+(buffer=
)->offset))
@@ -949,55 +960,47 @@
 	return IRQ_HANDLED;
 }
=20
-#ifdef __ISAPNP__
-static struct pnp_dev *pnpdev[2];
-static int num_pnpdevs;
-#endif
=20
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 {
-	struct Scsi_Host *shost, *shpnt;
-	struct aha152x_hostdata *aha;
+	struct Scsi_Host *shpnt;
=20
-	/* XXX: shpnt is needed for some broken macros */
-	shost =3D shpnt =3D scsi_register(&aha152x_driver_template,
-					sizeof(struct aha152x_hostdata));
-	if (!shost) {
+	shpnt =3D scsi_register(&aha152x_driver_template, sizeof(struct aha152x_h=
ostdata));
+	if (!shpnt) {
 		printk(KERN_ERR "aha152x: scsi_register failed\n");
 		return NULL;
 	}
=20
-	aha =3D (struct aha152x_hostdata *)&shost->hostdata;
-	memset(aha, 0, sizeof(*aha));
+	memset(HOSTDATA(shpnt), 0, sizeof *HOSTDATA(shpnt));
=20
-	shost->io_port   =3D setup->io_port;
-	shost->n_io_port =3D IO_RANGE;
-	shost->irq       =3D setup->irq;
+	shpnt->io_port   =3D setup->io_port;
+	shpnt->n_io_port =3D IO_RANGE;
+	shpnt->irq       =3D setup->irq;
=20
 	if (!setup->tc1550) {
-		aha->io_port0 =3D setup->io_port;
-		aha->io_port1 =3D setup->io_port;
+		HOSTIOPORT0 =3D setup->io_port;
+		HOSTIOPORT1 =3D setup->io_port;
 	} else {
-		aha->io_port0 =3D setup->io_port+0x10;
-		aha->io_port1 =3D setup->io_port-0x10;
+		HOSTIOPORT0 =3D setup->io_port+0x10;
+		HOSTIOPORT1 =3D setup->io_port-0x10;
 	}
=20
-	spin_lock_init(&aha->lock);
-	aha->reconnect =3D setup->reconnect;
-	aha->synchronous =3D setup->synchronous;
-	aha->parity =3D setup->parity;
-	aha->delay =3D setup->delay;
-	aha->ext_trans =3D setup->ext_trans;
+	spin_lock_init(&QLOCK);
+	RECONNECT   =3D setup->reconnect;
+	SYNCHRONOUS =3D setup->synchronous;
+	PARITY      =3D setup->parity;
+	DELAY       =3D setup->delay;
+	EXT_TRANS   =3D setup->ext_trans;
=20
 #if defined(AHA152X_DEBUG)
-	aha->debug =3D setup->debug;
+	HOSTDATA(shpnt)->debug =3D setup->debug;
 #endif
=20
 	SETPORT(SCSIID, setup->scsiid << 4);
-	shost->this_id =3D setup->scsiid;
+	shpnt->this_id =3D setup->scsiid;
=20
 	if (setup->reconnect)
-		shost->can_queue =3D AHA152X_MAXQUEUE;
+		shpnt->can_queue =3D AHA152X_MAXQUEUE;
=20
 	/* RESET OUT */
 	printk("aha152x: resetting bus...\n");
@@ -1006,7 +1009,7 @@
 	SETPORT(SCSISEQ, 0);
 	mdelay(DELAY);
=20
-	reset_ports(shost);
+	reset_ports(shpnt);
=20
 	printk(KERN_INFO
 	       "aha152x%d%s: "
@@ -1019,43 +1022,41 @@
 	       "synchronous=3D%s, "
 	       "delay=3D%d, "
 	       "extended translation=3D%s\n",
-	       shost->host_no, setup->tc1550 ? " (tc1550 mode)" : "",
+	       shpnt->host_no, setup->tc1550 ? " (tc1550 mode)" : "",
 	       GETPORT(REV) & 0x7,
-	       shost->io_port, aha->io_port0, aha->io_port1,
-	       shost->irq,
-	       shost->this_id,
-	       aha->reconnect ? "enabled" : "disabled",
-	       aha->parity ? "enabled" : "disabled",
-	       aha->synchronous ? "enabled" : "disabled",
-	       aha->delay,
-	       aha->ext_trans ? "enabled" : "disabled");
+	       shpnt->io_port, HOSTIOPORT0, HOSTIOPORT1,
+	       shpnt->irq,
+	       shpnt->this_id,
+	       RECONNECT ? "enabled" : "disabled",
+	       PARITY ? "enabled" : "disabled",
+	       SYNCHRONOUS ? "enabled" : "disabled",
+	       DELAY,
+	       EXT_TRANS ? "enabled" : "disabled");
=20
-	if (!request_region(shost->io_port, IO_RANGE, "aha152x"))
+	if (!request_region(shpnt->io_port, IO_RANGE, "aha152x"))
 		goto out_unregister;
=20
 	/* not expecting any interrupts */
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
=20
-	if (request_irq(shost->irq, swintr, SA_INTERRUPT|SA_SHIRQ,
-			"aha152x", shost) < 0) {
-		printk(KERN_ERR "aha152x%d: driver needs an IRQ.\n", shost->host_no);
+	if (request_irq(shpnt->irq, swintr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shp=
nt) < 0) {
+		printk(KERN_ERR "aha152x%d: driver needs an IRQ.\n", shpnt->host_no);
 		goto out_release_region;
 	}
=20
-	aha->swint =3D 0;
+	HOSTDATA(shpnt)->swint =3D 0;
=20
-	printk(KERN_INFO "aha152x%d: trying software interrupt, ",
-			 shost->host_no);
+	printk(KERN_INFO "aha152x%d: trying software interrupt, ", shpnt->host_no=
);
=20
 	/* need to have host registered before triggering any interrupt */
-	aha152x_host[registered_count] =3D shost;
+	aha152x_host[registered_count] =3D shpnt;
 	mb();
 	SETPORT(DMACNTRL0, SWINT|INTEN);
 	mdelay(1000);
-	free_irq(shost->irq, shost);
+	free_irq(shpnt->irq, shpnt);
=20
-	if (!aha->swint) {
+	if (!HOSTDATA(shpnt)->swint) {
 		if (TESTHI(DMASTAT, INTSTAT)) {
 			printk("lost.\n");
 		} else {
@@ -1065,7 +1066,7 @@
 		SETPORT(DMACNTRL0, INTEN);
=20
 		printk(KERN_ERR "aha152x%d: IRQ %d possibly wrong.  "
-				"Please verify.\n", shost->host_no, shost->irq);
+				"Please verify.\n", shpnt->host_no, shpnt->irq);
 		goto out_unregister_host;
 	}
 	printk("ok.\n");
@@ -1075,20 +1076,18 @@
 	SETPORT(SSTAT0, 0x7f);
 	SETPORT(SSTAT1, 0xef);
=20
-	if (request_irq(shost->irq, intr, SA_INTERRUPT|SA_SHIRQ,
-				"aha152x", shost) < 0) {
-		printk(KERN_ERR "aha152x%d: failed to reassign interrupt.\n",
-				shost->host_no);
+	if (request_irq(shpnt->irq, intr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shpnt=
) < 0) {
+		printk(KERN_ERR "aha152x%d: failed to reassign interrupt.\n", shpnt->hos=
t_no);
 		goto out_unregister_host;
 	}
-	return shost;	/* the pcmcia stub needs the return value; */
+	return shpnt;	/* the pcmcia stub needs the return value; */
=20
 out_unregister_host:
 	aha152x_host[registered_count] =3D NULL;
 out_release_region:
-	release_region(shost->io_port, IO_RANGE);
+	release_region(shpnt->io_port, IO_RANGE);
 out_unregister:
-	scsi_unregister(shost);
+	scsi_unregister(shpnt);
 	return NULL;
 }
=20
@@ -1097,9 +1096,9 @@
 	int i, j, ok;
 #if defined(AUTOCONF)
 	aha152x_config conf;
-#ifdef __ISAPNP__
-	struct pnp_dev *dev =3D NULL;
 #endif
+#ifdef __ISAPNP__
+	struct pnp_dev *dev=3D0, *pnpdev[2] =3D {0, 0};
 #endif
=20
 	if (setup_count) {
@@ -1269,7 +1268,7 @@
 #if defined(AHA152X_DEBUG)
 		setup[setup_count].debug       =3D DEBUG_DEFAULT;
 #endif
-		pnpdev[num_pnpdevs++] =3D dev;
+		pnpdev[setup_count]            =3D dev;
 		printk (KERN_INFO
 			"aha152x: found ISAPnP AVA-1505A at io=3D0x%03x, irq=3D%d\n",
 			setup[setup_count].io_port, setup[setup_count].irq);
@@ -1277,7 +1276,6 @@
 	}
 #endif
=20
-
 #if defined(AUTOCONF)
 	if (setup_count<ARRAY_SIZE(setup)) {
 #if !defined(SKIP_BIOSTEST)
@@ -1350,8 +1348,13 @@
=20
 	for (i=3D0; i<setup_count; i++) {
 		aha152x_probe_one(&setup[i]);
-		if (aha152x_host[registered_count])
+		if (aha152x_host[registered_count]) {
+#ifdef __ISAPNP__
+			if(pnpdev[i])
+				HOSTDATA(aha152x_host[registered_count])->pnpdev=3Dpnpdev[i];
+#endif
 			registered_count++;
+		}
 	}
=20
 	return registered_count>0;
@@ -1367,9 +1370,10 @@
 		release_region(shpnt->io_port, IO_RANGE);
=20
 #ifdef __ISAPNP__
-	while (num_pnpdevs--)
-		pnp_device_detach(pnpdev[num_pnpdevs]);
+	if (HOSTDATA(shpnt)->pnpdev)
+		pnp_device_detach(HOSTDATA(shpnt)->pnpdev);
 #endif
+
 	scsi_unregister(shpnt);
=20
 	return 0;
@@ -1418,7 +1422,7 @@
 /*=20
  *  Queue a command and setup interrupts for a free bus.
  */
-static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct semaphore *sem,=
 int phase, Scsi_Cmnd *done_SC, void (*done)(Scsi_Cmnd *))
+static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct semaphore *sem,=
 int phase, void (*done)(Scsi_Cmnd *))
 {
 	struct Scsi_Host *shpnt =3D SCpnt->device->host;
 	unsigned long flags;
@@ -1438,14 +1442,21 @@
 	SCpnt->SCp.Message	=3D 0;
 	SCpnt->SCp.have_data_in	=3D 0;
 	SCpnt->SCp.sent_command	=3D 0;
-	SCpnt->host_scribble    =3D kmalloc(sizeof(struct aha152x_scdata), GFP_AT=
OMIC);
-	if(!SCpnt->host_scribble) {
-		printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
-		return FAILED;
+
+	if(SCpnt->SCp.phase & (resetting|check_condition)) {
+		if(SCpnt->host_scribble=3D=3D0 || SCSEM(SCpnt) || SCNEXT(SCpnt)) {
+			printk(ERR_LEAD "cannot reuse command\n", CMDINFO(SCpnt));
+			return FAILED;
+		}
+	} else {
+		SCpnt->host_scribble    =3D kmalloc(sizeof(struct aha152x_scdata), GFP_A=
TOMIC);
+		if(SCpnt->host_scribble=3D=3D0) {
+			printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
+			return FAILED;
+		}
 	}
=20
 	SCNEXT(SCpnt)		=3D 0;
-	SCDONE(SCpnt)		=3D done_SC;
 	SCSEM(SCpnt)		=3D sem;
=20
 	/* setup scratch area
@@ -1487,6 +1498,10 @@
 	return 0;
 }
=20
+/*
+ *  queue a command
+ *
+ */
 static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
 #if 0
@@ -1498,23 +1513,25 @@
 	}
 #endif
=20
-	return aha152x_internal_queue(SCpnt, 0, 0, 0, done);
+	return aha152x_internal_queue(SCpnt, 0, 0, done);
 }
=20
=20
 /*
- *  run a command
+ * =20
  *
  */
-static void internal_done(Scsi_Cmnd *SCpnt)
+static void reset_done(Scsi_Cmnd *SCpnt)
 {
 #if 0
 	struct Scsi_Host *shpnt =3D SCpnt->host;
-
-	DPRINTK(debug_eh, INFO_LEAD "internal_done called\n", CMDINFO(SCpnt));
+	DPRINTK(debug_eh, INFO_LEAD "reset_done called\n", CMDINFO(SCpnt));
 #endif
-	if(SCSEM(SCpnt))
+	if(SCSEM(SCpnt)) {
 		up(SCSEM(SCpnt));
+	} else {
+		printk(KERN_ERR "aha152x: reset_done w/o semaphore\n");
+	}
 }
=20
 /*
@@ -1600,7 +1617,6 @@
 	struct Scsi_Host *shpnt =3D SCpnt->device->host;
 	DECLARE_MUTEX_LOCKED(sem);
 	struct timer_list timer;
-	Scsi_Cmnd *cmd;
 	int ret;
=20
 #if defined(AHA152X_DEBUG)
@@ -1615,40 +1631,32 @@
 		return FAILED;
 	}
=20
-	spin_unlock_irq(shpnt->host_lock);
-	cmd =3D scsi_get_command(SCpnt->device, GFP_ATOMIC);
-	if (!cmd) {
-		spin_lock_irq(shpnt->host_lock);
-		return FAILED;
-	}
-
-	cmd->cmd_len         =3D 0;
-	cmd->device->host    =3D SCpnt->device->host;
-	cmd->device->id      =3D SCpnt->device->id;
-	cmd->device->lun     =3D SCpnt->device->lun;
-	cmd->use_sg          =3D 0;
-	cmd->request_buffer  =3D 0;
-	cmd->request_bufflen =3D 0;
+	SCpnt->cmd_len         =3D 0;
+	SCpnt->use_sg          =3D 0;
+	SCpnt->request_buffer  =3D 0;
+	SCpnt->request_bufflen =3D 0;
=20
 	init_timer(&timer);
 	timer.data     =3D (unsigned long) cmd;
 	timer.expires  =3D jiffies + 100*HZ;   /* 10s */
 	timer.function =3D (void (*)(unsigned long)) timer_expired;
=20
-	aha152x_internal_queue(cmd, &sem, resetting, 0, internal_done);
-
+	aha152x_internal_queue(SCpnt, &sem, resetting, reset_done);
 	add_timer(&timer);
 	down(&sem);
-
 	del_timer(&timer);
=20
-	if(cmd->SCp.phase & resetted) {
+	SCpnt->cmd_len         =3D SCpnt->old_cmd_len;
+	SCpnt->use_sg          =3D SCpnt->old_use_sg;
+  	SCpnt->request_buffer  =3D SCpnt->buffer;
+       	SCpnt->request_bufflen =3D SCpnt->bufflen;
+
+	if(SCpnt->SCp.phase & resetted) {
 		ret =3D SUCCESS;
 	} else {
 		ret =3D FAILED;
 	}
=20
-	scsi_put_command(cmd);
 	spin_lock_irq(shpnt->host_lock);
 	return ret;
 }
@@ -1975,23 +1983,26 @@
 #if defined(AHA152X_STAT)
 		action++;
 #endif
-		if(SCDONE(DONE_SC)) {
-			Scsi_Cmnd *ptr=3DDONE_SC;
-			DONE_SC=3DSCDONE(DONE_SC);
-
+		if(DONE_SC->SCp.phase & check_condition) {
 #if 0
 			if(HOSTDATA(shpnt)->debug & debug_eh) {
-				printk(ERR_LEAD "received sense: ", CMDINFO(ptr));
+				printk(ERR_LEAD "received sense: ", CMDINFO(DONE_SC));
 				print_sense("bh", DONE_SC);
 			}
 #endif
=20
+			/* restore old command */
+			memcpy((void *) DONE_SC->cmnd, (void *) DONE_SC->data_cmnd, sizeof(DONE=
_SC->data_cmnd));
+			DONE_SC->request_buffer  =3D DONE_SC->buffer;
+			DONE_SC->request_bufflen =3D DONE_SC->bufflen;
+			DONE_SC->use_sg          =3D DONE_SC->old_use_sg;
+			DONE_SC->cmd_len         =3D DONE_SC->old_cmd_len;
+
+			DONE_SC->SCp.Status =3D 0x02;
+
 			HOSTDATA(shpnt)->commands--;
 			if (!HOSTDATA(shpnt)->commands)
 				SETPORT(PORTA, 0);	/* turn led off */
-
-			kfree(ptr->host_scribble);
-			kfree(ptr);
 		} else if(DONE_SC->SCp.Status=3D=3D0x02) {
 #if defined(AHA152X_STAT)
 			HOSTDATA(shpnt)->busfree_with_check_condition++;
@@ -2001,42 +2012,30 @@
 #endif
=20
 			if(!(DONE_SC->SCp.Status & not_issued)) {
-				Scsi_Cmnd *cmnd =3D kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
-
-				if(cmnd) {
-					Scsi_Cmnd *ptr=3DDONE_SC;
-					DONE_SC=3D0;
-
 #if 0
-					DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
+				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(DONE_SC));
 #endif
=20
-					cmnd->cmnd[0]         =3D REQUEST_SENSE;
-					cmnd->cmnd[1]         =3D 0;
-					cmnd->cmnd[2]         =3D 0;
-					cmnd->cmnd[3]         =3D 0;
-					cmnd->cmnd[4]         =3D sizeof(ptr->sense_buffer);
-					cmnd->cmnd[5]         =3D 0;
-					cmnd->cmd_len	      =3D 6;
-					cmnd->device->host    =3D ptr->device->host;
-					cmnd->device->id      =3D ptr->device->id;
-					cmnd->device->lun     =3D ptr->device->lun;
-					cmnd->use_sg          =3D 0;=20
-					cmnd->request_buffer  =3D ptr->sense_buffer;
-					cmnd->request_bufflen =3D sizeof(ptr->sense_buffer);
+				DONE_SC->cmnd[0]         =3D REQUEST_SENSE;
+				DONE_SC->cmnd[1]         =3D 0;
+				DONE_SC->cmnd[2]         =3D 0;
+				DONE_SC->cmnd[3]         =3D 0;
+				DONE_SC->cmnd[4]         =3D sizeof(DONE_SC->sense_buffer);
+				DONE_SC->cmnd[5]         =3D 0;
+				DONE_SC->cmd_len         =3D 6;
+				DONE_SC->use_sg          =3D 0;=20
+				DONE_SC->request_buffer  =3D DONE_SC->sense_buffer;
+				DONE_SC->request_bufflen =3D sizeof(DONE_SC->sense_buffer);
 		=09
-					DO_UNLOCK(flags);
-					aha152x_internal_queue(cmnd, 0, 0, ptr, internal_done);
-					DO_LOCK(flags);
-				} else {
-					printk(ERR_LEAD "allocation failed\n", CMDINFO(CURRENT_SC));
-					if(cmnd)
-						kfree(cmnd);
-				}
+				DO_UNLOCK(flags);
+				aha152x_internal_queue(DONE_SC, 0, check_condition, DONE_SC->scsi_done=
);
+				DO_LOCK(flags);
+
+				DONE_SC=3D0;
 			} else {
 #if 0
 				DPRINTK(debug_eh, ERR_LEAD "command not issued - CHECK CONDITION ignor=
ed\n", CMDINFO(DONE_SC));
-#endif			=09
+#endif
 			}
 		}
=20
@@ -2946,13 +2945,12 @@
 	int pending;
=20
 	DO_LOCK(flags);
-	if(HOSTDATA(shpnt)->in_intr!=3D0) {
+	if(HOSTDATA(shpnt)->in_intr) {
 		DO_UNLOCK(flags);
 		/* aha152x_error never returns.. */
 		aha152x_error(shpnt, "bottom-half already running!?");
 	}
 	HOSTDATA(shpnt)->in_intr++;
-	DO_UNLOCK(flags);
=20
 	/*
 	 * loop while there are interrupt conditions pending
@@ -2960,6 +2958,8 @@
 	 */
 	do {
 		unsigned long start =3D jiffies;
+		DO_UNLOCK(flags);
+
 		dataphase=3Dupdate_state(shpnt);
=20
 		DPRINTK(debug_phases, LEAD "start %s %s(%s)\n", CMDINFO(CURRENT_SC), sta=
tes[STATE].name, states[PREVSTATE].name, states[LASTSTATE].name);
@@ -3035,7 +3035,6 @@
 			HOSTDATA(shpnt)->count_trans[STATE]++;
 		HOSTDATA(shpnt)->time[STATE] +=3D jiffies-start;
 #endif
-		DO_UNLOCK(flags);
=20
 		DPRINTK(debug_phases, LEAD "end %s %s(%s)\n", CMDINFO(CURRENT_SC), state=
s[STATE].name, states[PREVSTATE].name, states[LASTSTATE].name);
 	} while(pending);
@@ -3044,7 +3043,6 @@
 	 * enable interrupts and leave bottom-half
 	 *
 	 */
-	DO_LOCK(flags);
 	HOSTDATA(shpnt)->in_intr--;
 	SETBITS(DMACNTRL0, INTEN);
 	DO_UNLOCK(flags);

--PNTmBPCT7hxwcZjr--

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/oYBqc/GhTF5ESHURArutAJ90mTzGvtGmeQmAqTXfXuJB7k3gYQCfQYDm
EjXuKaOGB7sZU/CA8/l/rkE=
=xBte
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
