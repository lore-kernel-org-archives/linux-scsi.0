From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: Re: 2.6-test4: mach_mpspec.h: Missing file
Date: Fri, 5 Sep 2003 10:12:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030905171221.44520.qmail@web60202.mail.yahoo.com>
References: <20030905140208.GI18654@parcelfarce.linux.theplanet.co.uk>
Reply-To: dead_emaill@nospam.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60202.mail.yahoo.com ([216.109.118.97]:49845 "HELO
	web60202.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265646AbTIERMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2003 13:12:31 -0400
In-Reply-To: <20030905140208.GI18654@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org


--- Matthew Wilcox <willy@debian.org> wrote:
> On Thu, Sep 04, 2003 at 03:19:27PM -0700, John Donnelly wrote:
> > I'm trying to build a (add-on) module 
> > on a machine booted from a 2.6-test4 kernel,
> > And keep running into this error. I've 
> > included the  gcc command line, sample
> > and the fatal error that mach_mpspec.h can't be found.
> 
> I think you'd be much better off integrating your code into the tree
> as
> a drivers/scsi/ subdirectory; see how little Makefile code has to be
> written for (eg) sym53c8xx_2/

   I tryed it and my first attempt failed , so it looks to
   be easlier to debug a module built problem and 
   other things outside first.
   I'll take a look that Makefile ( when in doubt -- borrow ;)  )
> 
> > My general question is, should I include the 
> > 
> > -I/work/src/<build>/include/asm-i386/mach-generic/mach_mpspec.h
> > 
> > in my gcc command line or is my build area incorrect
> > is
> > some way that the correct mpspec.h file can't be found ?
> 
> There are many bits of the 2.6 build system that work differently
> from 2.4,
> see below..
> 
> > In file included from
> /work/src/linux-2.6.0-test4/include/asm/smp.h:18,
> >                  from
> /work/src/linux-2.6.0-test4/include/linux/smp.h:17,
> >                  from
> /work/src/linux-2.6.0-test4/include/linux/topology.h:33,
> >                  from
> /work/src/linux-2.6.0-test4/include/linux/mmzone.h:294,
> >                  from
> /work/src/linux-2.6.0-test4/include/linux/gfp.h:4,
> >                  from
> /work/src/linux-2.6.0-test4/include/linux/slab.h:15,
> >                  from test.c:8:
> > /work/src/linux-2.6.0-test4/include/asm/mpspec.h:6:25:
> mach_mpspec.h: No such file or directory
> > /work/src/linux-2.6.0-test4/include/asm/mpspec.h:8: `MAX_MP_BUSSES'
> undeclared here (not in a function)
> > 
> >  gcc -g -D__KERNEL__ -DMODULE -I/work/src/linux-2.6.0-test4/include
> \
> > 	-I/work/src/linux-2.6.0-test4/drivers/scsi -c test.c
> 
> Here's the command line for a normal file (as compiled on my laptop,
> your tree will no doubt use subtly diffeent options.  Use `make V=1'
> to see the verbose output from make)
> 
>   gcc -Wp,-MD,mm/.fadvise.o.d -Wall -Wstrict-prototypes
> -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -pipe
> -mpreferred-stack-boundary=2 -march=k6
> -Iinclude/asm-i386/mach-default -D__KERNEL__ -Iinclude -Wall
> -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
> -fno-common -pipe -mpreferred-stack-boundary=2 -march=k6
> -Iinclude/asm-i386/mach-default -fomit-frame-pointer -nostdinc
> -iwithprefix include    -DKBUILD_BASENAME=fadvise
> -DKBUILD_MODNAME=fadvise -c -o mm/fadvise.o mm/fadvise.c
> 
> For building outside the tree, I guess you wouldn't need some of it,
> but
> I think your problem is caused by missing
> -Iinclude/asm-i386/mach-default
> 
> But build inside the tree.  You're going to want to do that
> eventually
> anyway and it saves you from this problem and several like it.
> 

 The cure I found ( and as Mattew  recommended ) was 
 to  include the  " include/asm-i386/mach-default " 
 directory in my search path. I can live with that.

 My only comments is that should the files (like mach_mpspec.h )
 that co-exist in other directories by migrated to the 
 common asm directory based on .config build options ? There 
 are versions based on BigMem, SMP, NUMA ... etc.  Or will 
 every person attempting to build modules OUTSIDE the kernel 
 run into this ?  

 Once I get function module built and running I'll try migrating
 into the drivers/scsi tree. I'm really not very familar
 with getting a driver to built there so this should be a 
 learning curve .

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
