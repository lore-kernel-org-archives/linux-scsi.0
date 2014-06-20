From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Fri, 20 Jun 2014 12:49:39 -0400
Message-ID: <yq1wqcbil0c.fsf@sermon.lab.mkp.net>
References: <53A28B21.7070500@profihost.ag>
	<yq1ionwjn15.fsf@sermon.lab.mkp.net>
	<20140620155321.GA24389@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140620155321.GA24389@soda.linbit> (Lars Ellenberg's message of
	"Fri, 20 Jun 2014 17:53:21 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:

Lars,

Lars> Any bio allocated that will be passed down with REQ_DISCARD has to
Lars> be allocated with nr_iovecs = 1 (at least), even though it must
Lars> not contain any bio_vec payload.

True. Although the correct answer is: Any discard request must be issued
by blkdev_issue_discard(). That's the interface.

The hacks we do to carry the information inside the bio constitute an
internal interface that is subject to change (it is just about to,
actually).

Lars> Though DRBD in 3.10 is not supposed to accept discard requests.
Lars> So I'm not sure how it manages to pass them down?

drbd_receiver.c:

static unsigned long wire_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
{
        return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
                (dpf & DP_FUA ? REQ_FUA : 0) |
                (dpf & DP_FLUSH ? REQ_FLUSH : 0) |
                (dpf & DP_DISCARD ? REQ_DISCARD : 0);
}

[...]

/* mirrored write */
static int receive_Data(struct drbd_tconn *tconn, struct packet_info
*pi)
{
[...]
       dp_flags = be32_to_cpu(p->dp_flags);
       rw |= wire_flags_to_bio(mdev, dp_flags);
[...]

That's pretty busticated. I suggest you simply remove REQ_DISCARD from
that helper for now.

It's also a good idea to disable discard and write same on the client
side when you set up the request queue:

	blk_queue_max_discard_sectors(q, 0);
	blk_queue_max_write_same_sectors(q, 0);

-- 
Martin K. Petersen	Oracle Linux Engineering
