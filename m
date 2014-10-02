From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/2] be2iscsi : Fix kernel panic during reboot/shutdown
Date: Thu, 02 Oct 2014 10:21:39 -0400
Message-ID: <1412259699.5241.75.camel@localhost.localdomain>
References: <4bc79dd1-5ea1-4956-8520-86ed5a8c78a1@CMEXHTCAS1.ad.emulex.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJBOWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 10:22:01 -0400
In-Reply-To: <4bc79dd1-5ea1-4956-8520-86ed5a8c78a1@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

On Fri, 2014-09-26 at 15:13 -0400, John Soni Jose wrote:
> In the reboot/shutdown path, workqueue was destroyed after the
>  adapter resource were freed. The task associated with workqueue
>  was getting executed after resources were freed. This lead to
>  kernel panic.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index db2bd4d..30d74a0 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5223,6 +5223,7 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
>  			free_irq(phba->pcidev->irq, phba);
>  		}
>  	pci_disable_msix(phba->pcidev);
> +	cancel_delayed_work_sync(&phba->beiscsi_hw_check_task);
>  
>  	for (i = 0; i < phba->num_cpus; i++) {
>  		pbe_eq = &phwi_context->be_eq[i];
> @@ -5244,7 +5245,6 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
>  		hwi_cleanup(phba);
>  	}
>  
> -	cancel_delayed_work_sync(&phba->beiscsi_hw_check_task);
>  }
>  
>  static void beiscsi_remove(struct pci_dev *pcidev)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


