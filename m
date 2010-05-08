From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch] be2iscsi: correct return value in mgmt_invalidate_icds()
Date: Fri, 07 May 2010 20:34:50 -0500
Message-ID: <4BE4BFBA.6010505@cs.wisc.edu>
References: <20100507085345.GB27064@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41193 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0EHBeB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 21:34:01 -0400
In-Reply-To: <20100507085345.GB27064@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 05/07/2010 03:53 AM, Dan Carpenter wrote:
> This function should return 0 on error.  Returning -1 would cause a
> crash.
>
> Also there is an extra space before the newline character and a missing
> space between the "for" and the "mgmt_invalidate_icds".  I put the string
> on one line.  The current version of checkpatch.pl complains that the
> line is too long, but it makes grepping easier.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
>
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index e641922..350cbea 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -167,10 +167,9 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
>   				&nonemb_cmd.dma);
>   	if (nonemb_cmd.va == NULL) {
>   		SE_DEBUG(DBG_LVL_1,
> -			 "Failed to allocate memory for"
> -			 "mgmt_invalidate_icds \n");
> +			 "Failed to allocate memory for mgmt_invalidate_icds\n");
>   		spin_unlock(&ctrl->mbox_lock);
> -		return -1;
> +		return 0;
>   	}
>   	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
>   	req = nonemb_cmd.va;

You are right. Nice catch.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
