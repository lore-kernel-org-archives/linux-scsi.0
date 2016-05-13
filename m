From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: UBSAN: Undefined behaviour in
 drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
Date: Thu, 12 May 2016 22:26:42 -0700
Message-ID: <1463117202.2380.88.camel@linux.vnet.ibm.com>
References: <alpine.LRH.2.20.1605121859240.4797@math.ut.ee>
	 <1463083710.2380.46.camel@linux.vnet.ibm.com>
	 <CAKb7Uvh8U1ncRg1jCnAVrdew=HyF+jNpY6=MknHgKyJmAdJEkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKb7Uvh8U1ncRg1jCnAVrdew=HyF+jNpY6=MknHgKyJmAdJEkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-05-12 at 17:56 -0400, Ilia Mirkin wrote:
> On Thu, May 12, 2016 at 4:08 PM, James Bottomley
> <jejb@linux.vnet.ibm.com> wrote:
> > On Thu, 2016-05-12 at 19:02 +0300, Meelis Roos wrote:
> > > This is from a dual-AthlonMP 32-bit x86 system with onboard
> > > Adaptec
> > > SCSI
> > > controller, once during bootup.
> > > 
> > > [    4.896307]
> > > =================================================================
> > > ====
> > > ===========
> > > [    4.896471] UBSAN: Undefined behaviour in
> > > drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
> > > [    4.896629] shift exponent -1 is negative
> > 
> > Is this some sort of false positive?  The shift in question is
> > 
> >         devinfo->target_mask = (0x01 << devinfo->target_offset);
> > 
> > The code which calls this in ahc_linux_initialize_scsi_bus() looks
> > to
> > be looping from 0-16 (or variations).  Since the value passed in is
> > unsigned, it would have to be set to ~0, which doesn't seem
> > possible.
> 
> It's getting called from ahc_reset_channel, which does:
> 
>         ahc_compile_devinfo(&devinfo,
>                             CAM_TARGET_WILDCARD,
>                             CAM_TARGET_WILDCARD,
>                             CAM_LUN_WILDCARD,
>                             channel, ROLE_UNKNOWN);
> 
> drivers/scsi/aic7xxx/cam.h:#define      CAM_TARGET_WILDCARD 
> ((u_int)~0)

OK, thanks, you can mark it as a false positive because only the SPI
parameters are actually used for this version of devinfo.

James
