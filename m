From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 18 Jan 2017 16:39:19 +0100
Message-ID: <aaf5c35f-7e81-fa44-d467-53b574debdd4@suse.de>
References: <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
 <53a3fb6c-c75a-519a-f669-2bcab404e01d@grimberg.me>
 <20170117162752.GE6067@linux-x5ow.site>
 <6df6bf6a-7cd3-1700-2b0a-e140325ebf47@grimberg.me>
 <20170118135156.GG3514@linux-x5ow.site>
 <e3438024-e0f2-db96-5122-4508863be603@grimberg.me>
 <20170118145816.GI3514@linux-x5ow.site>
 <c7eabe1c-5dcd-9859-2b41-9683f68a0534@grimberg.me>
 <20170118151643.GJ3514@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752487AbdARPjX (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 10:39:23 -0500
In-Reply-To: <20170118151643.GJ3514@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>

On 01/18/2017 04:16 PM, Johannes Thumshirn wrote:
> On Wed, Jan 18, 2017 at 05:14:36PM +0200, Sagi Grimberg wrote:
>>
>>> Hannes just spotted this:
>>> static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>                         const struct blk_mq_queue_data *bd)
>>> {
>>> [...]
>>>        __nvme_submit_cmd(nvmeq, &cmnd);
>>>        nvme_process_cq(nvmeq);
>>>        spin_unlock_irq(&nvmeq->q_lock);
>>>        return BLK_MQ_RQ_QUEUE_OK;
>>> out_cleanup_iod:
>>>        nvme_free_iod(dev, req);
>>> out_free_cmd:
>>>        nvme_cleanup_cmd(req);
>>>        return ret;
>>> }
>>>
>>> So we're draining the CQ on submit. This of cause makes polling for
>>> completions in the IRQ handler rather pointless as we already did in the
>>> submission path.
>>
>> I think you missed:
>> http://git.infradead.org/nvme.git/commit/49c91e3e09dc3c9dd1718df85112a8cce3ab7007
> 
> I indeed did, thanks.
> 
But it doesn't help.

We're still having to wait for the first interrupt, and if we're really
fast that's the only completion we have to process.

Try this:


diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b4b32e6..e2dd9e2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -623,6 +623,8 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
        }
        __nvme_submit_cmd(nvmeq, &cmnd);
        spin_unlock(&nvmeq->sq_lock);
+       disable_irq_nosync(nvmeq_irq(irq));
+       irq_poll_sched(&nvmeq->iop);
        return BLK_MQ_RQ_QUEUE_OK;
 out_cleanup_iod:
        nvme_free_iod(dev, req);

That should avoid the first interrupt, and with a bit of lock reduce the
number of interrupts _drastically_.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
