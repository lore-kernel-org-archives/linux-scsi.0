From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 13:16:57 -0500
Message-ID: <44525C19.8020703@us.ibm.com>
References: <20060428172842.44191.qmail@web31809.mail.mud.yahoo.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060428172842.44191.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Hi Brian,  I know I'm not "James" and you didn't direct you email
> to me, but I've a question for you:
> 
> Why do you want this to live in SCSI Core?  I mean, do you find
> it objectionable for a proper SATL (no, not libata), to return
> proper SK/ASC/ASCQ when a CDB not supported by the device is sent
> to the device?

Actually, I don't have a preference either way. In fact, I have
patches for both solutions. The problem I encountered with containing
it entirely within libata was that it was seen as a "regression"
by Jeff since I changed the behavior for existing libata users:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114299306909775&w=2

I could respin the libata patch above so that it only affects SAS
users of libata. 

Jeff - do you have any problem if we contain this function in libata?
I can either resubmit this patch:

http://marc.theaimsgroup.com/?l=linux-ide&m=114263740932464&w=2

or rediff it such that it does not affect current users. I prefer
to avoid special casing SAS users, but I'm open to any solution
that works.

Brian


> 
>     Luben
> 
>> Thanks
>>
>> Brian
>>
>> Brian King wrote:
>>> Add a max_cmd_len field to the scsi_device struct
>>> to allow for per device limits of allowable command
>>> lengths. This patch was submitted earlier and resulted
>>> in a bit of discussion regarding whether or not
>>> CDB length is a limitation of the host or the device.
>>> For ATA, both the host and the device can limit the
>>> CDB length. Currently libata reads the IDENTIFY
>>> PACKET DEVICE data for an ATAPI device and sets
>>> the max_cmd_len in the scsi host for the maximum
>>> supported CDB length of all ATA/ATAPI devices attached
>>> to the same scsi host. This patch allows libata to
>>> set the max CDB length on a per device basis and
>>> allows the SAS/SATA HBA to set its own max command
>>> length in the scsi host template.
>>>
>>> Signed-off-by: Brian King <brking@us.ibm.com>
>>> ---
>>>
>>>  libata-dev-bjking1/drivers/scsi/scsi.c        |    3 ++-
>>>  libata-dev-bjking1/drivers/scsi/scsi_scan.c   |    1 +
>>>  libata-dev-bjking1/include/scsi/scsi_device.h |    1 +
>>>  3 files changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff -puN include/scsi/scsi_device.h~scsi_device_cdb_len include/scsi/scsi_device.h
>>> --- libata-dev/include/scsi/scsi_device.h~scsi_device_cdb_len	2006-04-17 17:17:50.000000000
>> -0500
>>> +++ libata-dev-bjking1/include/scsi/scsi_device.h	2006-04-17 17:17:50.000000000 -0500
>>> @@ -72,6 +72,7 @@ struct scsi_device {
>>>  	unsigned int manufacturer;	/* Manufacturer of device, for using 
>>>  					 * vendor-specific cmd's */
>>>  	unsigned sector_size;	/* size in bytes */
>>> +	unsigned char max_cmd_len;
>>>  
>>>  	void *hostdata;		/* available to low-level driver */
>>>  	char type;
>>> diff -puN drivers/scsi/scsi_scan.c~scsi_device_cdb_len drivers/scsi/scsi_scan.c
>>> --- libata-dev/drivers/scsi/scsi_scan.c~scsi_device_cdb_len	2006-04-17 17:17:50.000000000
>> -0500
>>> +++ libata-dev-bjking1/drivers/scsi/scsi_scan.c	2006-04-17 17:17:50.000000000 -0500
>>> @@ -218,6 +218,7 @@ static struct scsi_device *scsi_alloc_sd
>>>  	sdev->lun = lun;
>>>  	sdev->channel = starget->channel;
>>>  	sdev->sdev_state = SDEV_CREATED;
>>> +	sdev->max_cmd_len = MAX_COMMAND_SIZE;
>>>  	INIT_LIST_HEAD(&sdev->siblings);
>>>  	INIT_LIST_HEAD(&sdev->same_target_siblings);
>>>  	INIT_LIST_HEAD(&sdev->cmd_list);
>>> diff -puN drivers/scsi/scsi.c~scsi_device_cdb_len drivers/scsi/scsi.c
>>> --- libata-dev/drivers/scsi/scsi.c~scsi_device_cdb_len	2006-04-17 17:17:50.000000000 -0500
>>> +++ libata-dev-bjking1/drivers/scsi/scsi.c	2006-04-17 17:17:50.000000000 -0500
>>> @@ -610,7 +610,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>>>  	 * Before we queue this command, check if the command
>>>  	 * length exceeds what the host adapter can handle.
>>>  	 */
>>> -	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
>>> +	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len ||
>>> +	    CDB_SIZE(cmd) > cmd->device->max_cmd_len) {
>>>  		SCSI_LOG_MLQUEUE(3,
>>>  				printk("queuecommand : command too long.\n"));
>>>  		cmd->result = (DID_ABORT << 16);
>>> _
>>
>> -- 
>> Brian King
>> eServer Storage I/O
>> IBM Linux Technology Center
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
