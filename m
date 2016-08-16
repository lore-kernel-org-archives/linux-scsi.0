From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 1/2] be2iscsi: Fix error return code
Date: Tue, 16 Aug 2016 11:34:28 +0530
Message-ID: <a9ab4e196fb105b4df1abb6dc344962d@mail.gmail.com>
References: <1470996152-31081-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470996152-31081-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christophe JAILLET
> Sent: Friday, August 12, 2016 3:33 PM
> To: jayamohan.kallickal@avagotech.com; jejb@linux.vnet.ibm.com;
> ketan.mukadam@avagotech.com; sony.john@avagotech.com;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; Christophe JAILLET
> Subject: [PATCH 1/2] be2iscsi: Fix error return code
>
> We know that 'ret' is not an error code because it has been tested a few
> lines
> above.
> So, if one of these function fails, 0 will be returned instead of an error
> code.
> Return -ENOMEM instead.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c
> b/drivers/scsi/be2iscsi/be_main.c
> index f05e7737107d..89ae6390b697 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3286,8 +3286,10 @@ static int beiscsi_create_eqs(struct beiscsi_hba
> *phba,
>  		eq_vaddress = pci_alloc_consistent(phba->pcidev,
>  						     num_eq_pages *
> PAGE_SIZE,
>  						     &paddr);
> -		if (!eq_vaddress)
> +		if (!eq_vaddress) {
> +			ret = -ENOMEM;
>  			goto create_eq_error;
> +		}
>
>  		mem->va = eq_vaddress;
>  		ret = be_fill_queue(eq, phba->params.num_eq_entries, @@ -
> 3349,8 +3351,11 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
>  		cq_vaddress = pci_alloc_consistent(phba->pcidev,
>  						     num_cq_pages *
> PAGE_SIZE,
>  						     &paddr);
> -		if (!cq_vaddress)
> +		if (!cq_vaddress) {
> +			ret = -ENOMEM;
>  			goto create_cq_error;
> +		}
> +
>  		ret = be_fill_queue(cq, phba->params.num_cq_entries,
>  				    sizeof(struct sol_cqe), cq_vaddress);
>  		if (ret) {
> @@ -5635,6 +5640,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
>  	if (!phba) {
>  		dev_err(&pcidev->dev,
>  			"beiscsi_dev_probe - Failed in beiscsi_hba_alloc\n");
> +		ret = -ENOMEM;
>  		goto disable_pci;
>  	}
>
> @@ -5754,6 +5760,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
>  			    "BM_%d : beiscsi_dev_probe-"
>  			    "Failed to allocate work queue\n");
> +		ret = -ENOMEM;
>  		goto free_twq;
>  	}
>

[JB] This still has to be fixed, right?
