From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 18 Jan 2017 16:16:43 +0100
Message-ID: <20170118151643.GJ3514@linux-x5ow.site>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55630 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750907AbdARPQr (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 10:16:47 -0500
Content-Disposition: inline
In-Reply-To: <c7eabe1c-5dcd-9859-2b41-9683f68a0534@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>

On Wed, Jan 18, 2017 at 05:14:36PM +0200, Sagi Grimberg wrote:
> 
> >Hannes just spotted this:
> >static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
> >                         const struct blk_mq_queue_data *bd)
> >{
> >[...]
> >        __nvme_submit_cmd(nvmeq, &cmnd);
> >        nvme_process_cq(nvmeq);
> >        spin_unlock_irq(&nvmeq->q_lock);
> >        return BLK_MQ_RQ_QUEUE_OK;
> >out_cleanup_iod:
> >        nvme_free_iod(dev, req);
> >out_free_cmd:
> >        nvme_cleanup_cmd(req);
> >        return ret;
> >}
> >
> >So we're draining the CQ on submit. This of cause makes polling for
> >completions in the IRQ handler rather pointless as we already did in the
> >submission path.
> 
> I think you missed:
> http://git.infradead.org/nvme.git/commit/49c91e3e09dc3c9dd1718df85112a8cce3ab7007

I indeed did, thanks.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
