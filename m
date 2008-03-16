From: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Subject: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 16:19:08 +0100
Message-ID: <1205680748.3050.29.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host194-211-dynamic.20-79-r.retail.telecomitalia.it ([79.20.211.194]:45378
	"EHLO eppesuigoccas.homedns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbYCPQHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 12:07:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
testing latest kernels on SGI O2, I found this new kernel oops. It has
been produced with kernel from linux-mips.org git of yesterday night.
A very similar oops has been reported by others[0] using 2.6.22.

As you may see, the oops happens while booting the machine, when init
run all scripts via rc. One of those scripts run hald-probe-storage, the
process that actually create the oops.

I am not able to identify the cause nor to propose a solution, but I am
willing to test any patch for this problem.

Thanks a lot,
Giuseppe

CPU 0 Unable to handle kernel paging request at virtual address 0000000000000000, epc == 0000000000000000, ra == 0000000000000000
Oops[#1]:
Cpu 0
$ 0   : 0000000000000000 ffffffff9001fce0 ffffffffffffff86 0000000000000028
$ 4   : 980000000fc01140 0000000000000080 0000000000024000 0000000000000000
$ 8   : 980000000fc54700 0000000000000001 0000000000008000 404000130a0808ff
$12   : 0000000000000008 ffffffff801b8db8 0000000000000000 ffffffff803f0000
$16   : 980000000ff2fa70 980000000c417bb8 980000000c417c20 980000000fdeb610
$20   : 000000007fffffff 980000000f9211a0 980000000fc26000 000000007fa51ecd
$24   : 0000000000000000 ffffffff80074290                                  
$28   : 980000000c414000 980000000c417bb0 0000000000400000 0000000000000000
Hi    : 0000000000000000
Lo    : 003d08dbda057200
epc   : 0000000000000000 0x0     Not tainted
ra    : 0000000000000000 0x0
Status: 9001fce3    KX SX UX KERNEL EXL IE 
Cause : 00000008
BadVA : 0000000000000000
PrId  : 00002321 (R5000)
Modules linked in: parport_pc lp parport ipv6 deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_generic xcbc sha25
6_generic sha1_generic crypto_null crypto_blkcipher dm_snapshot dm_mirror dm_mod ehci_hcd ohci_hcd r8169 usbcore sg evdev
Process hald-probe-stor (pid: 1937, threadinfo=980000000c414000, task=980000000ebf47d8)
Stack : 980000000c417be0 980000000c417de0 0800000000000000 980000000c417bb0
        00000008ffffff86 0000000000000000 0200000000000001 000006d600000000
        0000000000000000 980000000c417de0 980000000fdeb610 0000000000000001
        0000000000005326 ffffffff802460b0 0000000070023a00 000000000f9211a0
        ffffffff80490000 ffffffff8024bb84 980000000fc10e80 980000000f80bb28
        0000000000000000 980000000f9210e0 0000010100000001 00000000800d1618
        0000000000000004 980000000fc8f850 000000007fffffff 980000000fde4000
        0000000000005326 000000007fffffff 980000000c407540 980000000f9211a0
        980000000fc26000 000000007fa51ecd ffffffff80245c6c 980000000c407540
        0000000000000000 fffffffffffffdfd 0000000000005326 ffffffff801ad8bc
        ...
Call Trace:
[<ffffffff802460b0>] sr_drive_status+0x50/0xe8
[<ffffffff8024bb84>] cdrom_ioctl+0x5f4/0x1208
[<ffffffff80245c6c>] sr_block_ioctl+0x64/0xe8
[<ffffffff801ad8bc>] compat_blkdev_ioctl+0x7cc/0x18e0
[<ffffffff800d1870>] do_open+0x98/0x310
[<ffffffff800d1d60>] blkdev_open+0x0/0xc0
[<ffffffff800d1da8>] blkdev_open+0x48/0xc0
[<ffffffff8009c444>] __dentry_open+0x114/0x2e0
[<ffffffff8009c740>] do_filp_open+0x48/0x58
[<ffffffff8009c740>] do_filp_open+0x48/0x58
[<ffffffff800def8c>] compat_sys_ioctl+0xf4/0x440
[<ffffffff80019154>] handle_sys+0x114/0x130
[<ffffffff8001fcf3>] fpu_emulator_cop1Handler+0x362/0x2270


Code: (Bad address in epc)

[0]http://lists.debian.org/debian-mips/2008/03/msg00082.html

