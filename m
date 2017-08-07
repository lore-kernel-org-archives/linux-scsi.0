From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Mon, 7 Aug 2017 14:11:39 +0200
Message-ID: <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
References: <20170804210035.GA10017@redhat.com>
 <20170805084436.GA14264@lst.de> <20170805092704.GD20914@redhat.com>
 <20170805133954.GA17694@lst.de> <20170805155103.GE20914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170805155103.GE20914@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 05/08/2017 17:51, Richard W.M. Jones wrote:
> On Sat, Aug 05, 2017 at 03:39:54PM +0200, Christoph Hellwig wrote:
>> For now can you apply this testing patch to the guest kernel?
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 9be211d68b15..0cbe2c882e1c 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -818,7 +818,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
>>  	.eh_timed_out = virtscsi_eh_timed_out,
>>  	.slave_alloc = virtscsi_device_alloc,
>>  
>> -	.can_queue = 1024,
>> +	.can_queue = 64,
>>  	.dma_boundary = UINT_MAX,
>>  	.use_clustering = ENABLE_CLUSTERING,
>>  	.target_alloc = virtscsi_target_alloc,
>> @@ -839,7 +839,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
>>  	.eh_timed_out = virtscsi_eh_timed_out,
>>  	.slave_alloc = virtscsi_device_alloc,
>>  
>> -	.can_queue = 1024,
>> +	.can_queue = 64,
>>  	.dma_boundary = UINT_MAX,
>>  	.use_clustering = ENABLE_CLUSTERING,
>>  	.target_alloc = virtscsi_target_alloc,
>> @@ -983,7 +983,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>>  	shost->max_id = num_targets;
>>  	shost->max_channel = 0;
>>  	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
>> -	shost->nr_hw_queues = num_queues;
>> +	shost->nr_hw_queues = 1;
>>  
>>  #ifdef CONFIG_BLK_DEV_INTEGRITY
>>  	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
> 
> Yes, that's an improvement, although it's still a little way off the
> density possible the old way:
> 
>   With scsi-mq enabled:   175 disks
> * With this patch:        319 disks *
>   With scsi-mq disabled: 1755 disks
> 
> Also only the first two hunks are necessary.  The kernel behaves
> exactly the same way with or without the third hunk (ie. num_queues
> must already be 1).
> 
> Can I infer from this that qemu needs a way to specify the can_queue
> setting to the virtio-scsi driver in the guest kernel?

You could also add a module parameter to the driver, and set it to 64 on
the kernel command line (there is an example in
drivers/scsi/vmw_pvscsi.c of how to do it).

Paolo
