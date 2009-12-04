From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 14/15] be2iscsi: Fixing initialization of can_queue
Date: Fri, 4 Dec 2009 08:57:14 +0530
Message-ID: <20091204032705.GA6323@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:7102 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754972AbZLDD1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:27:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch fixes can_queue being uninitiallized since it
was done before beiscsi_get_params was called.

Thanks to Mike Christie for identifying this

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a6a2c64..b1c8975 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3825,8 +3825,8 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto free_port;
 	}
 	phba->shost->max_id = phba->fw_config.iscsi_cid_count;
-	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	beiscsi_get_params(phba);
+	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
 		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-- 
1.6.4

