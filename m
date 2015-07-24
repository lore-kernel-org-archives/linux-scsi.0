From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/20] scsi_dh_alua: simplify sense code handling
Date: Fri, 24 Jul 2015 17:00:59 +0200
Message-ID: <20150724150058.GC29296@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55914 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbbGXPBA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 11:01:00 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

> +		/*
> +		 * Retry on ALUA state transition or if any
> +		 * UNIT ATTENTION occurred.
> +		 */
> +		if (sense_hdr.sense_key == NOT_READY &&
> +		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
> +			err = SCSI_DH_RETRY;
> +		if (sense_hdr.sense_key == UNIT_ATTENTION)

else if or just but cases in the same condition for clarity?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
