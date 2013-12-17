From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 19/32] target: Convert to rbtree for se_dev_entry in
 se_node_acl
Date: Mon, 16 Dec 2013 17:54:42 -0800
Message-ID: <1387245282.20247.280.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-20-git-send-email-agrover@redhat.com>
	 <1387230041.20247.237.camel@haakon3.risingtidesystems.com>
	 <52AFA213.1050700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52AFA213.1050700@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-12-16 at 17:00 -0800, Andy Grover wrote:
> On 12/16/2013 01:40 PM, Nicholas A. Bellinger wrote:
> > On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> >> Instead of an array, use a rbtree. Less memory use on average, and
> >> can allow >255 entries. We go from O(1) to O(log n) on lookups. If this
> >> shows up on profiling (it won't) then transition to other kernel lookup
> >> methods is straightforward from here.
> >>
> >
> > Ugh.
> >
> > There is no reason to be using rbtrees in a performance critical path
> > here.
> >
> > The number of pointer lookups is what ends up hurting the most vs. a
> > flat array, so given that 256 LUNs per endpoint is currently not an
> > issue, and there is no hard limit on the number of endpoints with
> > virtual addressing, I don't see the benefit of this patch.
> >
> > NAK.
> 
> What does virtual addressing mean in this context? I'm not familiar -- 
> so instead of reporting 257+ luns per tpg, it would get split up somehow?

Virtual addressing meaning /sys/kernel/config/target/$FABRIC/$WWPN/
endpoints that are not tied to a specific hardware mapping, so any
arbitrary number of $WWPNs can be created.

Right now the only use-case where people are using more than a few dozen
LUNs per endpoint is with non NPIV qla2xxx mode, where a single physical
Fibre Channel WWPN is exporting 256-512 LUNs, with different per NodeACL
LUN mappings for different initiators.

With NPIV mode for qla2xxx (currently in development), the WWPN becomes
virtualized like iSCSI, and a unsigned short about of virtual port
addresses can be configured per physical FC port.

--nab
