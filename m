From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Mon, 14 Apr 2008 01:17:08 +0900
Message-ID: <20080414010112W.tomof@acm.org>
References: <47F89948.9060503@panasas.com>
	<20080412145152C.tomof@acm.org>
	<4801CEAE.6030309@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56089 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbYDMQRv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 12:17:51 -0400
In-Reply-To: <4801CEAE.6030309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Sun, 13 Apr 2008 12:13:18 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Sat, Apr 12 2008 at 8:52 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Sun, 06 Apr 2008 12:35:04 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> On Fri, Apr 04 2008 at 14:46 +0300, Jens Axboe <jens.axboe@oracle.com> wrote:
> >>> On Thu, Apr 03 2008, Boaz Harrosh wrote:
> >>>>  static void req_bio_endio(struct request *rq, struct bio *bio,
> >>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>>> index 6f79d40..2f87c9d 100644
> >>>> --- a/include/linux/blkdev.h
> >>>> +++ b/include/linux/blkdev.h
> >>>> @@ -213,8 +213,15 @@ struct request {
> >>>>  	/*
> >>>>  	 * when request is used as a packet command carrier
> >>>>  	 */
> >>>> -	unsigned int cmd_len;
> >>>> -	unsigned char cmd[BLK_MAX_CDB];
> >>>> +	unsigned short cmd_len;
> >>>> +	unsigned short ext_cdb_len;  /* length of ext_cdb buffer */
> >>>> +	union {
> >>>> +		unsigned char cmd[BLK_MAX_CDB];
> >>>> +		unsigned char *ext_cdb;/* an optional extended cdb.
> >>>> +	                                   * points to a user buffer that must
> >>>> +	                                   * be valid until end of request
> >>>> +	                                   */
> >>>> +	};
> >>> Why not just something ala
> >>>
> >>>         unsigned short cmd_len;
> >>>         unsigned char __cmd[BLK_MAX_CDB];
> >>>         unsigned char *cmd;
> >>>
> >>> and then have rq_init() do
> >>>
> >>>         rq->cmd = rq->__cmd;
> >>>
> >>> and just have a function for setting up a larger ->cmd and adjusting
> >>> ->cmd_len in the process?
> >>>
> >>> Then rq_set_cdb() would be
> >>>
> >>> static inline void rq_set_cdb(struct request *rq, u8 *cdb, short cdb_len)
> >>> {
> >>>         rq->cmd = cdb;
> >>>         rq->cmd_len = cdb_len;
> >>> }
> >>>
> >>> and rq_get_cdb() plus rq_get_cdb_len() could just go away.
> >>>
> >> Because this way it is dangerous if large commands are issued to legacy
> >> drivers. In scsi-land we have .cmd_len at host template that will govern if
> >> we are allow to issue larger commands to the driver. In block devices we do
> >> not have such a facility, and the danger is if such commands are issued through
> >> bsg or other means, even by malicious code. What you say is the ideal and it
> >> is what I've done for scsi, but for block devices we can not do that yet.
> >> With the way I did it here, Legacy drivers will see zero length command and
> >> will do the right thing, from what I've seen.
> > 
> > What are exactly block devices? ub and ide?
> > 
> > bsg are created only for scsi devices (and scsi objects like sas host)
> > now. Are there other means to send commands except for ioctl?
> 
> I'm not 100% sure either way, so I would like to be safe. Any way, there
> is the size issue, this way we add *nothing* at all, so it looks preferable.
> The final outcome will be the same both ways.

I think that a clean design is an important issue than the sizeof of
struct request.


> I would like if you reconsider the ugliness issue. I admit that at first I
> personally disliked it, but now that I look at it, I think it is cleaner,
> coding style, this way. Because the union points out the exclusiveness of
> the two systems, the striate way give the notion of two separate systems.

That's a ugly hack for me.

Why do we have two separate systems to represent the command length?
If the command length is smaller than 16 bytes, we use cmd_len. If the
length is larger than 16 bytes, we use varlen_cdb_len?

For me, as Jens proposed, having only cmd_len is the right way.

And 'cdb' name is not appropriate for the block layer, I think.

I agreed that changing the block layer and the scsi midlayer gradually
is a safe option. Shortly, I'll send patches to clean up the hack on
the top of your patchset.
