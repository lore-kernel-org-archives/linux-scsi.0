From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] Limit number of hw queues by nr_cpu_ids for
 virtio-blk and virtio-scsi
Date: Wed, 10 Apr 2019 08:18:50 -0600
Message-ID: <47e8d8bf-1820-5cb4-ac78-1bcd5ea26c49@kernel.dk>
References: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongli Zhang <dongli.zhang@oracle.com>, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com, cohuck@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 3/27/19 4:36 AM, Dongli Zhang wrote:
> When tag_set->nr_maps is 1, the block layer limits the number of hw queues
> by nr_cpu_ids. No matter how many hw queues are use by
> virtio-blk/virtio-scsi, as they both have (tag_set->nr_maps == 1), they
> can use at most nr_cpu_ids hw queues.
> 
> In addition, specifically for pci scenario, when the 'num-queues' specified
> by qemu is more than maxcpus, virtio-blk/virtio-scsi would not be able to
> allocate more than maxcpus vectors in order to have a vector for each
> queue. As a result, they fall back into MSI-X with one vector for config
> and one shared for queues.
> 
> Considering above reasons, this patch set limits the number of hw queues
> used by nr_cpu_ids for both virtio-blk and virtio-scsi.

I picked both up for 5.1.

-- 
Jens Axboe
