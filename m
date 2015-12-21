From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 3/3] hpsa: add box and bay information for enclosure
 devices
Date: Mon, 21 Dec 2015 11:09:07 -0600
Message-ID: <56783233.2@pmcs.com>
References: <20151209211816.519.50876.stgit@brunhilda>
 <20151209211857.519.17381.stgit@brunhilda>
 <2CD3971E-D620-445C-B97E-5271A471543B@linux.vnet.ibm.com>
 <AC8E6367-D629-4EED-944C-E970D9FC88A4@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36369 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbLURJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 12:09:11 -0500
Received: by mail-pa0-f66.google.com with SMTP id jx14so8386169pad.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2015 09:09:10 -0800 (PST)
In-Reply-To: <AC8E6367-D629-4EED-944C-E970D9FC88A4@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com, linux-scsi@vger.kernel.org



On 12/18/2015 02:19 PM, Matthew R. Ochs wrote:
> Hi Don,
>
> Did you see these comments I had from my review of this patch?
>
>
> -matt
>
>> On Dec 9, 2015, at 5:41 PM, Matthew R. Ochs <mrochs@linux.vnet.ibm.com> wrote:
>>
>>> On Dec 9, 2015, at 3:18 PM, Don Brace <don.brace@pmcs.com> wrote:
>> No commit message?
> You can disregard this one as I saw you added a message in v1.
>
>>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>> drivers/scsi/hpsa.c     |  108 ++++++++++++++++++++++++++++++++++++++++++++---
>>> drivers/scsi/hpsa_cmd.h |   13 ++++++
>>> 2 files changed, 114 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index f8370b8..6f84ec7 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>> @@ -750,7 +750,6 @@ static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
>>> }
>>>
>>> #define MAX_PATHS 8
>>> -
>>> static ssize_t path_info_show(struct device *dev,
>>> 	     struct device_attribute *attr, char *buf)
>>> {
>>> @@ -792,9 +791,7 @@ static ssize_t path_info_show(struct device *dev,
>>> 				hdev->bus, hdev->target, hdev->lun,
>>> 				scsi_device_type(hdev->devtype));
>>>
>>> -		if (hdev->external ||
>>> -			hdev->devtype == TYPE_RAID ||
>>> -			is_logical_device(hdev)) {
>>> +		if (hdev->devtype == TYPE_RAID || is_logical_device(hdev)) {
>> How does removing the check for external here relate to the rest of this commit?
We have enclosure devices that would not show up properly if this check
was not removed.
>>
>>> 			output_len += scnprintf(buf + output_len,
>>> 						PAGE_SIZE - output_len,
>>> 						"%s\n", active);
>>> @@ -808,8 +805,7 @@ static ssize_t path_info_show(struct device *dev,
>>> 			phys_connector[0] = '0';
>>> 		if (phys_connector[1] < '0')
>>> 			phys_connector[1] = '0';
>>> -		if (hdev->phys_connector[i] > 0)
>>> -			output_len += scnprintf(buf + output_len,
>>> +		output_len += scnprintf(buf + output_len,
>> Same question regarding the removal of the > 0 check.
The connector contains alpha-numeric data. We were missing
connector info like "2I" "2E", ...
>>
>>> 				PAGE_SIZE - output_len,
>>> 				"PORT: %.2s ",
>>> 				phys_connector);
>>> @@ -3191,6 +3187,90 @@ out:
>>> 	return rc;
>>> }
>>>
>>> +/*
>>> + * get enclosure information
>>> + * struct ReportExtendedLUNdata *rlep - Used for BMIC drive number
>>> + * struct hpsa_scsi_dev_t *encl_dev - device entry for enclosure
>>> + * Uses id_physical_device to determine the box_index.
>>> + */
>>> +static int hpsa_get_enclosure_info(struct ctlr_info *h,
>>> +			unsigned char *scsi3addr,
>>> +			struct ReportExtendedLUNdata *rlep, int rle_index,
>>> +			struct hpsa_scsi_dev_t *encl_dev)
>>> +{
>>> +	int rc = -1;
>>> +	struct CommandList *c = NULL;
>>> +	struct ErrorInfo *ei = NULL;
>>> +	struct bmic_sense_storage_box_params *bssbp = NULL;
>>> +	struct bmic_identify_physical_device *id_phys = NULL;
>>> +	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
>>> +	u16 bmic_device_index = 0;
>>> +
>>> +
>>> +	bssbp = kzalloc(sizeof(*bssbp), GFP_KERNEL);
>>> +	if (!bssbp)
>>> +		goto out;
>>> +
>>> +	id_phys = kzalloc(sizeof(*id_phys), GFP_KERNEL);
>>> +	if (!id_phys)
>>> +		goto out;
>>> +
>>> +	bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
>>> +
>>> +	if (bmic_device_index == 0xFF00)
>>> +		goto out;
>> Why not put this check before the memory allocations so you can
>> avoid them if this condition is not met?
Good point. I will do this for V3.
>>
>>> +
>>> +	memset(id_phys, 0, sizeof(*id_phys));
>> Didn't you just obtain zeroed memory from kzalloc()?
Another good catch.
>>
>>> +	rc = hpsa_bmic_id_physical_device(h, scsi3addr, bmic_device_index,
>>> +						id_phys, sizeof(*id_phys));
>>> +	if (rc) {
>>> +		dev_warn(&h->pdev->dev, "%s: id_phys failed %d bdi[0x%x]\n",
>>> +			__func__, encl_dev->external, bmic_device_index);
>>> +		goto out;
>>> +	}
>>> +
>>> +	c = cmd_alloc(h);
>>> +
>>> +	rc = fill_cmd(c, BMIC_SENSE_STORAGE_BOX_PARAMS, h, bssbp,
>>> +			sizeof(*bssbp), 0, RAID_CTLR_LUNID, TYPE_CMD);
>>> +
>>> +	if (rc)
>>> +		goto out;
>>> +
>>> +	if (id_phys->phys_connector[1] == 'E')
>>> +		c->Request.CDB[5] = id_phys->box_index;
>>> +	else
>>> +		c->Request.CDB[5] = 0;
>>> +
>>> +	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
>>> +						NO_TIMEOUT);
>>> +	if (rc)
>>> +		goto out;
>>> +
>>> +	ei = c->err_info;
>>> +	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
>>> +		rc = -1;
>>> +		goto out;
>>> +	}
>>> +
>>> +	encl_dev->box[id_phys->active_path_number] = bssbp->phys_box_on_port;
>>> +	memcpy(&encl_dev->phys_connector[id_phys->active_path_number],
>>> +		bssbp->phys_connector, sizeof(bssbp->phys_connector));
>>> +
>>> +	rc = IO_OK;
>>> +out:
>>> +	kfree(bssbp);
>>> +	kfree(id_phys);
>>> +
>>> +	if (c)
>>> +		cmd_free(h, c);
>>> +
>>> +	if (rc != IO_OK)
>>> +		hpsa_show_dev_msg(KERN_INFO, h, encl_dev,
>>> +			"Error, could not get enclosure information\n");
>>> +	return rc;
>>> +}
>>> +
>>> static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
>>> 						unsigned char *scsi3addr)
>>> {
>>> @@ -4032,7 +4112,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
>>>
>>> 		/* skip masked non-disk devices */
>>> 		if (MASKED_DEVICE(lunaddrbytes) && physical_device &&
>>> -			(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
>>> +		   (physdev_list->LUN[phys_dev_index].device_type != 0x06) &&
>>> +		   (physdev_list->LUN[phys_dev_index].device_flags & 0x01))
>>> 			continue;
>>>
>>> 		/* Get device type, vendor, model, device id */
>>> @@ -4117,6 +4198,9 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
>>> 		case TYPE_TAPE:
>>> 		case TYPE_MEDIUM_CHANGER:
>> Is it 'okay' that these two types are falling through and will call this new
>> enclosure info routine?
Good Point.
>>
>>> 		case TYPE_ENCLOSURE:
>>> +			hpsa_get_enclosure_info(h, lunaddrbytes,
>>> +						physdev_list, phys_dev_index,
>>> +						this_device);
>> Any reason this routine wasn't made a void? The return code is not being used
>> and the other similar helpers in this path are void.
Good point.
>>
>>> 			ncurrent++;
>>> 			break;
>>> 		case TYPE_RAID:
>>> @@ -6629,6 +6713,16 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
>>> 			c->Request.CDB[7] = (size >> 16) & 0xFF;
>>> 			c->Request.CDB[8] = (size >> 8) & 0XFF;
>>> 			break;
>>> +		case BMIC_SENSE_STORAGE_BOX_PARAMS:
>>> +			c->Request.CDBLen = 10;
>>> +			c->Request.type_attr_dir =
>>> +				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
>>> +			c->Request.Timeout = 0;
>>> +			c->Request.CDB[0] = BMIC_READ;
>>> +			c->Request.CDB[6] = BMIC_SENSE_STORAGE_BOX_PARAMS;
>>> +			c->Request.CDB[7] = (size >> 16) & 0xFF;
>>> +			c->Request.CDB[8] = (size >> 8) & 0XFF;
>>> +			break;
>>> 		case BMIC_IDENTIFY_CONTROLLER:
>>> 			c->Request.CDBLen = 10;
>>> 			c->Request.type_attr_dir =
>>> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
>>> index d92ef0d..6a919ad 100644
>>> --- a/drivers/scsi/hpsa_cmd.h
>>> +++ b/drivers/scsi/hpsa_cmd.h
>>> @@ -291,6 +291,7 @@ struct SenseSubsystem_info {
>>> #define BMIC_SENSE_DIAG_OPTIONS 0xF5
>>> #define HPSA_DIAG_OPTS_DISABLE_RLD_CACHING 0x40000000
>>> #define BMIC_SENSE_SUBSYSTEM_INFORMATION 0x66
>>> +#define BMIC_SENSE_STORAGE_BOX_PARAMS 0x65
>>>
>>> /* Command List Structure */
>>> union SCSI3Addr {
>>> @@ -842,5 +843,17 @@ struct bmic_sense_subsystem_info {
>>> 	u8	pad[332];
>>> };
>>>
>>> +struct bmic_sense_storage_box_params {
>>> +	u8	reserved[36];
>>> +	u8	inquiry_valid;
>>> +	u8	reserved_1[68];
>>> +	u8	phys_box_on_port;
>>> +	u8	reserved_2[22];
>>> +	u16	connection_info;
>>> +	u8	reserver_3[84];
>>> +	u8	phys_connector[2];
>>> +	u8	reserved_4[296];
>>> +};
>>> +
>>> #pragma pack()
>>> #endif /* HPSA_CMD_H */
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

