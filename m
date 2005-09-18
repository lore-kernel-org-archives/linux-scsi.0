From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] dont retry on SG_IO tape commands
Date: Sun, 18 Sep 2005 15:46:33 -0500
Message-ID: <432DD229.1080201@cs.wisc.edu>
References: <1127073191.3067.1.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:19667 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932239AbVIRWqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 18:46:39 -0400
In-Reply-To: <1127073191.3067.1.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

Actually forget this patch. We can just make scsi-ml handle this.


Mike Christie wrote:
> sd does not allow scsi_io_completion to retry commands for
> SG_IO requests, and it make sense that it should not happen for st
> SG_IO commands too. This patch returns to the block layer that
> the whole command completed and relies on the caller to check
> the request errors field.
> 
> Patch was made against scsi-rc-fixes.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4187,7 +4187,7 @@ static void scsi_tape_release(struct kre
>  
>  static void st_intr(struct scsi_cmnd *SCpnt)
>  {
> -	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen), 1);
> +	scsi_io_completion(SCpnt, SCpnt->bufflen, 0);
>  }
>  
>  /*
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

