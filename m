From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 09/25] hpsa: fix physical target reset
Date: Thu, 29 Oct 2015 10:29:09 -0500
Message-ID: <56323B45.1080707@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220524.5323.29044.stgit@brunhilda> <56322D8C.4030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36107 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbbJ2P3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 11:29:12 -0400
Received: by oiao187 with SMTP id o187so37811649oia.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:29:11 -0700 (PDT)
In-Reply-To: <56322D8C.4030007@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/29/2015 09:30 AM, Tomas Henzl wrote:
> On 28.10.2015 23:05, Don Brace wrote:
>> From: Scott Teel <scott.teel@pmcs.com>
>>
>> Set reset type in device_reset_handler to do either
>> logical unit reset for logical devices, or physical
>> target reset, for physical devices.
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>>   drivers/scsi/hpsa.c |   34 ++++++++++++++++++++++++++++------
>>   drivers/scsi/hpsa.h |    1 +
>>   2 files changed, 29 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 08a761c..67136fb 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -2746,9 +2746,8 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
>>   
>>   
>>   	/* fill_cmd can't fail here, no data buffer to map. */
>> -	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0,
>> +	(void) fill_cmd(c, reset_type, h, NULL, 0, 0,
>>   			scsi3addr, TYPE_MSG);
>> -	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to LUN reset */
>>   	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
>>   	if (rc) {
>>   		dev_warn(&h->pdev->dev, "Failed to send reset command\n");
>> @@ -5216,6 +5215,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>>   	int rc;
>>   	struct ctlr_info *h;
>>   	struct hpsa_scsi_dev_t *dev;
>> +	u8 reset_type;
>>   	char msg[48];
>>   
>>   	/* find the controller to which the command to be aborted was sent */
>> @@ -5254,15 +5254,23 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>>   	if (is_hba_lunid(dev->scsi3addr))
>>   		return SUCCESS;
>>   
>> -	hpsa_show_dev_msg(KERN_WARNING, h, dev, "resetting");
>> +	if (is_logical_dev_addr_mode(dev->scsi3addr))
>> +		reset_type = HPSA_DEVICE_RESET_MSG;
>> +	else
>> +		reset_type = HPSA_PHYS_TARGET_RESET;
>> +
>> +	sprintf(msg, "resetting %s",
>> +		reset_type == HPSA_DEVICE_RESET_MSG ? "logical " : "physical ");
>> +	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
>>   
>> */
> Will this new reset command work for the whole range of hpsa devices?
> (and for the older cciss hw - hpsa_allow_any) ?
The new reset works for newer controller that support HBA mode or IO
bypass mode that allow the driver to send commands directly to a
physical device. This new reset is for those situations.

We still do the existing reset for RAID volumes.
>
>>   #define HPSA_MSG_SEND_RETRY_LIMIT 10
>>   #define HPSA_MSG_SEND_RETRY_INTERVAL_MSECS (10000)
>>   
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

