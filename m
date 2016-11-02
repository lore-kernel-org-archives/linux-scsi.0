From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid-sas: request irqs later
Date: Wed, 2 Nov 2016 19:17:36 +0530
Message-ID: <d95b81c153e9435144328b5430b2fa75@mail.gmail.com>
References: <1478017922-22655-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34279 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbcKBNri (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2016 09:47:38 -0400
Received: by mail-oi0-f45.google.com with SMTP id 62so16934055oif.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2016 06:47:38 -0700 (PDT)
In-Reply-To: <1478017922-22655-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@broadcom.com>

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Tuesday, November 01, 2016 10:02 PM
>To: linux-scsi@vger.kernel.org
>Cc: sumit.saxena@broadcom.com; kashyap.desai@broadcom.com
>Subject: [PATCH] megaraid-sas: request irqs later
>
>It is not good when an irq arrives before driver structures are
allocated.
>
>Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 12 +++++-------
> 1 file changed, 5 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index c3efcc7255..e207410150 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -5155,11 +5155,6 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
> 		(unsigned long)instance);
>
>-	if (instance->msix_vectors ?
>-		megasas_setup_irqs_msix(instance, 1) :
>-		megasas_setup_irqs_ioapic(instance))
>-		goto fail_setup_irqs;
>-
> 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
> 				GFP_KERNEL);
> 	if (instance->ctrl_info == NULL)
>@@ -5175,6 +5170,10 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	if (instance->instancet->init_adapter(instance))
> 		goto fail_init_adapter;
>
>+	if (instance->msix_vectors ?
>+		megasas_setup_irqs_msix(instance, 1) :
>+		megasas_setup_irqs_ioapic(instance))
>+		goto fail_init_adapter;
>
> 	instance->instancet->enable_intr(instance);
>
>@@ -5314,9 +5313,8 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
>
> fail_get_pd_list:
> 	instance->instancet->disable_intr(instance);
>-fail_init_adapter:
> 	megasas_destroy_irqs(instance);
>-fail_setup_irqs:
>+fail_init_adapter:
> 	if (instance->msix_vectors)
> 		pci_disable_msix(instance->pdev);
> 	instance->msix_vectors = 0;
Looks good to me. Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>--
>2.7.4
