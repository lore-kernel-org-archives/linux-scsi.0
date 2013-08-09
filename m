From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2] pm80xx: Fix for 32 bit compilation issue.
Date: Fri, 09 Aug 2013 00:29:30 -0700
Message-ID: <52049A5A.6080202@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60884 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030396Ab3HIH1Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2013 03:27:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Rich.Bono@pmcs.com, xjtuwjp@gmail.com, Nikith.Ganigarakoppal@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com

>From d89ed52c141b7f5599eb09e9d7f1010e1a89dcad Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Mon, 5 Aug 2013 14:16:52 +0530
Subject: [PATCH V2] pm80xx: Fix for 32 bit compilation issue.

pm80xx driver does not compile under 32 bit linux. This patch
fixes the same.

Signed-off-by: Anandkumar.Santhanam@pmcs.com

---
 drivers/scsi/pm8001/pm8001_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e4b9bc7..c23a21f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -424,7 +424,8 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
 			PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
 				"base addr %llx virt_addr=%llx len=%d\n",
 				(u64)pm8001_ha->io_mem[logicalBar].membase,
-				(u64)pm8001_ha->io_mem[logicalBar].memvirtaddr,
+				(u64)(unsigned long)
+				pm8001_ha->io_mem[logicalBar].memvirtaddr,
 				pm8001_ha->io_mem[logicalBar].memsize));
 		} else {
 			pm8001_ha->io_mem[logicalBar].membase	= 0;
-- 
1.7.1

