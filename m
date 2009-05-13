From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Date: Tue, 12 May 2009 18:00:56 -0700
Message-ID: <20090513010056.GT21505@hexapodia.org>
References: <20090421015234.GA7014@hexapodia.org> <20090422144904.407df635.akpm@linux-foundation.org> <49F00EBB.7040504@gmail.com> <20090423070713.GF19113@hexapodia.org> <20090512215256.GA22095@hexapodia.org> <4A0A050D.4000804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A0A050D.4000804@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2009 at 05:23:57PM -0600, Robert Hancock wrote:
> >Looking at hald/linux/addons/addon-storage.c it does appear to
> >open(O_EXCL) as well, so perhaps the O_EXCL multiple-open logic broke
> >recently?
> >
> >Complete dmesg, kconfig, and so on at
> >
> >http://web.hexapodia.org/~adi/sysinfo/1242164411_cvpe4300_2.6.30-rc5-dmar-00096-ga4d7749/
> 
> I'm not sure how this is supposed to work. The only place I can see any 
> O_EXCL handling is in the sg driver. But if you access the sr device 
> directly, it doesn't seem like that would have any effect.
> 
> CCing linux-scsi. Could be there's a bad user-space assumption here, or 
> something.

Perhaps, I haven't tracked down exactly what the difference in behavior
between working 2.6.29 and broken 2.6.30-rc2 is.  It seems like the disk
spins up more often (in response to hal background probes presumably)
with 30-rc2 than it did before, and running "udevadm monitor" I do see
the following repeated "change" events happening, even on an idle
system:

KERNEL[1242175547.793029] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
KERNEL[1242175547.794669] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
UDEV  [1242175547.794912] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
UDEV  [1242175547.888539] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
KERNEL[1242175673.309129] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
KERNEL[1242175673.310775] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
UDEV  [1242175673.311013] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
UDEV  [1242175674.658718] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
KERNEL[1242175690.227604] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
KERNEL[1242175690.229730] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
UDEV  [1242175690.229960] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
UDEV  [1242175714.060440] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
KERNEL[1242175727.909819] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
KERNEL[1242175727.911356] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
UDEV  [1242175727.911690] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
UDEV  [1242175727.987747] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
KERNEL[1242175731.591853] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
KERNEL[1242175731.593541] change   /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)

I've verified that O_EXCL works at least with a trivial test program, so
it's not simply that EXCL broke.

Also I've verified with strace that hald-addon-storage and wodim are
both using O_EXCL, and that hald-addon-storage gets EBUSY while wodim is
writing the disk.  (The straced run didn't fail, unfortunately.)

-andy
