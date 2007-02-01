From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 04:52:43 -0500
Message-ID: <45C1B86B.4050502@garzik.org>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C1A424.5040805@garzik.org> <45C1A669.5000206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37487 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422677AbXBAJwr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 04:52:47 -0500
In-Reply-To: <45C1A669.5000206@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> Mark Lord wrote:
>>> For example, I think all existing ATAPI drives only speak 12-byte packet
>>> protocols, and so if we tell SCSI we're good for 16-byte, then won't the
>>> SCSI layer suddenly start sending us READ_16 and the like?
>> Speaking strictly about the device, IDENTIFY PACKET DEVICE data page
>> tells us whether the device supports 12-byte or 16-byte CDBs.  No need
>> to guess.
>>
>> Some host controllers only support 12-byte, but I think that most should
>> support 16-byte.
> 
> Out of curiosity, does ATA controllers which don't allow 16byte CDB
> actually exist?  It's transferred using PIO protocol anyway.

That's why I think that most PATA controllers are likely safe, since it 
is just more "twiddling signals" directly to the device.

We have to be more careful, ironically, with the "smart" controllers.

They are more likely to keep the CDB contents in a FIFO or other silicon 
buffer somewhere, as temporary storage during a DMA -> buffer -> device 
transfer of the CDB contents.

Any first-gen SATA-emulating-PATA controller is instantly under 
suspicion, because they are not truly "twiddling signals" but emulating 
such by building FIS's under the hood.

	Jeff



