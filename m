From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/11] qla2xxx: Track I-T nexus as single fc_port struct.
Date: Mon, 9 Jan 2017 05:28:28 -0800
Message-ID: <20170109132828.GE4438@infradead.org>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-8-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030709AbdAIN2b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 08:28:31 -0500
Content-Disposition: inline
In-Reply-To: <1482553419-4117-8-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

> +typedef struct {
> +	struct list_head	list;
> +	u8		iocb[64];	/* imm_ntfy_from_isp */

Please keep it as struct imm_ntfy_from_isp so that all the crazy
casts in the new code can be removed.

> +	qlt_plogi_ack_t* plogi_link[QLT_PLOGI_LINK_MAX];

	qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];

> +		if (con)
> +		{

		if (con) {

>  	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> +	ha->tgt.tgt_ops->put_sess(sess);
>  	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);

This pattern happens a lot and should probably be factored into a
helper.

> +	struct fc_port  *sess = container_of(kref,
> +	    struct fc_port, sess_kref);

This can fit into a single line:

	struct fc_port *sess = container_of(kref, struct fc_port, sess_kref);

