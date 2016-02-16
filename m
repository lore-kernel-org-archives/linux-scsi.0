From: Roger Willcocks <roger@filmlight.ltd.uk>
Subject: aacraid: ioctl hang (4.5-rc4)
Date: Tue, 16 Feb 2016 17:47:35 +0000
Message-ID: <1455644855.29507.452.camel@filmlight.ltd.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from c.mx.filmlight.ltd.uk ([54.76.112.217]:58748 "EHLO
	c.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbcBPRxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2016 12:53:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi folks,

I've see this on multiple machines here with various kernels and
hardware configurations, the most canonical being:

hardware: HP Z840 + ASR8405 (4 x HGST raid 6 formatted as xfs)

Z840 firmware: v01.16
ASR8405 firmware: 7.8-0 (32730)

kernel: 4.5.4.rc4 tip with command line options 'ro single'

(Adaptec driver 1.2-1 (41024))

However the same thing happens with 2 and 4 x ASR81605ZQ on a Supermicro
motherboard with the Adaptec 1.2.1-40300 driver. The 30200 driver, fwiw,
causes a kernel panic (page fault in aac_intr_normal).

To reproduce, queue up a bunch of write requests:

# dd if=/dev/zero of=/file/on/raid &

then in a loop, run 'arcconf getversion' repeatedly. I'm using arcconf
1.7 (B21229)

Within thirty seconds or so (less than 100 repeats) arcconf hangs with
userspace stack:

#0  0x00007f60103a9a47 in ioctl () from /lib64/libc.so.6
#1  0x000000000059f4bc in faos_SendReceiveFIB(FSAAPI_CONTEXT*, _FIB*,
unsigned int) ()
#2  0x000000000056de3f in FsaInternalSendReceiveFib(FSAAPI_CONTEXT*,
_FIB*, int, unsigned int) ()
#3  0x000000000058da76 in FsaGetAdapterSasPhyInfo ()
#4  0x00000000004f97ea in ArcAdapter::initSasPhyInfo(Ret&) ()
#5  0x0000000000507516 in ArcAdapter::buildChildren(Ret&) ()
#6  0x0000000000533486 in ArcSystem::buildChildren(StorLib*, Ret&) ()
#7  0x0000000000492170 in StorLib::getSystemConfig() ()
#8  0x00000000004289c0 in main ()

The kernel's stuck in down_interruptible() called from aac_fib_send().
^C releases it (but you can repeat the experiment.)

I've done a small amount of digging and afaict the controller issues an
interrupt when the request completes, but the driver doesn't call up()
because the XFerState in the reply doesn't match to the request.

sent: 1010a1
rcvd: 804832ad

I don't really know enough about the controller protocol to debug this
further.

First things first I'd be grateful if somebody could confirm the hang.

--
Roger


