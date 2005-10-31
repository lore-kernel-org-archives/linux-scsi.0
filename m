From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Mon, 31 Oct 2005 11:24:51 +0100
Message-ID: <20051031102451.GR19267@suse.de>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org> <435B6A62.8070306@torque.net> <435BBD9A.80603@pobox.com> <20051024075934.GK2811@suse.de> <43625EC3.9060708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:19979 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932448AbVJaKYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 05:24:06 -0500
Content-Disposition: inline
In-Reply-To: <43625EC3.9060708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, dougg@torque.net, linux-scsi@vger.kernel.org

On Fri, Oct 28 2005, Mike Christie wrote:
> Jens Axboe wrote:
> >On Sun, Oct 23 2005, Jeff Garzik wrote:
> >
> >>Douglas Gilbert wrote:
> >>
> >>>Which in turn makes me think of applying the same idea
> >>>to max_sectors
> >>>
> >>>      shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;
> >>
> >>
> >>Won't work.  max_sectors is communicated to the block layer, where we 
> >>limit the overall size of the request for practical reasons.
> >>
> >>Read the comment in libata-scsi's slave_configure:
> >>
> >>               /* TODO: 1024 is an arbitrary number, not the
> >>                * hardware maximum.  This should be increased to
> >>                * 65534 when Jens Axboe's patch for dynamically
> >>                * determining max_sectors is merged.
> >>                */
> >>
> >>Right now, setting the true hardware / command set maximum would use way 
> >>too much memory, with no way to get feedback from the VM.
> >>
> >>This is why SCSI_DEFAULT_MAX_SECTORS is defined to 1024.
> >
> >
> >The block layer has had split values for quite some time, ->max_sectors
> >and max_hw_sectors. scsi_ioctl.c needs a patch to look at max_hw_sectors
> >instead and SCSI drivers could then easily be updated to advertise a
> >real hardware value as well. That is what shost->max_sectors should be,
> >SCSI mid layer would then set q->max_sectors to SCSI_DEFAULT_MAX_SECTORS
> >and q->max_hw_sectors to shost->max_sectors.
> >
> >Then the limiting factor becomes BIO_MAX_PAGES for mapping in the user
> >data, which caps us at 1MiB currently.
> >
> 
> I was just wondering if you give a little more detail in case someone 
> wanted to implement this for you.

Certainly!

> Would the bio functions like __bio_add_page() and bio_get_nr_vecs() 
> continue to test against q->max_sectors. And then have the request 
> merging code test against q->max_hw_sectors. scsi or blk would need some 
> check that max_sectors was not larger than max_sectors, and for scsi we 
> would have to increase SCSI_DEFAULT_MAX_SECTORS to 2048 to match the 
> 1MiB limit and not make q->max_sectors the limit factor. Or how would 
> this work?

On the SCSI side, I would suggest just making shost->max_sectors set
q->max_hw_sectors and leave q->max_sectors to some generic kernel-wide
block layer define (of course making sure that ->max_sectors <=
->max_hw_sectors). That's the easy part.

The bio_add_page() stuff is a little trickier, since it wants to know if
this is fs or 'generic' io. For fs io, we would like to cap the building
of the bio to ->max_sectors, but for eg SG_IO issued io it should go as
high as ->max_hw_sectors. Perhaps the easiest is just to have
bio_fs_add_page() and bio_pc_add_page(), each just passing in the max
value as an integer to bio_add_page(). But it's not exactly pretty.

The ll_rw_blk.c merging is easy, since you don't need to do anything
there. It should test against ->max_sectors as it already does, since
this (sadly) is still the primary way we build large ios.

Make sense?

-- 
Jens Axboe

