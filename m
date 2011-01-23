From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] libosd: osd_req_read_sg, optimize the single entry case
Date: Sun, 23 Jan 2011 17:54:49 +0200
Message-ID: <4D3C4F49.3090804@panasas.com>
References: <4D3C4EF4.2090301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:58568 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1AWPyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2011 10:54:51 -0500
In-Reply-To: <4D3C4EF4.2090301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 01/23/2011 05:53 PM, Boaz Harrosh wrote:
> 
> Since sg-read is a bidi operation, it is a gain to convert
> a single sg entry into a regular read. Better do this in the
> generic layer then force each caller to do so.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/osd/osd_initiator.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 0433ea6..19ddf65 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1005,11 +1005,23 @@ int osd_req_read_sg(struct osd_request *or,
>  	const struct osd_sg_entry *sglist, unsigned numentries)
>  {
>  	u64 len;
> -	int ret = _add_sg_continuation_descriptor(or, sglist, numentries, &len);
> +	u64 off;
> +	int ret;
>  
> -	if (ret)
> -		return ret;
> -	osd_req_read(or, obj, 0, bio, len);
> +	if (numentries > 1) {
> +		off = 0;
> +		ret = _add_sg_continuation_descriptor(or, sglist, numentries,
> +						      &len);
> +		if (ret)
> +			return ret;
> +	} else {
> +		/* Optimize the case of single segment, read_sg is a
> +		 * bidi operation.
> +		 */
> +		len = sglist->len;
> +		off = sglist->offset;
> +	}
> +	osd_req_read(or, obj, off, bio, len);
>  
>  	return 0;
>  }

James please include this patch into scsi-misc for the next merge window.

Thanks
Boaz
