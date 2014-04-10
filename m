From: scameron@beardog.cce.hp.com
Subject: Re: hpsa driver bug crack kernel down!
Date: Thu, 10 Apr 2014 15:45:25 -0500
Message-ID: <20140410204525.GC21815@beardog.cce.hp.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com> <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net> <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike> <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net> <1397087425.9519.67.camel@dabdike> <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net> <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com> <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
Sender: linux-pci-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Baoquan He <bhe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>, Jiang Liu <jiang.liu@linux.intel.com>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 09, 2014 at 11:32:37PM -0700, Davidlohr Bueso wrote:
> On Wed, 2014-04-09 at 22:03 -0600, Bjorn Helgaas wrote:
> > [+cc Joerg, iommu list]
> > 
> > On Wed, Apr 9, 2014 at 6:19 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
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
> > >> > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
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

^^^ this one, 1a0b6abaea78, did not work for me, crashing in
hpsa_enter_performant mode() which was surprsing to me as I am
pretty sure I tried on this very same machine I'm using now
(DL360p with P420, P430 and P420i) with 3.14-rc-something plus
all the hpsa patches that I thought were merged in.

But now I am seeing:

 [<ffffffffa0002bd0>] hpsa_enter_performant_mode+0x4c0/0x540 [hpsa]
RSP: 0018:ffff88042c515a78  EFLAGS: 00010297
RAX: 0000000000000000 RBX: ffff88042c650000 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88042c515b48 R08: 0000000000000000 R09: 000000008af03cc0
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88042c515a98
R13: 0000000060000104 R14: ffff88042c515ad8 R15: ffffffffa0001630
FS:  00007f86f7a38700(0000) GS:ffff88043f560000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
usb 1-1.6: new low-speed USB device number 3 using ehci-pci
CR2: 0000000000000000 CR3: 000000042c4c3000 CR4: 00000000000407e0
Stack:
 0000000000008024 ffffffffa00000c0 ffffffffa0000be0 0000000000000000
 0000000600000005 0000000800000007 0000000a00000009 0000000c0000000b
 0000000e0000000d 000000100000000f 0000001200000011 0000000400000013
Call Trace:
 [<ffffffffa00000c0>] ? SA5_fifo_full+0x20/0x20 [hpsa]
 [<ffffffffa0000be0>] ? SA5_ioaccel_mode1_completed+0xd0/0xd0 [hpsa]
 [<ffffffffa000aab6>] hpsa_put_ctlr_into_performant_mode+0x186/0x320 [hpsa]
 [<ffffffffa0005132>] ? hpsa_allocate_sg_chain_blocks+0xa2/0xd0 [hpsa]
 [<ffffffffa000b08b>] hpsa_init_one+0x43b/0x7d0 [hpsa]
 [<ffffffff812bc34c>] local_pci_probe+0x4c/0xb0
 [<ffffffff812bc439>] pci_call_probe+0x89/0xb0
 [<ffffffff812bb074>] ? pci_match_device+0xc4/0xd0
 [<ffffffff812bc719>] pci_device_probe+0x79/0xa0
 [<ffffffff8138edd2>] ? driver_sysfs_add+0x82/0xb0
 [<ffffffff8138f03c>] really_probe+0x6c/0x320
usb 1-1.6: New USB device found, idVendor=0624, idProduct=0341
usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.6: Product: HP 336047-B21
usb 1-1.6: Manufacturer: Avocent
input: Avocent HP 336047-B21 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.64
hid-generic 0003:0624:0341.0001: input,hidraw0: USB HID v1.10 Keyboard
[Avocent0
input: Avocent HP 336047-B21 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.65
hid-generic 0003:0624:0341.0002: input,hidraw1: USB HID v1.10 Mouse [Avocent
HP1
 [<ffffffff8138f337>] driver_probe_device+0x47/0xa0
 [<ffffffff8138f43b>] __driver_attach+0xab/0xb0
 [<ffffffff8138f390>] ? driver_probe_device+0xa0/0xa0
 [<ffffffff8138f390>] ? driver_probe_device+0xa0/0xa0
 [<ffffffff8138d1d4>] bus_for_each_dev+0x94/0xb0
 [<ffffffff8138ecfe>] driver_attach+0x1e/0x20
 [<ffffffff8138e6e0>] bus_add_driver+0x1b0/0x250
usb 2-1.3: new high-speed USB device number 3 using ehci-pci
 [<ffffffffa0016000>] ? 0xffffffffa0015fff
 [<ffffffff8138f9d4>] driver_register+0x64/0xf0
 [<ffffffffa0016000>] ? 0xffffffffa0015fff
 [<ffffffff812bc80c>] __pci_register_driver+0x4c/0x50
 [<ffffffffa001601e>] hpsa_init+0x1e/0x20 [hpsa]
 [<ffffffff810002a2>] do_one_initcall+0xd2/0x180
 [<ffffffff810771a5>] ? __blocking_notifier_call_chain+0x65/0x80
 [<ffffffff810c8154>] do_init_module+0x44/0x1b0
 [<ffffffff810ca7c8>] load_module+0x5a8/0x6f0
 [<ffffffff810c7a30>] ? __unlink_module+0x30/0x30
 [<ffffffff81164c35>] ? __vmalloc_node+0x35/0x40
 [<ffffffff810c7120>] ? module_sect_show+0x30/0x30
 [<ffffffff810caa96>] SyS_init_module+0x96/0xc0
 [<ffffffff81590d52>] system_call_fastpath+0x16/0x1b
Code: 89 45 8c 78 2c 31 f6 8d 4e 04 4c 89 e2 31 c0 0f 1f 40 00 39 0a 7d 0c usb
0
usb 2-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1.3:1.0: USB hub found
hub 2-1.3:1.0: 2 ports detected

83 c0 01 48 83 c2 04 83 f8 10 75 f0 48 63 d6 83 c6 01 39 f7 <41> 89 04 90 7d
d6
RIP  [<ffffffffa0002bd0>] hpsa_enter_performant_mode+0x4c0/0x540 [hpsa]
 RSP <ffff88042c515a78>
CR2: 0000000000000000
---[ end trace ab56f106199a4971 ]---


> > 3f583bc21977 BAD ("Merge tag 'iommu-updates-v3.15'")
> 
> Yes, specifically (finally done bisecting):
> 
> commit 2e45528930388658603ea24d49cf52867b928d3e
> Author: Jiang Liu <jiang.liu@linux.intel.com>
> Date:   Wed Feb 19 14:07:36 2014 +0800
> 
>     iommu/vt-d: Unify the way to process DMAR device scope array
>     
>     Now we have a PCI bus notification based mechanism to update DMAR
>     device scope array, we could extend the mechanism to support boot
>     time initialization too, which will help to unify and simplify
>     the implementation.
>     
>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>     Signed-off-by: Joerg Roedel <joro@8bytes.org>

My git bisect appears to be converging on something else, something
within the hpsa patches that I sent up recently, unfortunately for
me.  Will let you all know when it converges.

-- steve
