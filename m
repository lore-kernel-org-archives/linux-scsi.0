From: Josip Rodin <joy@entuzijast.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Wed, 10 Sep 2008 00:00:38 +0200
Message-ID: <20080909220038.GA13300@orion.carnet.hr>
References: <20080909020102.GE25591@plap4-2.qlogic.org> <20080909143932.GA27117@orion.carnet.hr> <20080909150023.GA31517@orion.carnet.hr> <20080909.143012.193704777.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080909.143012.193704777.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2008 at 02:30:12PM -0700, David Miller wrote:
> I assume you use this device for your too filesystem, in which case
> the firmware has to be in the initial ramdisk.
> 
> The qla2xxx firmware isn't in the firmware tree, it's in the filesystem
> somewhere, and that gets put into the initial ramdisk you build for
> a particular kernel image.  For this reason CONFIG_FIRMWARE_IN_KERNEL
> won't make any difference.
> 
> This takes a bit of skill to get working properly, I hate it too.  It's
> really unfriendly to users and even kernel developers.  These drivers
> should "just work" when you build them, rather than require contortions
> such as this.

Exactly. And this *has* worked, up to now. I would run update-initramfs and
it would assemble the initial ramdisk and all was well.

% zcat /boot/initrd.img-2.6.27-rc5-usiii | cpio -ivt | grep ql
drwxr-xr-x   2 root     root            0 Sep  9 16:56 lib/modules/2.6.27-rc5-usiii/kernel/drivers/scsi/qla2xxx
-rw-r--r--   1 root     root       320472 Sep  9 16:55 lib/modules/2.6.27-rc5-usiii/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
-rw-r--r--   1 root     root        76802 Sep  9 16:56 lib/firmware/ql2100_fw.bin
-rw-r--r--   1 root     root        84566 Sep  9 16:56 lib/firmware/ql2200_fw.bin
-rw-r--r--   1 root     root       123170 Sep  9 16:56 lib/firmware/ql2300_fw.bin
-rw-r--r--   1 root     root       132978 Sep  9 16:56 lib/firmware/ql2322_fw.bin
-rw-r--r--   1 root     root       200244 Sep  9 16:56 lib/firmware/ql2400_fw.bin
11608 blocks

It's hardly any different from the working initrd:

% zcat /boot/initrd.img-2.6.25.5 | cpio -ivt | grep ql 
drwxr-xr-x   2 root     root            0 Aug  4 09:21 lib/modules/2.6.25.5/kernel/drivers/scsi/qla2xxx
-rw-r--r--   1 root     root       307988 Jun 10 14:14 lib/modules/2.6.25.5/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
-rw-r--r--   1 root     root        76802 Aug  4 09:22 lib/firmware/ql2100_fw.bin
-rw-r--r--   1 root     root        84566 Aug  4 09:22 lib/firmware/ql2200_fw.bin
-rw-r--r--   1 root     root       123170 Aug  4 09:22 lib/firmware/ql2300_fw.bin
-rw-r--r--   1 root     root       132978 Aug  4 09:22 lib/firmware/ql2322_fw.bin
-rw-r--r--   1 root     root       200244 Aug  4 09:22 lib/firmware/ql2400_fw.bin
11572 blocks

-- 
     2. That which causes joy or happiness.
