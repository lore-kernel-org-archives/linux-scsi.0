From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH] pm80xx: Fix for 32 bit compilation issue.
Date: Wed, 07 Aug 2013 00:51:55 -0700
Message-ID: <5201FC9B.5030701@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:39878 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab3HGIP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 04:15:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Rich.Bono@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From cc606631fae60a38ab9532bab79fd93523f4c579 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Mon, 5 Aug 2013 14:16:52 +0530
Subject: [PATCH] pm80xx: Fix for 32 bit compilation issue.

pm80xx driver does not compile under 32 bit linux. This patch
fixes the same.

Signed-off-by: Anandkumar.Santhanam@pmcs.com

---
 drivers/scsi/pm8001/pm8001_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e4b9bc7..584d04e 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -422,9 +422,10 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
 				pm8001_printk("PCI: bar %d, logicalBar %d ",
 				bar, logicalBar));
 			PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-				"base addr %llx virt_addr=%llx len=%d\n",
+				"base addr %llx virt_addr %p len=%d\n",
 				(u64)pm8001_ha->io_mem[logicalBar].membase,
-				(u64)pm8001_ha->io_mem[logicalBar].memvirtaddr,
+				(void __iomem *)
+				pm8001_ha->io_mem[logicalBar].memvirtaddr,
 				pm8001_ha->io_mem[logicalBar].memsize));
 		} else {
 			pm8001_ha->io_mem[logicalBar].membase	= 0;
-- 
1.7.1

