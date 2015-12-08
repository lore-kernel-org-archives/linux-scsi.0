From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/20] qla2xxx: Add TAS detection for kernel 3.15 n newer
Date: Mon, 7 Dec 2015 18:48:00 -0800
Message-ID: <20151208024800.GA32255@infradead.org>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbbLHCsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 21:48:00 -0500
Content-Disposition: inline
In-Reply-To: <1449535747-2850-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 842fcca..2e9c194 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -617,6 +617,26 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
>  				struct qla_tgt_cmd, se_cmd);
>  	int xmit_type = QLA_TGT_XMIT_STATUS;
>  
> +	if (se_cmd->transport_state & CMD_T_ABORTED) {
> +		/* For TCM TAS support n kernel >= 3.15:
> +		 * This cmd is attempting to respond with "Task Aborted Status".
> +		 */
> +		if (cmd->aborted) {
> +			return 0;
> +		} else if ((cmd->state == QLA_TGT_STATE_NEED_DATA) &&
> +		    cmd->cmd_sent_to_fw) {
> +			qlt_abort_cmd(cmd);
> +			return 0;
> +		} else if (cmd->state == QLA_TGT_STATE_PROCESSED) {
> +			if (cmd->cmd_sent_to_fw) {
> +				qlt_abort_cmd(cmd);
> +				return 0;
> +			} else {	/* about to be free */
> +				return 0;
> +			}
> +		}
> +	}
> +

This is really something that should be explicitly communicated
from the core instead of having to second guess it.
