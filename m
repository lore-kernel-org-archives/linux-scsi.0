From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] qla2xxx: Terminate exchange if corrputed.
Date: Tue, 20 Dec 2016 06:13:43 -0800
Message-ID: <20161220141343.GG16487@infradead.org>
References: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
 <1482208424-12358-8-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482208424-12358-8-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +	while ((ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) ||
> +		   FCPCMD_IS_CORRUPTED(ha->tgt.atio_ring_ptr)) {

No need for the inner braces.

> +#define FCPCMD_IS_CORRUPTED(_a)						\
> +	((_a->entry_type == ATIO_TYPE7) && 				\
> +	 ((le16_to_cpu(_a->attr_n_length) & FCP_CMD_LENTH_MASK) < 	\
> +	  FCP_CMD_LENTH_MIN))
> +
> +/* adjust corrupted atio so we won't trip over the same entry again. */
> +#define ADJ_CORRUPTED_ATIO(_a)						\
> +{									\
> +	_a->u.raw.attr_n_length = cpu_to_le16(FCP_CMD_LENTH_MIN);	\
> +	((struct atio_from_isp *)_a)->u.isp24.fcp_cmnd.add_cdb_len = 0;	\
> +}

These should be inline functions instead of macros.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
