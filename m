From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 3/3] scsi: Retry report-luns when reported LU count
 requres more memory
Date: Mon, 15 Dec 2014 07:47:53 -0800
Message-ID: <20141215154753.GC29357@infradead.org>
References: <1417808263-5632-1-git-send-email-revers@redhat.com>
 <1417808263-5632-4-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaLOPry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 10:47:54 -0500
Content-Disposition: inline
In-Reply-To: <1417808263-5632-4-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 05, 2014 at 02:37:43PM -0500, Rob Evers wrote:
> Update scsi_report_lun_scan to initially always report up to 511 LUs,
> as the previous default max_report_luns did.  Retry in a loop if not
> enough memory is available for the number of LUs reported.  Parameter
> max_report_luns is removed as it is no longer used.
> ---
>  drivers/scsi/scsi_scan.c | 43 ++++++++++++-------------------------------
>  1 file changed, 12 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 8db1f6f..ecd8703 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -80,6 +80,7 @@
>  
>  static const char *scsi_null_device_strs = "nullnullnullnull";
>  
> +#define INITIAL_MAX_SCSI_REPORT_LUNS	511

The name seems very verbose.  Given that it's only used once we might
as well just remove it and add a comment about why this number is chosen
instead.


> -	length = get_unaligned_be32(lun_data->scsi_lun);
> +	if (get_unaligned_be32(lun_data->scsi_lun) +
> +	    sizeof(struct scsi_lun) > length) {
> +		length = get_unaligned_be32(lun_data->scsi_lun) +
> +			 sizeof(struct scsi_lun);
> +		kfree(lun_data);
> +		goto retry;
> +	} else
> +		length = get_unaligned_be32(lun_data->scsi_lun);

The else won't be reached due to the goto.  Just remove it and one
level of indentation for the next line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
