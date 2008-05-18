From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
Date: Sun, 18 May 2008 17:00:30 +0100
Message-ID: <g0pk8d$ig3$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org> <20080518021423.3dcf0ddd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758382AbYERQIM@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:

> (cc's added)
> 
> On Sat, 17 May 2008 12:50:24 +0000 (UTC) Sitsofe Wheeler
> <sitsofe@yahoo.com> wrote:
> 
>> Sometimes when booting next-20080516 on Ubuntu Gutsy an oops then a panic
>> will occur. At first I thought it might be provoked by vga=0x164 but this
>> does not appear to be the case and the issue is seemingly random. I've
>> hand transcribed the oops so there may be errors in it but hopefully it
>> will still help:
>> 
>> BUG: unable to handle kernel paging request at e6f17fac
>> IP: [<c02604d6>] scsi_bus_uevent+0x1/0x17
>> *pde = 2714b163 *pte = 26f17160
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>> last sysfs file:
>> 
> 
> I thought we'd already fixed this?

If it hasn't yet been fixed I think it can be narrowed down to 
[dc16f5f2ede8cc2acf8ac22857a7fecf3a4296c2] PNP: make generic pnp_add_dma_resource() .
Be aware that the problem also seems to go away if an initrd file is present. I
struggled to revert this commit against the latest linux-next due to conflicts.

Here's the commit message:

Author: Bjorn Helgaas <bjorn.helgaas@hp.com>  2008-04-28 23:34:35
Committer: Len Brown <len.brown@intel.com>  2008-04-29 08:22:28
Child:  cc8c2e308194f0997c718c7c735550ff06754d20 (PNP: make generic pnp_add_io_resource())
Branches: v2.6.26rc1, remotes/origin/master, remotes/linux-next/stable, remotes/linux-next/master, remotes/linux-next/history, master, linux-next, bisect
Follows: v2.6.25
Precedes: v2.6.26-rc1, next-20080502, next-20080501, next-20080430

    PNP: make generic pnp_add_dma_resource()
    
    Add a pnp_add_dma_resource() that can be used by all the PNP
    backends.  This consolidates a little more pnp_resource_table
    knowledge into one place.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

Here's the git-bisect log:

# bad: [2ddcca36c8bcfa251724fe342c8327451988be0d] Linux 2.6.26-rc1
# good: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
git-bisect start 'v2.6.26-rc1' 'v2.6.25'
# good: [7ae44cfa7ab29b277691327e8de790d7b880722f] [ALSA] snd-powermac: style awacs.s and awacs.h
git-bisect good 7ae44cfa7ab29b277691327e8de790d7b880722f
# good: [c60264c494a119cd3a716a22edc0137b11de6d1e] smack: fix integer as NULL pointer warning in smack_lsm.c
git-bisect good c60264c494a119cd3a716a22edc0137b11de6d1e
# good: [3977c965ec35ce1a7eac988ad313f0fc9aee9660] ext4: zero out small extents when writing to prealloc area.
git-bisect good 3977c965ec35ce1a7eac988ad313f0fc9aee9660
# good: [ccf2779544eecfcc5447e2028d1029b6d4ff7bb6] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git-bisect good ccf2779544eecfcc5447e2028d1029b6d4ff7bb6
# bad: [55e462b05b5df4fd113c4a304c4f487d44b0898e] memcg: simple stats for memory resource controller
git-bisect bad 55e462b05b5df4fd113c4a304c4f487d44b0898e
# good: [96916090f488986a4ebb8e9ffa6a3b50881d5ccd] Merge branches 'release', 'acpica', 'bugzilla-10224', 'bugzilla-9772', 'bugzilla-9916', 'ec', 'eeepc', 'idle', 'misc', 'pm-legacy', 'sysfs-links-2.6.26', 'thermal', 'thinkpad' and 'video' into release
git-bisect good 96916090f488986a4ebb8e9ffa6a3b50881d5ccd
# bad: [6de3d58dcfbab516dbe9aff36ea9542f40cd1bf2] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-2.6
git-bisect bad 6de3d58dcfbab516dbe9aff36ea9542f40cd1bf2
# good: [f5d94ff014cb7e6212f40fc6644f3fd68507df33] PNP: pass resources, not indexes, to pnp_check_port(), et al
git-bisect good f5d94ff014cb7e6212f40fc6644f3fd68507df33
# bad: [d152cf5d0c3325979e71ee53b425fdd51a1a285a] PNPACPI: move _CRS/_PRS warnings closer to the action
git-bisect bad d152cf5d0c3325979e71ee53b425fdd51a1a285a
# good: [784f01d5bdeae7d7005ede17305306b042ba2617] PNP: add struct pnp_resource
git-bisect good 784f01d5bdeae7d7005ede17305306b042ba2617
# good: [dbddd0383c59d588f8db5e773b062756e39117ec] PNP: make generic pnp_add_irq_resource()
git-bisect good dbddd0383c59d588f8db5e773b062756e39117ec
# bad: [cc8c2e308194f0997c718c7c735550ff06754d20] PNP: make generic pnp_add_io_resource()
git-bisect bad cc8c2e308194f0997c718c7c735550ff06754d20
# bad: [dc16f5f2ede8cc2acf8ac22857a7fecf3a4296c2] PNP: make generic pnp_add_dma_resource()
git-bisect bad dc16f5f2ede8cc2acf8ac22857a7fecf3a4296c2

-- 
Sitsofe | http://sucs.org/~sits/
