From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 8/8] scsi: hpsa: use blk_mq to solve irq affinity issue
Date: Tue, 6 Feb 2018 16:23:54 +0800
Message-ID: <20180206082353.GB14651@ming.t460p>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-9-ming.lei@redhat.com>
 <bce37b1a-6faf-a661-19cd-ef583f19f280@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbeBFIYP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 03:24:15 -0500
Content-Disposition: inline
In-Reply-To: <bce37b1a-6faf-a661-19cd-ef583f19f280@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

Hello chenxiang,

On Tue, Feb 06, 2018 at 10:18:19AM +0800, chenxiang (M) wrote:
> 在 2018/2/5 23:20, Ming Lei 写道:
> > This patch uses .force_blk_mq to drive HPSA via SCSI_MQ, meantime maps
> > each reply queue to blk_mq's hw queue, then .queuecommand can always
> > choose the hw queue as the reply queue. And if no any online CPU is
> > mapped to one hw queue, request can't be submitted to this hw queue
> > at all, finally the irq affinity issue is solved.
> > 
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Arun Easi <arun.easi@cavium.com>
> > Cc: Omar Sandoval <osandov@fb.com>,
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> > Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> > Cc: Christoph Hellwig <hch@lst.de>,
> > Cc: Don Brace <don.brace@microsemi.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Peter Rivera <peter.rivera@broadcom.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/scsi/hpsa.c | 51 ++++++++++++++++++++++++++++++++++-----------------
> >   1 file changed, 34 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 443eabf63a9f..e517a4c74a28 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -51,6 +51,7 @@
> >   #include <linux/jiffies.h>
> >   #include <linux/percpu-defs.h>
> >   #include <linux/percpu.h>
> > +#include <linux/blk-mq-pci.h>
> >   #include <asm/unaligned.h>
> >   #include <asm/div64.h>
> >   #include "hpsa_cmd.h"
> > @@ -956,6 +957,13 @@ static struct device_attribute *hpsa_shost_attrs[] = {
> >   #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
> >   				 HPSA_MAX_CONCURRENT_PASSTHRUS)
> > +static int hpsa_map_queues(struct Scsi_Host *shost)
> > +{
> > +        struct ctlr_info *h = shost_to_hba(shost);
> > +
> > +        return blk_mq_pci_map_queues(&shost->tag_set, h->pdev);
> > +}
> > +
> 
> Hi Lei Ming,
> It is okay to use blk_mq_pci_map_queue to solve automatic irq affinity issue
> when the first interrupt vector for queues is 0.
> But if the first interrupt vector for queues is not 0,  we seems couldn't
> use blk_mq_pci_map_queue directly,
> such as blk_mq_virtio_map_queues, it realizes a interface itself. Is it
> possible to provide a general interface for those
> situations?

I guess it isn't necessary to do that, as you see .map_queues has been
introduced to 'scsi_host_template' for dealing driver specific irq
vector difference, such as, virtio-pci, 'irq_affinity' is needed for
excluding 'pre_vectors' which should serve as virtio config vector.

But that should belong to another topic about implementing generic
.map_queues interface, and seems not related with this patch, since
the usage of blk_mq_pci_map_queues() in this patch is correct.

Thanks,
Ming
