From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]  be2iscsi: Fix kernel panic when device initialization
 fails
Date: Mon, 06 Apr 2015 10:15:48 -0500
Message-ID: <5522A324.8060006@cs.wisc.edu>
References: <b34d5567-d9e1-44b2-ac6d-42d97d32309f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44796 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbbDFPP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Apr 2015 11:15:56 -0400
In-Reply-To: <b34d5567-d9e1-44b2-ac6d-42d97d32309f@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>, linux-scsi@vger.kernel.org, Jayamohan.Kallickal@Emulex.Com, MinhDuc.Tran@Emulex.Com

On 02/11/2015 07:15 PM, John Soni Jose wrote:
>  Kernel panic was happening as iscsi_host_remove() was called on
>  a host which was not yet added.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index f319340..1b0b31c 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5736,9 +5736,9 @@ free_port:
>  hba_free:
>  	if (phba->msix_enabled)
>  		pci_disable_msix(phba->pcidev);
> -	iscsi_host_remove(phba->shost);
>  	pci_dev_put(phba->pcidev);
>  	iscsi_host_free(phba->shost);
> +	pci_set_drvdata(pcidev, NULL);
>  disable_pci:
>  	pci_disable_device(pcidev);
>  	return ret;
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
