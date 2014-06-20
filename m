From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Fri, 20 Jun 2014 20:29:56 +0200
Message-ID: <20140620182956.GB24389@soda.linbit>
References: <53A28B21.7070500@profihost.ag>
 <yq1ionwjn15.fsf@sermon.lab.mkp.net>
 <20140620155321.GA24389@soda.linbit>
 <yq1wqcbil0c.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zimbra13.linbit.com ([212.69.166.240]:36387 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaFTS37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2014 14:29:59 -0400
Content-Disposition: inline
In-Reply-To: <yq1wqcbil0c.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>

On Fri, Jun 20, 2014 at 12:49:39PM -0400, Martin K. Petersen wrote:
> >>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:
> 
> Lars,
> 
> Lars> Any bio allocated that will be passed down with REQ_DISCARD has to
> Lars> be allocated with nr_iovecs = 1 (at least), even though it must
> Lars> not contain any bio_vec payload.
> 
> True. Although the correct answer is: Any discard request must be issued
> by blkdev_issue_discard(). That's the interface.
> 
> The hacks we do to carry the information inside the bio constitute an
> internal interface that is subject to change (it is just about to,
> actually).
> 
> Lars> Though DRBD in 3.10 is not supposed to accept discard requests.
> Lars> So I'm not sure how it manages to pass them down?
> 
> drbd_receiver.c:
> 
> static unsigned long wire_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
> {
>         return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
>                 (dpf & DP_FUA ? REQ_FUA : 0) |
>                 (dpf & DP_FLUSH ? REQ_FLUSH : 0) |
>                 (dpf & DP_DISCARD ? REQ_DISCARD : 0);
> }
> 
> [...]
> 
> /* mirrored write */
> static int receive_Data(struct drbd_tconn *tconn, struct packet_info
> *pi)
> {
> [...]
>        dp_flags = be32_to_cpu(p->dp_flags);
>        rw |= wire_flags_to_bio(mdev, dp_flags);
> [...]
> 
> That's pretty busticated. I suggest you simply remove REQ_DISCARD from
> that helper for now.
> 
> It's also a good idea to disable discard and write same on the client
> side when you set up the request queue:
> 
> 	blk_queue_max_discard_sectors(q, 0);
> 	blk_queue_max_write_same_sectors(q, 0);

Our main development still happens out-of-tree,
trying to be compatible to a large range of kernel versions.

linux upstream DRBD is supposed to handle discards "correctly"
(even though not using the proper interface blkdev_issue_discard).

But it does not, because one fix apparently slipped through
when preparing the pull request.

So linux upstream needs:
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b6c8aaf..5b17ec8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1337,8 +1337,11 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		return 0;
 	}
 
+	/* Discards don't have any payload.
+	 * But the scsi layer still expects a bio_vec it can use internally,
+	 * see sd_setup_discard_cmnd() and blk_add_request_payload(). */
 	if (peer_req->flags & EE_IS_TRIM)
-		nr_pages = 0; /* discards don't have any payload. */
+		nr_pages = 1;
 
 	/* In most cases, we will only need one bio.  But in case the lower
 	 * level restrictions happen to be different at this offset on this

I'll prepare a proper patch with commit message later.

linux upstream DRBD also does blk_queue_max_write_same_sectors(q, 0)
and blk_queue_max_discard_sectors(q, DRBD_MAX_DISCARD_SECTORS)

-------
For linux 3.10, things are different.

DRBD in linux 3.10 does not set QUEUE_FLAG_DISCARD,
and does not announce discard capabilities in any other way,
even though it already contains some preparation steps
(those pieces your grep foo managed to find above...)

DRBD does a handshake, and if there is no discard capability announced,
the peer is supposed to never send discards (and stop announcing them
on his side), even if the peer's DRBD version already supports
and announces discard capabilities.

So I'm still not really seeing how discard requests would be issued
by that version of DRBD.
The local submit path should not allow them (no QUEUE_FLAG_DISCARD set)
and the remote submit path should not allow them either,
for the same reason, and because the DRBD handshake does not allow them.

So my current guess would be that Stefan prepared a 3.10.44
+ "upstream DRBD", but unfortunately not upstream enough?

Stefan, please give more details how to trigger this,
with which exact DRBD versions on the peers, and what action.

	Lars
