From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 15:21:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058559719.1826.106.camel@mulgrave>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave>	<20030716170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org>	<20030717085952.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@suse.de>
	<3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>
	<3F1683F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>
	<3F168846.90902@cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net>
	<1058481553.19508.5.camel@markh1.pdx.osdl.net>
	<1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
	<20030717170055.5dbe20c1.akpm@osdl.org>  <3F17821A.307@cyberone.com.au>
	<1058540605.20130.48.camel@markh1.pdx.osdl.net>
	<1058545730.20130.62.camel@markh1.pdx.osdl.net>
	<1058547377.1826.61.camel@mulgrave>
	<1058550386.20130.75.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0X3/wKXktqbH1TxxFre1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:34820 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270334AbTGRUHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 16:07:19 -0400
In-Reply-To: <1058550386.20130.75.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>


--=-0X3/wKXktqbH1TxxFre1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2003-07-18 at 12:46, Mark Haverkamp wrote:
> I'll try out your test harness on our hardware and see what happens.

OK, I think I found the problem.

Parts of the SCSI and block code don't distinguish between queueing and
requeueing, so they trip over the exact same error.

The (fairly invasive) fix is to add an extra parameter to
blk_insert_request to tell it if this is a reinsertion or a new request
(patch attached--against Jens' previous one).

With this, I now get the AS ioscheduler to survive my tests.

Incidentally, I'm not sure whether scsi_requeue_command() counts as a
reinsertion.  It's used to redo I/O after end_that_request_first() but
before end_that_request_last().

James



--=-0X3/wKXktqbH1TxxFre1
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/block/ll_rw_blk.c 1.195 vs edited =3D=3D=3D=3D=3D
--- 1.195/drivers/block/ll_rw_blk.c	Fri Jul 18 12:36:20 2003
+++ edited/drivers/block/ll_rw_blk.c	Fri Jul 18 14:54:34 2003
@@ -1518,6 +1518,7 @@
  * @rq:		request to be inserted
  * @at_head:	insert request at head or tail of queue
  * @data:	private data
+ * @reinsert:	true if request it a reinsertion of previously processed one
  *
  * Description:
  *    Many block devices need to execute commands asynchronously, so they =
don't
@@ -1532,7 +1533,7 @@
  *    host that is unable to accept a particular command.
  */
 void blk_insert_request(request_queue_t *q, struct request *rq,
-			int at_head, void *data)
+			int at_head, void *data, int reinsert)
 {
 	unsigned long flags;
=20
@@ -1550,11 +1551,15 @@
 	/*
 	 * If command is tagged, release the tag
 	 */
-	if (blk_rq_tagged(rq))
-		blk_queue_end_tag(q, rq);
+	if(reinsert) {
+		blk_requeue_request(q, rq);
+	} else {
+		if (blk_rq_tagged(rq))
+			blk_queue_end_tag(q, rq);
=20
-	drive_stat_acct(rq, rq->nr_sectors, 1);
-	__elv_add_request(q, rq, !at_head, 0);
+		drive_stat_acct(rq, rq->nr_sectors, 1);
+		__elv_add_request(q, rq, !at_head, 0);
+	}
 	q->request_fn(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
=3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.104 vs edited =3D=3D=3D=3D=3D
--- 1.104/drivers/scsi/scsi_lib.c	Fri Jul 18 12:36:25 2003
+++ edited/drivers/scsi/scsi_lib.c	Fri Jul 18 14:54:35 2003
@@ -69,7 +69,7 @@
 	 */
 	sreq->sr_request->flags &=3D ~REQ_DONTPREP;
 	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
-		       	   at_head, sreq);
+		       	   at_head, sreq, 0);
 	return 0;
 }
=20
@@ -147,7 +147,7 @@
 	 * function.  The SCSI request function detects the blocked condition
 	 * and plugs the queue appropriately.
 	 */
-	blk_insert_request(device->request_queue, cmd->request, 1, cmd);
+	blk_insert_request(device->request_queue, cmd->request, 1, cmd, 1);
 	return 0;
 }
=20
@@ -445,7 +445,7 @@
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd=
 *cmd)
 {
 	cmd->request->flags &=3D ~REQ_DONTPREP;
-	blk_insert_request(q, cmd->request, 1, cmd);
+	blk_insert_request(q, cmd->request, 1, cmd, 1);
=20
 	scsi_run_queue(q);
 }
=3D=3D=3D=3D=3D include/linux/blkdev.h 1.118 vs edited =3D=3D=3D=3D=3D
--- 1.118/include/linux/blkdev.h	Fri Jul 18 12:36:34 2003
+++ edited/include/linux/blkdev.h	Fri Jul 18 14:54:35 2003
@@ -490,7 +490,7 @@
 extern void __blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, int);
 extern void blk_put_request(struct request *);
-extern void blk_insert_request(request_queue_t *, struct request *, int, v=
oid *);
+extern void blk_insert_request(request_queue_t *, struct request *, int, v=
oid *, int);
 extern void blk_requeue_request(request_queue_t *, struct request *);
 extern void blk_plug_device(request_queue_t *);
 extern int blk_remove_plug(request_queue_t *);

--=-0X3/wKXktqbH1TxxFre1--

