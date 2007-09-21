From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: translate INQUIRY VPD page 89h (ATA info)
Date: Fri, 21 Sep 2007 16:05:06 -0400
Message-ID: <46F423F2.40401@garzik.org>
References: <20070921094825.GA15940@havoc.gtf.org> <1190383924.3333.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48365 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762515AbXIUUFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2007 16:05:10 -0400
In-Reply-To: <1190383924.3333.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2007-09-21 at 05:48 -0400, Jeff Garzik wrote:
>> commit a6d5ac6a3a1cfbed2a045928bbadd5285f1df084
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Fri Sep 21 05:07:19 2007 -0400
>>
>>     [libata] SCSI: support INQUIRY page 89h (ATA info page)
>>     
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
>>  drivers/ata/libata-scsi.c |   82 +++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 78 insertions(+), 4 deletions(-)
>>
>> a6d5ac6a3a1cfbed2a045928bbadd5285f1df084
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 7ad046b..bb5a5c1 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1804,6 +1804,71 @@ unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
>>  }
>>  
>>  /**
>> + *	ata_scsiop_inq_89 - Simulate INQUIRY VPD page 89, ATA info
>> + *	@args: device IDENTIFY data / SCSI command of interest.
>> + *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
>> + *	@buflen: Response buffer length.
>> + *
>> + *	Yields SAT-specified ATA VPD page.
>> + *
>> + *	LOCKING:
>> + *	spin_lock_irqsave(host lock)
>> + */
>> +
>> +unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
>> +			      unsigned int buflen)
>> +{
>> +	struct ata_device *dev = args->dev;
>> +	u8 pbuf[60];
>> +	bool is_atapi = (dev->class == ATA_DEV_ATAPI);
> 
> I thought this was only used in the dev->class == ATA_DEV_ATA leg of the
> ata_scsi_queuecommand(), so isn't this always false?

Actually, yes, you're right.


>> +	struct ata_taskfile tf;
>> +	unsigned int i;
>> +
>> +	if (!buflen)
>> +		return 0;
>> +
>> +	memset(&pbuf, 0, sizeof(pbuf));
>> +	memset(&tf, 0, sizeof(tf));
>> +
>> +	if (is_atapi)
>> +		pbuf[0] = 0x5;	/* FIXME: hardcodes MMC */
> 
> Actually, in MMC implementation of INQUIRY per SPC-3 (or earlier if MMC
> < 5) is mandatory.  The problem cases I can see are non-standard ATAPI
> devices (probably scanners).

The problem at hand is that the device might -not- be an MMC device at all.

But it sounds like that stuff can be removed regardless.

	Jeff



