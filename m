From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: Re: [PATCH] scsi: be2iscsi: Use kasprintf
Date: Wed, 11 Oct 2017 12:24:32 +0530
Message-ID: <20171011065432.GA2577@himanshu-Vostro-3559>
References: <1507316265-9672-1-git-send-email-himanshujha199640@gmail.com>
 <5B8406DF-E1DB-48B1-8872-29C10B1509C4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8406DF-E1DB-48B1-8872-29C10B1509C4@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kyle Fortin <kyle.fortin@oracle.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 10, 2017 at 05:54:15PM -0400, Kyle Fortin wrote:
> Hi Himanshu,
> 
> On Oct 6, 2017, at 2:57 PM, Himanshu Jha <himanshujha199640@gmail.com> wrote:
> > 
> > Use kasprintf instead of combination of kmalloc and sprintf.
> > 
> > Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> > ---
> > drivers/scsi/be2iscsi/be_main.c | 12 +++++-------
> > 1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> > index b4542e7..6a9ee0e 100644
> > --- a/drivers/scsi/be2iscsi/be_main.c
> > +++ b/drivers/scsi/be2iscsi/be_main.c
> > @@ -803,15 +803,14 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
> > 
> > 	if (pcidev->msix_enabled) {
> > 		for (i = 0; i < phba->num_cpus; i++) {
> > -			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
> > -						    GFP_KERNEL);
> > +			phba->msi_name[i] = kasprintf(GFP_KERNEL,
> > +						      "beiscsi_%02x_%02x",
> > +						      phba->shost->host_no, i);
> > 			if (!phba->msi_name[i]) {
> > 				ret = -ENOMEM;
> > 				goto free_msix_irqs;
> > 			}
> > 
> > -			sprintf(phba->msi_name[i], "beiscsi_%02x_%02x",
> > -				phba->shost->host_no, i);
> > 			ret = request_irq(pci_irq_vector(pcidev, i),
> > 					  be_isr_msix, 0, phba->msi_name[i],
> > 					  &phwi_context->be_eq[i]);
> > @@ -824,13 +823,12 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
> > 				goto free_msix_irqs;
> > 			}
> > 		}
> > -		phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
> > +		phba->msi_name[i] = kasprintf(GFP_KERNEL, "beiscsi_mcc_%02x",
> > +					      phba->shost->host_no);
> > 		if (!phba->msi_name[i]) {
> > 			ret = -ENOMEM;
> > 			goto free_msix_irqs;
> > 		}
> > -		sprintf(phba->msi_name[i], "beiscsi_mcc_%02x",
> > -			phba->shost->host_no);
> > 		ret = request_irq(pci_irq_vector(pcidev, i), be_isr_mcc, 0,
> > 				  phba->msi_name[i], &phwi_context->be_eq[i]);
> > 		if (ret) {
> > -- 
> > 2.7.4
> 
> Since you are getting rid of the only use for BEISCSI_MSI_NAME within drivers/scsi/be2iscsi/be_main.h, that should be removed too.

Yes, that should be removed! Thanks for pointing that out.
I will send a v2 patch with the update.

> --
> Kyle Fortin - Oracle Linux Engineering
> 
> 
> 
> 
