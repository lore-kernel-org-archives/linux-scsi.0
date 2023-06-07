Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94171C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 05:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbjFGF1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 01:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjFGF1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 01:27:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3AD1989;
        Tue,  6 Jun 2023 22:27:14 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 072E068AA6; Wed,  7 Jun 2023 07:27:11 +0200 (CEST)
Date:   Wed, 7 Jun 2023 07:27:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
Message-ID: <20230607052710.GC20052@lst.de>
References: <20230606193845.9627-1-mwilck@suse.com> <20230606193845.9627-4-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606193845.9627-4-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:38:45PM +0200, mwilck@suse.com wrote:
> Simplify scsi_stop_queue(), which is only called in this code path, to never
> wait for the quiescing to finish. Rather call blk_mq_wait_quiesce_done()
> from scsi_target_block() after iterating over all devices.

I don't think simplify is the right word here.  The code isn't in any
way simpler, it just is more efficient an shifts work from
scsi_stop_queue to scsi_internal_device_block and scsi_target_block.

But the whole transformation is very confusing to me even if it looks
correct in the end, and it took me quite a while to understand it.

I'd suggest to further split this up and include some additional
cleanups:

  1) remove scsi_internal_device_block and fold it into device_block
  2) move the scsi_internal_device_block in what was
     scsi_internal_device_block and now is device_block out
     of state_mutex (and document in the commit log why this is safe)
  3) remove scsi_stop_queue and open code it in the two callers, one
     of which currently wants nowait semantics, and one that doesn't.
  4) move the quiesce wait to scsi_target_block and make it per-tagset

>  scsi_target_block(struct device *dev)
>  {
> +	struct Scsi_Host *shost = dev_to_shost(dev);
> +
>  	if (scsi_is_target_device(dev))
>  		starget_for_each_device(to_scsi_target(dev), NULL,
>  					device_block);
>  	else
>  		device_for_each_child(dev, NULL, target_block);
> +
> +	/* Wait for ongoing scsi_queue_rq() calls to finish. */
> +	if (!WARN_ON_ONCE(!shost))

How could host ever be NULL here?  I can't see why we'd want this
check.

Btw, as far as I can tell scsi_target_block is never called for
a device that is a target device.  It might be worth throwing in
another patch to remove support for that case and simplify things
further.
