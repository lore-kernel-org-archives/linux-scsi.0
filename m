From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 07/14] hpsa: rescan later if reset in progress
Date: Thu, 4 May 2017 14:08:43 -0500
Message-ID: <149392492371.10271.2637281726677205232.stgit@brunhilda>
References: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0047.outbound.protection.outlook.com ([104.47.36.47]:23616
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756183AbdEDTIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 15:08:50 -0400
In-Reply-To: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - schedule another scan.
 - mark current scan as completed

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2990897..53a4f34 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5620,6 +5620,7 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	 */
 	if (h->reset_in_progress) {
 		h->drv_req_rescan = 1;
+		hpsa_scan_complete(h);
 		return;
 	}
 
