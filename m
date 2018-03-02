From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH V2] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Fri, 2 Mar 2018 10:16:37 +0800
Message-ID: <c575c4d0-ee5a-6123-d44e-7be93650e3f4@oracle.com>
References: <1519808113-2863-1-git-send-email-jianchao.w.wang@oracle.com>
 <1519840355.2777.8.camel@wdc.com>
 <624cedc6-9658-7b76-9c63-61c30fdfe6be@oracle.com>
 <1519926225.2675.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519926225.2675.6.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Bart

Thanks for your precious time and detailed summary.

On 03/02/2018 01:43 AM, Bart Van Assche wrote:
> Yes, the block layer core guarantees that scsi_mq_get_budget() will be called
> before scsi_queue_rq(). I think the full picture is as follows:
> * Before scsi_queue_rq() calls .queuecommand(), get_device() is called for the
>   SCSI device and the device, target and host busy counters are incremented.

Supply some details here:
scsi_mq_get_budget before calling .queuecommand get_device and increase device_busy.
scsi_queue_rq increases target_busy and host_busy.

> * If the SCSI core decides to requeue a command, scsi_queue_insert() causes
>   __scsi_queue_insert() to call scsi_device_unbusy(). That last function
>   decreases the device, target and host busy counters but not put_device(sdev).
>   Hence the need for a separate put_device() call after requeuing.
> 
> It's unfortunate that the SCSI core became so asymmetric. Anyway, since I am
> now convinced that this patch is correct, feel free to add:
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>


Sincerely
Jianchao
