From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] dpt_i2o.c: fix transferred data length for scsi_set_resid()
Date: Wed, 05 Nov 2008 16:05:06 +0200
Message-ID: <4911A812.3020307@panasas.com>
References: <20081104230908.GA21652@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.225]:2890 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYKEOFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 09:05:09 -0500
Received: by qb-out-0506.google.com with SMTP id f11so1573qba.17
        for <linux-scsi@vger.kernel.org>; Wed, 05 Nov 2008 06:05:07 -0800 (PST)
In-Reply-To: <20081104230908.GA21652@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

Miquel van Smoorenburg wrote:
> This should go into 2.6.28 and -stable, I think.
> 
> dpt_i2o-fix-xferlen-for-scsi_set_resid.patch
> 
> [PATCH] dpt_i2o.c: fix transferred data length for scsi_set_resid()
> 
> dpt_i2o.c::adpt_i2o_to_scsi() reads the value at (reply+5) which
> should contain the length in bytes of the transferred data. This
> would be correct if reply was a u32 *. However it is a void * here,
> so we need to read the value at (reply+20) instead.
> 
> The value at (reply+5) is usually 0xff0000, which is apparently
> 'large enough' and didn't cause any trouble until 2.6.27 where
> 427e59f09fdba387547106de7bab980b7fff77be caused this to become
> visible through e.g. iostat -x .
> 
> Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>
> 
> --- linux-2.6.27.4/drivers/scsi/dpt_i2o.c.ORIG	2008-10-26 00:05:07.000000000 +0200
> +++ linux-2.6.27.4/drivers/scsi/dpt_i2o.c	2008-11-04 23:43:13.000000000 +0100
> @@ -2445,7 +2445,7 @@
>  	hba_status = detailed_status >> 8;
>  
>  	// calculate resid for sg 
> -	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
> +	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+20));
>  

I do wish that someone could do a:
+	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(REG_BYTE_COUNT));

or what ever. To prevent just these errors from happening.

>  	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
>  
> @@ -2456,7 +2456,7 @@
>  		case I2O_SCSI_DSC_SUCCESS:
>  			cmd->result = (DID_OK << 16);
>  			// handle underflow
> -			if(readl(reply+5) < cmd->underflow ) {
> +			if (readl(reply+20) < cmd->underflow) {

Look here it is used a gain. I would say it calls for a constant

>  				cmd->result = (DID_ERROR <<16);
>  				printk(KERN_WARNING"%s: SCSI CMD underflow\n",pHba->name);
>  			}

I understand that this is not your fault, but Just for the record, as a
"TODO:" comment for us all.

Thanks
Boaz

