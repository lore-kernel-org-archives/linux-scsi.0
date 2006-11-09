From: "Ju, Seokmann" <Seokmann.Ju@lsi.com>
Subject: RE: [patch 18/26] drivers/scsi/megaraid.c: Replacing yield() with a better alternative
Date: Thu, 9 Nov 2006 07:44:34 -0700
Message-ID: <890BF3111FB9484E9526987D912B2619F9798D@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:14827 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423712AbWKIOpU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 09:45:20 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, amol@verismonetworks.com

On Wednesday, November 08, 2006 10:56 PM, 
> For this driver cond_resched() seems to be a better alternative
Can you add some details on why cond_resched() better than yield()?
Is it because of _need_resched()_ checker in cond_resched()?


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of akpm@osdl.org
> Sent: Wednesday, November 08, 2006 10:56 PM
> To: James.Bottomley@steeleye.com
> Cc: linux-scsi@vger.kernel.org; akpm@osdl.org;
amol@verismonetworks.com
> Subject: [patch 18/26] drivers/scsi/megaraid.c: Replacing yield() with
a
> better alternative
> 
> From: Amol Lad <amol@verismonetworks.com>
> 
> For this driver cond_resched() seems to be a better alternative
> 
> Signed-off-by: Amol Lad <amol@verismonetworks.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/megaraid.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN
drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-
> a drivers/scsi/megaraid.c
> ---
a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a
> +++ a/drivers/scsi/megaraid.c
> @@ -1753,7 +1753,8 @@ __mega_busywait_mbox (adapter_t *adapter
>  	for (counter = 0; counter < 10000; counter++) {
>  		if (!mbox->m_in.busy)
>  			return 0;
> -		udelay(100); yield();
> +		udelay(100);
> +		cond_resched();
>  	}
>  	return -1;		/* give up after 1 second */
>  }
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
