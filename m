From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch 02/10] scsi: make scsi_alloc_sdev numa-aware
Date: Tue, 30 Oct 2012 16:14:36 -0400
Message-ID: <1351628084-29358-5-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the numa node id set in the Scsi_Host to allocate the sdev structure
on the device-local numa node.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/scsi_scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..f10a308 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -232,8 +232,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	extern void scsi_evt_thread(struct work_struct *work);
 	extern void scsi_requeue_run_queue(struct work_struct *work);
 
-	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+	sdev = kzalloc_node(sizeof(*sdev) + shost->transportt->device_size,
+			    GFP_ATOMIC, shost->numa_node);
 	if (!sdev)
 		goto out;
 
-- 
1.7.1
