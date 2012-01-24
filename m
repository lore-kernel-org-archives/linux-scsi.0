From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] target: handle empty string writes in sysfs
Date: Tue, 24 Jan 2012 11:40:36 +0300
Message-ID: <20120124084036.GB29097@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These are root only and we're not likely to hit the problem in practise,
but it makes a the static checkers happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0955bb8..9b86330 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1707,6 +1707,8 @@ static ssize_t target_core_store_dev_alias(
 	se_dev->su_dev_flags |= SDF_USING_ALIAS;
 	read_bytes = snprintf(&se_dev->se_dev_alias[0], SE_DEV_ALIAS_LEN,
 			"%s", page);
+	if (read_bytes == 0)
+		return -EINVAL;
 
 	if (se_dev->se_dev_alias[read_bytes - 1] == '\n')
 		se_dev->se_dev_alias[read_bytes - 1] = '\0';
@@ -1756,6 +1758,8 @@ static ssize_t target_core_store_dev_udev_path(
 	se_dev->su_dev_flags |= SDF_USING_UDEV_PATH;
 	read_bytes = snprintf(&se_dev->se_dev_udev_path[0], SE_UDEV_PATH_LEN,
 			"%s", page);
+	if (read_bytes == 0)
+		return -EINVAL;
 
 	if (se_dev->se_dev_udev_path[read_bytes - 1] == '\n')
 		se_dev->se_dev_udev_path[read_bytes - 1] = '\0';
