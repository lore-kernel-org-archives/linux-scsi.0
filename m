From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] Configure reported luns
Date: Fri, 01 Feb 2013 01:44:42 -0600
Message-ID: <510B726A.4030302@cs.wisc.edu>
References: <1359404874-30871-1-git-send-email-revers@redhat.com> <1359404874-30871-3-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55449 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3BAHou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 02:44:50 -0500
In-Reply-To: <1359404874-30871-3-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 01/28/2013 02:27 PM, Rob Evers wrote:
> Change default value of max_report_luns to 16k-1.
> 
> Use data returned from max report luns command to configure the number
> of logical units present if previous default of 511 isn't enough.
> 
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 79 +++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 58 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index b2abf22..0f7ce45 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -109,12 +109,13 @@ MODULE_PARM_DESC(scan, "sync, async or none");
>   * in practice, the maximum number of LUNs suppored by any device
>   * is about 16k.
>   */
> -static unsigned int max_scsi_report_luns = 511;
> +static unsigned int max_scsi_report_luns = 16383;
>  
>  module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(max_report_luns,
>  		 "REPORT LUNS maximum number of LUNS received (should be"
> -		 " between 1 and 16384)");
> +		 " between 1 and 16383)");
> +#define INITIAL_MAX_REPORT_LUNS 511
>  
>  static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
>  
> @@ -1366,9 +1367,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>  	char devname[64];
>  	unsigned int length;
>  	unsigned int lun;
> -	unsigned int num_luns;
> +	unsigned int num_luns, num_luns_reported;
>  	int result;
>  	struct scsi_lun *lunp, *lun_data;
> +	struct scsi_lun *first_lun_data, *second_lun_data;
>  	u8 *data;
>  	struct scsi_device *sdev;
>  	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> @@ -1409,45 +1411,80 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>  	/*
>  	 * Allocate enough to hold the header (the same size as one scsi_lun)
>  	 * plus the max number of luns we are requesting.
> -	 *
> -	 * Reallocating and trying again (with the exact amount we need)
> -	 * would be nice, but then we need to somehow limit the size
> -	 * allocated based on the available memory and the limits of
> -	 * kmalloc - we don't want a kmalloc() failure of a huge value to
> -	 * prevent us from finding any LUNs on this target.
>  	 */
> -	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
> -	lun_data = kmalloc(length, GFP_ATOMIC |
> -			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
> -	if (!lun_data) {
> +	if (max_scsi_report_luns > INITIAL_MAX_REPORT_LUNS)
> +		length = (INITIAL_MAX_REPORT_LUNS + 1) *
> +			sizeof(struct scsi_lun);
> +	else
> +		length = (max_scsi_report_luns + 1) *
> +			sizeof(struct scsi_lun);
> +
> +	first_lun_data = kmalloc(length, GFP_ATOMIC |
> +				 (sdev->host->unchecked_isa_dma ?
> +				 __GFP_DMA : 0));
> +	if (!first_lun_data) {
>  		printk(ALLOC_FAILURE_MSG, __func__);
>  		goto out;


I think it seems like a good idea from the user perspective. They do not
have to worry about setting the modparam. Maybe this is not done already
because of bad targets? I do not know. Maybe someone else does.

One question about the memory allocation here. I know it was already
like this, but why are we using GFP_ATOMIC here and in some of the other
places in this code path? We sleep in some of these paths and some
functions we call use GFP_KERNEL, so it seems like we could use
something that is a little safer from allocation failures like GFP_NOIO?

If we change it, that could be another patch that modifies all the scan
code since you are are just carrying over the existing gfp flag in this
patch and this patch is just doing the one change to the report luns code.

