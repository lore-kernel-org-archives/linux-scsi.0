From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] [SCSI] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Tue, 29 Oct 2013 12:36:00 -0700
Message-ID: <1383075360.2071.30.camel@dabdike.int.hansenpartnership.com>
References: <20131029191007.GD21820@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35144 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab3J2TgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Oct 2013 15:36:03 -0400
In-Reply-To: <20131029191007.GD21820@longonot.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, security@kernel.org

On Tue, 2013-10-29 at 22:10 +0300, Dan Carpenter wrote:
> If "fibsize" is zero then it leads to a ZERO_SIZE_PTR dereference when
> we dereference user_srbcmd.
> 
> Due to a missing capable() check in the compat ioctls then this error
> can be triggered without CAP_SYS_RAWIO.  I have fixed that in a separate
> patch.
> 
> Reported-by: Nico Golde <nico@ngolde.de>
> Reported-by: Fabian Yamaguchi <fabs@goesec.de>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index d85ac1a..efd0ba3 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -511,7 +511,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
>  		goto cleanup;
>  	}
>  
> -	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
> +	if (fibsize == 0 ||
> +	    fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {

Not really if you want to catch actual undersize errors.  We read out of
the allocated data structure after this, so it had better be at least
sizeof(*user_srbcmd) rather than just not zero to make sure we aren't
reading off the end of the allocated size.

James


