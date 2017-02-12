From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 13 Feb 2017 10:14:54 +1100
Message-ID: <1486941294.3401.67.camel@kernel.crashing.org>
References: <20170212214920.28866-1-anton@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:47256 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdBLXPR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Feb 2017 18:15:17 -0500
In-Reply-To: <20170212214920.28866-1-anton@ozlabs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@ozlabs.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org
Cc: linux-scsi@vger.kernel.org

On Mon, 2017-02-13 at 08:49 +1100, Anton Blanchard wrote:
> From: Anton Blanchard <anton@samba.org>
> 
> We see lpfc devices regularly fail during kexec. Fix this by adding
> a shutdown method which mirrors the remove method.

Or instead finally do what I've been advocating for years (and even
sent patches for) which is to have kexec call remove instead of
shutdown.

Shutdown is and has *always* been the wrong thing to do.

> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c
> b/drivers/scsi/lpfc/lpfc_init.c
> index 4776fd8..10f75ad 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11447,6 +11447,7 @@ static struct pci_driver lpfc_driver = {
>  	.id_table	= lpfc_id_table,
>  	.probe		= lpfc_pci_probe_one,
>  	.remove		= lpfc_pci_remove_one,
> +	.shutdown	= lpfc_pci_remove_one,
>  	.suspend        = lpfc_pci_suspend_one,
>  	.resume		= lpfc_pci_resume_one,
>  	.err_handler    = &lpfc_err_handler,
