From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 2/4] scsi: create an all-zero filter for scanners
Date: Mon, 27 May 2013 15:50:20 +0200
Message-ID: <1369662622-5959-3-git-send-email-pbonzini@redhat.com>
References: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, msnitzer@redhat.com, ksievers@redhat.com, jbottomley@parallels.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Using /dev/sg for scanners is blocked from unprivileged users.  Reimplement
this using customizable command filters, so that the sysfs knobs will work
in this case too.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_scan.c | 8 +++++++-
 drivers/scsi/sg.c        | 3 ---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..de5751b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -783,13 +783,19 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	switch (sdev->type) {
+	case TYPE_SCANNER:
+		sdev->request_queue->cmd_filter =
+			kzalloc(sizeof(struct blk_cmd_filter), GFP_ATOMIC);
+		if (sdev->request_queue->cmd_filter == NULL)
+			return SCSI_SCAN_NO_RESPONSE;
+		/* fallthrough */
+
 	case TYPE_RBC:
 	case TYPE_TAPE:
 	case TYPE_DISK:
 	case TYPE_PRINTER:
 	case TYPE_MOD:
 	case TYPE_PROCESSOR:
-	case TYPE_SCANNER:
 	case TYPE_MEDIUM_CHANGER:
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5f64202..f7f5c11 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -220,9 +220,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	struct sg_fd *sfp = filp->private_data;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-
 	return blk_verify_command(q->cmd_filter,
 				  cmd, filp->f_mode & FMODE_WRITE);
 }
-- 
1.8.1.4
