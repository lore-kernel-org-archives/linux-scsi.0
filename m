From: Long Li <longli@microsoft.com>
Subject: drivers:scsi:storvsc: Fix a bug in handling ring buffer failures that
 may result in I/O freeze
Date: Fri,  5 Dec 2014 19:38:18 -0800
Message-ID: <1417837098-23815-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-scsi@vger.kernel.org
Cc: haiyangz@microsoft.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

When ring buffer returns an error indicating retry, storvsc may not return a proper error code to SCSI when bounce buffer is not used. This has introduced I/O freeze on RAID running atop storvsc devices. This patch fixes it by always returning a proper error code.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e3ba251..4cff0dd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1688,13 +1688,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	if (ret == -EAGAIN) {
 		/* no more space */
 
-		if (cmd_request->bounce_sgl_count) {
+		if (cmd_request->bounce_sgl_count)
 			destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
 
-			ret = SCSI_MLQUEUE_DEVICE_BUSY;
-			goto queue_error;
-		}
+		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto queue_error;
 	}
 
 	return 0;
-- 
2.1.0
