From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] fix the sysfs_add_file_to_group interfaces
Date: Wed, 02 Jan 2008 18:44:05 -0600
Message-ID: <1199321045.3258.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57086 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbYACAoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 19:44:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

I can't see a reason why these shouldn't work on every group.  However,
they only seem to work on named groups.  This patch allows the group
functions to work on anonymous groups (those with NULL names).

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

Again, this is something that's needed by the code to convert the SCSI
transport classes to groups (because we currently have the attributes
set up as anonymous groups on class devices).  So, taking this via the
SCSI tree would be appreciated.

Thanks,

James

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4045bdc..b834f17 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -568,7 +568,11 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 	struct sysfs_dirent *dir_sd;
 	int error;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (group)
+		dir_sd = sysfs_get_dirent(kobj->sd, group);
+	else
+		dir_sd = sysfs_get(kobj->sd);
+
 	if (!dir_sd)
 		return -ENOENT;
 
@@ -656,7 +660,10 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 {
 	struct sysfs_dirent *dir_sd;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (group)
+		dir_sd = sysfs_get_dirent(kobj->sd, group);
+	else
+		dir_sd = sysfs_get(kobj->sd);
 	if (dir_sd) {
 		sysfs_hash_and_remove(dir_sd, attr->name);
 		sysfs_put(dir_sd);


