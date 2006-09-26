From: Brian King <brking@us.ibm.com>
Subject: Re: [patch 21/28] Signedness issue in drivers/scsi/ipr.c
Date: Tue, 26 Sep 2006 08:10:41 -0500
Message-ID: <451926D1.2070309@us.ibm.com>
References: <200609252359.k8PNx7vJ003518@shell0.pdx.osdl.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:23502 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751336AbWIZNKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 09:10:44 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8QDAhld012343
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 09:10:43 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8QDAhLJ255984
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 09:10:44 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8QDAhoS002805
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 09:10:43 -0400
In-Reply-To: <200609252359.k8PNx7vJ003518@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, snakebyte@gmx.de

ACK

akpm@osdl.org wrote:
> From: Eric Sesterhenn <snakebyte@gmx.de>
> 
> gcc 4.1 with some extra warnings show the following:
> 
> drivers/scsi/ipr.c:6361: warning: comparison of unsigned expression < 0 is always false
> drivers/scsi/ipr.c:6385: warning: comparison of unsigned expression < 0 is always false
> drivers/scsi/ipr.c:6415: warning: comparison of unsigned expression < 0 is always false
> 
> The problem is that rc is of the type u32, which can never be smaller than
> zero, therefore all three error handling checks get useless.  This patch
> changes it to a normal int, because all usages / all functions it get used
> with expect an int.
> 
> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Cc: Brian King <brking@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/ipr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/ipr.c~signedness-issue-in-drivers-scsi-iprc drivers/scsi/ipr.c
> --- a/drivers/scsi/ipr.c~signedness-issue-in-drivers-scsi-iprc
> +++ a/drivers/scsi/ipr.c
> @@ -6352,7 +6352,7 @@ static int __devinit ipr_probe_ioa(struc
>  	struct Scsi_Host *host;
>  	unsigned long ipr_regs_pci;
>  	void __iomem *ipr_regs;
> -	u32 rc = PCIBIOS_SUCCESSFUL;
> +	int rc = PCIBIOS_SUCCESSFUL;
>  	volatile u32 mask, uproc;
>  
>  	ENTER;
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
