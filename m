From: Alexander Duyck <aduyck@mirantis.com>
Subject: [PATCH 1/2] scsi: Do not attach VPD to devices that don't support it
Date: Wed, 20 Jan 2016 22:35:22 -0800
Message-ID: <20160121063522.3803.23150.stgit@localhost.localdomain>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160121063039.3803.66.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@odin.com, hare@suse.de, linux-scsi@vger.kernel.org
Cc: alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

The patch "scsi: rescan VPD attributes" introduced a regression in which
devices that don't support VPD were being scanned for VPD attributes
anyway.  This could cause issues for this parts and should be avoided so
the check for scsi_level has been moved out of scsi_add_lun and into
scsi_attach_vpd so that all callers will not scan VPD for devices that
don't support it.

Fixes: 09e2b0b14690 ("scsi: rescan VPD attributes")
Signed-off-by: Alexander Duyck <aduyck@mirantis.com>
---
 drivers/scsi/scsi.c      |    3 +++
 drivers/scsi/scsi_scan.c |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b1bf42b93fcc..ed085e78c893 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -784,6 +784,9 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int pg83_supported = 0;
 	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
 
+	if (sdev->scsi_level < SCSI_3)
+		return;
+
 	if (sdev->skip_vpd_pages)
 		return;
 retry_pg0:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6a820668d442..1b16c89e0cf9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -986,8 +986,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		}
 	}
 
-	if (sdev->scsi_level >= SCSI_3)
-		scsi_attach_vpd(sdev);
+	scsi_attach_vpd(sdev);
 
 	sdev->max_queue_depth = sdev->queue_depth;
 
