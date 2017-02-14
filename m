From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: megaraid_sas: array overflow in megasas_dump_frame()
Date: Tue, 14 Feb 2017 19:38:55 +0300
Message-ID: <20170214163855.GA1687@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "sz" variable is in terms of bytes, but we're treating the buffer as
an array of __le32 so we have to divide by 4.

Fixes: def0eab3af86 ("scsi: megaraid_sas: enhance debug logs in OCR context")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index dc9f42e135bb..7ac9a9ee9bd4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2754,7 +2754,7 @@ megasas_dump_frame(void *mpi_request, int sz)
 	__le32 *mfp = (__le32 *)mpi_request;
 
 	printk(KERN_INFO "IO request frame:\n\t");
-	for (i = 0; i < sz; i++) {
+	for (i = 0; i < sz / sizeof(__le32); i++) {
 		if (i && ((i % 8) == 0))
 			printk("\n\t");
 		printk("%08x ", le32_to_cpu(mfp[i]));
