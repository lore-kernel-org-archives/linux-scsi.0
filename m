From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel
 Errors
Date: Wed, 17 Dec 2003 23:00:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FE15087.6090009@us.ibm.com>
References: <000501c3c47c$dfc05ae0$0200000a@nightsky> <1071671058.10878.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:4560 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264943AbTLRHAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 02:00:33 -0500
In-Reply-To: <1071671058.10878.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James Daniel <jdaniel@dakotacom.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>


>>It then goes on to ID the drive correctly, and loads the sd driver, which
>>again IDs the drive correctly.. and we get:
>>
>>SCSI device  sda: 17783240 512-byte hdwr sectors (9105 MB)
>>SCSI device sda: drive cache: write back
>>/dev/scsi/host0/bus0/target1/lun0: unknown partition table
>>Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
> 
> 
> This one's really strange, because clearly the INQUIRY and the
> READ_CAPACITY both succeeded and returned apparently good values.  The
> READ10 to the DOS parition sector has failed (with no errors).
> 
> The only difference is that the READ10 is generated in the partition
> code (via read_dev_sector), so it will be a sg read (probably with
> scsi_device->use_sg set to 1)...I'm travelling today, so if Mike hasn't
> found the problem by the tomorrow, I'll take a look.
> 

For use_sg == 1 the driver was doing this:

-		if (SCpnt->use_sg == 1) {	/* If only one entry in the list *//* 
treat it as regular I/O */
-			pSCB->SCB_BufPtr = (U32) VIRT_TO_BUS(pSrbSG->address);
-			TotalLen = pSrbSG->length;
-			pSCB->SCB_SGLen = 0;

but I had changed it to do sg io instead not knowing why it needed to 
treat it is as regular I/O. I will send a new patch in the next mail.

mike


