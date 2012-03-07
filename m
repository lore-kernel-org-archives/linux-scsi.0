From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Date: Wed, 7 Mar 2012 10:11:28 -0500
Message-ID: <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com> <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn> <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: santoshprasadnayak@gmail.com
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

One more NAK:

> @@ -3497,7 +3499,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
> {
> 	u32 pHeader = (u32)*(u32 *)piomb;
> -	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
> +	u8 opc = (u8)(pHeader & 0xFFF);
> 
> 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));

The swap is necessary. Should be:

	__le32 pHeader = (__le32)*(__le32 *)piomb;

instead ...

Sincerely -- Mark Salyzyn

On Mar 7, 2012, at 9:58 AM, Mark Salyzyn wrote:

> NAK on one point.
> 
> The fw_flash_Update_resp structure erroneously defines tag as a dma_addr_t, when in fact it should be an __le32, as the response hTag is reported in this field. The removal of the le32_to_cpu(ppayload->tag) was done to remove a warning, but is incorrect. The warning should have been solved by correctly defining the tag element in the structure.
> 
> Sincerely -- Mark Salyzyn
> 
> On Feb 26, 2012, at 11:51 PM, Jack Wang wrote:
> 
>> Thanks for fix.
>> Acked-by: Jack Wang <jack_wang@usish.com>
>>> 
>>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>> 
>>> 1. Fix endian issue.
>>> 2. Fix the following warning :
>>>   " drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: comparison
>>>     between 'enum sas_device_type' and 'enum sas_dev_type'".
>>> 3. Few code optimization.
>>> 
>>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>>> ---
>>> . . .
>>> @@ -3149,7 +3152,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info
>>> *pm8001_ha, void *piomb)
>>> 	struct fw_control_ex	fw_control_context;
>>> 	struct fw_flash_Update_resp *ppayload
>>> 		(struct fw_flash_Update_resp *)(piomb + 4);
>>> -	u32 tag = le32_to_cpu(ppayload->tag);
>>> +	u32 tag = ppayload->tag;
>>> 	struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
>>> 	status = le32_to_cpu(ppayload->status);
>>> 	memcpy(&fw_control_context,
> 
