From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/7] block: Make blkdev_issue_zeroout use WRITE SAME
Date: Fri, 09 Mar 2012 19:05:49 +0100
Message-ID: <4F5A467D.1000703@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com> <1330658571-12958-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2CISF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Mar 2012 13:05:56 -0500
Received: by dajr28 with SMTP id r28so1698711daj.19
        for <linux-scsi@vger.kernel.org>; Fri, 09 Mar 2012 10:05:56 -0800 (PST)
In-Reply-To: <1330658571-12958-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, vgoyal@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Il 02/03/2012 04:22, Martin K. Petersen ha scritto:
> +int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
> +			 sector_t nr_sects, gfp_t gfp_mask)
> +{
> +	if (bdev_write_same(bdev)) {
> +		unsigned char bdn[BDEVNAME_SIZE];
> +
> +		if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
> +					     ZERO_PAGE(0)))
> +			return 0;
> +
> +		bdevname(bdev, bdn);
> +		printk(KERN_ERR "%s: WRITE SAME failed. Manually zeroing.\n",
> +		       bdn);
> +	}
> +
> +	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
> +}

Why not try DISCARD first if lbprz is true and the alignment is okay?
This doesn't even require WRITE SAME support in the disk.

Paolo
