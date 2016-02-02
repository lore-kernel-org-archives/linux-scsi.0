From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v3 2/5] target: Fix LUN_RESET active TMR descriptor
	handling
Date: Tue, 2 Feb 2016 10:39:00 +0100
Message-ID: <20160202093900.GB26933@lst.de>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com> <1454132222-29009-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36532 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbcBBJjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 04:39:02 -0500
Content-Disposition: inline
In-Reply-To: <1454132222-29009-3-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

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

Same here - what is the point of sess_cmd_lock?
