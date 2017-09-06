From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH RESEND] lpfc: Don't return internal MBXERR_ERROR code
 from probe function
Date: Wed, 6 Sep 2017 11:54:15 +0200
Message-ID: <20170906115415.435a1bfb@elisabeth>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
        <20170906110256.4445e353@elisabeth>
        <20170906093034.hkyeg3pjxy3nmyig@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752432AbdIFJyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Sep 2017 05:54:22 -0400
In-Reply-To: <20170906093034.hkyeg3pjxy3nmyig@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Wed, 6 Sep 2017 11:30:34 +0200
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> On Wed, Sep 06, 2017 at 11:02:56AM +0200, Stefano Brivio wrote:
> > Internal error codes happen to be positive, thus the PCI driver
> > core won't treat them as failure, but we do. This would cause a
> > crash later on as lpfc_pci_remove_one() is called (e.g. as
> > shutdown function).
> > 
> > Fixes: 6d368e532168 ("[SCSI] lpfc 8.3.24: Add resource extent support")
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> > This seems to have been ignored. Re-sending as suggested by Johannes.
> > 
> >  drivers/scsi/lpfc/lpfc_init.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> > index 491aa95eb0f6..38cc2b5bb5a2 100644
> > --- a/drivers/scsi/lpfc/lpfc_init.c
> > +++ b/drivers/scsi/lpfc/lpfc_init.c
> > @@ -6118,6 +6118,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
> >  				"Extents and RPI headers enabled.\n");
> >  		}
> >  		mempool_free(mboxq, phba->mbox_mem_pool);
> > +		rc = -EIO;
> >  		goto out_free_bsmbx;
> >  	}
> >  
> > -- 
> > 2.9.4  
> 
> The patch looks good, but there are lots of 
> 	if (rc) {
> 		mempool_free(mboxq, phba->mbox_mem_pool);
> 		rc = -EIO;
> 		goto out_free_bsmbx;
> 	}
> 
> in lpfc_sli4_driver_resource_setup(). Shouldn't out_free_bsmbx take care of it
> all so we only have:
> 	if (rc)
> 		goto out_free_bsmbx;

Thanks for your feedback!

I considered doing something similar, but there are different error
coded which are set when we reach the label out_free_mbsx. I checked all
of them (and I hope I didn't miss any), but they all looked correct,
and in quite a few cases different than -EIO (e.g. -ENODEV).

So I think always returning -EIO in those cases is not what we want.

> Because as this patch shows there's always a chance to miss an 'rc = -EIO'.
> 
> Out of curiosity, do you know what's the value of rc in the failure case?

Yes, MBXERR_ERROR (mentioned in patch subject -- sorry, I could have
repeated it in the message perhaps).


--
Stefano
