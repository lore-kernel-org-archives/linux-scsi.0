From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH resend 1/2] be2iscsi: Remove unnecessary synchronize_irq()
 before free_irq()
Date: Mon, 7 Mar 2016 07:59:12 +0530
Message-ID: <50df46ee2ea235f2bd6eba6aa064d151@mail.gmail.com>
References: <1457086507-5937-1-git-send-email-lars@metafoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:36039 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbcCGC3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2016 21:29:14 -0500
Received: by mail-vk0-f42.google.com with SMTP id c3so103577130vkb.3
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2016 18:29:13 -0800 (PST)
In-Reply-To: <1457086507-5937-1-git-send-email-lars@metafoo.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, linux-scsi@vger.kernel.org, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Lars-Peter Clausen
>Sent: Friday, March 04, 2016 3:45 PM
>To: James E.J. Bottomley; Martin K. Petersen
>Cc: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; Jitendra
Bhivare;
>linux-scsi@vger.kernel.org; MPT-FusionLinux.pdl@broadcom.com; Lars-Peter
>Clausen
>Subject: [PATCH resend 1/2] be2iscsi: Remove unnecessary
synchronize_irq()
>before free_irq()
>
>Calling synchronize_irq() right before free_irq() is quite useless. On
one hand the
>IRQ can easily fire again before free_irq() is entered, on the other hand
free_irq()
>itself calls synchronize_irq() internally (in a race condition free way),
before any
>state associated with the IRQ is freed.
>
>Patch was generated using the following semantic patch:
>// <smpl>
>@@
>expression irq;
>@@
>-synchronize_irq(irq);
> free_irq(irq, ...);
>// </smpl>
>
>Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>---
> drivers/scsi/be2iscsi/be_main.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/be2iscsi/be_main.c
b/drivers/scsi/be2iscsi/be_main.c
>index b51e726..e89a0f8d 100644
>--- a/drivers/scsi/be2iscsi/be_main.c
>+++ b/drivers/scsi/be2iscsi/be_main.c
>@@ -5303,15 +5303,12 @@ static void beiscsi_quiesce(struct beiscsi_hba
*phba,
> 	if (phba->msix_enabled) {
> 		for (i = 0; i <= phba->num_cpus; i++) {
> 			msix_vec = phba->msix_entries[i].vector;
>-			synchronize_irq(msix_vec);
> 			free_irq(msix_vec, &phwi_context->be_eq[i]);
> 			kfree(phba->msi_name[i]);
> 		}
> 	} else
>-		if (phba->pcidev->irq) {
>-			synchronize_irq(phba->pcidev->irq);
>+		if (phba->pcidev->irq)
> 			free_irq(phba->pcidev->irq, phba);
>-		}
> 	pci_disable_msix(phba->pcidev);
> 	cancel_delayed_work_sync(&phba->beiscsi_hw_check_task);
>
>--
>2.1.4

Reviewed-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Thanks,

JB
