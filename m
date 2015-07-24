From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/20] scsi_dh_alua: Pass buffer as function argument
Date: Fri, 24 Jul 2015 16:48:59 +0200
Message-ID: <20150724144859.GB29096@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55835 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbbGXOtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:49:01 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

> -	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
> -	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
> -	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> -	rq->cmd[9] = h->bufflen & 0xff;
> +	put_unaligned_be32(bufflen, &rq->cmd[6]);

This is unrelated to the rest of the patch, can you split it out,
maybe together with other get/put_unaligned conversions?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
