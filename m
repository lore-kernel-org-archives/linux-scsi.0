From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V14 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Thu, 4 Oct 2018 16:10:27 +0530
Message-ID: <4aca5fe6-43db-c7b0-b255-622ccec4d1fc@codeaurora.org>
References: <1537770516-28410-1-git-send-email-sayalil@codeaurora.org>
 <1537770516-28410-3-git-send-email-sayalil@codeaurora.org>
 <SN6PR04MB4925D198F7AE8961254F43C9FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB4925D198F7AE8961254F43C9FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>
Cc: "stummala@codeaurora.org" <stummala@codeaurora.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 9/24/2018 3:33 PM, Avri Altman wrote:
>> obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>> obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>> ufshcd-core-objs := ufshcd.o ufs-sysfs.o
>> +obj-$(CONFIG_SCSI_UFS_PROVISION) += ufs-configfs.o
> Isn't ufs-configfs should be part of ufshcd-core? like ufs-sysfs ?
Agree. Will update.
>
>
>> +static ssize_t ufs_config_desc_show(struct config_item *item, char *buf,
>> +                                   u8 index)
>> +{
> The read part already exist in ufs-sysfs.
User can just read the existing desc here and update the required fields 
as per need and write updated buffer to same configfs path.
I think its better to have both r/w functionality here.
>
>> +ssize_t ufshcd_desc_configfs_store(struct config_item *item, const char *buf,
>> +                                  size_t count, u8 index)
>> +{
>
>> +
>> +       /*
>> +        * First read the current configuration descriptor
>> +        * and then update with user provided parameters
>> +        */
> if originally only lun0 was configured, and you want to configure a new set of luns -
> luns 8 to 15 (config index 0x1) - won't the read fail in that case?
Let me try it out on my setup internally and update once I test this 
scenario
>
> Thanks,
> Avri
