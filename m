From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Wed, 9 Aug 2017 18:50:10 +0200
Message-ID: <3b96a6c9-c5af-c50d-ba02-59863d1ee5f2@redhat.com>
References: <20170804210035.GA10017@redhat.com>
 <20170805084436.GA14264@lst.de> <20170805092704.GD20914@redhat.com>
 <20170805133954.GA17694@lst.de> <20170805155103.GE20914@redhat.com>
 <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
 <20170807122701.GH20914@redhat.com>
 <ffc29e81-ff6b-7132-2e90-86b5632098fb@redhat.com>
 <20170809160111.GC3141@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170809160111.GC3141@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 09/08/2017 18:01, Christoph Hellwig wrote:
> On Mon, Aug 07, 2017 at 03:07:48PM +0200, Paolo Bonzini wrote:
>> can_queue should depend on the virtqueue size, which unfortunately can
>> vary for each virtio-scsi device in theory.  The virtqueue size is
>> retrieved by drivers/virtio prior to calling vring_create_virtqueue, and
>> in QEMU it is the second argument to virtio_add_queue.
> 
> Why is that unfortunate?  We don't even have to set can_queue in
> the host template, we can dynamically set it on per-host basis.

Ah, cool, I thought allocations based on can_queue happened already in
scsi_host_alloc, but they happen at scsi_add_host time.

Paolo
