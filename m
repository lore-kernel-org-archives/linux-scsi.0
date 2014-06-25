From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 25 Jun 2014 02:14:18 -0700
Message-ID: <20140625091418.GA5360@infradead.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
 <53A9A702.8050503@dev.mellanox.co.il>
 <20140624163040.GA11499@infradead.org>
 <53A9AEB8.4040104@cs.wisc.edu>
 <53A9B0A0.6000103@cs.wisc.edu>
 <53AA42E6.3090101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaFYJOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 05:14:37 -0400
Content-Disposition: inline
In-Reply-To: <53AA42E6.3090101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

Mike, I'd prefer a fix on top of the core-for-3.16 branch in my
scsi-queue tree, which already has the fix from Martin.

I also really don't like these three confusing helpers:

> +static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	return __scsi_calculate_transfer_length(scmd,
> +						blk_rq_bytes(scmd->request));
> +}

So here we use blk_rq_bytes still, which is incorrect for WRITE SAME.

> +static inline unsigned scsi_in_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	return __scsi_calculate_transfer_length(scmd, scsi_in(scmd)->length);
> +}
> +
> +static inline unsigned scsi_out_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	return __scsi_calculate_transfer_length(scmd, scsi_out(scmd)->length);

And here we use the in/out length.  And no documentation whatsover which
one you'd want to choose.

I think the easiest fix is to just pass a scsi_data_buffer to
scsi_transfer_length(), and let the caller use scsi_in/scsi_out to find
the right one.

