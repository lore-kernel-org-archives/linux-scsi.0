From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] regression, megaraid - fix irq setup process
Date: Tue, 2 Jun 2015 12:36:51 +0530
Message-ID: <3c1a3409bc0508d38d3ded5a2d4ec330@mail.gmail.com>
References: <1433179605-31821-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33561 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbFBHGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2015 03:06:53 -0400
Received: by qkhg32 with SMTP id g32so96502174qkh.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2015 00:06:53 -0700 (PDT)
In-Reply-To: <1433179605-31821-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Monday, June 01, 2015 10:57 PM
>To: linux-scsi@vger.kernel.org
>Cc: kashyap.desai@avagotech.com; Sumit.Saxena@avagotech.com
>Subject: [PATCH] regression, megaraid - fix irq setup process
>
>This fixes a regression caused by commit
>d3557fc8be11d25f316884581f487684f8e7dad3
>megaraid_sas : Add separate function for setting up IRQs This makes boot
end
>with 'root does not exist' message on certain adapters.
>
>The bug is that the driver does not setup ints for cards without msi-x
support.
>This patch fixes it, in addition to that it moves irq-enable call after
tasklet
>initialisation - otherwise a kernel panic may occur, when an int arrives
before
>the tasklet is ready.

Thanks for pointing it out.
Tasklet is only scheduled for MFI adapters inside ISR routine and all
commands fired prior to "tasklet_init" are in polled mode  and MFI
adapters will not  send interrupt for the same.
Fusion adapters may send the interrupts but their ISR function don't use
tasklet at all so there should not be any problem.
We will move tasklet_init prior to enable_intr.  Calling enable_intr later
after firing few more DCMDs will cause more DCMDs to be fired in polled
mode(though fusion adapter will send interrupt but will not free up MFI
frame used).
I agree that cleaning up of this is required. I will send a patch to clean
it up and address few additional stuff.

>
>Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 22 ++++++++++------------
> 1 file changed, 10 insertions(+), 12 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index a022c39153..3771d6fff5 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4619,18 +4619,16 @@ static int megasas_init_fw(struct
>megasas_instance *instance)
> 			instance->msix_vectors = i;
> 		else
> 			instance->msix_vectors = 0;
>+	}
>
>-		dev_info(&instance->pdev->dev,
>-			"firmware supports msix\t: (%d)", fw_msix_count);
>-		dev_info(&instance->pdev->dev,
>-			"current msix/online cpus\t: (%d/%d)\n",
>-			instance->msix_vectors, (unsigned
>int)num_online_cpus());
>+	dev_info(&instance->pdev->dev, "firmware supports msix\t: (%d)",
>+		fw_msix_count);
>+	dev_info(&instance->pdev->dev, "current msix/online cpus\t:
>(%d/%d)\n",
>+		instance->msix_vectors, (unsigned int)num_online_cpus());
>
>-		if (instance->msix_vectors ?
>-				megasas_setup_irqs_msix(instance, 1) :
>-				megasas_setup_irqs_ioapic(instance))
>-			goto fail_setup_irqs;
>-	}
>+	if (instance->msix_vectors ? megasas_setup_irqs_msix(instance, 1)
:
>+				     megasas_setup_irqs_ioapic(instance))
>+		goto fail_setup_irqs;
>
> 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
> 				GFP_KERNEL);
>@@ -4646,8 +4644,6 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	/* Get operational params, sge flags, send init cmd to controller
*/
> 	if (instance->instancet->init_adapter(instance))
> 		goto fail_init_adapter;
>-	instance->instancet->enable_intr(instance);
>-
> 	printk(KERN_ERR "megasas: INIT adapter done\n");
>
> 	/** for passthrough
>@@ -4769,6 +4765,8 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
> 		(unsigned long)instance);
>
>+	instance->instancet->enable_intr(instance);
>+
> 	/* Launch SR-IOV heartbeat timer */
> 	if (instance->requestorId) {
> 		if (!megasas_sriov_start_heartbeat(instance, 1))

>--
>1.9.3
