From: Lance Dryden <lance@jound.net>
Subject: Re: Sym53c8xx_2
Date: Mon, 16 Aug 2004 07:39:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41209D02.6010202@jound.net>
References: <1092366037.28144.202254467@webmail.messagingengine.com>   <Pine.LNX.4.60.0408132049060.4069@poirot.grange>   <1092432298.18813.202307545@webmail.messagingengine.com>   <Pine.LNX.4.60.0408150005570.5333@poirot.grange>   <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local> <1092624889.15338.202386294@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-200-116.nyc2.dsl.speakeasy.net ([64.81.200.116]:54401
	"EHLO ellision.sky-haven.net") by vger.kernel.org with ESMTP
	id S267546AbUHPLjt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 07:39:49 -0400
Received: from [192.168.1.21] (dsl081-200-026.nyc2.dsl.speakeasy.net [64.81.200.26])
	by ellision.sky-haven.net (Postfix) with ESMTP id 8B7761BA6F8
	for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2004 07:39:47 -0400 (EDT)
In-Reply-To: <1092624889.15338.202386294@webmail.messagingengine.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello.

Kai OM wrote:

> On Sun, 15 Aug 2004 10:21:35 +0300 (EEST), "Kai Makisara"
> <Kai.Makisara@kolumbus.fi> said:
> 
>>Domain Validation does not fail in all configurations. I am using 
>>sym53c8xx_2 in two machines to drive the system disk and some other 
>>devices. I have had no SCSI problems with these systems.
> 
> What chipset is your controller based on?
> 
> I'm using an LSIU160, based on the LSI53C1010-33 chipset
> 
> I'm pretty sure at least one other person I know that had this problem
> was using a very similar chipset/controller, which strikes me as
> pertinent.

I can replicate the same problem with a Tekram DC390U3W, which is also
based on the LSI53C1010.  I am guessing it's a specific problem with the
53c1010, as I have since replaced it with a 53c895-based card (Tekram
DC390U2W) and it functions normally in the same system.

For me, the failure symptom starts with domain validation of the first 
device on the bus (Quantum Atlas V 18).  The last lines indicate that 
domain validation is beginning for the device.  After a delay, the SCSI 
layer reports an attempted device reset.  Once that finishes, another 
delay and then the SCSI layer reports an attempted bus reset.  I will 
need to re-attach a c1010 to the host in order to provide a precise log.

When I had the 53c1010-based card, the other way to continue working
with the > 2.6.5 kernels was to deliberately stub out the call to
"spi_dv_device_internal()" within
drivers/scsi/scsi_transport_spi.c:spi_dv_device(struct scsi_device
*sdev).  Obviously not a nice thing to do.

I can only speculate that the 53c1010 somehow messes up domain
validation where the 53c895 does not.

   Cheers,
   Lance Dryden

