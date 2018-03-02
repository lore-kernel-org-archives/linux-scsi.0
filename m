From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH V2] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Fri, 2 Mar 2018 10:17:24 +0800
Message-ID: <1bb1537c-3427-b56d-c296-aa9b101262e3@oracle.com>
References: <1519808113-2863-1-git-send-email-jianchao.w.wang@oracle.com>
 <1519840355.2777.8.camel@wdc.com>
 <624cedc6-9658-7b76-9c63-61c30fdfe6be@oracle.com>
 <1519926225.2675.6.camel@wdc.com> <yq17eqvz1zn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq17eqvz1zn.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi martin

Thanks for your kindly response.

On 03/02/2018 09:43 AM, Martin K. Petersen wrote:
> 
> Jianchao,
> 
>> Yes, the block layer core guarantees that scsi_mq_get_budget() will be
>> called before scsi_queue_rq(). I think the full picture is as follows:
> 
>> * Before scsi_queue_rq() calls .queuecommand(), get_device() is called for the
>>   SCSI device and the device, target and host busy counters are incremented.
>> * If the SCSI core decides to requeue a command, scsi_queue_insert() causes
>>   __scsi_queue_insert() to call scsi_device_unbusy(). That last function
>>   decreases the device, target and host busy counters but not put_device(sdev).
>>   Hence the need for a separate put_device() call after requeuing.
>>
>> It's unfortunate that the SCSI core became so asymmetric. Anyway,
>> since I am now convinced that this patch is correct, feel free to add:
> 
> Please add something akin to Bart's explanation as a comment and repost.

yes, sure.


Thanks
Jianchao
