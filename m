From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 19:28:54 +0100
Message-ID: <569FD1E6.30309@de.ibm.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp09.uk.ibm.com ([195.75.94.105]:33775 "EHLO
	e06smtp09.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934679AbcATS3A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 13:29:00 -0500
Received: from localhost
	by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <borntraeger@de.ibm.com>;
	Wed, 20 Jan 2016 18:28:58 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 815B01B08069
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 18:29:00 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0KISteL5046726
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 18:28:55 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0KIStH2032767
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 11:28:55 -0700
In-Reply-To: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 01/20/2016 05:01 PM, Martin K. Petersen wrote:
> Commit ca369d51b3e1 ("block/sd: Fix device-imposed transfer length
> limits") accidentally switched optimal I/O size reporting from bytes to
> block layer sectors.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4e08d1cd704d..ec163d08f6c3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2893,7 +2893,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
>  	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_CACHE_SIZE)
>  		rw_max = q->limits.io_opt =
> -			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> +			sdkp->opt_xfer_blocks * sdp->sector_size;
>  	else
>  		rw_max = BLK_DEF_MAX_SECTORS;
> 

the error message is gone

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>


