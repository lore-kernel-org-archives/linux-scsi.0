From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/20] scsi_dh_alua: Make stpg synchronous
Date: Fri, 24 Jul 2015 16:51:03 +0200
Message-ID: <20150724145103.GC29096@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55865 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbbGXOvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:51:04 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

> -	memset(h->buff, 0, stpg_len);
> -	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> -	h->buff[6] = (h->group_id >> 8) & 0xff;
> -	h->buff[7] = h->group_id & 0xff;
> +	memset(stpg_data, 0, stpg_len);
> +	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> +	put_unaligned_be16(group_id, &stpg_data[6]);

Unrelated get/put_unaligned changes again.


> -		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> +		if (!(driver_byte(retval) & DRIVER_SENSE) ||
> +		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,

Where does this come from?

> +		    (!h->pref) &&


no need for braces here.
