From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] aacraid: Greater than 2TB capacity support
Date: Tue, 20 Sep 2005 21:13:30 +0100
Message-ID: <20050920201330.GA12220@infradead.org>
References: <1127246156.1891.31.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:23719 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965113AbVITUNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 16:13:38 -0400
Content-Disposition: inline
In-Reply-To: <1127246156.1891.31.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>


> +		if ((scsicmd->cmnd[0] == WRITE_6) ||	/* 6 byte command */
> +		    (scsicmd->cmnd[0] == READ_6))
> +			lba = ((scsicmd->cmnd[1] & 0x1F) << 16) |
> +			    (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
> +		else if ((scsicmd->cmnd[0] == WRITE_16)	|| /* 16 byte command */
> +		  	 (scsicmd->cmnd[0] == READ_16))
> +			lba = ((u64)scsicmd->cmnd[2] << 56) |
> +			      ((u64)scsicmd->cmnd[3] << 48) |
> +			      ((u64)scsicmd->cmnd[4] << 40) |
> +			      ((u64)scsicmd->cmnd[5] << 32) |
> +			      ((u64)scsicmd->cmnd[6] << 24) |
> +			      (scsicmd->cmnd[7] << 16) |
> +			      (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
> +		else if ((scsicmd->cmnd[0] == WRITE_12)	|| /* 12 byte command */
> +		 	 (scsicmd->cmnd[0] == READ_12))
> +			lba = ((u64)scsicmd->cmnd[2] << 24) |
> +			      (scsicmd->cmnd[3] << 16) |
> +			      (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
> +		else
> +			lba = ((u64)scsicmd->cmnd[2] << 24) |
> +			       (scsicmd->cmnd[3] << 16) |
> +			       (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
> +		printk(KERN_DEBUG
> +		  "io_callback[cpu %d]: lba = %llu, t = %ld.\n",
> +		  smp_processor_id(), (unsigned long long)lba, jiffies);
> +	}

this would be more readable as a swich statement.

> +	} else if (scsicmd->cmnd[0] == READ_16) { /* 16 byte command */
> +		dprintk((KERN_DEBUG "aachba: received a read(16) command on id %d.\n", cid));
> +
> +		lba = 	((u64)scsicmd->cmnd[2] << 56) |
> +		 	((u64)scsicmd->cmnd[3] << 48) |
> +			((u64)scsicmd->cmnd[4] << 40) |
> +			((u64)scsicmd->cmnd[5] << 32) |
> +			((u64)scsicmd->cmnd[6] << 24) | 
> +			(scsicmd->cmnd[7] << 16) |
> +			(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
> +		count = (scsicmd->cmnd[10] << 24) | (scsicmd->cmnd[11] << 16) |
> +			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
> +	} else if (scsicmd->cmnd[0] == READ_12) { /* 12 byte command */
> +		dprintk((KERN_DEBUG "aachba: received a read(12) command on id %d.\n", cid));
> +
> +		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16)
> +		    | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
> +		count = (scsicmd->cmnd[6] << 24) | (scsicmd->cmnd[7] << 16)
> +		      | (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
>  	} else {
>  		dprintk((KERN_DEBUG "aachba: received a read(10) command on id %d.\n", cid));

dito

> -
> +			if (scsicmd->request->rq_disk)
> +				strlcpy(fsa_dev_ptr[cid].devname,
> +				scsicmd->request->rq_disk->disk_name,
> +			  	min(sizeof(fsa_dev_ptr[cid].devname),
> +				sizeof(scsicmd->request->rq_disk->disk_name) + 1));

do we really need this?  A driver really shouldn't look at ->rq_disk

