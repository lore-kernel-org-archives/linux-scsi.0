From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 19/33] scsi_debug: support sg chaining
Date: Sat, 08 Sep 2007 10:53:31 -0400
Message-ID: <46E2B76B.6050703@torque.net>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792682668-git-send-email-jens.axboe@oracle.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34640 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbXIHOyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Sep 2007 10:54:11 -0400
In-Reply-To: <11845792682668-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <tomof@acm.org>

Jens Axboe wrote:
> Cc: dgilbert@interlog.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/scsi_debug.c |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4cd9c58..46a3e07 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -38,6 +38,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/moduleparam.h>
> +#include <linux/scatterlist.h>
>  
>  #include <linux/blkdev.h>
>  #include "scsi.h"
> @@ -600,7 +601,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  	int k, req_len, act_len, len, active;
>  	void * kaddr;
>  	void * kaddr_off;
> -	struct scatterlist * sgpnt;
> +	struct scatterlist * sg;
>  
>  	if (0 == scp->request_bufflen)
>  		return 0;
> @@ -619,16 +620,16 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  			scp->resid = req_len - act_len;
>  		return 0;
>  	}
> -	sgpnt = (struct scatterlist *)scp->request_buffer;
>  	active = 1;
> -	for (k = 0, req_len = 0, act_len = 0; k < scp->use_sg; ++k, ++sgpnt) {
> +	req_len = act_len = 0;
> +	scsi_for_each_sg(scp, sg, scp->use_sg, k) {
>  		if (active) {
>  			kaddr = (unsigned char *)
> -				kmap_atomic(sgpnt->page, KM_USER0);
> +				kmap_atomic(sg->page, KM_USER0);
>  			if (NULL == kaddr)
>  				return (DID_ERROR << 16);
> -			kaddr_off = (unsigned char *)kaddr + sgpnt->offset;
> -			len = sgpnt->length;
> +			kaddr_off = (unsigned char *)kaddr + sg->offset;
> +			len = sg->length;
>  			if ((req_len + len) > arr_len) {
>  				active = 0;
>  				len = arr_len - req_len;
> @@ -637,7 +638,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  			kunmap_atomic(kaddr, KM_USER0);
>  			act_len += len;
>  		}
> -		req_len += sgpnt->length;
> +		req_len += sg->length;
>  	}
>  	if (scp->resid)
>  		scp->resid -= act_len;
> @@ -653,7 +654,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  	int k, req_len, len, fin;
>  	void * kaddr;
>  	void * kaddr_off;
> -	struct scatterlist * sgpnt;
> +	struct scatterlist * sg;
>  
>  	if (0 == scp->request_bufflen)
>  		return 0;
> @@ -668,13 +669,14 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  		memcpy(arr, scp->request_buffer, len);
>  		return len;
>  	}
> -	sgpnt = (struct scatterlist *)scp->request_buffer;
> -	for (k = 0, req_len = 0, fin = 0; k < scp->use_sg; ++k, ++sgpnt) {
> -		kaddr = (unsigned char *)kmap_atomic(sgpnt->page, KM_USER0);
> +	sg = scsi_sglist(scp);
> +	req_len = fin = 0;
> +	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
> +		kaddr = (unsigned char *)kmap_atomic(sg->page, KM_USER0);
>  		if (NULL == kaddr)
>  			return -1;
> -		kaddr_off = (unsigned char *)kaddr + sgpnt->offset;
> -		len = sgpnt->length;
> +		kaddr_off = (unsigned char *)kaddr + sg->offset;
> +		len = sg->length;
>  		if ((req_len + len) > max_arr_len) {
>  			len = max_arr_len - req_len;
>  			fin = 1;
> @@ -683,7 +685,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  		kunmap_atomic(kaddr, KM_USER0);
>  		if (fin)
>  			return req_len + len;
> -		req_len += sgpnt->length;
> +		req_len += sg->length;
>  	}
>  	return req_len;
>  }

Signed-off-by: Douglas Gilbert <dougg@torque.net>


In a post titled: "Re: [PATCH 4/9] scsi_debug: convert to
                   use the data buffer accessors"
FUJITA Tomonori wrote:
> On Fri, 07 Sep 2007 15:12:06 -0400
> Douglas Gilbert <dougg@torque.net> wrote:
>
>> FUJITA Tomonori wrote:
>>> From: Boaz Harrosh <bharrosh@panasas.com>
>>>
>>> - remove the unnecessary map_single path.
>>>
>>> - convert to use the new accessors for the sg lists and the
>>> parameters.
>>>
>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Signed-off-by: Douglas Gilbert <dougg@torque.net>
>
> This patch is on the top of the following patch:
>
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=63499aaafa6ec0c107a925574c2af84a2cd86703
>
> Can we get your ACK on this too?

Done.

> Probably, it would be fine to integrate these patches.

Yes that is fine.

When the dust settles, I can send a patch of my various mode
and log pages additions to scsi_debug in my working copy.

Doug Gilbert

