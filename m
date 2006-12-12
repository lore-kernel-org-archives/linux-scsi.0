From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118
 caused by "pktsetup dvd /dev/sr0"
Date: Tue, 12 Dec 2006 16:21:23 +0200
Message-ID: <457EBAE3.6090609@panasas.com>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:44175 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbWLLO0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 09:26:18 -0500
In-Reply-To: <20061212132600.GA19912@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@osdl.org>, Peter Osterlund <petero2@telia.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, laurent.riffard@free.fr, Adrian Bunk <bunk@stusta.de>

Christoph Hellwig wrote:
> On Tue, Dec 12, 2006 at 11:38:42AM +0100, Christoph Hellwig wrote:
>> This is because the packet driver tries to send down read/write
>> BLOCK_PC commands that don't use a bio and do not use sg lists.
>> As part of the patch you mentioned I added strict assertations for t=
hat
>> case because the scsi layer doesn't handle those anymore.
>>
>> The right fix is to replace all the packet_command stuff in the pack=
et
>> driver by scsi_execute() which needs to be lifted from scsi code to
>> the block code for that.  I'll prepare a patch this weekend unless
>> someone beets me in doing that work.
>=20
> Please try the patch below to fix the bug for now.  It's not the
> full way to a generic execute block pc infrastcuture but should fix
> the bug for the time beeing:
>=20
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>=20
> Index: linux-2.6/drivers/block/pktcdvd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/block/pktcdvd.c	2006-12-12 11:30:45.000000=
000 +0100
> +++ linux-2.6/drivers/block/pktcdvd.c	2006-12-12 14:23:37.000000000 +=
0100
> @@ -765,47 +765,34 @@
>   */
>  static int pkt_generic_packet(struct pktcdvd_device *pd, struct pack=
et_command *cgc)
>  {
> -	char sense[SCSI_SENSE_BUFFERSIZE];
> -	request_queue_t *q;
> +	request_queue_t *q =3D bdev_get_queue(pd->bdev);
>  	struct request *rq;
> -	DECLARE_COMPLETION_ONSTACK(wait);
> -	int err =3D 0;
> +	int ret =3D 0;
> =20
> -	q =3D bdev_get_queue(pd->bdev);
> +	rq =3D blk_get_request(q, (cgc->data_direction =3D=3D CGC_DATA_WRIT=
E) ?
> +			     WRITE : READ, __GFP_WAIT);
> +
> +	if (cgc->buflen) {
> +		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
> +			goto out;
> +	}
> +
> +	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
> +	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
> +	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
> +		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PAC=
KET_SIZE);
> =20
> -	rq =3D blk_get_request(q, (cgc->data_direction =3D=3D CGC_DATA_WRIT=
E) ? WRITE : READ,
> -			     __GFP_WAIT);
> -	rq->errors =3D 0;
> -	rq->rq_disk =3D pd->bdev->bd_disk;
> -	rq->bio =3D NULL;
> -	rq->buffer =3D NULL;
>  	rq->timeout =3D 60*HZ;
> -	rq->data =3D cgc->buffer;
> -	rq->data_len =3D cgc->buflen;
> -	rq->sense =3D sense;
> -	memset(sense, 0, sizeof(sense));
> -	rq->sense_len =3D 0;
>  	rq->cmd_type =3D REQ_TYPE_BLOCK_PC;
>  	rq->cmd_flags |=3D REQ_HARDBARRIER;
>  	if (cgc->quiet)
>  		rq->cmd_flags |=3D REQ_QUIET;
> -	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
> -	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
> -		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PAC=
KET_SIZE);
> -	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
> -
> -	rq->ref_count++;
> -	rq->end_io_data =3D &wait;
> -	rq->end_io =3D blk_end_sync_rq;
> -	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
> -	generic_unplug_device(q);
> -	wait_for_completion(&wait);
> -
> -	if (rq->errors)
> -		err =3D -EIO;
> =20
> +	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
> +	ret =3D rq->errors;
> +out:
>  	blk_put_request(rq);
> -	return err;
> +	return ret;
>  }
> =20
>  /*
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I'm afraid this might not be enough because of code in drivers/ide/ide-=
cd.c. It does IO off of request->data.

[background]
pkt_generic_packet and ton of other places mainly cd(s), floppy(s), and=
 other ide code paths,
are using what I call BLACK requests. They put some data on request->bu=
ffer or request->data
stick it in the Q and than advance on them later down the ladder. Remov=
e of "buffer" and "data" from
struct request will reveal all these places. At one time I had plans to=
 do just that. But 1/2 way through I gave
up, it is too risky, too much Hardware that I don't have, that needs ch=
ecking.

below patch combined with your patch might get a bit closer for this co=
de path.
At struct request I have changed the name of "data" member to "user_dat=
a". than changed the code paths that used
"data" as IO to use request->buffer instead. This is just as bad but is=
 a more common practice.

I suspect there is a problem with what I did in scsi_lib.c Christoph pl=
ease check me out with the new BUG_ON.
Mainly what you need from below is only the code in ide-cd.c.
(And there are 3-4 places that do exactly like pkt_generic_packet, thou=
gh I'm not sure they end up through SCSI.
At first I thought this code doesn't either)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 9eaee66..f52a4f2 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -257,7 +257,7 @@ static void rq_init(request_queue_t *q,
 	rq->q =3D q;
 	rq->special =3D NULL;
 	rq->data_len =3D 0;
-	rq->data =3D NULL;
+	rq->user_data =3D NULL;
 	rq->nr_phys_segments =3D 0;
 	rq->sense =3D NULL;
 	rq->end_io =3D NULL;
@@ -1199,7 +1199,7 @@ void blk_dump_rq_flags(struct request *r
 	printk("\nsector %llu, nr/cnr %lu/%u\n", (unsigned long long)rq->sect=
or,
 						       rq->nr_sectors,
 						       rq->current_nr_sectors);
-	printk("bio %p, biotail %p, buffer %p, data %p, len %u\n", rq->bio, r=
q->biotail, rq->buffer, rq->data, rq->data_len);
+	printk("bio %p, biotail %p, buffer %p, user_data %p, len %u\n", rq->b=
io, rq->biotail, rq->buffer, rq->user_data, rq->data_len);

 	if (blk_pc_request(rq)) {
 		printk("cdb: ");
@@ -2370,7 +2370,7 @@ int blk_rq_map_user(request_queue_t *q,
 		rq->bio =3D rq->biotail =3D bio;
 		blk_rq_bio_prep(q, rq, bio);

-		rq->buffer =3D rq->data =3D NULL;
+		rq->buffer =3D NULL;
 		rq->data_len =3D len;
 		return 0;
 	}
@@ -2420,7 +2420,7 @@ int blk_rq_map_user_iov(request_queue_t

 	rq->bio =3D rq->biotail =3D bio;
 	blk_rq_bio_prep(q, rq, bio);
-	rq->buffer =3D rq->data =3D NULL;
+	rq->buffer =3D NULL;
 	rq->data_len =3D bio->bi_size;
 	return 0;
 }
@@ -2479,7 +2479,7 @@ int blk_rq_map_kern(request_queue_t *q,
 	rq->bio =3D rq->biotail =3D bio;
 	blk_rq_bio_prep(q, rq, bio);

-	rq->buffer =3D rq->data =3D NULL;
+	rq->buffer =3D NULL;
 	rq->data_len =3D len;
 	return 0;
 }
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index dcd9c71..d163a2c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -502,7 +502,6 @@ static int __blk_send_generic(request_qu

 	rq =3D blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type =3D REQ_TYPE_BLOCK_PC;
-	rq->data =3D NULL;
 	rq->data_len =3D 0;
 	rq->timeout =3D BLK_DEFAULT_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index f2904f6..b72758c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -360,9 +360,8 @@ static int pkt_generic_packet(struct pkt
 	rq->errors =3D 0;
 	rq->rq_disk =3D pd->bdev->bd_disk;
 	rq->bio =3D NULL;
-	rq->buffer =3D NULL;
 	rq->timeout =3D 60*HZ;
-	rq->data =3D cgc->buffer;
+	rq->buffer =3D cgc->buffer;
 	rq->data_len =3D cgc->buflen;
 	rq->sense =3D sense;
 	memset(sense, 0, sizeof(sense));
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 8821494..00fce03 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -613,14 +613,14 @@ static void cdrom_queue_request_sense(id
 	/* stuff the sense request in front of our current request */
 	cdrom_prepare_request(drive, rq);

-	rq->data =3D sense;
+	rq->buffer =3D sense;
 	rq->cmd[0] =3D GPCMD_REQUEST_SENSE;
 	rq->cmd[4] =3D rq->data_len =3D 18;

 	rq->cmd_type =3D REQ_TYPE_SENSE;

-	/* NOTE! Save the failed command in "rq->buffer" */
-	rq->buffer =3D (void *) failed_command;
+	/* NOTE! Save the failed command in "rq->user_data" */
+	rq->user_data =3D failed_command;

 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
@@ -632,10 +632,10 @@ static void cdrom_end_request (ide_drive

 	if (blk_sense_request(rq) && uptodate) {
 		/*
-		 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
+		 * For REQ_TYPE_SENSE, "rq->user_data" points to the original
 		 * failed request
 		 */
-		struct request *failed =3D (struct request *) rq->buffer;
+		struct request *failed =3D rq->user_data;
 		struct cdrom_info *info =3D drive->driver_data;
 		void *sense =3D &info->sense_data;
 		unsigned long flags;
@@ -1441,7 +1441,7 @@ static ide_startstop_t cdrom_pc_intr (id
 		    rq->data_len > 0 &&
 		    rq->data_len <=3D 5) {
 			while (rq->data_len > 0) {
-				*(unsigned char *)rq->data++ =3D 0;
+				*(unsigned char *)rq->buffer++ =3D 0;
 				--rq->data_len;
 			}
 		}
@@ -1468,12 +1468,12 @@ static ide_startstop_t cdrom_pc_intr (id

 	/* The drive wants to be written to. */
 	if ((ireason & 3) =3D=3D 0) {
-		if (!rq->data) {
+		if (!rq->buffer) {
 			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
 			goto confused;
 		}
 		/* Transfer the data. */
-		HWIF(drive)->atapi_output_bytes(drive, rq->data, thislen);
+		HWIF(drive)->atapi_output_bytes(drive, rq->buffer, thislen);

 		/* If we haven't moved enough data to satisfy the drive,
 		   add some padding. */
@@ -1484,18 +1484,18 @@ static ide_startstop_t cdrom_pc_intr (id
 		}

 		/* Keep count of how much data we've moved. */
-		rq->data +=3D thislen;
+		rq->buffer +=3D thislen;
 		rq->data_len -=3D thislen;
 	}

 	/* Same drill for reading. */
 	else if ((ireason & 3) =3D=3D 2) {
-		if (!rq->data) {
+		if (!rq->buffer) {
 			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
 			goto confused;
 		}
 		/* Transfer the data. */
-		HWIF(drive)->atapi_input_bytes(drive, rq->data, thislen);
+		HWIF(drive)->atapi_input_bytes(drive, rq->buffer, thislen);

 		/* If we haven't moved enough data to satisfy the drive,
 		   add some padding. */
@@ -1506,7 +1506,7 @@ static ide_startstop_t cdrom_pc_intr (id
 		}

 		/* Keep count of how much data we've moved. */
-		rq->data +=3D thislen;
+		rq->buffer +=3D thislen;
 		rq->data_len -=3D thislen;

 		if (blk_sense_request(rq))
@@ -1644,7 +1644,7 @@ static void post_transform_command(struc
 	if (req->bio)
 		ibuf =3D bio_data(req->bio);
 	else
-		ibuf =3D req->data;
+		ibuf =3D req->buffer;

 	if (!ibuf)
 		return;
@@ -1662,7 +1662,7 @@ typedef void (xfer_func_t)(ide_drive_t *

 /*
  * best way to deal with dma that is not sector aligned right now... n=
ote
- * that in this path we are not using ->data or ->buffer at all. this =
irs
+ * that in this path we are not using ->buffer at all. this irs
  * can replace cdrom_pc_intr, cdrom_read_intr, and cdrom_write_intr in=
 the
  * future.
  */
@@ -1745,7 +1745,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	 */
 	while (thislen > 0) {
 		int blen =3D blen =3D rq->data_len;
-		char *ptr =3D rq->data;
+		char *ptr =3D rq->buffer;

 		/*
 		 * bio backed?
@@ -1772,7 +1772,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		if (rq->bio)
 			end_that_request_chunk(rq, 1, blen);
 		else
-			rq->data +=3D blen;
+			rq->buffer +=3D blen;
 	}

 	/*
@@ -2206,7 +2206,7 @@ static int cdrom_read_capacity(ide_drive

 	req.sense =3D sense;
 	req.cmd[0] =3D GPCMD_READ_CDVD_CAPACITY;
-	req.data =3D (char *)&capbuf;
+	req.buffer =3D (char *)&capbuf;
 	req.data_len =3D sizeof(capbuf);
 	req.cmd_flags |=3D REQ_QUIET;

@@ -2229,7 +2229,7 @@ static int cdrom_read_tocentry(ide_drive
 	cdrom_prepare_request(drive, &req);

 	req.sense =3D sense;
-	req.data =3D  buf;
+	req.buffer =3D  buf;
 	req.data_len =3D buflen;
 	req.cmd_flags |=3D REQ_QUIET;
 	req.cmd[0] =3D GPCMD_READ_TOC_PMA_ATIP;
@@ -2324,7 +2324,7 @@ #endif  /* not STANDARD_ATAPI */
 		   If we get an error for the regular case, we assume
 		   a CDI without additional audio tracks. In this case
 		   the readable TOC is empty (CDI tracks are not included)
-		   and only holds the Leadout entry. Heiko Ei=EF=BF=BDeldt */
+		   and only holds the Leadout entry. Heiko Ei=EF=BF=BDeldt */
 		ntracks =3D 0;
 		stat =3D cdrom_read_tocentry(drive, CDROM_LEADOUT, 1, 0,
 					   (char *)&toc->hdr,
@@ -2426,7 +2426,7 @@ static int cdrom_read_subchannel(ide_dri
 	cdrom_prepare_request(drive, &req);

 	req.sense =3D sense;
-	req.data =3D buf;
+	req.buffer =3D buf;
 	req.data_len =3D buflen;
 	req.cmd[0] =3D GPCMD_READ_SUBCHANNEL;
 	req.cmd[1] =3D 2;     /* MSF addressing */
@@ -2527,7 +2527,7 @@ static int ide_cdrom_packet(struct cdrom
 	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (cgc->sense)
 		memset(cgc->sense, 0, sizeof(struct request_sense));
-	req.data =3D cgc->buffer;
+	req.buffer =3D cgc->buffer;
 	req.data_len =3D cgc->buflen;
 	req.timeout =3D cgc->timeout;

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2614f41..dbf0295 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -141,7 +141,7 @@ enum {

 static void ide_complete_power_step(ide_drive_t *drive, struct request=
 *rq, u8 stat, u8 error)
 {
-	struct request_pm_state *pm =3D rq->data;
+	struct request_pm_state *pm =3D rq->user_data;

 	if (drive->media !=3D ide_disk)
 		return;
@@ -167,7 +167,7 @@ static void ide_complete_power_step(ide_

 static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct=
 request *rq)
 {
-	struct request_pm_state *pm =3D rq->data;
+	struct request_pm_state *pm =3D rq->user_data;
 	ide_task_t *args =3D rq->special;

 	memset(args, 0, sizeof(*args));
@@ -433,7 +433,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 			}
 		}
 	} else if (blk_pm_request(rq)) {
-		struct request_pm_state *pm =3D rq->data;
+		struct request_pm_state *pm =3D rq->user_data;
 #ifdef DEBUG_PM
 		printk("%s: complete_power_step(step: %d, stat: %x, err: %x)\n",
 			drive->name, rq->pm->pm_step, stat, err);
@@ -945,7 +945,7 @@ #endif

 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm =3D rq->data;
+	struct request_pm_state *pm =3D rq->user_data;

 	if (blk_pm_suspend_request(rq) &&
 	    pm->pm_step =3D=3D ide_pm_state_start_suspend)
@@ -1030,7 +1030,7 @@ #endif
 		    rq->cmd_type =3D=3D REQ_TYPE_ATA_TASKFILE)
 			return execute_drive_cmd(drive, rq);
 		else if (blk_pm_request(rq)) {
-			struct request_pm_state *pm =3D rq->data;
+			struct request_pm_state *pm =3D rq->user_data;
 #ifdef DEBUG_PM
 			printk("%s: start_power_step(step: %d)\n",
 				drive->name, rq->pm->pm_step);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 287a662..47a6110 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1223,7 +1223,7 @@ static int generic_ide_suspend(struct de
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type =3D REQ_TYPE_PM_SUSPEND;
 	rq.special =3D &args;
-	rq.data =3D &rqpm;
+	rq.user_data =3D &rqpm;
 	rqpm.pm_step =3D ide_pm_state_start_suspend;
 	if (mesg.event =3D=3D PM_EVENT_PRETHAW)
 		mesg.event =3D PM_EVENT_FREEZE;
@@ -1244,7 +1244,7 @@ static int generic_ide_resume(struct dev
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type =3D REQ_TYPE_PM_RESUME;
 	rq.special =3D &args;
-	rq.data =3D &rqpm;
+	rq.user_data =3D &rqpm;
 	rqpm.pm_step =3D ide_pm_state_start_resume;
 	rqpm.pm_state =3D PM_EVENT_ON;

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fb616c6..bea6e9e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -351,7 +351,7 @@ static int scsi_req_map_sg(struct reques
 		}
 	}

-	rq->buffer =3D rq->data =3D NULL;
+	rq->buffer =3D NULL;
 	rq->data_len =3D data_len;
 	return 0;

@@ -1116,12 +1116,11 @@ static int scsi_setup_blk_pc_cmnd(struct
 			return ret;
 	} else {
 		BUG_ON(req->data_len);
-		BUG_ON(req->data);
+		BUG_ON(req->buffer);

 		cmd->request_bufflen =3D 0;
 		cmd->request_buffer =3D NULL;
 		cmd->use_sg =3D 0;
-		req->buffer =3D NULL;
 	}

 	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7bfcde2..beb1f8d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -288,7 +288,8 @@ struct request {
 	unsigned short ioprio;

 	void *special;
-	char *buffer;
+	char *buffer;			/* FIXME: Deprecated */
+	void *user_data;		/* FIXME: used to be *data. Deprecated this allread=
y */

 	int tag;
 	int errors;
@@ -303,7 +304,6 @@ struct request {

 	unsigned int data_len;
 	unsigned int sense_len;
-	void *data;
 	void *sense;

 	unsigned int timeout;




-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
