From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 22/72] ncr5380: Eliminate selecting state
Date: Sun, 06 Dec 2015 12:31:48 +1100
Message-ID: <20151206013132.395468618@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-eliminate-selecting-state
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Linux v2.1.105 changed the algorithm for polling for the BSY signal
in NCR5380_select() and NCR5380_main().

Presently, this code has a bug. Back then, NCR5380_set_timer(hostdata, =
1)
meant reschedule main() after sleeping for 10 ms. Repeated 25 times thi=
s
provided the recommended 250 ms selection time-out delay. This got brok=
en
when HZ became configurable.

We could fix this but there's no need to reschedule the main loop. This
BSY polling presently happens when the NCR5380_main() work queue item
calls NCR5380_select(), which in turn schedules NCR5380_main(), which
calls NCR5380_select() again, and so on.

This algorithm is a deviation from the simpler one in atari_NCR5380.c.
The extra complexity and state is pointless. There's no reason to
stop selection half-way and return to to the main loop when the main
loop can do nothing useful until selection completes.

So just poll for BSY. We can sleep while polling now that we have a
suitable workqueue.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   74 ++++++++--------------------------=
---------
 drivers/scsi/NCR5380.h       |    2 -
 drivers/scsi/atari_NCR5380.c |   49 ++++++++--------------------
 3 files changed, 29 insertions(+), 96 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:54.000000000 +11=
00
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:56.000000000 +1100
@@ -983,7 +983,7 @@ static void NCR5380_main(struct work_str
 	do {
 		/* Lock held here */
 		done =3D 1;
-		if (!hostdata->connected && !hostdata->selecting) {
+		if (!hostdata->connected) {
 			dprintk(NDEBUG_MAIN, "scsi%d : not connected\n", instance->host_no)=
;
 			/*
 			 * Search through the issue_queue for a command destined
@@ -1013,9 +1013,6 @@ static void NCR5380_main(struct work_str
 					 */
 					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for=
 target %d lun %llu removed from issue_queue\n", instance->host_no, tmp=
->device->id, tmp->device->lun);
 =09
-					hostdata->selecting =3D NULL;
-					/* RvC: have to preset this to indicate a new command is being pe=
rformed */
-
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -1033,26 +1030,13 @@ static void NCR5380_main(struct work_str
 						done =3D 0;
 						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main(): select() fa=
iled, returned to issue_queue\n", instance->host_no);
 					}
-					if (hostdata->connected ||
-					    hostdata->selecting)
+					if (hostdata->connected)
 						break;
 					/* lock held here still */
 				}	/* if target/lun is not busy */
 			}	/* for */
 			/* exited locked */
 		}	/* if (!hostdata->connected) */
-		if (hostdata->selecting) {
-			tmp =3D (struct scsi_cmnd *) hostdata->selecting;
-			/* Selection will drop and retake the lock */
-			if (!NCR5380_select(instance, tmp)) {
-				/* OK or bad target */
-			} else {
-				LIST(tmp, hostdata->issue_queue);
-				tmp->host_scribble =3D (unsigned char *) hostdata->issue_queue;
-				hostdata->issue_queue =3D tmp;
-				done =3D 0;
-			}
-		}	/* if hostdata->selecting */
 		if (hostdata->connected
 #ifdef REAL_DMA
 		    && !hostdata->dmalen
@@ -1171,7 +1155,6 @@ static irqreturn_t NCR5380_intr(int dumm
  * Returns : -1 if selection failed but should be retried.
  *      0 if selection failed and should not be retried.
  *      0 if selection succeeded completely (hostdata->connected =3D=3D=
 cmd).
- *      0 if selection in progress (hostdata->selecting =3D=3D cmd).
  *
  * Side effects :=20
  *      If bus busy, arbitration failed, etc, NCR5380_select() will ex=
it=20
@@ -1195,13 +1178,8 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned char tmp[3], phase;
 	unsigned char *data;
 	int len;
-	unsigned long timeout;
-	unsigned char value;
 	int err;
=20
-	if (hostdata->selecting)
-		goto part2;
-
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id =3D %d=
\n", instance->host_no, instance->this_id);
=20
@@ -1337,33 +1315,9 @@ static int NCR5380_select(struct Scsi_Ho
 	 * selection.
 	 */
=20
-	timeout =3D jiffies + msecs_to_jiffies(250);
-
-	/*=20
-	 * XXX very interesting - we're seeing a bounce where the BSY we=20
-	 * asserted is being reflected / still asserted (propagation delay?)
-	 * and it's detecting as true.  Sigh.
-	 */
-
-	hostdata->select_time =3D 0;	/* we count the clock ticks at which we =
polled */
-	hostdata->selecting =3D cmd;
-
-part2:
-	/* RvC: here we enter after a sleeping period, or immediately after
-	   execution of part 1
-	   we poll only once ech clock tick */
-	value =3D NCR5380_read(STATUS_REG) & (SR_BSY | SR_IO);
-
-	if (!value && (hostdata->select_time < HZ/4)) {
-		/* RvC: we still must wait for a device response */
-		hostdata->select_time++;	/* after 25 ticks the device has failed */
-		NCR5380_set_timer(hostdata, 1);
-		return 0;	/* RvC: we return here with hostdata->selecting set,
-				   to go to sleep */
-	}
+	err =3D NCR5380_poll_politely(instance, STATUS_REG, SR_BSY, SR_BSY,
+	                            msecs_to_jiffies(250));
=20
-	hostdata->selecting =3D NULL;/* clear this pointer, because we passed=
 the
-					   waiting period */
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) =3D=3D (SR_SEL | SR=
_IO)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
@@ -1371,6 +1325,17 @@ part2:
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
 	}
+
+	if (err < 0) {
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		cmd->result =3D DID_BAD_TARGET << 16;
+		cmd->scsi_done(cmd);
+		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 25=
0ms\n",
+		        instance->host_no);
+		return 0;
+	}
+
 	/*=20
 	 * No less than two deskew delays after the initiator detects the=20
 	 * BSY signal is true, it shall release the SEL signal and may=20
@@ -1381,15 +1346,6 @@ part2:
=20
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
=20
-	if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		cmd->result =3D DID_BAD_TARGET << 16;
-		cmd->scsi_done(cmd);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 25=
0ms\n", instance->host_no);
-		return 0;
-	}
-
 	/*
 	 * Since we followed the SCSI spec, and raised ATN while SEL=20
 	 * was true but before BSY was false during selection, the informatio=
n
Index: linux/drivers/scsi/NCR5380.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-06 12:29:54.000000000 +11=
00
+++ linux/drivers/scsi/NCR5380.h	2015-12-06 12:29:56.000000000 +1100
@@ -267,8 +267,6 @@ struct NCR5380_hostdata {
 	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconne=
ct */
 	int flags;
 	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
-	int select_time;			/* timer in select for target response */
-	volatile struct scsi_cmnd *selecting;
 	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
 	char info[256];
Index: linux/drivers/scsi/atari_NCR5380.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:54.0000000=
00 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:56.000000000 +1=
100
@@ -1426,7 +1426,7 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned char tmp[3], phase;
 	unsigned char *data;
 	int len;
-	unsigned long timeout;
+	int err;
 	unsigned long flags;
=20
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
@@ -1600,25 +1600,8 @@ static int NCR5380_select(struct Scsi_Ho
 	 * selection.
 	 */
=20
-	timeout =3D jiffies + msecs_to_jiffies(250);
-
-	/*
-	 * XXX very interesting - we're seeing a bounce where the BSY we
-	 * asserted is being reflected / still asserted (propagation delay?)
-	 * and it's detecting as true.  Sigh.
-	 */
-
-#if 0
-	/* ++roman: If a target conformed to the SCSI standard, it wouldn't a=
ssert
-	 * IO while SEL is true. But again, there are some disks out the in t=
he
-	 * world that do that nevertheless. (Somebody claimed that this annou=
nces
-	 * reselection capability of the target.) So we better skip that test=
 and
-	 * only wait for BSY... (Famous german words: Der Kl=C3=BCgere gibt n=
ach :-)
-	 */
-
-	while (time_before(jiffies, timeout) &&
-	       !(NCR5380_read(STATUS_REG) & (SR_BSY | SR_IO)))
-		;
+	err =3D NCR5380_poll_politely(instance, STATUS_REG, SR_BSY, SR_BSY,
+	                            msecs_to_jiffies(250));
=20
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) =3D=3D (SR_SEL | SR=
_IO)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1628,22 +1611,8 @@ static int NCR5380_select(struct Scsi_Ho
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
 	}
-#else
-	while (time_before(jiffies, timeout) && !(NCR5380_read(STATUS_REG) & =
SR_BSY))
-		;
-#endif
-
-	/*
-	 * No less than two deskew delays after the initiator detects the
-	 * BSY signal is true, it shall release the SEL signal and may
-	 * change the DATA BUS.                                     -wingel
-	 */
=20
-	udelay(1);
-
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
-
-	if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
+	if (err < 0) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result =3D DID_BAD_TARGET << 16;
 #ifdef SUPPORT_TAGS
@@ -1656,6 +1625,16 @@ static int NCR5380_select(struct Scsi_Ho
 	}
=20
 	/*
+	 * No less than two deskew delays after the initiator detects the
+	 * BSY signal is true, it shall release the SEL signal and may
+	 * change the DATA BUS.                                     -wingel
+	 */
+
+	udelay(1);
+
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
+
+	/*
 	 * Since we followed the SCSI spec, and raised ATN while SEL
 	 * was true but before BSY was false during selection, the informatio=
n
 	 * transfer phase should be a MESSAGE OUT phase so that we can send t=
he
