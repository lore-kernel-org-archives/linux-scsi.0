From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Adaptec 2810SA problems
Date: Fri, 25 Jun 2004 08:59:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D40D@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:690 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266167AbUFYM7K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 08:59:10 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mark Overmeer <Mark@Overmeer.net>, linux-scsi@vger.kernel.org

Your best bet to hone in on the problem is to contact Adaptec Technical
support, make sure you have your products TSID handy.

The appears dead message is a result of a failure in the adapter
identified by performing a sequence of health checks. Finer resolution
of this failure mode is available in the Adaptec release for this
driver. It may very well point to errant (or rather abhorrent) behavior
of the target device; technical support may have to recommend F/W
updates to either the adapter or the component drives.

The card's firmware can be updated by using the native Linux cli tool
supplied with the card.

I can not comment (currently) on whether the panic was a result of the
errant behavior in the adapter, hardening the kernel from such problems
is a good thing.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mark Overmeer
Sent: Friday, June 25, 2004 4:47 AM
To: linux-scsi@vger.kernel.org
Subject: Adaptec 2810SA problems


Hi all,

I bought an Adaptec 2810SA with 8x250GB disks last month (PCI card).
It ran for about one week, and then one disk got degraded.  I couldn't
get it to work again, it seemed, so replaced the disk. However, recovery
still doesn't work.

Now, when I start a 2.6.7 kernel, I get this: (line starts with only the
second, all within the same minute)

02:Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
03:st: Version 20040403, fixed bufsize 32768, s/g segs 256
33:aacraid: Host adapter reset request. SCSI hang ?
33: aacraid: Host adapter appears dead
33:scsi: Device offlined - not ready after error recovery: host 0
channel 0 id 0 lun 0
33:SCSI error : <0 0 0 0> return code = 0x6000000
33:end_request: I/O error, dev sda, sector 0
33:Unable to handle kernel NULL pointer dereference at virtual address
00000040
33: printing eip:
33:f8c5a0e7
33:*pde = 00000000
33:Oops: 0000 [#1]
33:SMP
33:Modules linked in: st sr_mod cdrom sg usbserial parport_pc lp parport
md5 ipv6 button battery ac eth1394 uhci_hcd ehci_hcd usbcore raw1394
ohci1394 ieee1394 aacraid sd_mod scsi_mod xfs dm_mod 8250 serial_core
sk98lin reiserfs
33:CPU:    0
33:EIP:    0060:[__crc_lock_sock+1007081/3098769]   Not tainted
33:EIP:    0060:[<f8c5a0e7>]    Not tainted
33:EFLAGS: 00010282   (2.6.7)
33:EIP is at aac_biosparm+0x95/0x173 [aacraid]
33:eax: 00000000   ebx: 00003ec1   ecx: 00000000 edx: f7fff480
33:esi: cc800080   edi: 00000000   ebp: f264bf4c esp: f264bf14
33:ds: 007b   es: 007b   ss: 0068
33:Process hwscan (pid: 6067, threadinfo=f264a000 task=f77680b0)
33:Stack: f71e8500 00000000 cc800080 00000000 f7ed7b94 bfffdca0 f77e0400
f71e8500
33:       f8c198d4 f77e0400 f71e8500 cc800080 00000000 f264bf4c 000000ff
0000003f
33:       0003423e f71e8500 f8c199c7 f71e856c bfffdca0 f7fa9d38 c021a638
f71e8500
33:Call Trace:
33: [__crc_lock_sock+742870/3098769] sd_hdio_getgeo+0x72/0x165 [sd_mod]
33: [<f8c198d4>] sd_hdio_getgeo+0x72/0x165 [sd_mod]
33: [__crc_lock_sock+743113/3098769] sd_ioctl+0x0/0x10e [sd_mod]
33: [<f8c199c7>] sd_ioctl+0x0/0x10e [sd_mod]
33: [blkdev_ioctl+165/1144] blkdev_ioctl+0xa5/0x478
33: [<c021a638>] blkdev_ioctl+0xa5/0x478
33: [block_ioctl+0/21] block_ioctl+0x0/0x15
33: [<c01615e6>] block_ioctl+0x0/0x15
33: [sys_ioctl+485/658] sys_ioctl+0x1e5/0x292
33: [syscall_call+7/11] syscall_call+0x7/0xb
33: [<c0105fd7>] syscall_call+0x7/0xb
33:Code: 66 81 78 40 55 aa 74 22 8b 54 24 0c 89 14 24 e8 af 94 4e c7

I have four questions:
  1) the kernel says:    aacraid: Host adapter appears dead
     Do you think that the controller is really dead, or how can I check
     that?  From BIOS, I can see the discs controlled by the card
  2) Would upgrading the firmware version 7211 to 7244 help in this
     situation?  Anyone experience with that.
  3) Can I upgrade the firmware using wine (it would be nice when
     adaptec would describe that procedure somewhere) or do I really
     need to boot DOS from floppy first?
  4) Probably there is a kernel bug when this exception situation is
     handled.

I hope someone can help me save the 500GB of data already on the disks.
-- 
Thanks in advance,

               MarkOv

------------------------------------------------------------------------
drs Mark A.C.J. Overmeer                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net
-- 
Met vriendelijke groet,

               MarkOv

------------------------------------------------------------------------
drs Mark A.C.J. Overmeer                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
