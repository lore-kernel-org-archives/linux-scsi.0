From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: GFP_ATOMIC allocations...
Date: 29 Aug 2002 11:47:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1030618075.7290.110.camel@irongate.swansea.linux.org.uk>
References: <20020828202534.G30927@redhat.com>
	<20020828174737.A27554@eng2.beaverton.ibm.com>
	<20020828214215.A31167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020828214215.A31167@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Thu, 2002-08-29 at 02:42, Doug Ledford wrote:
> > Do GFP_KERNEL alloc failures during boot time just return NULL?
> 
> GFP_ATOMIC returns NULL on failure, GFP_KERNEL *should* never fail until 
> we get to a true OOM condition because it will block and wait for the vm 
> subsystem to free us up some space.  Under true OOM conditions it will 
> return NULL AFAIK.

Or maybe deadlock if its happening due to I/O. If it wants to flush a
page out to that scsi device and the scsi device is doing the allocation
life gets very unpleasant. SCSI may not be coming from block layer
access with PF_MEM* set either, think about /proc and scsi-generic

"Here be dragons"

