From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/3] Constify scsi_dev_info_list_add_keyed() string arguments
Date: Tue, 14 Nov 2017 18:33:16 -0800
Message-ID: <20171115023317.3595-3-bart.vanassche@wdc.com>
References: <20171115023317.3595-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42762 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdKOCf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2017 21:35:29 -0500
In-Reply-To: <20171115023317.3595-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_devinfo.c | 9 +++++----
 drivers/scsi/scsi_priv.h    | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index e63873537139..d195560a641c 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -292,8 +292,8 @@ static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
  * scsi_strcpy_devinfo: called from scsi_dev_info_list_add to copy into
  * devinfo vendor and model strings.
  */
-static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
-				char *from, int compatible)
+static void scsi_strcpy_devinfo(const char *name, char *to, size_t to_length,
+				const char *from, int compatible)
 {
 	size_t from_length;
 
@@ -360,8 +360,9 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
  *
  * Returns: 0 OK, -error on failure.
  **/
-int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
-				 char *strflags, int flags, int key)
+int scsi_dev_info_list_add_keyed(int compatible, const char *vendor,
+				 const char *model, const char *strflags,
+				 int flags, int key)
 {
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d79759271fe3..b82238577b19 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -58,8 +58,8 @@ extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				       const unsigned char *vendor,
 				       const unsigned char *model, int key,
 				       unsigned int *flags);
-extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
-					char *model, char *strflags,
+extern int scsi_dev_info_list_add_keyed(int compatible, const char *vendor,
+					const char *model, const char *strflags,
 					int flags, int key);
 extern int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key);
 extern int scsi_dev_info_add_list(int key, const char *name);
-- 
2.15.0
