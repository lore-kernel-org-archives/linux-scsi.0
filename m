From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Wed, 28 Aug 2002 17:47:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828174737.A27554@eng2.beaverton.ibm.com>
References: <20020828202534.G30927@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e2.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g7T0lYIV267554
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 20:47:34 -0400
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g7T0lUaw027422
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 20:47:30 -0400
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id g7T0lKv32580
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 17:47:20 -0700
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g7T0lbM27618
	for linux-scsi@vger.kernel.org; Wed, 28 Aug 2002 17:47:37 -0700 (PDT)
In-Reply-To: <20020828202534.G30927@redhat.com>; from dledford@redhat.com on Wed, Aug 28, 2002 at 08:25:34PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2002 at 08:25:34PM -0400, Doug Ledford wrote:
> I'm looking through some of the new code that has been put in the kernel 
> scsi subsystem lately and I'm seeing a few of the same mistakes that the 
> old code made.  So, I'm pointing out one of them here.  There are lots of 
> places in the SCSI mid layer that are called outside of any spinlocks and 
> not from interrupt context where there is absolutely no need to use 
> GFP_ATOMIC allocations for memory.  In general, if you don't need to use 
> GFP_ATOMIC, then don't use it.  You're more likely to fail the allocation 
> and therefore fail the operation.  So, if you are working on a section of 
> code, please think about this when doing allocations and do whatever is 
> right for the code snippet you are currently hacking.  Fixing places in 
> the existing code that use GFP_ATOMIC needlessly is a plus ;-)

So, you think all (or most) of the GFP_ATOMIC's in scsi_scan.c should
be GFP_KERNEL? All the kmalloc calls should be at boot time, or via
insmod.

I was wondering about them, but left them to match the previous
scsi_scan.c code.

Do GFP_KERNEL alloc failures during boot time just return NULL?
(Given that there is really no memory left.) I'd hope so, but was
never sure.

I suppose I could change them and boot with mem=something-low and
see what happens.

-- Patrick
