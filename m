From: "Rob Mueller" <robm@fastmail.fm>
Subject: mtp fusion "MID not found" and "DMA Error" under high streaming load with 2.6.27 and 2.6.29
Date: Tue, 2 Jun 2009 01:51:31 +1000
Message-ID: <520D9429153B45F7BD93B54E761FB07E@robmhp>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50970 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbZFAPvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2009 11:51:41 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 36FF934C448
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2009 11:51:43 -0400 (EDT)
Received: from robmhp (dsl-202-173-180-52.vic.westnet.com.au [202.173.180.52])
	by mail.messagingengine.com (Postfix) with ESMTPSA id B0A1627EBE
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2009 11:51:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We have an IBM x3550 server with 32G of RAM that has an LSI53C1030 card 
connected to two external SATA-to-SCSI units. This server has been running 
fine with modest load for several *years* with the exact same hardware and 
various 2.6.x kernel versions (regularly upgraded) with no problems. 
Generally IO on this machine is lots of small random IOs to many millions of 
files (an email server).

Yesterday we used the server to unpack a multi-gigabyte data file to a 
partition, causing a huge streaming IO run. This repeatedly caused the mtp 
fusion driver/scsi bus to get confused, causing various batches of errors 
such as:

[1853281.761689] mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
[1853281.761719] mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
[1853281.761748] mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error

[1861597.029169] mptscsih: ioc0: attempting task abort! 
(sc=ffff88031d71d200)
[1861597.029203] sd 1:0:0:1: [sdc] CDB: cdb[0]=0x28: 28 00 0b 7a 3d 7d 00 00 
08 00
[1861597.029272] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88031d71d200)

[1862303.900733] lost page write due to I/O error on sdh2
[1862303.900774] sd 2:0:0:3: rejecting I/O to offline device
[1862303.900809] sd 2:0:0:3: [sdi] Unhandled error code
[1862303.900834] sd 2:0:0:3: [sdi] Result: hostbyte=0x01 driverbyte=0x00
[1862303.900863] end_request: I/O error, dev sdi, sector 1936592578
[1862303.900891] Buffer I/O error on device sdi4, logical block 22349051
[1862303.900919] lost page write due to I/O error on sdi4
[1862313.681008] mptbase: ioc0: ERROR - Wait IOC_READY state timeout(15)!

[1862330.893017] target1:0:0: Beginning Domain Validation
[1862330.899215] target1:0:0: Ending Domain Validation
[1862330.926581] target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, 
offset 127)

[1862393.257341] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[1862393.257373] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[1862393.257406] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found

Initially this machine had a 2.6.29.3-amd64 kernel (vanilla, mpt driver 
compiled in), but we rebooted into a 2.6.27.24-amd64 (vanilla, mpt driver 
compiled in) kernel as well, and were able to pretty much reproduce the same 
problem at will by doing the streaming read/write workload. Post reboot into 
2.6.27.24 eample:

[ 416.849313] mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
[ 416.849384] mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
[ 416.849454] mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error

Hardware revision is:

$ dmesg | grep FwRev
[ 5.959949] scsi1 : ioc0: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, 
IRQ=19
[ 11.478451] scsi2 : ioc1: LSI53C1030 C0, FwRev=01032700h, Ports=1, 
MaxQ=255, IRQ=16

Let me know what debugging information I can supply to help with this 
because we should be able to reproduce it again quite easily.

Rob

