From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] scsi_error: do not use command list for host reset
Date: Fri, 27 Jun 2014 00:58:39 -0700
Message-ID: <20140627075839.GC21799@infradead.org>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
 <1403850425-89297-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaF0H6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 03:58:41 -0400
Content-Disposition: inline
In-Reply-To: <1403850425-89297-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

> @@ -771,7 +770,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
>  		if (!hostt->skip_settle_delay)
>  			ssleep(HOST_RESET_SETTLE_TIME);
>  		spin_lock_irqsave(host->host_lock, flags);
> -		scsi_report_bus_reset(host, scmd_channel(scmd));
> +		scsi_report_bus_reset(host, -1);

The old code report a bus reset for every device on the channel this
command was on, and the new one will not report anything because
scsi_report_bus_reset doesn't treat -1 as a wild card.  To keep the old
behaviour you'll have to pass a channel argument here.  It's not quite
clear to me if ->eh_host_reset_handler is only supposed to reset a
"channel" or the whole HBA, but if we want to change behavior here
it should be a separate well documented patch.

