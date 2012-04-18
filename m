From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND 2/2] scsi/ufs: Fix evaluation of task_failed
 status
Date: Wed, 18 Apr 2012 15:56:43 -0700
Message-ID: <20120418155643.5b6eff01.akpm@linux-foundation.org>
References: <1334734733-13640-1-git-send-email-svenkatr@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2DRW4p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 18:56:45 -0400
In-Reply-To: <1334734733-13640-1-git-send-email-svenkatr@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Venkatraman S <svenkatr@ti.com>
Cc: linux-kernel@vger.kernel.org, santoshsy@gmail.com, linkinjeon@gmail.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


Please cc James and linux-scsi on drivers/scsi patches?

On Wed, 18 Apr 2012 13:08:53 +0530
Venkatraman S <svenkatr@ti.com> wrote:

> Else FAILED would be set even if task_result was
> originally equal to UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.

This changelog is inadequate.  It failed to describe the end-user
impact of the bug.  Without this information we cannot decide which
kernel version(s) should be patched.  Please always fully describe a
bug when fixing it.

> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
>  		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
>  		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
>  
> -		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
> +		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
>  		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
>  			task_result = FAILED;
>  	} else {

And the title of the patch is poor.  There is no "task_failed" here. 
Something like "fix evaluation of task completion code" would be
better?
