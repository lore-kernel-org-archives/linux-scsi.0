From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 01/21] hpsa: correct calls to dev_printk
Date: Mon, 26 Oct 2015 08:41:32 -0500
Message-ID: <562E2D8C.1090206@pmcs.com>
References: <20151024193306.17127.7819.stgit@brunhilda>
 <20151024195232.17127.59627.stgit@brunhilda> <562E2208.5060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36292 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbJZNlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 09:41:35 -0400
Received: by pacfv9 with SMTP id fv9so197741851pac.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2015 06:41:35 -0700 (PDT)
In-Reply-To: <562E2208.5060200@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/26/2015 07:52 AM, Tomas Henzl wrote:
> On 24.10.2015 21:52, Don Brace wrote:
>> was seeing issues passing level into hpsa_show_dev_msg and then using
>> the level as an arguement to dev_printk. For now, switch to dev_warn.
>>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>>   drivers/scsi/hpsa.c |   41 ++++++++++++++++++++++++-----------------
>>   1 file changed, 24 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 40669f8..8454f22 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -1137,11 +1137,15 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
>>   static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
>>   	struct hpsa_scsi_dev_t *dev, char *description)
>>   {
>> -	dev_printk(level, &h->pdev->dev,
>> +	if (dev == NULL)
>> +		return;
>> +
>> +	dev_warn(&h->pdev->dev,
>>   			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
>>   			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
>>   			description,
>> -			scsi_device_type(dev->devtype),
>> +			dev->devtype >= 0 ?
>> +				scsi_device_type(dev->devtype) : "unknown",
> Can devtype ever be negative? Found only this place in code
> where it is set "this_device->devtype = (inq_buff[0] & 0x1f);"
> And if it was negative the scsi_device_type will return "Unknown"
> anyway. You probably could skip the test now and switch devtype
> from int to unsigned in the future.
>
> Cheers,
> Tomas
>
>
Thanks, changed to unsigned and removed check.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

