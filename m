From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Fri, 30 Aug 2002 09:22:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020830092257.A19730@eng2.beaverton.ibm.com>
References: <20020828202534.G30927@redhat.com> <20020828174737.A27554@eng2.beaverton.ibm.com> <20020828214215.A31167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020828214215.A31167@redhat.com>; from dledford@redhat.com on Wed, Aug 28, 2002 at 09:42:15PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, zaitcev@redhat.com

On Wed, Aug 28, 2002 at 09:42:15PM -0400, Doug Ledford wrote:
> On Wed, Aug 28, 2002 at 05:47:37PM -0700, Patrick Mansfield wrote:
> > So, you think all (or most) of the GFP_ATOMIC's in scsi_scan.c should
> > be GFP_KERNEL?
> 

> 
> > All the kmalloc calls should be at boot time, or via
> > insmod.
> 
> Right, process context with no locks held.
> 

There was past discussion about calling into scsi_build_commandblocks()
while not in user context (via usb etc.), this implies that we could
scan while not in user context.

I don't see how that would work, since the scan sleeps waiting for IO. 

Do we really call scan_scsis and scsi_build_commandblocks while not in user
context? Who is the caller (to scsi_register_host)?

Here is Pete's response saying he found such a case, but not where:

http://marc.theaimsgroup.com/?l=linux-scsi&m=101678634608966&w=2

-- Patrick Mansfield
