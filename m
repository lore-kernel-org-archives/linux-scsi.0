From: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Thu, 10 Apr 2014 09:15:35 +0200
Message-ID: <20140410071535.GX13491@8bytes.org>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	<1397084904.9519.62.camel@dabdike>
	<1397085044.9519.63.camel@dabdike>
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	<1397087425.9519.67.camel@dabdike>
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1397111557.2608.29.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Cc: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "open list:INTEL IOMMU (VT-d)" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Stephen M. Cameron" <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

[+ David, VT-d maintainer ]

Jiang, David, can you please have a look into this issue?

Thanks,

	Joerg

On Wed, Apr 09, 2014 at 11:32:37PM -0700, Davidlohr Bueso wrote:
> On Wed, 2014-04-09 at 22:03 -0600, Bjorn Helgaas wrote:
> > [+cc Joerg, iommu list]
> > 
> > On Wed, Apr 9, 2014 at 6:19 PM, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org> wrote:
> > > On Wed, 2014-04-09 at 16:50 -0700, James Bottomley wrote:
> > >> On Wed, 2014-04-09 at 16:40 -0700, Davidlohr Bueso wrote:
> > >> > On Wed, 2014-04-09 at 16:10 -0700, James Bottomley wrote:
> > >> > > On Wed, 2014-04-09 at 16:08 -0700, James Bottomley wrote:
> > >> > > > [+linux-scsi]
> > >> > > > On Wed, 2014-04-09 at 15:49 -0700, Davidlohr Bueso wrote:
> > >> > > > > On Wed, 2014-04-09 at 10:39 +0800, Baoquan He wrote:
> > >> > > > > > Hi,
> > >> > > > > >
> > >> > > > > > The kernel is 3.14.0+ which is pulled just now.
> > >> > > > >
> > >> > > > > Cc'ing more people.
> > >> > > > >
> > >> > > > > While the hpsa driver appears to be involved in some way, I'm sure if
> > >> > > > > this is a related issue, but as of today's pull I'm getting another
> > >> > > > > problem that causes my DL980 not to come up.
> > >> > > > >
> > >> > > > > *Massive* amounts of:
> > >> > > > >
> > >> > > > > DMAR:[fault reason 02] Present bit in context entry is clear
> > >> > > > > dmar: DRHD: handling fault status reg 602
> > >> > > > > dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7f61e000
> > >> > > > >
> > >> > > > > Then:
> > >> > > > >
> > >> > > > > hpsa 0000:03:00.0: Controller lockup detected: 0xffff0000
> > >> > > > > ...
> > >> > > > > Workqueue: events hpsa_monitor_ctlr_worker [hpsa]
> > >> > > > > ...
> > >> > > > >
> > >> > > > > Screenshot of the actual LOCKUP:
> > >> > > > > http://stgolabs.net/hpsa-hard-lockup-3.14+.png
> > >> > > > >
> > >> > > > > While I haven't bisected, things worked fine until at least until commit
> > >> > > > > 39de65aa2c3e (April 2nd).
> > >> > > > >
> > >> > > > > Any ideas?
> > >> > > >
> > >> > > > Well, it's either a DMA remapping issue or a hpsa one.  Your assertion
> > >> > > > that everything worked fine until 39de65aa2c3e would tend to vindicate
> > >> > > > hpsa,
> > >> >
> > >> > Hmm here you mean DMA, right?
> > >>
> > >> No, it vindicates the hpsa changes ... they don't seem to be causing
> > >> problems until something goes wrong with dma remapping.
> > >>
> > >> > > because all the hpsa changes went in before that under
> > >> > > Missing crucial info:
> > >> > >
> > >> > > commit 1a0b6abaea78f73d9bc0a2f6df2d9e4c917cade1
> > >> > >
> > >> > > > Merge: 3e75c6d b2bff6c
> > >> > > > Author: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > >> > > > Date:   Tue Apr 1 18:49:04 2014 -0700
> > >> > > >
> > >> > > >     Merge tag 'scsi-misc' of
> > >> > > > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> > >> > > >
> > >> > > > can you revalidate that this commit works OK just to make sure?
> > >> >
> > >> > Ok so I don't see those DMA messages and system starts just fine. I'm
> > >> > thinking perhaps something broke after the IO mmu stuff in commit
> > >> > 3f583bc21977a608908b83d03ee2250426a5695c... could this be indirectly
> > >> > causing the CPU stalls and just blame hpsa in the path as a side effect?
> > >> >
> > >> > /me goes out to try the commit.
> > >>
> > >> That's my guess.  The DMAR messages are DMA remapping issues caused in
> > >> the IOMMU.  If I had to guess, I'd say the DMAR fault message is
> > >> indicating the IOMMU is calling for a mapping address before it can
> > >> satisfy the driver read request, which is causing the hang apparently in
> > >> the hpsa driver.
> > >>
> > >> I've added linux-pci to the cc; I think they deal with iommu issues on
> > >> x86.
> > >
> > > So that merge commit appears to be the culprit, I see both the DMA
> > > messages and the lockup blaming hpsa...
> > 
> > My understanding so far (please correct me if I'm wrong):
> > 
> > 39de65aa2c3e OK ("Merge branch 'i2c/for-next'")
> > 1a0b6abaea78 OK ("Merge tag 'scsi-misc'")
> > 3f583bc21977 BAD ("Merge tag 'iommu-updates-v3.15'")
> 
> Yes, specifically (finally done bisecting):
> 
> commit 2e45528930388658603ea24d49cf52867b928d3e
> Author: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Date:   Wed Feb 19 14:07:36 2014 +0800
> 
>     iommu/vt-d: Unify the way to process DMAR device scope array
>     
>     Now we have a PCI bus notification based mechanism to update DMAR
>     device scope array, we could extend the mechanism to support boot
>     time initialization too, which will help to unify and simplify
>     the implementation.
>     
>     Signed-off-by: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>     Signed-off-by: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
> 
