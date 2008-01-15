From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Only print SCSI data direction warning once for a command
Date: Tue, 15 Jan 2008 00:02:57 -0500
Message-ID: <478C3E81.3020007@torque.net>
References: <200801020703.01180.ak@suse.de> <1200166584.3656.36.camel@localhost.localdomain> <200801131741.43173.ak@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYAOFDq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 00:03:46 -0500
In-Reply-To: <200801131741.43173.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> to the log because they come from printk_ratelimit().  So all you've
>> done is halved the volume of flow to the logs and left a dangling printk
>> suppressed message that keeps spewing, so I don't think the patch even
>> does what you describe it as doing ...  if you reverse the order of the
>> operands in the if() it will ...
> 
> Here's an updated patch with the reversed order.
> 
> -Andi
> 
> ---
> 
> Only print SCSI data direction warning once for a command v2
> 
> When I use cdparanoia my logs get spammed a lot by
> 
> printk: 464 messages suppressed.
> sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
>    program cdparanoia not setting count and/or reply_len properly
> printk: 1078 messages suppressed.
> 
> and many more of those. With this patch the message is only printed once
> for a command in a row.
> 
> v1->v2: Prevent rate limit messages too (pointed out by jejb)
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  drivers/scsi/sg.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/scsi/sg.c
> ===================================================================
> --- linux.orig/drivers/scsi/sg.c
> +++ linux/drivers/scsi/sg.c
> @@ -602,8 +602,9 @@ sg_write(struct file *filp, const char _
>  	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
>  	 * is a non-zero input_size, so emit a warning.
>  	 */
> -	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
> -		if (printk_ratelimit())
> +	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
> +		static char cmd[TASK_COMM_LEN];
> +		if (strcmp(current->comm, cmd) && printk_ratelimit()) {
>  			printk(KERN_WARNING
>  			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
>  			       "guessing data in;\n" KERN_WARNING "   "
> @@ -611,6 +612,9 @@ sg_write(struct file *filp, const char _
>  			       old_hdr.reply_len - (int)SZ_SG_HEADER,
>  			       input_size, (unsigned int) cmnd[0],
>  			       current->comm);
> +			strcpy(cmd, current->comm);
> +		}
> +	}
>  	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
>  	return (k < 0) ? k : count;
>  }
> 
> 

Signed-off-by: Douglas Gilbert <dougg@torque.net>

