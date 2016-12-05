From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 1/2] scsi: be2iscsi: set errno on error path
Date: Mon, 5 Dec 2016 08:57:28 +0530
Message-ID: <b61ce2dfc2777dc7a58a1c479f1e3393@mail.gmail.com>
References: <1480828902-4406-1-git-send-email-bianpan201603@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480828902-4406-1-git-send-email-bianpan201603@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan201603@163.com>, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Pan Bian [mailto:bianpan201603@163.com]
> Sent: Sunday, December 04, 2016 10:52 AM
> To: Subbu Seetharaman; Ketan Mukadam; Jitendra Bhivare; James E.J.
> Bottomley; Martin K. Petersen; linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Pan Bian
> Subject: [PATCH 1/2] scsi: be2iscsi: set errno on error path
>
> From: Pan Bian <bianpan2016@163.com>
>
> Variable ret is reset in the loop, and its value will be 0 during the
second and
> after repeat of the loop. If pci_alloc_consistent() returns a NULL
pointer then, it
> will leaves with return value 0. 0 means no error, which is contrary to
the fact.
> This patches fixes the bug, explicitly assigning "-ENOMEM" to return
variable ret
> on the path that the call to
> pci_alloc_consistent() fails.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188941
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c
b/drivers/scsi/be2iscsi/be_main.c
> index d9239c2..b6c5791 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3113,8 +3113,10 @@ static int beiscsi_create_cqs(struct beiscsi_hba
> *phba,
>  		cq_vaddress = pci_alloc_consistent(phba->pcidev,
>  						   num_cq_pages *
PAGE_SIZE,
>  						   &paddr);
> -		if (!cq_vaddress)
> +		if (!cq_vaddress) {
> +			ret = -ENOMEM;
>  			goto create_cq_error;
> +		}
>
>  		ret = be_fill_queue(cq, phba->params.num_cq_entries,
>  				    sizeof(struct sol_cqe), cq_vaddress);
> --
> 1.9.1

[JB] Thanks.

Reviewed-by: Jitendra Bhivare <Jitendra.bhivare@broadcom.com>
