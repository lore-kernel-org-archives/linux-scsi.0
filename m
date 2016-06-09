From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Add support for SCT Write Same
Date: Thu, 9 Jun 2016 02:22:12 -0700
Message-ID: <20160609092212.GA7459@infradead.org>
References: <1465453967-11085-1-git-send-email-shaun@tancheff.com>
 <1465453967-11085-2-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465453967-11085-2-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

> +	if (ata_id_sct_write_same(dev->id))
> +		sdev->sct_write_same = 1;
> +

What's the point of this flag?  It should simply clear the no_write_same
flag for this device.  Due to the way how we have both a per-host and
per-device flag that might not be completely trivial, but untangling
that mess might be a good idea anyway.

> @@ -3305,6 +3308,37 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>  		goto invalid_param_len;
>  
>  	buf = page_address(sg_page(scsi_sglist(scmd)));
> +
> +	if (ata_id_sct_write_same(dev->id)) {

Various comments:

 - The plain page_address above looks harmful, how do we know that
   the page is mapped into kernel memory?  This might actually be broken
   already, though.
 - Why is this below the check that rejects non-unmap WRITE SAME
   commands?
 - Shouldn't we still translate discard command to TRIM?  Maybe we
   need a check of the operation in the request structure..

