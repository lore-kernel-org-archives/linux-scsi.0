From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 4/6] Add refcount to fw_event_work struct
Date: Mon, 8 Jun 2015 20:50:54 -0700
Message-ID: <1433821856-2815280-5-git-send-email-calvinowens@fb.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

The fw_event_work struct is concurrently referenced at shutdown, so
add a refcount to protect it.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 9645055..611b34d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -176,9 +176,37 @@ struct fw_event_work {
 	u8			VP_ID;
 	u8			ignore;
 	u16			event;
+	struct kref		refcount;
 	char			event_data[0] __aligned(4);
 };
 
+static void fw_event_work_free(struct kref *r)
+{
+	kfree(container_of(r, struct fw_event_work, refcount));
+}
+
+static void fw_event_work_get(struct fw_event_work *fw_work)
+{
+	kref_get(&fw_work->refcount);
+}
+
+static void fw_event_work_put(struct fw_event_work *fw_work)
+{
+	kref_put(&fw_work->refcount, fw_event_work_free);
+}
+
+static struct fw_event_work *alloc_fw_event_work(int len)
+{
+	struct fw_event_work *fw_event;
+
+	fw_event = kzalloc(sizeof(*fw_event) + len, GFP_ATOMIC);
+	if (!fw_event)
+		return NULL;
+
+	kref_init(&fw_event->refcount);
+	return fw_event;
+}
+
 /* raid transport support */
 static struct raid_template *mpt2sas_raid_template;
 
-- 
1.8.1
