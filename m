From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] scsi: add scsi-mq helpers to retrieve pdu and
	check started state
Date: Sun, 5 Apr 2015 17:39:12 +0200
Message-ID: <20150405153912.GA28173@lst.de>
References: <1428076703-31014-1-git-send-email-axboe@fb.com> <1428076703-31014-4-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45849 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbDEPjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Apr 2015 11:39:15 -0400
Content-Disposition: inline
In-Reply-To: <1428076703-31014-4-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Fri, Apr 03, 2015 at 09:58:19AM -0600, Jens Axboe wrote:
> +static inline void *scsi_mq_scmd_to_pdu(struct scsi_cmnd *scmd)
> +{
> +	return blk_mq_rq_to_pdu(scmd->request) + sizeof(*scmd);
> +}

We've already got scsi_cmd_priv to cover this.

> +static inline bool scsi_mq_scmd_started(struct scsi_cmnd *scmd)
> +{
> +	return blk_mq_request_started(scmd->request);
> +}

I don't really think we want to expose this functionality, but more
on that in my reply to the mpt2 patch.
