From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH v1] lpfc 8.3.37: Remove redundant NULL check before kfree
Date: Wed, 6 Mar 2013 16:10:01 -0500
Message-ID: <2b628a59-616e-40c9-b5c4-a9899ae38b80@CMEXHTCAS2.ad.emulex.com>
References: <1362600754-6139-1-git-send-email-s.syam@samsung.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22666 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3CFVKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Mar 2013 16:10:07 -0500
In-Reply-To: <1362600754-6139-1-git-send-email-s.syam@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: syamsidhardh@gmail.com
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Syam Sidhardhan <s.syam@samsung.com>, "Smart, James" <James.Smart@Emulex.Com>

Syam,

Thank you for the patch - it is valid.

However, I prefer not to merge this.  I would rather force the coder to 
think about the pointer value explicitly rather than depending on the 
convenience/one line optimization.  We've had errors in the past covered 
up by this gracious behavior.  Additionally, we have coders that work on 
linux and vmware, and the semantics of the kfree() routine differ.   For 
now, I'd prefer to stay as is and force good habits.

-- james s


On 3/6/2013 3:12 PM, syamsidhardh@gmail.com wrote:
> From: Syam Sidhardhan <s.syam@samsung.com>
>
> kfree on NULL pointer is a no-op.
>
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---
> v1-> Corrected the from address.
>
>   drivers/scsi/lpfc/lpfc_bsg.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 32d5683..2166097 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -1129,8 +1129,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
>   	return 0; /* call job done later */
>   
>   job_error:
> -	if (dd_data != NULL)
> -		kfree(dd_data);
> +	kfree(dd_data);
>   
>   	job->dd_data = NULL;
>   	return rc;

