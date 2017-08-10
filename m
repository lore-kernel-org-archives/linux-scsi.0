From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Thu, 10 Aug 2017 14:53:58 +0200
Message-ID: <63c286cb-4720-33a7-5fcd-e7591cd6dd2c@redhat.com>
References: <20170804210035.GA10017@redhat.com>
 <20170805084436.GA14264@lst.de> <20170805092704.GD20914@redhat.com>
 <20170805133954.GA17694@lst.de> <20170805155103.GE20914@redhat.com>
 <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
 <20170807122701.GH20914@redhat.com>
 <ffc29e81-ff6b-7132-2e90-86b5632098fb@redhat.com>
 <20170809160111.GC3141@lst.de>
 <3b96a6c9-c5af-c50d-ba02-59863d1ee5f2@redhat.com>
 <20170810122232.GY20914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170810122232.GY20914@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 10/08/2017 14:22, Richard W.M. Jones wrote:
> On Wed, Aug 09, 2017 at 06:50:10PM +0200, Paolo Bonzini wrote:
>> On 09/08/2017 18:01, Christoph Hellwig wrote:
>>> On Mon, Aug 07, 2017 at 03:07:48PM +0200, Paolo Bonzini wrote:
>>>> can_queue should depend on the virtqueue size, which unfortunately can
>>>> vary for each virtio-scsi device in theory.  The virtqueue size is
>>>> retrieved by drivers/virtio prior to calling vring_create_virtqueue, and
>>>> in QEMU it is the second argument to virtio_add_queue.
>>>
>>> Why is that unfortunate?  We don't even have to set can_queue in
>>> the host template, we can dynamically set it on per-host basis.
>>
>> Ah, cool, I thought allocations based on can_queue happened already in
>> scsi_host_alloc, but they happen at scsi_add_host time.
> 
> I think I've decoded all that information into the patch below.
> 
> I tested it, and it appears to work: when I set cmd_per_lun on the
> qemu command line, I see that the guest can add more disks:
> 
>   With scsi-mq enabled:   175 disks
>   cmd_per_lun not set:    177 disks  *
>   cmd_per_lun=16:         776 disks  *
>   cmd_per_lun=4:         1160 disks  *
>   With scsi-mq disabled: 1755 disks
>                                      * = new result
> 
> From my point of view, this is a good result, but you should be warned
> that I don't fully understand what's going on here and I may have made
> obvious or not-so-obvious mistakes.

can_queue and cmd_per_lun are different.  can_queue should be set to the
value of vq->vring.num where vq is the command virtqueue (the first one
is okay if there's >1).

If you want to change it, you'll have to do so in QEMU.

Paolo

> I tested the performance impact and it's not noticable in the
> libguestfs case even with very small cmd_per_lun settings, but
> libguestfs is largely serial and so this result won't be applicable to
> guests in general.
> 
> Also, should the guest kernel validate cmd_per_lun to make sure it's
> not too small or large?  And if so, what would the limits be?
> 
> Rich.
> 
> From e923e49846189b2f55f3f02b70a290d4be237ed5 Mon Sep 17 00:00:00 2001
> From: "Richard W.M. Jones" <rjones@redhat.com>
> Date: Thu, 10 Aug 2017 12:21:47 +0100
> Subject: [PATCH] scsi: virtio_scsi: Set can_queue based on cmd_per_lun passed
>  by hypervisor.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 9be211d68b15..b22591e9b16b 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -973,7 +973,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  		goto virtscsi_init_failed;
>  
>  	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
> -	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
> +	shost->cmd_per_lun = shost->can_queue = cmd_per_lun;
>  	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
>  
>  	/* LUNs > 256 are reported with format 1, so they go in the range
> 
