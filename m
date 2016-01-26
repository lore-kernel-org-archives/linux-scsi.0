From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 2/3] target: Fix LUN_RESET active TMR descriptor
	handling
Date: Tue, 26 Jan 2016 18:21:41 +0100
Message-ID: <20160126172141.GB3663@lst.de>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com> <1453513067-23169-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37587 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966846AbcAZRVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 12:21:43 -0500
Content-Disposition: inline
In-Reply-To: <1453513067-23169-3-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

> +		sess = cmd->se_sess;
> +		if (WARN_ON_ONCE(!sess))
> +			continue;
> +
> +		spin_lock(&sess->sess_cmd_lock);
>  		spin_lock(&cmd->t_state_lock);
>  		if (!(cmd->transport_state & CMD_T_ACTIVE)) {
>  			spin_unlock(&cmd->t_state_lock);
> +			spin_unlock(&sess->sess_cmd_lock);
>  			continue;
>  		}
>  		if (cmd->t_state == TRANSPORT_ISTATE_PROCESSING) {
>  			spin_unlock(&cmd->t_state_lock);
> +			spin_unlock(&sess->sess_cmd_lock);
>  			continue;
>  		}
> +		cmd->transport_state |= CMD_T_ABORTED;
>  		spin_unlock(&cmd->t_state_lock);
>  
> +		rc = kref_get_unless_zero(&cmd->cmd_kref);
> +		spin_unlock(&sess->sess_cmd_lock);

Similar to the previous patch I don't understand the need for
sess_cmd_lock here.

> +	spin_lock_irqsave(&cmd->t_state_lock, flags);
> +	if (cmd->transport_state & CMD_T_ABORTED) {
> +		tmr->response = TMR_FUNCTION_REJECTED;
> +		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> +		goto check_stop;
> +	}
> +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);

Taking a lock for checking a single bit is pointless.
