From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6 05/13] scsi: remove a timer race from scsi_queue_insert() and cleanup timer
Date: Thu, 31 Mar 2005 11:13:53 +0100
Message-ID: <20050331101353.GC13842@infradead.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.4025028A@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7139 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261226AbVCaKN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 05:13:58 -0500
Content-Disposition: inline
In-Reply-To: <20050331090647.4025028A@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>  		/* Queue the command and wait for it to complete */
>  		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
>  		init_timer(&cmd->eh_timeout);
> +		cmd->eh_timeout.function = NULL;

I'd rather not see aic7xxx poke even deeper into this internal code.
Can you please switch it to use a timer of it's own first?

