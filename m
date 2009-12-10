From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/5 ] BNX2I - Adjust sq_size module parametr to power
 of 2 only if a non-zero value is specified
Date: Wed, 09 Dec 2009 20:45:44 -0600
Message-ID: <4B2060D8.2080207@cs.wisc.edu>
References: <1260214794.31468.93.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57304 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000AbZLJCps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2009 21:45:48 -0500
In-Reply-To: <1260214794.31468.93.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, mchan@broadcom.com, poswald@novell.com

Anil Veerabhadrappa wrote:
>     * This issue was discovered during 10G iscsi testing
>     * Default value of 'sq_size' module parameter is '0' which means
>       driver should use predefined SQ queue size when setting up iscsi
>       connection.
>     * roundup_pow_of_two(0) results in '1' and forces driver to setup
>       connections with send queue size of '1' and results in lower
>       performance as well
> 
> Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
> index 3c46458..dc6b56c 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -367,7 +367,7 @@ static int __init bnx2i_mod_init(void)
>  
>  	printk(KERN_INFO "%s", version);
>  
> -	if (!is_power_of_2(sq_size))
> +	if (sq_size && !is_power_of_2(sq_size))
>  		sq_size = roundup_pow_of_two(sq_size);
>  
>  	mutex_init(&bnx2i_dev_lock);

Ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
