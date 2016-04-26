From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 02/10] aacraid: Fix incorrectly named MACRO
Date: Mon, 25 Apr 2016 23:31:03 -0700
Message-ID: <20160426063103.28402.96631.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:42016
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbcDZGe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:34:58 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Suggested-by: Seymour, Shane M <shane.seymour@hpe.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h  |    2 +-
 drivers/scsi/aacraid/comminit.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index efa493c..1936e08 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -720,7 +720,7 @@ struct sa_registers {
 };
 
 
-#define Sa_MINIPORT_REVISION			1
+#define SA_INIT_NUM_MSIXVECTORS		1
 
 #define sa_readw(AEP, CSR)		readl(&((AEP)->regs.sa->CSR))
 #define sa_readl(AEP, CSR)		readl(&((AEP)->regs.sa->CSR))
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 2b4e753..35697c1 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -91,7 +91,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION);
 	if (dev->max_fib_size != sizeof(struct hw_fib))
 		init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4);
-	init->Sa_MSIXVectors = cpu_to_le32(Sa_MINIPORT_REVISION);
+	init->Sa_MSIXVectors = cpu_to_le32(SA_INIT_NUM_MSIXVECTORS);
 	init->fsrev = cpu_to_le32(dev->fsrev);
 
 	/*

