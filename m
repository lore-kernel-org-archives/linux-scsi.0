From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] lpfc: Don't return internal MBXERR_ERROR code
 from probe function
Date: Wed, 6 Sep 2017 11:30:34 +0200
Message-ID: <20170906093034.hkyeg3pjxy3nmyig@linux-x5ow.site>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
 <20170906110256.4445e353@elisabeth>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752226AbdIFJak (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Sep 2017 05:30:40 -0400
Content-Disposition: inline
In-Reply-To: <20170906110256.4445e353@elisabeth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Wed, Sep 06, 2017 at 11:02:56AM +0200, Stefano Brivio wrote:
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
>  
> -- 
> 2.9.4

The patch looks good, but there are lots of 
	if (rc) {
		mempool_free(mboxq, phba->mbox_mem_pool);
		rc = -EIO;
		goto out_free_bsmbx;
	}

in lpfc_sli4_driver_resource_setup(). Shouldn't out_free_bsmbx take care of it
all so we only have:
	if (rc)
		goto out_free_bsmbx;

Because as this patch shows there's always a chance to miss an 'rc = -EIO'.

Out of curiosity, do you know what's the value of rc in the failure case?

Anyways:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
