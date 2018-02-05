From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] scsi: virtio_scsi: fix IO hang by irq vector
 automatic affinity
Date: Mon, 5 Feb 2018 07:57:29 +0100
Message-ID: <4b831a39-1024-48d3-bb7c-3395f85cd4db@suse.de>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <20180203042112.15239-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbeBEG5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 01:57:30 -0500
In-Reply-To: <20180203042112.15239-6-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On 02/03/2018 05:21 AM, Ming Lei wrote:
> Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> for some irq vectors, this can't be avoided even though the allocation
> is improved.
> 
> For example, on a 8cores VM, 4~7 are not-present/offline, 4 queues of
> virtio-scsi, the irq affinity assigned can become the following shape:
> 
> 	irq 36, cpu list 0-7
> 	irq 37, cpu list 0-7
> 	irq 38, cpu list 0-7
> 	irq 39, cpu list 0-1
> 	irq 40, cpu list 4,6
> 	irq 41, cpu list 2-3
> 	irq 42, cpu list 5,7
> 
> Then IO hang is triggered in case of non-SCSI_MQ.
> 
> Given storage IO is always C/S model, there isn't such issue with SCSI_MQ(blk-mq),
> because no IO can be submitted to one hw queue if the hw queue hasn't online
> CPUs.
> 
> Fix this issue by forcing to use blk_mq.
> 
> BTW, I have been used virtio-scsi(scsi_mq) for several years, and it has
> been quite stable, so it shouldn't cause extra risk.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 59 +++-------------------------------------------
>  1 file changed, 3 insertions(+), 56 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
