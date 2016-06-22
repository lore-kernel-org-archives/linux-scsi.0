From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] scsi: make scsi_eh_scmd_add() always succeed
Date: Wed, 22 Jun 2016 15:28:45 +0200
Message-ID: <20160622132845.GD6118@lst.de>
References: <1466415340-104465-1-git-send-email-hare@suse.de> <1466415340-104465-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52023 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbcFVN2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 09:28:47 -0400
Content-Disposition: inline
In-Reply-To: <1466415340-104465-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Agreed, I think trying to handle these sorts of errors isn't going
to be helpful, while the WARN_ON at least gives us a chance to
diagnose the issue if it ever happened.

> +	WARN_ON(!shost->ehandler);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> +	WARN_ON(shost->shost_state != SHOST_RUNNING &&
> +		shost->shost_state != SHOST_CANCEL &&
> +		shost->shost_state != SHOST_RECOVERY &&
> +		shost->shost_state != SHOST_CANCEL_RECOVERY);

Use WARN_ON_ONCE to avoid repeated backtraces for the same condition.

>  	if (scsi_host_set_state(shost, SHOST_RECOVERY))
> -		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
> -			goto out_unlock;
> +		scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);

No warn_on or early return here?
