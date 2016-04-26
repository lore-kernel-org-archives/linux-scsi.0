From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 03/10] aacraid: Start adapter after updating number of MSIX
 vectors
Date: Mon, 25 Apr 2016 23:31:12 -0700
Message-ID: <20160426063111.28402.3757.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:22688
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752520AbcDZGgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:36:07 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

The adapter has to be started after updating the number of MSIX Vectors

Fixes: ecc479e00db8 (aacraid: Set correct MSIX count for EEH recovery)
Cc: stable@vger.kernel.org

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ff6caab..79a1cec 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1431,8 +1431,8 @@ static int aac_acquire_resources(struct aac_dev *dev)
 		/* After EEH recovery or suspend resume, max_msix count
 		 * may change, therfore updating in init as well.
 		 */
-		aac_adapter_start(dev);
 		dev->init->Sa_MSIXVectors = cpu_to_le32(dev->max_msix);
+		aac_adapter_start(dev);
 	}
 	return 0;
 

