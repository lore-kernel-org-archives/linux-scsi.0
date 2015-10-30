From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 15/25] hpsa: enhance hpsa_get_device_id
Date: Fri, 30 Oct 2015 15:59:47 -0500
Message-ID: <5633DA43.3010002@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220601.5323.62936.stgit@brunhilda> <56332562.4000707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:36575 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbbJ3U7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 16:59:49 -0400
Received: by obctp1 with SMTP id tp1so4336597obc.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 13:59:48 -0700 (PDT)
In-Reply-To: <56332562.4000707@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/30/2015 03:08 AM, Hannes Reinecke wrote:
> On 10/28/2015 11:06 PM, Don Brace wrote:
>> use an index into vpd data for SAS/SATA drives
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>>   drivers/scsi/hpsa.c |   23 ++++++++++++++++++++---
>>   1 file changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index c1b053f..1361414 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -3137,7 +3137,7 @@ out:
>>   
>>   /* Get the device id from inquiry page 0x83 */
>>   static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
>> -	unsigned char *device_id, int buflen)
>> +	unsigned char *device_id, int index, int buflen)
>>   {
>>   	int rc;
>>   	unsigned char *buf;
>> @@ -3149,8 +3149,10 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
>>   		return -ENOMEM;
>>   	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
>>   	if (rc == 0)
>> -		memcpy(device_id, &buf[8], buflen);
>> +		memcpy(device_id, &buf[index], buflen);
>> +
>>   	kfree(buf);
>> +
>>   	return rc != 0;
>>   }
>>   
>> @@ -3379,6 +3381,18 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
>>   	return rc;
>>   }
>>   
>> +static void sanitize_inquiry_string(unsigned char *s, int len)
>> +{
>> +	bool terminated = false;
>> +
>> +	for (; len > 0; (--len, ++s)) {
>> +		if (*s == 0)
>> +			terminated = true;
>> +		if (terminated || *s < 0x20 || *s > 0x7e)
>> +			*s = ' ';
>> +	}
>> +}
>> +
>>   static int hpsa_update_device_info(struct ctlr_info *h,
>>   	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
>>   	unsigned char *is_OBDR_device)
> I would prefer to have the function from scsi_scan.c to be exported.
> Hardly a point to duplicate it.
>
> Cheers,
>
> Hannes
I can submit a patch to change it. Can it be in a later patch?
