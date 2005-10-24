From: Andrew Morton <akpm@osdl.org>
Subject: Fw: 2.6.13.4 aacraid: Partitioning array makes adapter go "dead"
Date: Sun, 23 Oct 2005 18:39:30 -0700
Message-ID: <20051023183930.5ff403a6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:47058 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750878AbVJXBkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 21:40:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Jones <rowjones@cs.indiana.edu>



Begin forwarded message:

Date: Sun, 23 Oct 2005 15:45:31 -0500
From: Robert Jones <rowjones@cs.indiana.edu>
To: linux-kernel@vger.kernel.org
Subject: 2.6.13.4 aacraid: Partitioning array makes adapter go "dead"


I apologize if I happen to break list etiquette, as this is the first
time I have posted here before. I'll try to make this as short as possible.

Here's some information regarding the machine I'm having the problem with:
2-Way Dual-Core AMD Opteron 275's
8GB Reg ECC
Tyan 2882-D (K8SD-Pro) motherboard (AMD-8000 series chipset)
2 Seagate ST336754LC's, updated to latest firmware (0004)
Adaptec 2230S (updated to latest firmware, 8205)

The machine boots wonderfully with any kernel I have tried (2.6.9,
2.6.12.9, 2.6.13.4, 2.6.14-rc5; all kernels are vanilla kernels) and
binds the array to /dev/sda, so long as the array is unpartitioned.
Here's what the kernel reports when booting:

-----------

SCSI device sda: 71619584 512-byte hdwr sectors (36669 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
SCSI device sda: 71619584 512-byte hdwr sectors (36669 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
   sda: unknown partition table
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0

-----------

However, once I partition the array things begin to go wrong. While the
partitioning succeeds, any point after this aacraid will state the
controller is "dead". Here's what the kernel is telling me at this point:

-----------

SCSI device sda: 71619584 512-byte hdwr sectors (36669 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
   sda: sda1 sda2 sda3
SCSI device sda: 71619584 512-byte hdwr sectors (36669 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
   sda: sda1 sda2 sda3

-----------

This looks fine too, however, when I reboot or try to access the array
directly such as a mke2fs /dev/sda1, the kernel says this:

-----------

aacraid: Host adapter reset request. SCSI hang ?
aacraid: Host adapter appears dead
scsi: Device offlined - not ready after error recovery: host 0 channel 0
id 0 lun 0
sd 0:0:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 63
Buffer I/O error on device sda1, logical block 0
scsi0 (0:0): rejecting I/O to offline device
Buffer I/O error on device sda1, logical block 0
scsi0 (0:0): rejecting I/O to offline device
Buffer I/O error on device sda1, logical block 64
scsi0 (0:0): rejecting I/O to offline device
Buffer I/O error on device sda1, logical block 64

-----------

The same machine will install Win2K w/ Adaptec's driver just fine, so I
think the hardware is okay. I went ahead and pulled Adaptec's "official"
aacraid implementation and replaced the "vanilla" implementation in
2.6.9 with it. Unfortunately, this did not seem to help.

Also, if I remove the partitions aacraid is happy again and will bind
the array into /dev/sda as before. It's only after partitioning do
things go bad.

I have three of these machines and they don't have to go live until
January 1, 2006, so I have some time-and am willing-to knock around some
trial and error work with aacraid if needed.

Thanks,
Robert
	
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
