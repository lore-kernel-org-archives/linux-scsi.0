From: Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: Re: [PATCH] scsi: devinfo: Add Microsoft iSCSI target to 1024 sector
 blacklist
Date: Thu, 5 Apr 2018 17:58:13 +0100
Message-ID: <2b7a3146-e2e4-699f-5633-13d8b568786d@citrix.com>
References: <20180326135651.8193-1-ross.lagerwall@citrix.com>
 <yq17epvj2f1.fsf@oracle.com>
 <MWHPR2101MB0729E7680EDB0EE4886AAED1CEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB0729E7680EDB0EE4886AAED1CEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, KY Srinivasan <kys@microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/28/2018 11:33 PM, Long Li wrote:
>> Subject: Re: [PATCH] scsi: devinfo: Add Microsoft iSCSI target to 1024 sector
>> blacklist
>>
>>
>> Long, KY: Please confirm.
>>
>>> The Windows Server 2016 iSCSI target doesn't work with the Linux
>>> kernel initiator since the kernel started sending larger requests by
>>> default, nor does it implement the block limits VPD page. Apply the
>>> sector limit workaround for these targets.
>>>
>>> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
>>> ---
>>>   drivers/scsi/scsi_devinfo.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
>>> index f3b1172..5cb748a 100644
>>> --- a/drivers/scsi/scsi_devinfo.c
>>> +++ b/drivers/scsi/scsi_devinfo.c
>>> @@ -213,7 +213,7 @@ static struct {
>>>   	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
>>>   	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
>>>   	{"MICROP", "4110", NULL, BLIST_NOTQ},
>>> -	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
>>> +	{"MSFT", "Virtual HD", NULL, BLIST_MAX_1024 | BLIST_NO_RSOC},
> 
> Ross,
> 
> What about storage_channel_properties.max_transfer_bytes returned from VSTOR_OPERATION_QUERY_PROPERTIES (in storvsc_channel_init())
> 
> Does it return correctly the maximum transfer size for iSCSI?
> 

I presume you're referring to the Hyper-V virtual storage driver? This 
has nothing to do with that module -- I don't even have it compiled in. 
It's just simply the Linux kernel initiator connecting over plain 
software iSCSI to a Windows Server 2016 iSCSI target.

This is easy enough to reproduce. Just set up a Windows Server 2016 
target and try and use it from Linux. You get I/O errors as soon as you 
try and format the disk.

Cheers,
-- 
Ross Lagerwall
