From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 5/6] libata: Per device max command length checking
Date: Mon, 12 Jun 2006 13:22:25 -0500
Message-ID: <448DB0E1.9030702@us.ibm.com>
References: <200606071625.k57GPxAB009587@d01av03.pok.ibm.com> <448CDF7F.2090609@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <448CDF7F.2090609@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
>> Currently, libata sets the scsi_host's max_cmd_len to
>> be the minimum of the max command lengths of all devices
>> attached to the same ATA port. This patch moves this checking
>> into libata so libata can check this on a per device
>> basis and still allows an ATA host to implement its
>> own host limit.
>>
>> Signed-off-by: Brian King <brking@us.ibm.com>
>> ---
>>
>>  libata-dev-bjking1/drivers/scsi/libata-core.c |    8 +-------
>>  libata-dev-bjking1/drivers/scsi/libata-scsi.c |    6 ++++++
>>  2 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff -puN drivers/scsi/libata-core.c~libata_max_cmd_len drivers/scsi/libata-core.c
>> --- libata-dev/drivers/scsi/libata-core.c~libata_max_cmd_len	2006-06-07 10:54:09.000000000 -0500
>> +++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-07 10:54:09.000000000 -0500
>> @@ -1415,12 +1415,6 @@ static int ata_dev_configure(struct ata_
>>  				       cdb_intr_string);
>>  	}
>>  
>> -	ap->host->max_cmd_len = 0;
>> -	for (i = 0; i < ATA_MAX_DEVICES; i++)
>> -		ap->host->max_cmd_len = max_t(unsigned int,
>> -					      ap->host->max_cmd_len,
>> -					      ap->device[i].cdb_len);
>> -
>>  	/* limit bridge transfers to udma5, 200 sectors */
>>  	if (ata_dev_knobble(dev)) {
>>  		if (print_info)
>> @@ -5166,7 +5160,7 @@ static void ata_host_init(struct ata_por
>>  	host->max_lun = 1;
>>  	host->max_channel = 1;
>>  	host->unique_id = ata_unique_id++;
>> -	host->max_cmd_len = 12;
>> +	host->max_cmd_len = ATAPI_CDB_LEN;
>>  
>>  	ap->lock = &host_set->lock;
>>  	ap->flags = ATA_FLAG_DISABLED;
>> diff -puN drivers/scsi/libata-scsi.c~libata_max_cmd_len drivers/scsi/libata-scsi.c
>> --- libata-dev/drivers/scsi/libata-scsi.c~libata_max_cmd_len	2006-06-07 10:54:09.000000000 -0500
>> +++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-06-07 10:54:09.000000000 -0500
>> @@ -2607,6 +2607,12 @@ static inline int __ata_scsi_queuecmd(st
>>  {
>>  	int rc = 0;
>>  
>> +	if (unlikely(cmd->cmd_len > dev->cdb_len)) {
>> +		cmd->result = (DID_ABORT << 16);
>> +		done(cmd);
>> +		return 0;
>> +	}
> 
> :(  do we really need to be adding this to the hot path, for such an 
> unlikely case?
>
> Further, I wonder why this matters?  Doesn't ipr present devices as one 
> per port?

ipr does present devices as one per port, but ipr can also have 'n' ports
per host adapter, so it cannot simply use the scsi_host's max_cmd_len.

The other option would be to move this check into the SAS only path
since it would be the only user that would need this since SATA
users can use scsi_host->max_cmd_len. I'll roll this into my patchset
so you can take a look...

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
