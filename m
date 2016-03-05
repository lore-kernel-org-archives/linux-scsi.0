From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
	SAM BUSY/TASK_SET_FULL
Date: Sat, 5 Mar 2016 22:01:08 +0100
Message-ID: <20160305210108.GA16337@lst.de>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com> <1457161634-15756-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457161634-15756-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> -	if (atomic_read(&ibr->ib_bio_err_cnt))
> -		status = SAM_STAT_CHECK_CONDITION;
> -	else
> +	/*
> +	 * Propigate use these two bio completion values from raw block
> +	 * drivers to signal up BUSY and TASK_SET_FULL status to the
> +	 * host side initiator.  The latter for Linux/iSCSI initiators
> +	 * means the Linux/SCSI LLD will begin to reduce it's internal
> +	 * per session queue_depth.
> +	 */
> +	if (atomic_read(&ibr->ib_bio_err_cnt)) {
> +		switch (ibr->ib_bio_retry) {
> +		case -EAGAIN:
> +			status = SAM_STAT_BUSY;
> +			break;
> +		case -ENOMEM:
> +			status = SAM_STAT_TASK_SET_FULL;
> +			break;
> +		default:
> +			status = SAM_STAT_CHECK_CONDITION;
> +			break;
> +		}
> +	} else {
>  		status = SAM_STAT_GOOD;
> +	}

I think you;d be much better off killing ib_bio_err_cnt and having
an ib_error that gets set to the last / most server error.
