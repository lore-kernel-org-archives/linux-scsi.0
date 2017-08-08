From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH v2] scsi: megaraid_sas: fix allocate instance->pd_info twice
Date: Tue, 8 Aug 2017 19:36:51 +0530
Message-ID: <d1ffa8c6e1c8ec8e8815674f6286a84a@mail.gmail.com>
References: <20170808051549.GA11601@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35057 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdHHOGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 10:06:54 -0400
Received: by mail-oi0-f41.google.com with SMTP id e124so33601695oig.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2017 07:06:54 -0700 (PDT)
In-Reply-To: <20170808051549.GA11601@bogon.didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: weiping zhang [mailto:zhangweiping@didichuxing.com]
>Sent: Tuesday, August 08, 2017 10:46 AM
>To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>shivasharan.srikanteshwara@broadcom.com
>Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
>Subject: [PATCH v2] scsi: megaraid_sas: fix allocate instance->pd_info
twice
>
>fix allocate instance->pd_info twice which was introduced by
96188a89cc6d.
>
>Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 71c4746..a0f057c 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -6096,14 +6096,12 @@ static int megasas_probe_one(struct pci_dev
>*pdev,
> 		instance->pd_info = pci_alloc_consistent(pdev,
> 			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
>
>-		instance->pd_info = pci_alloc_consistent(pdev,
>-			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
>-		instance->tgt_prop = pci_alloc_consistent(pdev,
>-			sizeof(struct MR_TARGET_PROPERTIES), &instance-
>>tgt_prop_h);
>-
> 		if (!instance->pd_info)
> 			dev_err(&instance->pdev->dev, "Failed to alloc mem
>for pd_info\n");
>
>+		instance->tgt_prop = pci_alloc_consistent(pdev,
>+			sizeof(struct MR_TARGET_PROPERTIES), &instance-
>>tgt_prop_h);
>+
> 		if (!instance->tgt_prop)
> 			dev_err(&instance->pdev->dev, "Failed to alloc mem
>for tgt_prop\n");

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>
>--
>2.9.4
