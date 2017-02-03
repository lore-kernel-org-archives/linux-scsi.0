From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 3/6] sg: protect accesses to 'reserved' page array
Date: Fri, 3 Feb 2017 14:31:40 +0100
Message-ID: <20170203133140.GC646@lst.de>
References: <1486127531-13716-1-git-send-email-hare@suse.de> <1486127531-13716-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48172 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752521AbdBCNbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 08:31:41 -0500
Content-Disposition: inline
In-Reply-To: <1486127531-13716-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -		if (sg_res_in_use(sfp)) {
> +		mutex_lock(&sfp->f_mutex);
> +		if (sfp->res_in_use) {
> +			mutex_unlock(&sfp->f_mutex);
>  			sg_remove_request(sfp, srp);
>  			return -EBUSY;	/* reserve buffer already being used */
>  		}
> +		mutex_unlock(&sfp->f_mutex);

Holding a mutex over a the check of a single scalar doesn't make sense.
