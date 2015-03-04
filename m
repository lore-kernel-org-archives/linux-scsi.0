From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] ibmvfc: Fix a locking imbalance
Date: Wed, 4 Mar 2015 11:03:10 +0100
Message-ID: <54F6D85E.5060906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0093.outbound.protection.outlook.com ([157.56.111.93]:61360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932828AbbCDKDS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2015 05:03:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that the spin_lock() statement after kref_put() triggers a
lockup if rport != NULL && get_device() == 0. Detected by sparse.
Compile-tested only.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 057d277..b46257a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4722,6 +4722,8 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 					tgt_dbg(tgt, "Setting rport roles\n");
 					fc_remote_port_rolechg(rport, tgt->ids.roles);
 					put_device(&rport->dev);
+				} else {
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				}
 
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
-- 
2.1.4

