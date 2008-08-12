From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Tue, 12 Aug 2008 11:24:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808121120130.2248-100000@iolanthe.rowland.org>
References: <48A15318.30600@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48A15318.30600-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Aug 2008, Alan Jenkins wrote:

> > This suggests that we need to change the call to scsi_end_request() at 
> > the end of scsi_io_completion().  If result is nonzero then nothing 
> > will be requeued, so this_count should be replaced with the total 
> > number of bytes remaining in the request.  Does that sound reasonable?

> It sounds a bit like the hangs that happened with my buggy card reader. 
> My card reader returned errors because of the IO patterns from the first
> version of the last_sector_bug flag.  But instead of reads returning
> with errors, I just ended up with hung processes.
> 
> It's great to see this tracked down.  Keep me CC'd and I'll test
> whatever patch you come up with.  I can simulate the old last_sector_bug
> behaviour by changing SD_LAST_BUGGY_SECTORS to 1 (instead of 8).

Well, here's a patch that fixes the problem.  However I'm not certain
it's the right thing to do.  (The first hunk has nothing to do with
this; it is just a comment change.  I simply can't stand the existing
comment -- it is wrong in at least three respects.)

James, what do you think?

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -909,8 +909,8 @@ void scsi_io_completion(struct scsi_cmnd
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
+	/* There are leftovers and result != 0, so scsi_end_request couldn't
+	 * requeue the remainder and we have to retry it.
 	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
@@ -1015,6 +1015,10 @@ void scsi_io_completion(struct scsi_cmnd
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
+
+		/* Fail the entire remainder of the request. */
+		this_count = (blk_pc_request(req) ? req->data_len :
+				(req->hard_nr_sectors << 9));
 	}
 	scsi_end_request(cmd, -EIO, this_count, !result);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
