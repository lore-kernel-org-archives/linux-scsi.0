From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 RESEND] scsi: report 'INQUIRY result too short' once per host
Date: Fri, 30 Oct 2015 12:23:45 +0100
Message-ID: <1446204225-6114-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <^Cottomley@Odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan\"" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
INQUIRY result too short (5), using 36' messages on console. This can be
problematic for slow consoles. Introduce short_inquiry flag in struct
Scsi_Host to print the message once per host.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v3:
- no changes, this is just a RESEND.

Changes since v2:
- This is a successor of previously sent (and still not merged) "scsi:
  introduce short_inquiry flag for broken host adapters" patch. I'm not
  particularly sure which solution is better but I'm leaning towards this
  one as it doesn't require changes to adapter drivers.
---
 drivers/scsi/scsi_scan.c | 9 ++++++---
 include/scsi/scsi_host.h | 3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..cd347e4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -701,9 +701,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		sdev_printk(KERN_INFO, sdev,
-			    "scsi scan: INQUIRY result too short (%d),"
-			    " using 36\n", sdev->inquiry_len);
+		if (!sdev->host->short_inquiry) {
+			shost_printk(KERN_INFO, sdev->host,
+				    "scsi scan: INQUIRY result too short (%d),"
+				    " using 36\n", sdev->inquiry_len);
+			sdev->host->short_inquiry = 1;
+		}
 		sdev->inquiry_len = 36;
 	}
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c75..3a22da7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -673,6 +673,9 @@ struct Scsi_Host {
 	unsigned use_blk_mq:1;
 	unsigned use_cmd_list:1;
 
+	/* Host responded with short (<36 bytes) INQUIRY result */
+	unsigned short_inquiry:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
2.4.3
