From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 03/21] hpsa: abandon rescans on memory alloaction
 failures.
Date: Mon, 26 Oct 2015 15:32:01 +0100
Message-ID: <562E3961.2000602@redhat.com>
References: <20151024193306.17127.7819.stgit@brunhilda>
 <20151024195244.17127.26347.stgit@brunhilda> <562E379B.5040400@redhat.com>
 <562E38AE.8080409@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbbJZOcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Oct 2015 10:32:05 -0400
In-Reply-To: <562E38AE.8080409@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 26.10.2015 15:29, Don Brace wrote:
> On 10/26/2015 09:24 AM, Tomas Henzl wrote:
>> On 24.10.2015 21:52, Don Brace wrote:
>>> Abandon and reschedule rescan process only if device inquiries
>>> fail due to mem alloc failures, which are likely to occur for
>>> all devices.
>>>
>>> Otherwise, skip device if inquiry fails for other reasons,
>>> and continue rescanning process for other devices.
>>>
>>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>>   drivers/scsi/hpsa.c |   24 +++++++++++++++++++-----
>>>   1 file changed, 19 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index 5dfb6cf..e1ee06d 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>>
>>> @@ -3799,11 +3804,20 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>>>   				continue;
>>>   
>>>   		/* Get device type, vendor, model, device id */
>>> -		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
>>> -							&is_OBDR)) {
>>> +		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
>>> +							&is_OBDR);
>>> +		if (rc == -ENOMEM) {
>>> +			dev_warn(&h->pdev->dev,
>>> +				"Out of memory, rescan stopped.\n");
>> What about 'rescan deferred" instead of "rescan stopped?
> I can do either "rescan deferred" or "rescan rescheduled"

Do what you prefer, it's your language.

>
>>   
>>
>>>   			h->drv_req_rescan = 1;
>>> -			continue; /* skip it if we can't talk to it. */
>>> +			goto out;
>>>   		}
>>> +		if (rc) {
>>> +			dev_warn(&h->pdev->dev,
>>> +				"Inquiry failed, skipping device.\n");
>>> +			continue;
>>> +		}
>>> +
>>>   		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
>>>   		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
>>>   		this_device = currentsd[ncurrent];
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

