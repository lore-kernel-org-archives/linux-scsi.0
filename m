From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Date: Tue, 28 Jun 2011 01:25:26 +0300
Message-ID: <20110627222526.GA14591@shale.localdomain>
References: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 27, 2011 at 11:54:48PM +0200, Jesper Juhl wrote:
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1321,7 +1321,8 @@ struct se_wwn *tcm_loop_make_scsi_hba(
>  
>  	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
>  			" %s\n", name);
> -	return ERR_PTR(-EINVAL);
> +	ret = -EINVAL;
> +	goto out;

You've added a weird bunny hop goto here.  It might be better to
change the if (ptr) check to if (!ptr) so we could fall through
here in the normal case.

>  
>  check_len:
>  	if (strlen(name) >= TL_WWN_ADDR_LEN) {

If this check fails then it calls kfree() and returns.  It would be
cleaner to "goto out" here as well.

regards,
dan carpenter
