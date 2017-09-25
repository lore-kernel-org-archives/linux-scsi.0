From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] bsg-lib: fix use-after-free under memory-pressure
Date: Mon, 25 Sep 2017 08:53:07 -0700
Message-ID: <20170925155307.GA27522@infradead.org>
References: <9040282c25a027344945e9be2c3afc3d90386909.1506016742.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36299 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934482AbdIYPxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 11:53:08 -0400
Content-Disposition: inline
In-Reply-To: <9040282c25a027344945e9be2c3afc3d90386909.1506016742.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org

>  	if (!q)
>  		return ERR_PTR(-ENOMEM);
>  	q->cmd_size = sizeof(struct bsg_job) + dd_job_size;
> -	q->init_rq_fn = bsg_init_rq;
> -	q->exit_rq_fn = bsg_exit_rq;
> +	q->init_rq_fn = bsg_init_job;
> +	q->exit_rq_fn = bsg_exit_job;
> +	q->initialize_rq_fn = bsg_init_rq;

Please use function names that match the method names, that is keep
the existing names and name the new helper bsg_initialize_rq;

Except for that the patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
