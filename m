From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] fix more ipr kref problems
Date: Mon, 30 Aug 2004 09:01:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41333352.9060303@us.ibm.com>
References: <1093816265.1708.45.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:62607 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S268138AbUH3OCu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 10:02:50 -0400
In-Reply-To: <1093816265.1708.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Patch looks good. Thanks.

-Brian

James Bottomley wrote:
> This was caused by
> 
> KREF: make kref_get() return void as it makes sense to do so.
>   
> drivers/scsi/ipr.c: In function `ipr_worker_thread':
> drivers/scsi/ipr.c:1825: error: wrong type argument to unary exclamation
> mark
> make[2]: *** [drivers/scsi/ipr.o] Error 1
> 
> The fix is fairly simple.
> 
> James
> 
> ===== drivers/scsi/ipr.c 1.25 vs edited =====
> --- 1.25/drivers/scsi/ipr.c	2004-08-16 01:40:17 -05:00
> +++ edited/drivers/scsi/ipr.c	2004-08-29 16:25:31 -05:00
> @@ -1822,10 +1822,11 @@
>  
>  	if (ioa_cfg->sdt_state == GET_DUMP) {
>  		dump = ioa_cfg->dump;
> -		if (!dump || !kref_get(&dump->kref)) {
> +		if (!dump) {
>  			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  			return;
>  		}
> +		kref_get(&dump->kref);
>  		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  		ipr_get_ioa_dump(ioa_cfg, dump);
>  		kref_put(&dump->kref, ipr_release_dump);
> @@ -2423,11 +2424,11 @@
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>  	dump = ioa_cfg->dump;
>  
> -	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump || !kref_get(&dump->kref)) {
> +	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump) {
>  		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  		return 0;
>  	}
> -
> +	kref_get(&dump->kref);
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  
>  	if (off > dump->driver_dump.hdr.len) {
> 
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

