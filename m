From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix for memory leak in scsi_prep_fn
Date: 28 Jan 2003 12:52:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043779950.2991.101.camel@mulgrave>
References: <1043778768.2991.74.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-EYfexEwJWTWwhbl0uz1I"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA03662
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2003 10:52:32 -0800
In-Reply-To: <1043778768.2991.74.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>


--=-EYfexEwJWTWwhbl0uz1I
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2003-01-28 at 12:32, James Bottomley wrote:
> This should fix the memory leak Russell King spotted if command
> initialisation fails in the request prep function.
> 
> The patch is against the scsi-combined-2.5 bkbits.net repository.

Well, OK, I had a closer look at what scsi_init_io is doing.  I
obviously don't want to release the command for a defer.  However,
there's also a bug in scsi_init_io which can cause
end_that_request_first to be called twice for the request.

This hopefully corrects that problem as well as the command leakage.

James


--=-EYfexEwJWTWwhbl0uz1I
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.63 vs edited =3D=3D=3D=3D=3D
--- 1.63/drivers/scsi/scsi_lib.c	Tue Jan 28 10:19:35 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Jan 28 12:43:38 2003
@@ -781,11 +781,8 @@
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
=20
-	/*
-	 * kill it. there should be no leftover blocks in this request
-	 */
-	SCpnt =3D scsi_end_request(SCpnt, 0, req->nr_sectors, 1);
-	BUG_ON(SCpnt);
+	/* release the command and kill it */
+	scsi_put_command(SCpnt);
 	ret =3D BLKPREP_KILL;
 out:
 	return ret;
@@ -884,6 +881,7 @@
 		 * required).
 		 */
 		if ((ret =3D scsi_init_io(SCpnt)))
+			/* BLKPREP_KILL return also releases the command */
 			return ret;
 	=09
 		/*
@@ -891,6 +889,7 @@
 		 */
 		if (!STpnt->init_command(SCpnt)) {
 			scsi_release_buffers(SCpnt);
+			scsi_put_command(SCpnt);
 			return BLKPREP_KILL;
 		}
 	}

--=-EYfexEwJWTWwhbl0uz1I--

