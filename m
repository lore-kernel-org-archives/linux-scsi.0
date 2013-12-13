From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 25/32] target: Call remove_lun instead of del_lun in fabric_port_unlink
Date: Fri, 13 Dec 2013 15:59:13 -0800
Message-ID: <1386979160-6928-26-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3LMX7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:35 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

We want to be freeing the port here, not freeing the lun.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_fabric_configfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 4715836..fe940d4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -808,7 +808,7 @@ static int target_fabric_port_unlink(
 		tf->tf_ops.fabric_pre_unlink(se_tpg, lun);
 	}
 
-	core_dev_del_lun(se_tpg, lun);
+	core_tpg_remove_lun(se_tpg, lun);
 	return 0;
 }
 
-- 
1.7.1

