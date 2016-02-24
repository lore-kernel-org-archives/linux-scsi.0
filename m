From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: aacraid: ioctl hang (4.5-rc4)
Date: Wed, 24 Feb 2016 07:24:40 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D20C0CD@BBYEXM01.pmc-sierra.internal>
References: <1455644855.29507.452.camel@filmlight.ltd.uk>
 <yq1wppuj1ni.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:58919 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730AbcBXHYm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2016 02:24:42 -0500
In-Reply-To: <yq1wppuj1ni.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello Martin,

This is a legacy issue that was apparently present in the previous version  30200 
as well.

I am still in the process of trying to reproduce it.

Will update once I get any results.

Regards,
Raghava Aditya




> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, February 23, 2016 6:14 PM
> To: Raghava Aditya Renukunta
> Cc: Roger Willcocks; linux-scsi@vger.kernel.org
> Subject: Re: aacraid: ioctl hang (4.5-rc4)
> 
> >>>>> "Roger" == Roger Willcocks <roger@filmlight.ltd.uk> writes:
> 
> Raghava,
> 
> This appears to be a regression after the latest update...
> 
> Roger> I've see this on multiple machines here with various kernels and
> Roger> hardware configurations, the most canonical being:
> 
> Roger> hardware: HP Z840 + ASR8405 (4 x HGST raid 6 formatted as xfs)
> 
> Roger> Z840 firmware: v01.16 ASR8405 firmware: 7.8-0 (32730)
> 
> Roger> kernel: 4.5.4.rc4 tip with command line options 'ro single'
> 
> Roger> (Adaptec driver 1.2-1 (41024))
> 
> Roger> However the same thing happens with 2 and 4 x ASR81605ZQ on a
> Roger> Supermicro motherboard with the Adaptec 1.2.1-40300 driver. The
> Roger> 30200 driver, fwiw, causes a kernel panic (page fault in
> Roger> aac_intr_normal).
> 
> Roger> To reproduce, queue up a bunch of write requests:
> 
> Roger> # dd if=/dev/zero of=/file/on/raid &
> 
> Roger> then in a loop, run 'arcconf getversion' repeatedly. I'm using
> Roger> arcconf 1.7 (B21229)
> 
> Roger> Within thirty seconds or so (less than 100 repeats) arcconf hangs
> Roger> with userspace stack:
> 
> Roger> #0 0x00007f60103a9a47 in ioctl () from /lib64/libc.so.6 #1
> Roger> 0x000000000059f4bc in faos_SendReceiveFIB(FSAAPI_CONTEXT*,
> _FIB*,
> Roger> unsigned int) () #2 0x000000000056de3f in
> Roger> FsaInternalSendReceiveFib(FSAAPI_CONTEXT*, _FIB*, int, unsigned
> Roger> int) () #3 0x000000000058da76 in FsaGetAdapterSasPhyInfo () #4
> Roger> 0x00000000004f97ea in ArcAdapter::initSasPhyInfo(Ret&) () #5
> Roger> 0x0000000000507516 in ArcAdapter::buildChildren(Ret&) () #6
> Roger> 0x0000000000533486 in ArcSystem::buildChildren(StorLib*, Ret&) ()
> Roger> #7 0x0000000000492170 in StorLib::getSystemConfig() () #8
> Roger> 0x00000000004289c0 in main ()
> 
> Roger> The kernel's stuck in down_interruptible() called from
> Roger> aac_fib_send().  ^C releases it (but you can repeat the
> Roger> experiment.)
> 
> Roger> I've done a small amount of digging and afaict the controller
> Roger> issues an interrupt when the request completes, but the driver
> Roger> doesn't call up() because the XFerState in the reply doesn't
> Roger> match to the request.
> 
> Roger> sent: 1010a1 rcvd: 804832ad
> 
> Roger> I don't really know enough about the controller protocol to debug
> Roger> this further.
> 
> Roger> First things first I'd be grateful if somebody could confirm the
> Roger> hang.
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
