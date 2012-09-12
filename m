From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/3] scsi: create an all-zero filter for scanners
Date: Wed, 12 Sep 2012 13:25:32 +0200
Message-ID: <1347449133-26476-3-git-send-email-pbonzini@redhat.com>
References: <1347449133-26476-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1347449133-26476-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Using /dev/sg for scanners is blocked from unprivileged users.  Reimplement
this using customizable command filters, so that the sysfs knobs will work
in this case too.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_scan.c |    6 +++++-
 drivers/scsi/sg.c        |    3 ---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 56a9379..d168c15 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -773,13 +773,17 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	switch (sdev->type) {
+	case TYPE_SCANNER:
+		sdev->request_queue->cmd_filter =
+			kzalloc(sizeof(struct blk_cmd_filter), GFP_KERNEL);
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
index 2ba7c82..c7474f5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -219,9 +219,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	struct sg_fd *sfp = filp->private_data;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-
 	return blk_verify_command(q->cmd_filter,
 				  cmd, filp->f_mode & FMODE_WRITE);
 }
-- 
1.7.1
