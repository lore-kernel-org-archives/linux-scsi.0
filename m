From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 21 Sep 2006 11:55:00 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC074144D8@AVEXCH1.qlogic.org>
References: <20060921184731.GE16556@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:20067 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751455AbWIUSzA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 14:55:00 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20060921184731.GE16556@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Thursday, September 21, 2006 11:48 AM
> To: Mike Christie
> Cc: James.Smart@Emulex.Com; David Somayajulu; James Bottomley;
linux-scsi@vger.kernel.org; Doug
> Maxey; David Wagner; Ravi Anand; Duane Grigsby
> Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
> 
> On Thu, Sep 21 2006, Jens Axboe wrote:
> > On Thu, Sep 21 2006, Mike Christie wrote:
> > > Jens Axboe wrote:
> > > > On Thu, Sep 21 2006, Mike Christie wrote:
> > > >> James Smart wrote:
> > > >>> Why does your LLD need to reach up into the block layer to
find an i/o ?
> > > >>>
> > > >>> Even if you are using tags as an index into something... I
would think that
> > > >>> having to go up to the blk layer to retrieve a something that
should have
> > > >>> already been known lower in the driver leaves room for race
conditions.
> > > >>>
> > > >> This is how the blk and scsi tag api work for queue based
tagging. We
> > > >> have the scsi_find_tag() function which takes a scsi device and
than
> > > >> calls blk_queue_find_tag to get the request. It then does all
the magic
> > > >> sdev to request_queue and request to scsi command work and pass
the LLD
> > > >> the scsi command for the tag. So we can either add a driver
array and do
> > > >> some tag to scsi command or driver stucture mapping or we can
use the
> > > >> array already created in the scsi host block queue tag. And as
you see
> > > >> Dave's patch did the latter in the spirit of not duplicating
what
> > > >> scsi-ml or the block layer already do.
> > > >>
> > > >> I think there are some basic races though. For example,
scsi_request_fn
> > > >> calls blk_queue_start_tag with only the queue lock held and so
if the
> > > >> request_fn was called for two devices on the same host at the
same time
> > > >> they both could call find_first_zero_bit on the shared
bqt->tag_map and
> > > >> end up getting the same tag.
> > > >
> > > > Hrmpf good point, I suspect that would be easy enough to fix
with just
> > > > using a
> > > >
> > > >         do {
> > > >                 tag = ffz_bit(..);
> > > >         } while (test_and_set_bit(tag, map);
> > > >
> > > > construct. Agree?
> > > >
> > >
> > > I think so. I think this is similar to what Dave was going to do
too.
> >
> > Already checked in such a fix:
> >
> >
http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=7ddbe6863ac4b7a55
88aa4a70f262c098f3c469a

Thanks. This a lot elegant than the one I came up with using a lock. 
Jens, any comments on this patch
[RFC] [PATCH] helper function for retrieving scsi_cmd given host based
block layer tag
http://marc.theaimsgroup.com/?l=linux-scsi&m=115871027627964&w=2

