From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 2/3] scsi: ufs: Delete an error message for a failed
 memory allocation in ufshcd_memory_alloc()
Date: Wed, 26 Apr 2017 10:57:31 -0700
Message-ID: <019b6365c15b0764c156d6453648f7a2@codeaurora.org>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
 <3d355c13-159a-2570-9ead-af93ad95c210@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932455AbdDZR5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 13:57:33 -0400
In-Reply-To: <3d355c13-159a-2570-9ead-af93ad95c210@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>, linux-scsi-owner@vger.kernel.org

On 2017-04-25 13:28, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 25 Apr 2017 21:50:43 +0200
> 
> The script "checkpatch.pl" pointed information out like the following.
> 
> WARNING: Possible unnecessary 'out of memory' message
> 
> Thus remove such a statement here.
> 
> Link:
> http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ce385911a20e..5216e33e61a3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3274,8 +3274,7 @@ static int ufshcd_memory_alloc(struct ufs_hba 
> *hba)
>  				GFP_KERNEL);
> -	if (!hba->lrb) {
> -		dev_err(hba->dev, "LRB Memory allocation failed\n");
> +	if (!hba->lrb)
>  		goto out;
> -	}
> +
>  	return 0;
>  out:
>  	return -ENOMEM;

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

PS: ufshcd_memory_alloc() also does some DMA coherent memory allocation 
(via dmam_alloc_coherent() APIs) and tries to print out the message on 
allocation failure. Although i don't know "out of memory" messages will 
be printed out by dmam_alloc_coherent() APIs or not. If it does print it 
out then we might want to remove our local memory allocation failure log 
messages.


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
