From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [RFC PATCH v2] scsi: fix oops in scsi_uninit_cmd()
Date: Fri, 22 Mar 2019 09:33:01 +0800
Message-ID: <eb0051ca-2676-e6b8-0362-8a89f01e58ec@huawei.com>
References: <20190316020905.14962-1-yanaijie@huawei.com>
 <1553193542.65329.119.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553193542.65329.119.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, hch@lst.de, tom.leiming@gmail.com
List-Id: linux-scsi@vger.kernel.org


On 2019/3/22 2:39, Bart Van Assche wrote:
> On Sat, 2019-03-16 at 10:09 +0800, Jason Yan wrote:
>> If we remove the scsi disk when running io with fio, oops occured with
>> the following condition.
>>
>> [scsi_eh_0]                              [fio]
>> scsi_end_request
>>    ->blk_update_request
>>      ->end_bio(io returned to userspace)
>>                                           close
>>                                             ->sd_release
>>                                                ->scsi_disk_put
>>                                                   ->scsi_disk_release
>>                                                       ->disk->private_data = NULL;
>>
>>    ->scsi_mq_uninit_cmd
>>      ->scsi_uninit_cmd
>>        ->scsi_cmd_to_driver
>>      ->drv is NULL, Oops
>>
>> There is a small window between blk_update_request() and
>> scsi_mq_uninit_cmd() that scsi disk may have been released. This will
>> cause a oops like below:
>>
>> Unable to handle kernel NULL pointer dereference at virtual address
>> 0000000000000000
>> s/sync.c:67, func=xfer, error=In[11347.116050] Mem abort info:
>> put/output error
>> [11347.121598]   ESR = 0x96000006
>> [11347.126200]   Exception class = DABT (current EL), IL = 32 bits
>> [11347.132117]   SET = 0, FnV = 0
>> [11347.135170]   EA = 0, S1PTW = 0
>> [11347.138308] Data abort info:
>> [11347.141186]   ISV = 0, ISS = 0x00000006
>> [11347.145019]   CM = 0, WnR = 0
>> [11347.147977] user pgtable: 4k pages, 48-bit VAs, pgdp =
>> 00000000a67aece2
>> [11347.154591] [0000000000000000] pgd=0000002f90774003,
>> pud=0000002fab098003, pmd=0000000000000000
>> [11347.163304] Internal error: Oops: 96000006 [#1] PREEMPT SMP
>> [11347.168870] Modules linked in: hisi_sas_v3_hw hisi_sas_main libsas
>> [11347.175044] CPU: 56 PID: 4294 Comm: scsi_eh_2 Not tainted
>> 4.19.0-g8052059-dirty #2
>> [11347.182600] Hardware name: Huawei D06/D06, BIOS Hisilicon D06 UEFI
>> RC0 - B601 (V6.01) 11/08/2018
>> [11347.191370] pstate: a0c00009 (NzCv daif 㰃繐ε흾㯗
> 
> Please verify whether the following patch is a valid alternative for your patch:
> 

Thanks Bart, I will verify it later.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ed34bfbc3844..745ffdda1bc1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1408,6 +1408,7 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
>   {
>   	struct scsi_disk *sdkp = scsi_disk(disk);
>   	struct scsi_device *sdev = sdkp->device;
> +	struct request_queue *q = sdkp->disk->queue;
>   
>   	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
>   
> @@ -1417,9 +1418,12 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
>   	}
>   
>   	/*
> -	 * XXX and what if there are packets in flight and this close()
> -	 * XXX is followed by a "rmmod sd_mod"?
> +	 * Wait until any requests that are in progress have completed.
> +	 * This is necessary to avoid that e.g. scsi_end_request() crashes
> +	 * due to scsi_disk_relase() clearing the disk->private_data pointer.
>   	 */
> +	blk_mq_freeze_queue(q);
> +	blk_mq_unfreeze_queue(q);
>   
>   	scsi_disk_put(sdkp);
>   }
> 
> Thanks,
> 
> Bart.
> 
> .
> 
