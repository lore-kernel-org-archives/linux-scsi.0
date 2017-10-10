From: Kyle Fortin <kyle.fortin@oracle.com>
Subject: Re: [PATCH] scsi: be2iscsi: Use kasprintf
Date: Tue, 10 Oct 2017 17:54:15 -0400
Message-ID: <5B8406DF-E1DB-48B1-8872-29C10B1509C4@oracle.com>
References: <1507316265-9672-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507316265-9672-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu,

On Oct 6, 2017, at 2:57 PM, Himanshu Jha <himanshujha199640@gmail.com> wrote:
> 
> Use kasprintf instead of combination of kmalloc and sprintf.
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
> drivers/scsi/be2iscsi/be_main.c | 12 +++++-------
> 1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index b4542e7..6a9ee0e 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -803,15 +803,14 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
> 
> 	if (pcidev->msix_enabled) {
> 		for (i = 0; i < phba->num_cpus; i++) {
> -			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
> -						    GFP_KERNEL);
> +			phba->msi_name[i] = kasprintf(GFP_KERNEL,
> +						      "beiscsi_%02x_%02x",
> +						      phba->shost->host_no, i);
> 			if (!phba->msi_name[i]) {
> 				ret = -ENOMEM;
> 				goto free_msix_irqs;
> 			}
> 
> -			sprintf(phba->msi_name[i], "beiscsi_%02x_%02x",
> -				phba->shost->host_no, i);
> 			ret = request_irq(pci_irq_vector(pcidev, i),
> 					  be_isr_msix, 0, phba->msi_name[i],
> 					  &phwi_context->be_eq[i]);
> @@ -824,13 +823,12 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
> 				goto free_msix_irqs;
> 			}
> 		}
> -		phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
> +		phba->msi_name[i] = kasprintf(GFP_KERNEL, "beiscsi_mcc_%02x",
> +					      phba->shost->host_no);
> 		if (!phba->msi_name[i]) {
> 			ret = -ENOMEM;
> 			goto free_msix_irqs;
> 		}
> -		sprintf(phba->msi_name[i], "beiscsi_mcc_%02x",
> -			phba->shost->host_no);
> 		ret = request_irq(pci_irq_vector(pcidev, i), be_isr_mcc, 0,
> 				  phba->msi_name[i], &phwi_context->be_eq[i]);
> 		if (ret) {
> -- 
> 2.7.4

Since you are getting rid of the only use for BEISCSI_MSI_NAME within drivers/scsi/be2iscsi/be_main.h, that should be removed too.

--
Kyle Fortin - Oracle Linux Engineering
