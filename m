From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Mon, 5 Dec 2016 08:20:06 -0800
Message-ID: <20161205162006.GD11206@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52519 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbcLEQUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 11:20:38 -0500
Content-Disposition: inline
In-Reply-To: <1480715097-13611-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>  create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_top.c

What's the point of three new fairly small files, two of them very
oddly named?  Can't we keep the code together by logical groups?

> +	/* distill these fields down to 'online=0/1'
> +	 * ha->flags.eeh_busy
> +	 * ha->flags.pci_channel_io_perm_failure
> +	 * base_vha->loop_state
> +	 */
> +	uint32_t online:1;
> +	/* move vha->flags.difdix_supported here */
> +	uint32_t difdix_supported:1;
> +	uint32_t delete_in_progress:1;

These probably should be atomic bitops.

> +#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		\
> +	atomic_inc(&__vha->vref_count);			\
> +	mb();						\
> +	if (__vha->flags.delete_progress) {		\
> +		atomic_dec(&__vha->vref_count);		\
> +		__bail = 1;				\
> +	} else {					\
> +		__bail = 0;				\
> +	}						\
>  } while (0)

Something like this should be an inline function, not a macro
that returns through an argument.

(and move to lower case it while at it, please).

Btw, the way vref_count is used looks incredibly buggy, instead
of the busy wait just add a waie queue to sleep on in
qla24xx_deallocate_vp_id.

> +	QLA_QPAIR_MARK_BUSY(qpair, bail);
> +	if (unlikely(bail))
> +		return NULL;
> +
> +	sp = mempool_alloc(qpair->srb_mempool, flag);
> +	if (!sp)
> +		goto done;
> +
> +	memset(sp, 0, sizeof(*sp));
> +	sp->fcport = fcport;
> +	sp->iocbs = 1;

FYI, the blk-mq model would be to allocate the srps as part of the
scsi_cmd by setting the cmd_size field in the host template.  Note
that this is also supported for the non-blk-mq path.

> +	qpair->delete_in_progress = 1;
> +	while (atomic_read(&qpair->ref_count))
> +		msleep(500);

Please use a waitqueue instead of a busy wait here as well.

> +int ql2xmqsupport;
> +module_param(ql2xmqsupport, int, S_IRUGO);
> +MODULE_PARM_DESC(ql2xmqsupport,
> +		"Enable on demand multiple queue pairs support "
> +		"Default is 0 for no support. "
> +		"Set it to 1 to turn on mq qpair support.");

Why isn't this enabled by default?

> +		ha->queue_pair_map = kzalloc(sizeof(struct qla_qpair *)
> +			* ha->max_qpairs, GFP_KERNEL);

Use kcalloc instead.
