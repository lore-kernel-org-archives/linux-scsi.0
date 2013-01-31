From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] target: Fix regression allowing unconfigured devices to fabric port link
Date: Thu, 31 Jan 2013 23:19:14 +0000
Message-ID: <1359674355-8590-2-git-send-email-nab@linux-iscsi.org>
References: <1359674355-8590-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1359674355-8590-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a v3.8-rc1 regression bug where an unconfigured se_device
was incorrectly allowed to perform a fabric port-link.  This bug was
introduced in commit:

  commit 0fd97ccf45be26fb01b3a412f1f6c6b5044b2f16
  Author: Christoph Hellwig <hch@infradead.org>
  Date:   Mon Oct 8 00:03:19 2012 -0400

      target: kill struct se_subsystem_dev

which ended up dropping the original se_subsystem_dev->se_dev_ptr check
preventing this from happening with pre commit 0fd97ccf code.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 810263d..c57bbbc 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -754,6 +754,11 @@ static int target_fabric_port_link(
 		return -EFAULT;
 	}
 
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("se_device not configured yet, cannot port link\n");
+		return -ENODEV;
+	}
+
 	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
 	se_tpg = container_of(to_config_group(tpg_ci),
 				struct se_portal_group, tpg_group);
-- 
1.7.2.5
