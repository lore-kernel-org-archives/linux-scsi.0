From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Tue, 13 Oct 2009 19:39:08 -0600
Message-ID: <200910131939.09039.tfjellstrom@shaw.ca>
References: <200910091141.52303.tfjellstrom@shaw.ca> <4AD22532.9060001@univ-lille2.fr> <200910111658.13639.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910111658.13639.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, kewei@marvell.com
List-Id: linux-scsi@vger.kernel.org

On Sun October 11 2009, Thomas Fjellstrom wrote:
> On Sun October 11 2009, Christian Vilhelm wrote:
> > Thomas Fjellstrom wrote:
> > > Hi,
> > >
> > > I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card)
> > > to work with linux for the past month or so. I've recently just RMAed
> > > my first card, and tested the new one under linux, and I see the same
> > > problems.
> > >
> > > The very first time I made a new array off the controller, formated
> > > (with xfs) and mounted the volume, it seemed to work. ioozone even
> > > seemed to run for a while. Sadly after a few minutes I got a stream of
> > > mvs_abort_task messages in dmesg, and any accesses to the volume, or
> > > any disks connected to the controller lock up.
> > >
> > > After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of
> > > kernel.org, and the volume fails to mount with the same mvs_abort_task
> > > messages.
> >
> > I have the exact same problem with another Marvell 88SE64xx based card,
> > namely an Areca ARC-1300ix-16 and the mvsas driver.
> > If the disks are just used alone, with a filesystem on them, all seems
> > to work fine. dd and badblocks run fine on them. Mounting them,
> > reading/writing work fine. The error seem to popup but rarely when
> > several disks are used simultaneously.
> > But, an absolute sure way to trigger the error is to assemble (or
> > create) a md raid array with the disks. I join a syslog extract from the
> > error. You can see it happens seconds after the array creation.
> > I tried :
> > 1) disabling the write cache on the disks => same error
> > 2) disabling NCQ : in mv_sas.h :
> > #define MV_DISABLE_NCQ  1
> > same error.
> > Afer a while, the devices handled by the card are just dropped from the
> > system and the card stops working at all, a reboot is necessary.
> 
> I have found that a proper reboot is impossible once the card/driver starts
> misbehaving. Anything that tries to do anything with the md device, or any
>  of the component drives will hang. Even kernel threads it seems. A reboot
>  or a shutdown hangs when it tries to sync the md device, and ALT+SYSRQ+S/U
>  both hang. After the first Alt+sysrq+s it will register more of them, but
>  it won't print the "Emergency Sync Complete" message.
> 
> > Does anyone have a working config based on a Marvell 64xx card ?
> >
> > I'm willing to explore solutions, patches or anything, just tell me what
> > to do to help.
> >
> > Christian Vilhelm.
> 

I'd really appreciate some assistance with this. The card is essentially 
useless under linux, if not harmful (causes oopses and hangs) with the current 
driver.

My last weekly backup failed while creating the disk image due to my array 
being low on space, I really need to get the new array up asap.

Thanks.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
