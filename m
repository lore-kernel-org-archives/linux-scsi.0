From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH -repost 3/4] SCSI: lpfc, fix memory leak
Date: Fri, 9 Oct 2009 13:43:24 -0400
Message-ID: <4ACF763C.5070308@emulex.com>
References: <1255096688-23399-1-git-send-email-jirislaby@gmail.com> <1255096688-23399-3-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38061 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZJIRoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 13:44:07 -0400
In-Reply-To: <1255096688-23399-3-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Acked-by: James Smart <james.smart@emulex.com>

-- james s

Jiri Slaby wrote:
> Stanse found a memory leak on one fail path in lpfc_sli4_read_rev.
>
> Add there kfree.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: James Smart <james.smart@emulex.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 43cbe33..7750868 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4211,6 +4211,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
>  	if (rc) {
>  		dma_free_coherent(&phba->pcidev->dev, dma_size,
>  				  dmabuf->virt, dmabuf->phys);
> +		kfree(dmabuf);
>  		return -EIO;
>  	}
>  
>   
