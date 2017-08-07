From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] scsi: megaraid_sas: fix error handle in megasas_probe_one
Date: Mon, 7 Aug 2017 23:14:23 +0530
Message-ID: <03fabd3896ffd7c04c0060eb5ce28f86@mail.gmail.com>
References: <20170807172650.GA33146@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34065 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdHGRo0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:44:26 -0400
Received: by mail-oi0-f49.google.com with SMTP id x3so10912884oia.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2017 10:44:26 -0700 (PDT)
In-Reply-To: <20170807172650.GA33146@bogon.didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: weiping zhang [mailto:zhangweiping@didichuxing.com]
>Sent: Monday, August 07, 2017 10:57 PM
>To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>shivasharan.srikanteshwara@broadcom.com
>Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
>Subject: [PATCH] scsi: megaraid_sas: fix error handle in
megasas_probe_one
>
>megasas_mgmt_info.max_index has increased by 1 before
>megasas_io_attach, if megasas_io_attach return error, then goto
>fail_io_attach, megasas_mgmt_info.instance has a wrong index here. So
first
>reduce max_index and then set that instance to NULL.
>
>Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index b5b9ba7..91eeec9 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -6226,8 +6226,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
> fail_start_aen:
> fail_io_attach:
> 	megasas_mgmt_info.count--;
>-	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] =
>NULL;
> 	megasas_mgmt_info.max_index--;
>+	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] =
>NULL;
>
> 	instance->instancet->disable_intr(instance);
> 	megasas_destroy_irqs(instance);

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>--
>2.9.4
