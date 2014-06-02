From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: Implement 'ZBC' device type
Date: Mon, 2 Jun 2014 02:19:31 -0700
Message-ID: <20140602091931.GC32301@infradead.org>
References: <1401692478-23557-1-git-send-email-hare@suse.de>
 <1401692478-23557-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBJTc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 05:19:32 -0400
Content-Disposition: inline
In-Reply-To: <1401692478-23557-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e02b3aa..0788213 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -819,6 +819,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	case TYPE_COMM:
>  	case TYPE_RAID:
>  	case TYPE_OSD:
> +	case TYPE_ZBC:
>  		sdev->writeable = 1;
>  		break;
>  	case TYPE_ROM:

sdev->writeable is only used in the sd and sr drivers, so we should
just remove it from the scsi_device structure and track it internally
to get rid of this layering violation.

