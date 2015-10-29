From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 17/25] hpsa: move scsi_add_device and scsi_remove_device
 calls to new function
Date: Thu, 29 Oct 2015 15:30:03 -0500
Message-ID: <563281CB.5040409@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220613.5323.52829.stgit@brunhilda>
 <90741AFD-5D5E-4588-A7B1-53A3E80DA984@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33002 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbJ2UaL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 16:30:11 -0400
Received: by padhy1 with SMTP id hy1so44409671pad.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:30:10 -0700 (PDT)
In-Reply-To: <90741AFD-5D5E-4588-A7B1-53A3E80DA984@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On 10/29/2015 12:21 PM, Matthew R. Ochs wrote:
>> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
>>
>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>
>> preparation for adding the sas transport class
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>> drivers/scsi/hpsa.c |   65 +++++++++++++++++++++++++++++++--------------------
>> 1 file changed, 39 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 24b3c8c..06207e2 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -1660,6 +1660,37 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
>> 	}
>> }
>>
>> +static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
>> +{
>> +	int rc = 0;
>> +
>> +	rc = scsi_add_device(h->scsi_host, device->bus,
>> +					device->target, device->lun);
>> +	return rc;
>> +}
>> +
>> +static void hpsa_remove_device(struct ctlr_info *h,
>> +			struct hpsa_scsi_dev_t *device)
>> +{
>> +	struct scsi_device *sdev = NULL;
>> +
>> +	sdev = scsi_device_lookup(h->scsi_host, device->bus,
>> +						device->target, device->lun);
>> +
>> +	if (sdev) {
>> +		scsi_remove_device(sdev);
>> +		scsi_device_put(sdev);
>> +	} else {
>> +		/*
>> +		 * We don't expect to get here.  Future commands
>> +		 * to this device will get a selection timeout as
>> +		 * if the device were gone.
>> +		 */
>> +		hpsa_show_dev_msg(KERN_WARNING, h, device,
>> +					"didn't find device for removal.");
>> +	}
>> +}
>> +
>> static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>> 	struct hpsa_scsi_dev_t *sd[], int nsds)
>> {
>> @@ -1672,7 +1703,6 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>> 	unsigned long flags;
>> 	struct hpsa_scsi_dev_t **added, **removed;
>> 	int nadded, nremoved;
>> -	struct Scsi_Host *sh = NULL;
>>
>> 	/*
>> 	 * A reset can cause a device status to change
>> @@ -1792,46 +1822,29 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>> 	if (hostno == -1 || !changes)
>> 		goto free_and_out;
>>
>> -	sh = h->scsi_host;
>> -	if (sh == NULL) {
>> -		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
>> -		return;
>> -	}
> Are we guaranteed that h->scsi_host will never be NULL when running in here? Or when
> the newly introduced hpsa_remove_device() is invoked elsewhere for that matter?
>
> This commit loses this check and scsi_device_lookup() is not tolerant of a NULL
> scsi_host * (first action is to grab the host_lock).
Better to be safe. I'll add a check in both functions.
>
>> 	/* Notify scsi mid layer of any removed devices */
>> 	for (i = 0; i < nremoved; i++) {
>> 		if (removed[i] == NULL)
>> 			continue;
>> -		if (removed[i]->expose_device) {
>> -			struct scsi_device *sdev =
>> -				scsi_device_lookup(sh, removed[i]->bus,
>> -					removed[i]->target, removed[i]->lun);
>> -			if (sdev != NULL) {
>> -				scsi_remove_device(sdev);
>> -				scsi_device_put(sdev);
>> -			} else {
>> -				/*
>> -				 * We don't expect to get here.
>> -				 * future cmds to this device will get selection
>> -				 * timeout as if the device was gone.
>> -				 */
>> -				hpsa_show_dev_msg(KERN_WARNING, h, removed[i],
>> -					"didn't find device for removal.");
>> -			}
>> -		}
>> +		if (removed[i]->expose_device)
>> +			hpsa_remove_device(h, removed[i]);
>> 		kfree(removed[i]);
>> 		removed[i] = NULL;
>> 	}
>>
>> 	/* Notify scsi mid layer of any added devices */
>> 	for (i = 0; i < nadded; i++) {
>> +		int rc = 0;
>> +
>> 		if (added[i] == NULL)
>> 			continue;
>> 		if (!(added[i]->expose_device))
>> 			continue;
>> -		if (scsi_add_device(sh, added[i]->bus,
>> -			added[i]->target, added[i]->lun) == 0)
>> +		rc = hpsa_add_device(h, added[i]);
>> +		if (!rc)
>> 			continue;
>> -		dev_warn(&h->pdev->dev, "addition failed, device not added.");
>> +		dev_warn(&h->pdev->dev,
>> +			"addition failed %d, device not added.", rc);
>> 		/* now we have to remove it from h->dev,
>> 		 * since it didn't get added to scsi mid layer
>> 		 */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

