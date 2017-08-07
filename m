From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Mon, 7 Aug 2017 15:07:48 +0200
Message-ID: <ffc29e81-ff6b-7132-2e90-86b5632098fb@redhat.com>
References: <20170804210035.GA10017@redhat.com>
 <20170805084436.GA14264@lst.de> <20170805092704.GD20914@redhat.com>
 <20170805133954.GA17694@lst.de> <20170805155103.GE20914@redhat.com>
 <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
 <20170807122701.GH20914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170807122701.GH20914@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 07/08/2017 14:27, Richard W.M. Jones wrote:
> Also I noticed this code in virtio_scsi.c:
> 
>         cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
>         shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
> 
> but setting cmd_per_lun (as a qemu virtio-scsi-pci parameter) didn't
> seem to make any difference to memory usage.

That's because memory depends on shost->can_queue, not
shost->cmd_per_lun (see scsi_mq_setup_tags).

can_queue should depend on the virtqueue size, which unfortunately can
vary for each virtio-scsi device in theory.  The virtqueue size is
retrieved by drivers/virtio prior to calling vring_create_virtqueue, and
in QEMU it is the second argument to virtio_add_queue.

For virtio-scsi this is VIRTIO_SCSI_VQ_SIZE, which is 128, so changing
can_queue to 128 should be a no brainer.

Thanks,

Paolo
