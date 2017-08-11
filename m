From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
 WARN.
Date: Fri, 11 Aug 2017 16:09:26 +0200
Message-ID: <64d3c483-076b-1362-b284-30dda704f80c@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
 <20170810164035.19963-2-rjones@redhat.com>
 <20170811001447-mutt-send-email-mst@kernel.org>
 <20170810213038.GC20914@redhat.com>
 <20170811003107-mutt-send-email-mst@kernel.org>
 <20170810213511.GB10017@redhat.com>
 <20170811003621-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170811003621-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>, "Richard W.M. Jones" <rjones@redhat.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10/08/2017 23:41, Michael S. Tsirkin wrote:
>>> Then we probably should fail probe if vq size is too small.
>> What does this mean?
> 
> We must prevent driver from submitting s/g lists > vq size to device.

What is the rationale for the limit?  It makes no sense if indirect
descriptors are available, especially because...

> Either tell linux to avoid s/g lists that are too long, or
> simply fail request if this happens, or refuse to attach driver to device.
> 
> Later option would look something like this within probe:
> 
>         for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
> 		if (vqs[i]->num < MAX_SG_USED_BY_LINUX)
> 			goto err;
> 
> 
> I don't know what's MAX_SG_USED_BY_LINUX though.
> 

... both virtio-blk and virtio-scsi transmit their own value for the
maximum sg list size (max_seg in virtio-scsi, seg_max in virtio-blk).

Paolo
