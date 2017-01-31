From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/10] mpt3sas: lockless command submission for scsi-mq
Date: Tue, 31 Jan 2017 14:22:06 +0100
Message-ID: <20170131132206.GA5686@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56364 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752026AbdAaNXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 08:23:40 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 10:25:58AM +0100, Hannes Reinecke wrote:
> Enable lockless command submission for scsi-mq by moving the
> command structure into the payload for struct request.

We support cmd_size for both the mq and !mq code path, so this
could be simplified by always taking your new block-mq path.

>  4 files changed, 427 insertions(+), 57 deletions(-)

The amount of new code scare me.  Especially compared to the very
shport changelog.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 942fb7e..29e139f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -867,6 +867,20 @@ struct scsiio_tracker *
>  {
>  	WARN_ON(!smid);
>  	WARN_ON(smid >= ioc->hi_priority_smid);
> +	if (shost_use_blk_mq(ioc->shost)) {
> +		u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
> +		u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
> +		struct blk_mq_tag_set *tagset = &ioc->shost->tag_set;
> +		struct request *req;
> +
> +		req = blk_mq_tag_to_rq(tagset->tags[hwq], tag);
> +		if (req) {
> +			struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +
> +			return scsi_cmd_priv(cmd);
> +		} else
> +			return NULL;
> +	}

This looks like it basically duplicates scsi_host_find_tag().

> +	if (shost_use_blk_mq(ioc->shost)) {
> +		unsigned int unique_tag = blk_mq_unique_tag(scmd->request);
> +		u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
> +		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
> +		u16 smid = (tag * ioc->shost->nr_hw_queues) + hwq + 1;
> +
> +		request = scsi_cmd_priv(scmd);
> +		request->scmd = scmd;

no need for a backpointer, blk_mq_rq_from_pdu gets your
back to the request, and scsi_cmd_priv back to driver private data.

> +		request->cb_idx = cb_idx;
> +		request->msix_io = hwq;
> +		request->smid = smid;

why do we need to store the smid?

> @@ -562,12 +642,7 @@ enum block_state {
>  _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,

I think this function just needs to go away instantly.
Trying to send task management requests from userspace for any
active smid is plain dangerous.
