From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 13/25] hpsa: simplify update scsi devices
Date: Thu, 29 Oct 2015 14:01:35 -0500
Message-ID: <56326D0F.50203@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220549.5323.85641.stgit@brunhilda>
 <998BCB19-5910-44A6-A53F-29BB78160ED9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35590 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbJ2TBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 15:01:39 -0400
Received: by pasz6 with SMTP id z6so48510794pas.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 12:01:39 -0700 (PDT)
In-Reply-To: <998BCB19-5910-44A6-A53F-29BB78160ED9@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On 10/29/2015 11:43 AM, Matthew R. Ochs wrote:
>> On Oct 28, 2015, at 5:05 PM, Don Brace <don.brace@pmcs.com> wrote:
>>
>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>
>> remove repeated calculation that checks for physical
>> or logical devices.
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>> drivers/scsi/hpsa.c |   23 ++++++++++++++---------
>> drivers/scsi/hpsa.h |    1 +
>> 2 files changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index d011540..7c1a552 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -3761,6 +3761,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>> 	int ncurrent = 0;
>> 	int i, n_ext_target_devs, ndevs_to_allocate;
>> 	int raid_ctlr_position;
>> +	bool physical_device;
> Any particular reason for using a bool here and a u8 when you cache the value?
Changed definition to u8 physical_device : 1; in hpsa_scsi_dev_t

>
>> 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
>>
>> 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
>> @@ -3821,16 +3822,17 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>> 		int rc = 0;
>> 		int phys_dev_index = i - (raid_ctlr_position == 0);
>>
>> +		physical_device = i < nphysicals + (raid_ctlr_position == 0);
>> +
>> 		/* Figure out where the LUN ID info is coming from */
>> 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
>> 			i, nphysicals, nlogicals, physdev_list, logdev_list);
>>
>> 		/* skip masked non-disk devices */
>> -		if (MASKED_DEVICE(lunaddrbytes))
>> -			if (i < nphysicals + (raid_ctlr_position == 0) &&
>> -				(physdev_list->
>> -				LUN[phys_dev_index].device_flags & 0x01))
>> -				continue;
>> +		if (physical_device &&
>> +			MASKED_DEVICE(lunaddrbytes) &&
>> +			(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
>> +			continue;
> In this conditional you swapped the ordering, evaluating physical_device first, why?
Changed it back. Better to be consistent.
>
>> 		/* Get device type, vendor, model, device id */
>> 		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
>> @@ -3866,10 +3868,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>> 		}
>>
>> 		*this_device = *tmpdevice;
>> +		this_device->physical_device = physical_device;
>>
>> -		/* do not expose masked devices */
>> -		if (MASKED_DEVICE(lunaddrbytes) &&
>> -			i < nphysicals + (raid_ctlr_position == 0))
>> +		/*
>> +		 * Expose all devices except for physical devices that
>> +		 * are masked.
>> +		 */
>> +		if (MASKED_DEVICE(lunaddrbytes) && this_device->physical_device)
>> 			this_device->expose_device = 0;
>> 		else
>> 			this_device->expose_device = 1;
>> @@ -3887,7 +3892,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>> 				ncurrent++;
>> 			break;
>> 		case TYPE_DISK:
>> -			if (i < nphysicals + (raid_ctlr_position == 0)) {
>> +			if (this_device->physical_device) {
>> 				/* The disk is in HBA mode. */
>> 				/* Never use RAID mapper in HBA mode. */
>> 				this_device->offload_enabled = 0;
>> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
>> index a6ead07..808b520 100644
>> --- a/drivers/scsi/hpsa.h
>> +++ b/drivers/scsi/hpsa.h
>> @@ -37,6 +37,7 @@ struct hpsa_scsi_dev_t {
>> 	unsigned int devtype;
>> 	int bus, target, lun;		/* as presented to the OS */
>> 	unsigned char scsi3addr[8];	/* as presented to the HW */
>> +	u8 physical_device;
>> 	u8 expose_device;
>> #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
>> 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
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

