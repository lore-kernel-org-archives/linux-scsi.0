From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH v2 20/27] hpsa: generalize external arrays
Date: Thu, 5 Nov 2015 13:51:41 -0600
Message-ID: <563BB34D.60805@pmcs.com>
References: <20151104214910.15472.23179.stgit@brunhilda>
 <20151104215157.15472.13416.stgit@brunhilda>
 <9FDA9021-7F35-44B6-B3CA-04604EA89D31@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33694 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbbKETvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 14:51:45 -0500
Received: by obbww6 with SMTP id ww6so48825773obb.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 11:51:45 -0800 (PST)
In-Reply-To: <9FDA9021-7F35-44B6-B3CA-04604EA89D31@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On 11/05/2015 10:23 AM, Matthew R. Ochs wrote:
>> On Nov 4, 2015, at 3:51 PM, Don Brace <don.brace@pmcs.com> wrote:
>>
>> From: Scott Teel <scott.teel@pmcs.com>
>>
>> External array LUNs must use target and lun numbers assigned by the
>> external array. So the driver must treat these differently from
>> local LUNs when assigning lun/target.
>>
>> LUN's 'model' field has been used to detect Lun types that need
>> special treatment, but the desire is to eliminate the need to reference
>> specific array models, and support any external array.
>>
>> Pass-through RAID (PTRAID) luns are not luns of the local controller,
>> so they are not reported in LUN count of command 'ID controller'.
>> However, they ARE reported in "Report logical Luns" command.
>> Local luns are listed first, then PTRAID LUNs.
>>
>> The number of luns from "Report LUNs" in excess of those reported by
>> 'ID controller' are therefore the PTRAID LUNS.
>>
>> We can now remove function is_ext_target, and the 'white list'
>> array of supported model names.
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>> drivers/scsi/hpsa.c     |  139 ++++++++++++++++++++++++++++++++++++++---------
>> drivers/scsi/hpsa.h     |    1
>> drivers/scsi/hpsa_cmd.h |   11 ++++
>> 3 files changed, 125 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 0af4c67..1a67d63 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -275,7 +275,6 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
>> static void hpsa_command_resubmit_worker(struct work_struct *work);
>> static u32 lockup_detected(struct ctlr_info *h);
>> static int detect_controller_lockup(struct ctlr_info *h);
>> -static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device);
>>
>>
>> }
>>
>> @@ -6414,6 +6484,23 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
>> 			c->Request.CDB[7] = (size >> 16) & 0xFF;
>> 			c->Request.CDB[8] = (size >> 8) & 0XFF;
>> 			break;
>> +		case BMIC_IDENTIFY_CONTROLLER:
>> +			c->Request.CDBLen = 10;
>> +			c->Request.type_attr_dir =
>> +				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
>> +			c->Request.Timeout = 0;
>> +			c->Request.CDB[0] = BMIC_READ;
>> +			c->Request.CDB[1] = 0;
>> +			c->Request.CDB[2] = 0;
>> +			c->Request.CDB[3] = 0;
>> +			c->Request.CDB[4] = 0;
>> +			c->Request.CDB[5] = 0;
>> +			c->Request.CDB[6] = BMIC_IDENTIFY_CONTROLLER;
>> +			c->Request.CDB[7] = (size >> 16) & 0xFF;
>> +			c->Request.CDB[8] = (size >> 8) & 0XFF;
>> +			c->Request.CDB[9] = 0;
>> +			break;
>> +
> For consistency with the other fill_cmd() cases these unnecessary zeroing statements
> should be removed, either now or at some point in the future.
>
> Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Thanks, unless I have to send up a V3, I'll add this to my next patch set.
It does look cleaner with them removed.
>
>> 		default:
>> 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
>> 			BUG();
>> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
>> index a4cab12..ffcd4cb 100644
>> --- a/drivers/scsi/hpsa.h
>> +++ b/drivers/scsi/hpsa.h
>> @@ -77,6 +77,7 @@ struct hpsa_scsi_dev_t {
>> 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
>> 	int nphysical_disks;
>> 	int supports_aborts;
>> +	int external;   /* 1-from external array 0-not <0-unknown */
>> };
>>
>> struct reply_queue_buffer {
>> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
>> index c2c0737..c83eaf1 100644
>> --- a/drivers/scsi/hpsa_cmd.h
>> +++ b/drivers/scsi/hpsa_cmd.h
>> @@ -286,6 +286,7 @@ struct SenseSubsystem_info {
>> #define BMIC_FLASH_FIRMWARE 0xF7
>> #define BMIC_SENSE_CONTROLLER_PARAMETERS 0x64
>> #define BMIC_IDENTIFY_PHYSICAL_DEVICE 0x15
>> +#define BMIC_IDENTIFY_CONTROLLER 0x11
>>
>> /* Command List Structure */
>> union SCSI3Addr {
>> @@ -682,6 +683,16 @@ struct hpsa_pci_info {
>> 	u32		board_id;
>> };
>>
>> +struct bmic_identify_controller {
>> +	u8	configured_logical_drive_count;	/* offset 0 */
>> +	u8	pad1[153];
>> +	__le16	extended_logical_unit_count;	/* offset 154 */
>> +	u8	pad2[136];
>> +	u8	controller_mode;	/* offset 292 */
>> +	u8	pad3[32];
>> +};
>> +
>> +
>> struct bmic_identify_physical_device {
>> 	u8    scsi_bus;          /* SCSI Bus number on controller */
>> 	u8    scsi_id;           /* SCSI ID on this bus */
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

