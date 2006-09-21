From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 21 Sep 2006 20:45:26 +0200
Message-ID: <20060921184526.GD16556@kernel.dk>
References: <1158710887.4358.17.camel@dcslnxpc.site> <451297C7.4000007@emulex.com> <4512D91B.1020507@cs.wisc.edu> <20060921183550.GA16556@kernel.dk> <4512DC01.8020002@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:5169 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1751445AbWIUSkw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 14:40:52 -0400
Content-Disposition: inline
In-Reply-To: <4512DC01.8020002@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, David C Somayajulu <david.somayajulu@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

On Thu, Sep 21 2006, Mike Christie wrote:
> Jens Axboe wrote:
> > On Thu, Sep 21 2006, Mike Christie wrote:
> >> James Smart wrote:
> >>> Why does your LLD need to reach up into the block layer to find an i/o ?
> >>>
> >>> Even if you are using tags as an index into something... I would think that
> >>> having to go up to the blk layer to retrieve a something that should have
> >>> already been known lower in the driver leaves room for race conditions.
> >>>
> >> This is how the blk and scsi tag api work for queue based tagging. We
> >> have the scsi_find_tag() function which takes a scsi device and than
> >> calls blk_queue_find_tag to get the request. It then does all the magic
> >> sdev to request_queue and request to scsi command work and pass the LLD
> >> the scsi command for the tag. So we can either add a driver array and do
> >> some tag to scsi command or driver stucture mapping or we can use the
> >> array already created in the scsi host block queue tag. And as you see
> >> Dave's patch did the latter in the spirit of not duplicating what
> >> scsi-ml or the block layer already do.
> >>
> >> I think there are some basic races though. For example, scsi_request_fn
> >> calls blk_queue_start_tag with only the queue lock held and so if the
> >> request_fn was called for two devices on the same host at the same time
> >> they both could call find_first_zero_bit on the shared bqt->tag_map and
> >> end up getting the same tag.
> > 
> > Hrmpf good point, I suspect that would be easy enough to fix with just
> > using a
> > 
> >         do {
> >                 tag = ffz_bit(..);
> >         } while (test_and_set_bit(tag, map);
> > 
> > construct. Agree?
> > 
> 
> I think so. I think this is similar to what Dave was going to do too.

Already checked in such a fix:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=7ddbe6863ac4b7a5588aa4a70f262c098f3c469a

-- 
Jens Axboe

