From: Doug Ledford <dledford@redhat.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Mon, 3 Feb 2003 17:55:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030203225550.GJ29516@redhat.com>
References: <20030129104731.A2811@beaverton.ibm.com> <3E382E2C.4030201@splentec.com> <20030129121117.A3389@beaverton.ibm.com> <20030130225738.1874c2e0.akpm@digeo.com> <1044020591.2002.16.camel@mulgrave> <20030131124412.086f2d1c.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030131124412.086f2d1c.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, patmans@us.ibm.com, luben@splentec.com, linux-scsi@vger.kernel.org

On Fri, Jan 31, 2003 at 12:44:12PM -0800, Andrew Morton wrote:
> Bear in mind that on the swapout path, the calling process has PF_MEMALLOC
> set.  This is a strong and successful mechanism - it allows the caller to dip
> into the final page reserves which are denied to even GFP_ATOMIC allocations.
> There's maybe a megabyte or two there.
> 
> Could be that there's no problem to be solved here.  It depends on whether
> these allocations are occurring in process context or not.

I think the case is that there is no problem to be solved.  One command 
per host is enough to keep each host running, and that's enough to keep 
the system running.  If we are ever low enough on mem that we get down to 
failing scsi command allocations, the system is already hurting.  The 
complaint was that a device doing something other than swap could starve a 
swap device.  I don't buy that.  If the device is doing constant reads 
then it's going to run out of mem eventually and block just like our 
allocations are, if it's writing then it very likely is freeing up just as 
many pages as the swap operation would be.  In short, I think if we keep 
the disk subsystem running, even if crippled with just one command, the 
problem becomes self correcting and there isn't much for us to solve.  Of 
course, that's just my 5 minute analysis, someone feel free to prove me 
wrong.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
