From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: translate INQUIRY VPD page 89h (ATA info)
Date: Fri, 21 Sep 2007 19:25:12 -0400
Message-ID: <46F452D8.7080200@garzik.org>
References: <20070921094825.GA15940@havoc.gtf.org> <1190383924.3333.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1190383924.3333.2.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

Now I remember why this is here -- SAT specifies providing this page 
even for ATAPI devices (optional).  If the SATL chooses to do so, the 
obvious fallout ensues:  snooping and modifying the list of supported 
VPD pages, etc.

That's too cumbersome IMO, so I'm just going to do it for ATA.

So, same end result as with my previous response (atapi checks go away), 
but this was some additional info.


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

To be more clear:  pbuf[0] is peripheral device type.  ATAPI devices are 
not limited to device type == 5 (MMC), hence the 'FIXME'.  Tape devices 
are a different device type, for example.

libata treats ATAPI as a pass-through bridge to a conforming SCSI device 
of /any/ type.  There are actually some ATAPI bridges which plug into 
any SCSI-2 device, those these are quite rare in practice.

libata only provides a single modification to any SCSI command passed to 
an ATAPI device:  INQUIRY is fixed up to report scsi-version==5, if 
scsi-version==0 (see atapi_qc_complete).

	Jeff


