From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: RE: [Bugme-new] [Bug 5244] New: HW RAID1 detected as zero size dr
	 ive
Date: Thu, 15 Sep 2005 16:51:17 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662B3C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44537 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932597AbVIOUv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 16:51:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@kernel-bugs.osdl.org>

Hi Andrew,

I hope you have had chance to review those messages.

Thank you,

Seokmann

> -----Original Message-----
> From: Ju, Seokmann 
> Sent: Wednesday, September 14, 2005 4:39 PM
> To: 'Andrew Morton'
> Cc: linux-scsi@vger.kernel.org; Bagalkote, Sreenivas; 
> bugme-daemon@kernel-bugs.osdl.org
> Subject: RE: [Bugme-new] [Bug 5244] New: HW RAID1 detected as 
> zero size dr ive
> 
> Hi Andrew,
> 
> On Wednesday, September 14, 2005 3:36 PM, Andrew Morton wrote:
> > It's unusual to get a panic with no messages which explain 
> > the reason for
> > the panic.  We'd need to get additional info about that panic 
> > to proceed
> > any further.
> Here, I've attached the message displayed when panic, below.
> Please let me know for any clues.
> ---
> Uncompressing linux... Ok, booting the kernel
> Ibm-acpi: ec object not found
> Red Hat nash version 4.2.1.3 starting
> File descriptor 3 left open.
>   Reading all physical volumes.
>   This may take a while...
>   Found volume group "VolGroup00" using metadata type lvm2
> File descriptor 3 left open.
>   2 logical volume(s) in volume group "VolGroup00" now active
>   Enforcing mode requested but no policy loaded. Halting now.
> Kernel panic - not syncing: Attempted to kill init!
> ---
> 
> 
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@osdl.org] 
> > Sent: Wednesday, September 14, 2005 3:36 PM
> > To: Ju, Seokmann
> > Cc: linux-scsi@vger.kernel.org; sreenib@lsil.com; 
> > bugme-daemon@kernel-bugs.osdl.org
> > Subject: Re: [Bugme-new] [Bug 5244] New: HW RAID1 detected as 
> > zero size dr ive
> > 
> > "Ju, Seokmann" <sju@lsil.com> wrote:
> > >
> > > > On Tuesday, September 13, 2005 7:55 PM, Andrew Morton wrote:
> > > > > Could whoever maintains the megaraid driver(s) please submit 
> > > > > a MANTAINERS
> > > > > patch?
> > > > > 
> > > > > It broke in 2.6.14-rc1.
> > > > I'm checking out 2.6.14-rc1, right now. The patch will be 
> > > > submitted soon.
> > > I've compiled the kernel and created bzImage and initrd.
> > > When I reboot the system with 2.6.14-rc1, I'm getting panic 
> > without any
> > > meaningful messages.
> > 
> > It's unusual to get a panic with no messages which explain 
> > the reason for
> > the panic.  We'd need to get additional info about that panic 
> > to proceed
> > any further.
> > 
> > You may need to double-check the .config - sometimes `make 
> oldconfig'
> > doesn't quite do the right thing, especially if the old 
> > config file isn't
> > very recent.
> > 
> > If you're on x86_64 you may need this:
> > 
> > --- 
> > devel/mm/slab.c~fix-slab-bug-due-to-change-in-array-cac
> > he-size	2005-09-14 11:54:18.000000000 -0700
> > +++ devel-akpm/mm/slab.c	2005-09-14 11:54:18.000000000 -0700
> > @@ -659,7 +659,7 @@ static inline kmem_cache_t *__find_gener
> >   	* kmem_cache_create(), or __kmalloc(), before
> >   	* the generic caches are initialized.
> >   	*/
> > -	BUG_ON(csizep->cs_cachep == NULL);
> > +	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
> >  #endif
> >  	while (size > csizep->cs_size)
> >  		csizep++;
> > _
> > 
> 
