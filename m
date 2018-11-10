From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/3] scsi: create an all-one filter for scanners
Date: Sat, 10 Nov 2018 17:35:32 +0100
Message-ID: <1541867733-7836-3-git-send-email-pbonzini@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

Any command is allowed for scanners when /dev/sg is used.
Reimplement this using customizable command filters, so that the
sysfs knobs will work in this case, too.

Cc: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_scan.c | 13 +++++++++++++
 drivers/scsi/sg.c        |  3 ---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 78ca63dfba4a..ceb7f5535f44 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -844,6 +844,19 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			*bflags |= BLIST_NOREPORTLUN;
 	}
 
+	if (sdev->type == TYPE_SCANNER) {
+		sdev->request_queue->cmd_filter =
+			kzalloc(sizeof(struct blk_cmd_filter), GFP_KERNEL);
+
+		if (!sdev->request_queue->cmd_filter)
+			return SCSI_SCAN_NO_RESPONSE;
+
+		memset(sdev->request_queue->cmd_filter->read_ok, 0xFF,
+		       sizeof(sdev->request_queue->cmd_filter->read_ok));
+		memset(sdev->request_queue->cmd_filter->write_ok, 0xFF,
+		       sizeof(sdev->request_queue->cmd_filter->write_ok));
+	}
+
 	/*
 	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
 	 * spec says: The device server is capable of supporting the
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1b04016d3bb8..e04acf41f283 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -242,9 +242,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	struct sg_fd *sfp = filp->private_data;
 	struct scsi_device *device = sfp->parentdp->device;
 
-	if (device->type == TYPE_SCANNER)
-		return 0;
-
 	return blk_verify_command(device->request_queue, cmd, filp->f_mode);
 }
 
-- 
1.8.3.1
