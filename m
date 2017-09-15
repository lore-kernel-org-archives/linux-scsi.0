From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] lpfc: Don't return internal MBXERR_ERROR code from probe function
Date: Thu, 14 Sep 2017 21:19:29 -0400
Message-ID: <yq1k210rc66.fsf@oracle.com>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
        <20170906110256.4445e353@elisabeth>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31572 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdIOBTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2017 21:19:43 -0400
In-Reply-To: <20170906110256.4445e353@elisabeth> (Stefano Brivio's message of
        "Wed, 6 Sep 2017 11:02:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>


James/Dick,

Please review!

> Internal error codes happen to be positive, thus the PCI driver
> core won't treat them as failure, but we do. This would cause a
> crash later on as lpfc_pci_remove_one() is called (e.g. as
> shutdown function).
>
> Fixes: 6d368e532168 ("[SCSI] lpfc 8.3.24: Add resource extent support")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This seems to have been ignored. Re-sending as suggested by Johannes.
>
>  drivers/scsi/lpfc/lpfc_init.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 491aa95eb0f6..38cc2b5bb5a2 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -6118,6 +6118,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  				"Extents and RPI headers enabled.\n");
>  		}
>  		mempool_free(mboxq, phba->mbox_mem_pool);
> +		rc = -EIO;
>  		goto out_free_bsmbx;
>  	}

-- 
Martin K. Petersen	Oracle Linux Engineering
