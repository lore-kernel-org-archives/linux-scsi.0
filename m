From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 10/12] hpsa: correct logical volume removal
Date: Fri, 20 Oct 2017 16:52:04 -0500
Message-ID: <150853632403.28275.1721043305036068989.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0052.outbound.protection.outlook.com ([104.47.40.52]:22656
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753533AbdJTVwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:52:40 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Suggested-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 228d744..a536ed6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1882,6 +1882,12 @@ static void hpsa_remove_device(struct ctlr_info *h,
 	if (!h->scsi_host)
 		return;
 
+	/*
+	 * Allow for commands to drain
+	 */
+	device->removed = 1;
+	hpsa_wait_for_outstanding_commands_for_dev(h, device);
+
 	if (is_logical_device(device)) { /* RAID */
 		sdev = scsi_device_lookup(h->scsi_host, device->bus,
 						device->target, device->lun);
@@ -1899,9 +1905,6 @@ static void hpsa_remove_device(struct ctlr_info *h,
 		}
 	} else { /* HBA */
 
-		device->removed = 1;
-		hpsa_wait_for_outstanding_commands_for_dev(h, device);
-
 		hpsa_remove_sas_device(device);
 	}
 }
