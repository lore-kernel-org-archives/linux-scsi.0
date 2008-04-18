From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/10] drivers/scsi/mvsas.c: fix build warnings
Date: Fri, 18 Apr 2008 17:03:03 -0400
Message-ID: <48090C87.40504@garzik.org>
References: <200804182057.m3IKvQtS015394@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40656 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762804AbYDRVDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 17:03:09 -0400
In-Reply-To: <200804182057.m3IKvQtS015394@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, kewei@marvell.com, oliver.pntr@gmail.com

akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> powerpc:
> 
> drivers/scsi/mvsas.c: In function 'mvs_update_phyinfo':
> drivers/scsi/mvsas.c:2536: warning: format '%llX' expects type 'long long unsigned int', but argument 5 has type 'u64'
> drivers/scsi/mvsas.c:2536: warning: format '%llX' expects type 'long long unsigned int', but argument 6 has type 'u64'
> 
> we do not know what type the architecture uses to implement u64 hence we
> cannot print them directly.
> 
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Oliver Pinter <oliver.pntr@gmail.com>
> Cc: Ke Wei <kewei@marvell.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/mvsas.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-build-warnings drivers/scsi/mvsas.c
> --- a/drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-build-warnings
> +++ a/drivers/scsi/mvsas.c
> @@ -2822,7 +2822,9 @@ static void mvs_update_phyinfo(struct mv
>  		dev_printk(KERN_DEBUG, &pdev->dev,
>  			"phy[%d] Get Attached Address 0x%llX ,"
>  			" SAS Address 0x%llX\n",
> -			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
> +			i,
> +			(unsigned long long)phy->att_dev_sas_addr,
> +			(unsigned long long)phy->dev_sas_addr);
>  		dev_printk(KERN_DEBUG, &pdev->dev,

Acked-by: Jeff Garzik <jgarzik@redhat.com>


