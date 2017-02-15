From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [patch] scsi: megaraid_sas: array overflow in megasas_dump_frame()
Date: Wed, 15 Feb 2017 19:47:04 +0530
Message-ID: <88e4e1cf9306d5f0db1b7e24e4c4a6f7@mail.gmail.com>
References: <20170214163855.GA1687@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170214163855.GA1687@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

Patch looks good. In last reply, Acked-by tag was not in proper format.
Fixing it now. Sorry for inconvenience.
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
