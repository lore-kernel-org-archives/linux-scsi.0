From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [patch] scsi: megaraid_sas: array overflow in megasas_dump_frame()
Date: Wed, 15 Feb 2017 11:36:48 +0530
Message-ID: <87590a598a0de2094b2a169fe6d9e818@mail.gmail.com>
References: <20170214163855.GA1687@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:36342 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdBOGGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 01:06:51 -0500
Received: by mail-ot0-f173.google.com with SMTP id 32so110193476oth.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2017 22:06:50 -0800 (PST)
In-Reply-To: <20170214163855.GA1687@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>-----Original Message-----
>From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>Sent: Tuesday, February 14, 2017 10:09 PM
>To: Kashyap Desai; Shivasharan S
>Cc: Sumit Saxena; James E.J. Bottomley; Martin K. Petersen;
>megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; kernel-
>janitors@vger.kernel.org
>Subject: [patch] scsi: megaraid_sas: array overflow in
megasas_dump_frame()
>
>The "sz" variable is in terms of bytes, but we're treating the buffer as
an array of
>__le32 so we have to divide by 4.
>
>Fixes: def0eab3af86 ("scsi: megaraid_sas: enhance debug logs in OCR
context")
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index dc9f42e135bb..7ac9a9ee9bd4 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -2754,7 +2754,7 @@ megasas_dump_frame(void *mpi_request, int sz)
> 	__le32 *mfp = (__le32 *)mpi_request;
>
> 	printk(KERN_INFO "IO request frame:\n\t");
>-	for (i = 0; i < sz; i++) {
>+	for (i = 0; i < sz / sizeof(__le32); i++) {
> 		if (i && ((i % 8) == 0))
> 			printk("\n\t");
> 		printk("%08x ", le32_to_cpu(mfp[i]));

Thanks for fixing this.
Acked-by: Sumit Saxena<sumit.saxena@broadcom.com>
