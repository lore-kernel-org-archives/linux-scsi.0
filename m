From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] SCSI: lpfc, don't dereference NULL
Date: Wed, 15 Jul 2009 15:00:50 -0400
Message-ID: <4A5E2762.8050502@emulex.com>
References: <1247520354-32145-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43055 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbZGOTA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 15:00:57 -0400
In-Reply-To: <1247520354-32145-1-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Thanks Jiri.

-- james s


Acked-By:  James Smart  <james.smart@emulex.com>


Jiri Slaby wrote:
> When kzalloc fails in lpfc_hba_alloc, don't dereference the NULL by
> lpfc_printf_log. Use dev_err instead.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index fc67cc6..2452dc9 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4130,8 +4130,7 @@ lpfc_hba_alloc(struct pci_dev *pdev)
>  	/* Allocate memory for HBA structure */
>  	phba = kzalloc(sizeof(struct lpfc_hba), GFP_KERNEL);
>  	if (!phba) {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"1417 Failed to allocate hba struct.\n");
> +		dev_err(&pdev->dev, "failed to allocate hba struct\n");
>  		return NULL;
>  	}
>  
