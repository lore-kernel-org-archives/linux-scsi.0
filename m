From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 7/9] scsi: megaraid_sas - Driver created the self work
 queue for OCR
Date: Tue, 30 Nov 2010 17:11:10 +0100
Message-ID: <4CF5221E.8080603@redhat.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0K3QMO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 11:12:14 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

On 11/19/2010 06:37 PM, Yang, Bo wrote:
> Driver created the owner work queue (don't use global work queue). This queue will be used for online controller reset routine.
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>
>
> ---
> drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>   
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
> new/drivers/scsi/megaraid/megaraid_sas.c ---
> old/drivers/scsi/megaraid/megaraid_sas.c 2010-11-17 13:46:11.000000000
> -0500 +++ new/drivers/scsi/megaraid/megaraid_sas.c 2010-11-17
> 13:47:46.000000000 -0500 @@ -108,6 +108,7 @@ static struct
> megasas_mgmt_info megasas_ static struct fasync_struct
> *megasas_async_queue; static DEFINE_MUTEX(megasas_async_queue_mutex);
> +static struct workqueue_struct *megasas_ocr_wq; static int
> megasas_poll_wait_aen; static
> DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait); static u32
> support_poll_for_event; @@ -2435,7 +2436,7 @@
> megasas_deplete_reply_queue(struct megas printk(KERN_NOTICE "megasas:
> fwState=%x, stage:%d\n", fw_state, instance->adprecovery); -
> schedule_work(&instance->work_init); + queue_work(megasas_ocr_wq,
> &instance->work_init); return IRQ_HANDLED; } else { @@ -5157,6
> +5158,11 @@ static int __init megasas_init(void) goto err_pcidrv; } +
> megasas_ocr_wq = create_workqueue("megasas_ocr"); + + if (
> !megasas_ocr_wq ) + printk(KERN_DEBUG "megasas: Failed to create
> workqueue.\n"); + 
What happens later, when you pass the null pointer to the queue_work ?
I'm not sure this will work.

> rval = driver_create_file(&megasas_pci_driver.driver,
> &driver_attr_version); if (rval) @@ -5228,6 +5234,11 @@ static void
> __exit megasas_exit(void) &driver_attr_release_date);
> driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
> + if (megasas_ocr_wq) { + destroy_workqueue(megasas_ocr_wq); +
> megasas_ocr_wq = NULL; + } +
> pci_unregister_driver(&megasas_pci_driver);
> unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl"); } 

