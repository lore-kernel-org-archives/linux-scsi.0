From: Doug Ledford <dledford@redhat.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Thu, 29 Aug 2002 11:58:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020829115812.A31625@redhat.com>
References: <20020828202534.G30927@redhat.com> <20020828174737.A27554@eng2.beaverton.ibm.com> <20020828214215.A31167@redhat.com> <1030618075.7290.110.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1030618075.7290.110.camel@irongate.swansea.linux.org.uk>; from alan@lxorguk.ukuu.org.uk on Thu, Aug 29, 2002 at 11:47:55AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Thu, Aug 29, 2002 at 11:47:55AM +0100, Alan Cox wrote:
> On Thu, 2002-08-29 at 02:42, Doug Ledford wrote:
> > > Do GFP_KERNEL alloc failures during boot time just return NULL?
> > 
> > GFP_ATOMIC returns NULL on failure, GFP_KERNEL *should* never fail until 
> > we get to a true OOM condition because it will block and wait for the vm 
> > subsystem to free us up some space.  Under true OOM conditions it will 
> > return NULL AFAIK.
> 
> Or maybe deadlock if its happening due to I/O.

That would be a trick indeed since Patrick and I were referring to the
scanning code so the device isn't even configured for kernel use yet :-P

> If it wants to flush a
> page out to that scsi device and the scsi device is doing the allocation
> life gets very unpleasant.

Of course.  This is why the mid layer doesn't typically allocate anything 
at all once initial setup of a device is complete.  No allocations once 
setup is complete means no deadlock.

> SCSI may not be coming from block layer
> access with PF_MEM* set either, think about /proc and scsi-generic
> 
> "Here be dragons"

That's why I recommended people think each use through instead of blindly 
changing things ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
