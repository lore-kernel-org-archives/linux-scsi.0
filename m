From: Douglas Gilbert <dougg@torque.net>
Subject: Re: 2.5.x Scsi_Cmnd to Scsi_Request driver fixup...
Date: Thu, 25 Jul 2002 00:26:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D3F7DFF.C0F077C3@torque.net>
References: <20020724165109.A32395@zuul.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: steve.cameron@hp.com
Cc: linux-scsi@vger.kernel.org

Stephen Cameron wrote:
> 
> I was patching up the cpqfc driver to compile again in the 2.5.27
> kernel, which was easy enough, or so I thought, until I noticed
> this in scsi.c:
> 
> >  *              This function is deprecated, and drivers should be
> >  *              rewritten to use Scsi_Request instead of Scsi_Cmnd.
> >  */
> >
> > Scsi_Cmnd *scsi_allocate_device(Scsi_Device * device, int wait,
> >                                 int interruptable)
> 
> So, I'm wondering if anyone has written anything up to help
> low-level scsi driver maintainers know what is needed to
> accomplish this rewrite?  Probably I can figure it out myself,
> (eventually) but I'm always left with a nagging feeling maybe
> I missed something crucial.  A summary of the types of things
> that need to change would be most helpful, if such a thing exists.
> 
> I stumbled onto this: http://gear.torque.net/scsi/scsi_stat25.html
> but it doesn't seem to mention Scsi_Request, the rationale
> for the change and what is expected of the low-level driver
> maintainers.

Steve,
That document was some rough ideas prior to OLS 2002. It probably
should be removed.

There is some documentation on the scsi mid level to lower
level interface for the lk 2.5 series in the kernel source file:
	/usr/src/linux/drivers/scsi/scsi_mid_low_api.txt
[a small update follows in my next post]


This document does not address scsi_allocate_device(). I believe
that comment was placed in there by Eric Youngdale in the lk 2.3
development series (i.e. prior to lk 2.4). About the same time
the sg driver (and st) switched from using:
    scsi_allocate_device() and scsi_do_cmd()
to
    scsi_allocate_request() and scsi_do_req()

My guess is that little has changed in this area in lk 2.5 (yet)
so if it worked in lk 2.4, leave it and see what happens :-)
eata_dma_proc.c is the only lower level driver in 2.5.28 using the
newer scsi_allocate_request().

Doug Gilbert

P.S. the bios_param() callback changed its 2nd argument in lk 2.5.28
