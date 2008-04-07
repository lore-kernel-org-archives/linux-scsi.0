From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Mon, 7 Apr 2008 10:31:26 +0200
Message-ID: <20080407083125.GM12774@kernel.dk>
References: <47E92672.1040208@panasas.com> <47E92934.6040903@panasas.com> <1207240982.3048.45.camel@localhost.localdomain> <47F522A6.3080806@panasas.com> <20080404114614.GJ29686@kernel.dk> <47F89948.9060503@panasas.com> <47F8AE7C.4040901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:29633 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbYDGIb3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 04:31:29 -0400
Content-Disposition: inline
In-Reply-To: <47F8AE7C.4040901@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Apr 06 2008, Boaz Harrosh wrote:
> On Sun, Apr 06 2008 at 12:35 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > On Fri, Apr 04 2008 at 14:46 +0300, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> On Thu, Apr 03 2008, Boaz Harrosh wrote:
> >>>  static void req_bio_endio(struct request *rq, struct bio *bio,
> >>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>> index 6f79d40..2f87c9d 100644
> >>> --- a/include/linux/blkdev.h
> >>> +++ b/include/linux/blkdev.h
> >>> @@ -213,8 +213,15 @@ struct request {
> >>>  	/*
> >>>  	 * when request is used as a packet command carrier
> >>>  	 */
> >>> -	unsigned int cmd_len;
> >>> -	unsigned char cmd[BLK_MAX_CDB];
> >>> +	unsigned short cmd_len;
> >>> +	unsigned short ext_cdb_len;  /* length of ext_cdb buffer */
> >>> +	union {
> >>> +		unsigned char cmd[BLK_MAX_CDB];
> >>> +		unsigned char *ext_cdb;/* an optional extended cdb.
> >>> +	                                   * points to a user buffer that must
> >>> +	                                   * be valid until end of request
> >>> +	                                   */
> >>> +	};
> >> Why not just something ala
> >>
> >>         unsigned short cmd_len;
> >>         unsigned char __cmd[BLK_MAX_CDB];
> >>         unsigned char *cmd;
> >>
> >> and then have rq_init() do
> >>
> >>         rq->cmd = rq->__cmd;
> >>
> >> and just have a function for setting up a larger ->cmd and adjusting
> >> ->cmd_len in the process?
> >>
> >> Then rq_set_cdb() would be
> >>
> >> static inline void rq_set_cdb(struct request *rq, u8 *cdb, short cdb_len)
> >> {
> >>         rq->cmd = cdb;
> >>         rq->cmd_len = cdb_len;
> >> }
> >>
> >> and rq_get_cdb() plus rq_get_cdb_len() could just go away.
> >>
> > 
> > Because this way it is dangerous if large commands are issued to legacy
> > drivers. In scsi-land we have .cmd_len at host template that will govern if
> > we are allow to issue larger commands to the driver. In block devices we do
> > not have such a facility, and the danger is if such commands are issued through
> > bsg or other means, even by malicious code. What you say is the ideal and it
> > is what I've done for scsi, but for block devices we can not do that yet.
> > With the way I did it here, Legacy drivers will see zero length command and
> > will do the right thing, from what I've seen.
> > 
> > Boaz
> >
> 
> I forgot to say.
> With the proposed way, we are saving the space of the pointer. And the final outcome
> of eventually eliminating the buffer, is the same.
> 
> Let me summarize.
> - support extended, arbitrary large commands by introducing the notion that cdb space
>   can be pointed to not carried.
> - Eventually transition all block drivers and users to the new system, for all commands
>   not just large ones.
> - Do so without introducing any extra cost or instability, but also let the transition
>   be done gradually, and not at once, (hence more stability).
> 
> I have thought about that long and hard, my first patch of the matter was 18 month ago.
> I still think this is the smoothest way to go, and not that ugly, really.

OK, thanks for giving it some thought. I don't like the initial way of
doing this (I DO think it's ugly), but as long as there are plans to
make it smoother along the way, it's ok with me.

-- 
Jens Axboe

