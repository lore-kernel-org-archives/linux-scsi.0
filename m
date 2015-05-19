From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] target: double locking typo in
 core_clear_lun_from_tpg()
Date: Tue, 19 May 2015 15:04:19 +0300
Message-ID: <20150519120419.GA12107@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We accidentally deadlock instead of unlocking.

Fixes: 08d20ff62cde ('target: Acquire lun_entry_mutex during core_disable_device_list_for_node')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2f4c8fa..20618df 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -433,7 +433,7 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 
 			core_disable_device_list_for_node(lun, deve, nacl, tpg);
 		}
-		mutex_lock(&nacl->lun_entry_mutex);
+		mutex_unlock(&nacl->lun_entry_mutex);
 	}
 	mutex_unlock(&tpg->acl_node_mutex);
 }
