From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 03/19] tcmu: Use macro to call container_of in tcmu_cmd_time_out_show
Date: Sun, 29 Oct 2017 22:44:23 -0500
Message-ID: <1509335079-5276-4-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Kenjiro Nakayama <nakayamakenjiro@gmail.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

This patch makes a tiny change that using TCMU_DEV in
tcmu_cmd_time_out_show so it is consistent with other functions.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
[added missing tcmu_cmd_time_out_store conversion]
Signed-off-by: Mike Christie <mchristi@redhat.com>

---
 drivers/target/target_core_user.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index fa251d3..1207b5b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1763,8 +1763,7 @@ static ssize_t tcmu_cmd_time_out_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 					struct se_dev_attrib, da_group);
-	struct tcmu_dev *udev = container_of(da->da_dev,
-					struct tcmu_dev, se_dev);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 
 	return snprintf(page, PAGE_SIZE, "%lu\n", udev->cmd_time_out / MSEC_PER_SEC);
 }
@@ -1774,8 +1773,7 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 					struct se_dev_attrib, da_group);
-	struct tcmu_dev *udev = container_of(da->da_dev,
-					struct tcmu_dev, se_dev);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 	u32 val;
 	int ret;
 
-- 
1.8.3.1
