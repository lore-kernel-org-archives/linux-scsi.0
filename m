Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DAFC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 09:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E30D3600D4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 09:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhEDJyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 05:54:43 -0400
Received: from verein.lst.de ([213.95.11.211]:38785 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhEDJyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 05:54:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2EF1168AFE; Tue,  4 May 2021 11:53:46 +0200 (CEST)
Date:   Tue, 4 May 2021 11:53:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
Message-ID: <20210504095346.GC25986@lst.de>
References: <20210503150333.130310-1-hare@suse.de> <20210503150333.130310-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503150333.130310-4-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 03, 2021 at 05:03:18PM +0200, Hannes Reinecke wrote:
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	unsigned int op, blk_mq_req_flags_t flags)

Weird indentation - prototype continuations either use two tabs or
are aligned after the opening brace (I generally prefer the former).

> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +
> +	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
> +		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));

Woudn't a simple bool write command make more sense than passing the
actual op here?

> +	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->request = rq;
> +	scmd->device = sdev;

Maybe a comment that explains what part of the scmd are initialized
and which not would be useful.
