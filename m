From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 06/25] hpsa: abandon rescans on memory alloaction
 failures.
Date: Fri, 30 Oct 2015 15:44:34 -0500
Message-ID: <5633D6B2.2090106@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220506.5323.34488.stgit@brunhilda> <56332204.1010509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:34123 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581AbbJ3Uog (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 16:44:36 -0400
Received: by obbza9 with SMTP id za9so4309039obb.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 13:44:36 -0700 (PDT)
In-Reply-To: <56332204.1010509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org



On 10/30/2015 02:53 AM, Hannes Reinecke wrote:
> On 10/28/2015 11:05 PM, Don Brace wrote:
>> Abandon and reschedule rescan process only if device inquiries
>> fail due to mem alloc failures, which are likely to occur for
>> all devices.
>>
>> Otherwise, skip device if inquiry fails for other reasons,
>> and continue rescanning process for other devices.
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>>   drivers/scsi/hpsa.c |   24 +++++++++++++++++++-----
>>   1 file changed, 19 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index a3f671c..ecc6ada 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -3375,10 +3375,13 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>>   
>>   	unsigned char *inq_buff;
>>   	unsigned char *obdr_sig;
>> +	int rc = 0;
>>   
>>   	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
>> -	if (!inq_buff)
>> +	if (!inq_buff) {
>> +		rc = -ENOMEM;
>>   		goto bail_out;
>> +	}
>>   
>>   	/* Do an inquiry to the device to see what it is. */
>>   	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
>> @@ -3386,6 +3389,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>>   		/* Inquiry failed (msg printed already) */
>>   		dev_err(&h->pdev->dev,
>>   			"hpsa_update_device_info: inquiry failed\n");
>> +		rc = 1;
>>   		goto bail_out;
>>   	}
>>   
> Why '1' and not a normal error code, seeing that you're using -ENOMEM above?
Changed to -EIO
>
>> @@ -3435,7 +3439,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>>   
>>   bail_out:
>>   	kfree(inq_buff);
>> -	return 1;
>> +	return rc;
>>   }
>>   
>>   static void hpsa_update_device_supports_aborts(struct ctlr_info *h,
>> @@ -3803,6 +3807,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>>   	n_ext_target_devs = 0;
>>   	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
>>   		u8 *lunaddrbytes, is_OBDR = 0;
>> +		int rc = 0;
>>   
>>   		/* Figure out where the LUN ID info is coming from */
>>   		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
>> @@ -3815,11 +3820,20 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>>   				continue;
>>   
>>   		/* Get device type, vendor, model, device id */
>> -		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
>> -							&is_OBDR)) {
>> +		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
>> +							&is_OBDR);
>> +		if (rc == -ENOMEM) {
>> +			dev_warn(&h->pdev->dev,
>> +				"Out of memory, rescan deferred.\n");
>>   			h->drv_req_rescan = 1;
>> -			continue; /* skip it if we can't talk to it. */
>> +			goto out;
>>   		}
>> +		if (rc) {
>> +			dev_warn(&h->pdev->dev,
>> +				"Inquiry failed, skipping device.\n");
>> +			continue;
>> +		}
>> +
>>   		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
>>   		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
>>   		this_device = currentsd[ncurrent];
>>
> Cheers,
>
> Hannes

