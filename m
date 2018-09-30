From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: arcmsr: clean up clang warning on extraneous
 parentheses
Date: Sun, 30 Sep 2018 16:18:10 -0700
Message-ID: <bd6313064c790b1db5806245b8c3d00e2f82c8f7.camel@perches.com>
References: <20180930230307.18664-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930230307.18664-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-01 at 00:03 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are extraneous parantheses that are causing clang to produce a
> warning so remove these.
> 
> Clean up 3 clang warnings:
> equality comparison with extraneous parentheses [-Wparentheses-equality]
[]
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
[]
> @@ -4135,9 +4135,9 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
>  		pci_read_config_byte(acb->pdev, i, &value[i]);
>  	}
>  	/* hardware reset signal */
> -	if ((acb->dev_id == 0x1680)) {
> +	if (acb->dev_id == 0x1680) {
>  		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);
> -	} else if ((acb->dev_id == 0x1880)) {
> +	} else if (acb->dev_id == 0x1880) {
>  		do {
>  			count++;
>  			writel(0xF, &pmuC->write_sequence);
> @@ -4161,7 +4161,7 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
>  		} while (((readl(&pmuE->host_diagnostic_3xxx) &
>  			ARCMSR_ARC1884_DiagWrite_ENABLE) == 0) && (count < 5));
>  		writel(ARCMSR_ARC188X_RESET_ADAPTER, &pmuE->host_diagnostic_3xxx);
> -	} else if ((acb->dev_id == 0x1214)) {
> +	} else if (acb->dev_id == 0x1214) {
>  		writel(0x20, pmuD->reset_request);
>  	} else {
>  		pci_write_config_byte(acb->pdev, 0x84, 0x20);

It'd probably read better using a switch/case like the below:
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 12316ef4c893..ad45583f5ae0 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -4135,9 +4135,11 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 		pci_read_config_byte(acb->pdev, i, &value[i]);
 	}
 	/* hardware reset signal */
-	if ((acb->dev_id == 0x1680)) {
+	switch (acb->dev_id) {
+	case 0x1680:
 		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);
-	} else if ((acb->dev_id == 0x1880)) {
+		break;
+	case 0x1880:
 		do {
 			count++;
 			writel(0xF, &pmuC->write_sequence);
@@ -4148,7 +4150,8 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 			writel(0xD, &pmuC->write_sequence);
 		} while (((readl(&pmuC->host_diagnostic) & ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
-	} else if (acb->dev_id == 0x1884) {
+		break;
+	case 0x1884:
 		struct MessageUnit_E __iomem *pmuE = acb->pmuE;
 		do {
 			count++;
@@ -4161,10 +4164,13 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 		} while (((readl(&pmuE->host_diagnostic_3xxx) &
 			ARCMSR_ARC1884_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC188X_RESET_ADAPTER, &pmuE->host_diagnostic_3xxx);
-	} else if ((acb->dev_id == 0x1214)) {
+		break;
+	case 0x1214:
 		writel(0x20, pmuD->reset_request);
-	} else {
+		break;
+	default:
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
+		break;
 	}
 	msleep(2000);
 	/* write back pci config data */
