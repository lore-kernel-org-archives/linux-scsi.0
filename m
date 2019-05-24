From: lijiang <lijiang@redhat.com>
Subject: Re: [PATCH] scsi: smartpqi: properly set both the DMA mask and the
 coherent DMA mask in pqi_pci_init()
Date: Fri, 24 May 2019 19:16:17 +0800
Message-ID: <cea857c8-12db-d10c-124a-fd68cdcdc202@redhat.com>
References: <20190523055212.23568-1-lijiang@redhat.com>
 <c5d45523-43f5-d2fd-01ac-85f285146ecd@amd.com>
 <SN6PR11MB2767D4410415F0B03BFE900DE1010@SN6PR11MB2767.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR11MB2767D4410415F0B03BFE900DE1010@SN6PR11MB2767.namprd11.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Don.Brace@microchip.com, Thomas.Lendacky@amd.com, linux-kernel@vger.kernel.org
Cc: don.brace@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, dyoung@redhat.com
List-Id: linux-scsi@vger.kernel.org

在 2019年05月24日 06:55, Don.Brace@microchip.com 写道:
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Lendacky, Thomas
> Sent: Thursday, May 23, 2019 9:45 AM
> To: Lianbo Jiang <lijiang@redhat.com>; linux-kernel@vger.kernel.org
> Cc: don.brace@microsemi.com; jejb@linux.ibm.com; martin.petersen@oracle.com; linux-scsi@vger.kernel.org; esc.storagedev@microsemi.com; dyoung@redhat.com
> Subject: Re: [PATCH] scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask in pqi_pci_init()
> 
> On 5/23/19 12:52 AM, Lianbo Jiang wrote:
>> When SME is enabled, the smartpqi driver won't work on the HP DL385
>> G10 machine, which causes the failure of kernel boot because it fails 
>> to allocate pqi error buffer. Please refer to the kernel log:
>> ....
>> [    9.431749] usbcore: registered new interface driver uas
>> [    9.441524] Microsemi PQI Driver (v1.1.4-130)
>> [    9.442956] i40e 0000:04:00.0: fw 6.70.48768 api 1.7 nvm 10.2.5
>> [    9.447237] smartpqi 0000:23:00.0: Microsemi Smart Family Controller found
>>          Starting dracut initqueue hook...
>> [  OK  ] Started Show Plymouth Boot Scre[    9.471654] Broadcom NetXtreme-C/E driver bnxt_en v1.9.1
>> en.
>> [  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
>> [[0;[    9.487108] smartpqi 0000:23:00.0: failed to allocate PQI error buffer
>> ....
>> [  139.050544] dracut-initqueue[949]: Warning: dracut-initqueue 
>> timeout - starting timeout scripts [  139.589779] 
>> dracut-initqueue[949]: Warning: dracut-initqueue timeout - starting 
>> timeout scripts
>>
>> For correct operation, lets call the dma_set_mask_and_coherent() to 
>> properly set the mask for both streaming and coherent, in order to 
>> inform the kernel about the devices DMA addressing capabilities.
> 
> You should probably expand on this a bit...  Basically, the fact that the coherent DMA mask value wasn't set caused the driver to fall back to SWIOTLB when SME is active.

Thank you, Tom.

> I'm not sure if the failure was from running out of SWIOTLB or exceeding the maximum allocation size for SWIOTLB
If so, it should print some messages like "swiotlb buffer is full", but i did not get such a log.

> I believe the fix is proper, but I'll let the driver owner comment on that.
> 
> Thanks,
> Tom
> 
> Acked-by: Don Brace <don.brace@microsemi.com>
> Tested-by: Don Brace <don.brace@microsemi.com>
> 
> Please add the extra description suggested by Thomas.
> 
OK, i will add Tom's description to patch log and post again.

Thank you, Don.

Lianbo
> 
>>
>> Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
>> ---
>>  drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c 
>> b/drivers/scsi/smartpqi/smartpqi_init.c
>> index c26cac819f9e..8b1fde6c7dab 100644
>> --- a/drivers/scsi/smartpqi/smartpqi_init.c
>> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
>> @@ -7282,7 +7282,7 @@ static int pqi_pci_init(struct pqi_ctrl_info *ctrl_info)
>>         else
>>                 mask = DMA_BIT_MASK(32);
>>
>> -       rc = dma_set_mask(&ctrl_info->pci_dev->dev, mask);
>> +       rc = dma_set_mask_and_coherent(&ctrl_info->pci_dev->dev, 
>> + mask);
>>         if (rc) {
>>                 dev_err(&ctrl_info->pci_dev->dev, "failed to set DMA mask\n");
>>                 goto disable_device;
>> --
>> 2.17.1
>>
