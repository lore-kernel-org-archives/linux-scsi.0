From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 03/25] hpsa: check for null arguments to dev_printk
Date: Fri, 30 Oct 2015 09:16:28 -0500
Message-ID: <56337BBC.5070104@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220447.5323.79638.stgit@brunhilda> <5633207B.6030200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36123 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030891AbbJ3OQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:16:29 -0400
Received: by oiao187 with SMTP id o187so59963866oia.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:16:29 -0700 (PDT)
In-Reply-To: <5633207B.6030200@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/30/2015 02:47 AM, Hannes Reinecke wrote:
> On 10/28/2015 11:04 PM, Don Brace wrote:
>> Check for NULLs.
>>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>>   drivers/scsi/hpsa.c |    6 ++++++
>>   drivers/scsi/hpsa.h |    2 +-
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 864fb03..6b6e9bb 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -1139,6 +1139,12 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
>>   static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
>>   	struct hpsa_scsi_dev_t *dev, char *description)
>>   {
>> +	if (dev == NULL)
>> +		return;
>> +
>> +	if (h == NULL || h->pdev == NULL || h->scsi_host == NULL)
>> +		return;
>> +
>>   	dev_printk(level, &h->pdev->dev,
>>   			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
>>   			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
>> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
>> index 27debb3..d6c4ebf 100644
>> --- a/drivers/scsi/hpsa.h
>> +++ b/drivers/scsi/hpsa.h
>> @@ -34,7 +34,7 @@ struct access_method {
>>   };
>>   
>>   struct hpsa_scsi_dev_t {
>> -	int devtype;
>> +	unsigned int devtype;
>>   	int bus, target, lun;		/* as presented to the OS */
>>   	unsigned char scsi3addr[8];	/* as presented to the HW */
>>   #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
>>
> That's not really a check for NULL, isn't it?
> Should rather be moved into an individual patch.
>
> Cheers,
>
> Hannes

Making the change.

