From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] target: Fix LUN_RESET active TMR descriptor
	handling
Date: Tue, 12 Jan 2016 16:25:13 +0100
Message-ID: <20160112152513.GC2294@lst.de>
References: <1452594245-921-1-git-send-email-nab@daterainc.com> <1452594245-921-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38553 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbcALPZO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 10:25:14 -0500
Content-Disposition: inline
In-Reply-To: <1452594245-921-3-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

>  	if (dev) {
>  		spin_lock_irqsave(&dev->se_tmr_lock, flags);
> -		list_del(&tmr->tmr_list);
> +		if (!list_empty(&tmr->tmr_list))
> +			list_del_init(&tmr->tmr_list);

list_del_init on a empty list is fine.

> +		sess = cmd->se_sess;
> +		if (!sess) {
> +			dump_stack();
> +			continue;
> +		}

Why not something like:

		if (WARN_ON_ONCE(!sess))
			continue;

same for the previous patch.

> +		spin_lock(&sess->sess_cmd_lock);
> +		rc = kref_get_unless_zero(&cmd->cmd_kref);
> +		spin_unlock(&sess->sess_cmd_lock);

no need to take a lock around kref_get_unless_zero, it's not going to
help with anything.
