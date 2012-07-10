From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Mon, 09 Jul 2012 17:29:14 -0700
Message-ID: <1341880154.23954.608.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	 <20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	 <20120704150557.GA26951@redhat.com>  <4FF4BFBD.2080000@us.ibm.com>
	 <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
Sender: kvm-owner@vger.kernel.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

On Wed, 2012-07-04 at 18:52 -0700, Nicholas A. Bellinger wrote:
> 
> To give an idea of how things are looking on the performance side, here
> some initial numbers for small block (4k) mixed random IOPs using the
> following fio test setup:

<SNIP>

> fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> ------------------------------------------------------------------------------------
> 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K
> 
> 

After checking the original benchmarks here again, I realized that for
virtio-scsi+tcm_vhost the results where actually switched..

So this should have been: heavier READ case (25 / 75) == 55K, and
heavier WRITE case (75 / 25) == 45K.

> In the first case, virtio-scsi+tcm_vhost is out performing by 3x
> compared to virtio-scsi-raw using QEMU SCSI emulation with the same raw
> flash backend device.  For the second case heavier WRITE case, tcm_vhost
> is nearing full bare-metal utilization (~55K vs. ~60K).
> 
> Also converting tcm_vhost to use proper cmwq process context I/O
> submission will help to get even closer to bare metal speeds for both
> work-loads.
> 

Here are initial follow-up virtio-scsi randrw 4k benchmarks with
tcm_vhost recently converted to run backend I/O dispatch via modern cmwq
primitives (kworkerd).

fio randrw 4k workload | virtio-scsi+tcm_vhost+cmwq
---------------------------------------------------
  25 Write / 75 Read   |          ~60K
  75 Write / 25 Read   |	  ~45K

So aside from the minor performance improvement for the 25 / 75
workload, the other main improvement is lower CPU usage using the
iomemory_vsl backends.  This is attributed to cmwq providing process
context on the same core as the vhost thread pulling items off vq, which
ends up being on the order of 1/3 less host CPU usage (for both
workloads) primarly from positive cache effects.

This patch is now available in target-pending/tcm_vhost, and I'll be
respinning the initial merge series into for-next-merge over the next
days + another round of list review.

Please let us know if you have any concerns.

Thanks!

--nab

