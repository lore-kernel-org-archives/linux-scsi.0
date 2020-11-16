Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E53BC61DD8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E7A221F9
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbgKPRWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:22:24 -0500
Received: from verein.lst.de ([213.95.11.211]:55311 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730773AbgKPRWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 12:22:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AEF6568BFE; Mon, 16 Nov 2020 18:22:20 +0100 (CET)
Date:   Mon, 16 Nov 2020 18:22:20 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
Subject: Re: [PATCH v2 7/9] scsi_transport_spi: Freeze request queues
 instead of quiescing
Message-ID: <20201116172220.GG22007@lst.de>
References: <20201116030459.13963-1-bvanassche@acm.org> <20201116030459.13963-8-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116030459.13963-8-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Nov 15, 2020 at 07:04:57PM -0800, Bart Van Assche wrote:
> Instead of quiescing the request queues involved in domain validation,
> freeze these. As a result, the struct request_queue pm_only member is no
> longer set during domain validation. That will allow to modify
> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
> Three additional changes in this patch are that scsi_mq_alloc_queue() is
> exported, that scsi_device_quiesce() is no longer exported and that
> scsi_target_{quiesce,resume}() have been changed into
> scsi_target_{freeze,unfreeze}().

Can you explain why you need the new request_queue?  spi_dv_device seems
to generally be called from ->slave_configure where no other I/O
should ever be pending.

> +++ b/drivers/scsi/scsi_lib.c
> @@ -1893,6 +1893,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
>  	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
>  	return q;
>  }
> +EXPORT_SYMBOL_GPL(scsi_mq_alloc_queue);

I'd much rather open scsi_mq_alloc_queue in a new caller, especially
given that __scsi_init_queue already is exported.
