From: Darsen <darsen@micro.ee.nthu.edu.tw>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 29 Oct 2004 22:22:03 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4182520B.3060701@micro.ee.nthu.edu.tw>
References: <Pine.LNX.4.44L0.0410271507560.783-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from msr70.hinet.net ([168.95.4.170]:16581 "EHLO msr70.hinet.net")
	by vger.kernel.org with ESMTP id S263346AbUJ2O0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 10:26:22 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410271507560.783-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Eero Volotinen <eero@ping-viini.org>, Adriaan Penning <a.penning@luon.net>, Andries Brouwer <aebr@win.tue.nl>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

I tested the patch on 2.6.9 and everything works fine.
There are some error messages, but I believe they already existed before 
the patch was applied :)

-------------<dmsg part 1>-----------

usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x12f R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sda : odd number of sectors reported, decreasing by one.
SCSI device sda: 251904 512-byte hdwr sectors (129 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)

---------------<dmsg part 2>--------------

Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi1, channel 0, id 0, lun 0, type 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad LUN (0:1)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (1:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (2:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (3:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (4:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (5:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (6:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (7:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
USB Mass Storage device found at 4

(end of log)

Alan Stern wrote:

>On Wed, 27 Oct 2004, Darsen wrote:
>
>  
>
>>I applied this patch but failed in many places.
>>neither kernel 2.6.8.1 nor 2.6.9 works.
>>
>>Could you tell me what version it should be applied on?
>>
>>Thanks
>>    
>>
>
>Sorry, that patch was meant for 2.6.10-rc1 (and a development version, not 
>the standard version at that).  Below is the equivalent patch for vanilla 
>2.6.9.  Thanks for testing it.
>
>Alan Stern
>
>
>
>diff -ur linux-2.6.9/drivers/scsi/sd.c linux-2.6.9-new/drivers/scsi/sd.c
>--- linux-2.6.9/drivers/scsi/sd.c	2004-10-27 14:55:30.000000000 -0400
>+++ linux-2.6.9-new/drivers/scsi/sd.c	2004-10-27 14:57:17.000000000 -0400
>@@ -1129,6 +1129,16 @@
> 		 */
> 		sdkp->capacity = 0;
> 	}
>+
>+	/* Handle broken devices that return the total number of sectors
>  
>

