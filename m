From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2fc: Do not log error for netevents that need no
 action
Date: Tue, 10 Jun 2014 14:29:06 -0700
Message-ID: <1402435746.18569.5.camel@lbirv-waie-lx2.broadcom.com>
References: <1402077959-13170-1-git-send-email-spargaonkar@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43798 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaFJVd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 17:33:28 -0400
In-Reply-To: <1402077959-13170-1-git-send-email-spargaonkar@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shirishpargaonkar@gmail.com
Cc: linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Fri, 2014-06-06 at 13:05 -0500, shirishpargaonkar@gmail.com wrote:
> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> 
> 
> Do not log error for netevents that need no action such as
> NETDEV_REGISTER 0x0005, NETDEV_CHANGEADDR, and NETDEV_CHANGENAME.
> It results in logging error messages such as these
> 
> [   35.315872] bnx2fc: Unknown netevent 5
> [   35.315935] bnx2fc: Unknown netevent 8
> [   35.353866] bnx2fc: Unknown netevent 10
> 
> and generating bug reports.
> Remove logging this message as an ERROR instead of turning them into
> either DEBUG or INFO level messages.
> 
> 
> Signed-by: Shirish Pargaonkar <spargaonkar@suse.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 1d41f4b..c7388a8 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -856,7 +856,6 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
>  		return;
>  
>  	default:
> -		printk(KERN_ERR PFX "Unknown netevent %ld", event);
>  		return;
>  	}
>  
Thanks for fixing this, Shirish.  It makes sense to suppress the
unwanted netevent messages.

The patch looks good to me, but we should really get the current bnx2fc
maintainer from Qlogic to ACK this.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>


