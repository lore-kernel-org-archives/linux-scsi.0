From: <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 1/1] scsi: Synchronize request queue PM status only on
 successful resume
Date: Thu, 3 Jan 2019 14:53:15 +0800
Message-ID: <1546498395-4184-3-git-send-email-stanley.chu@mediatek.com>
References: <1546498395-4184-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1546498395-4184-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

The commit 356fd2663cff ("scsi: Set request queue runtime PM status
back to active on resume") fixed up the inconsistent RPM status between
request queue and device. However changing request queue RPM status
shall be done only on successful resume, otherwise status may be still
inconsistent as below,

Request queue: RPM_ACTIVE
Device: RPM_SUSPENDED

This ends up soft lockup because requests can be submitted to
underlying devices but those devices and their required resource
are not resumed.

Fixes: 356fd2663cff ("scsi: Set request queue runtime PM status
back to active on resume")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/scsi_pm.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index a2b4179bfdf7..7639df91b110 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -80,8 +80,22 @@ static int scsi_dev_type_resume(struct device *dev,
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
+		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
+
+		/*
+		 * Forcibly set runtime PM status of request queue to "active"
+		 * to make sure we can again get requests from the queue
+		 * (see also blk_pm_peek_request()).
+		 *
+		 * The resume hook will correct runtime PM status of the disk.
+		 */
+		if (!err && scsi_is_sdev_device(dev)) {
+			struct scsi_device *sdev = to_scsi_device(dev);
+
+			if (sdev->request_queue->dev)
+				blk_set_runtime_active(sdev->request_queue);
+		}
 	}
 
 	return err;
@@ -140,16 +154,6 @@ static int scsi_bus_resume_common(struct device *dev,
 	else
 		fn = NULL;
 
-	/*
-	 * Forcibly set runtime PM status of request queue to "active" to
-	 * make sure we can again get requests from the queue (see also
-	 * blk_pm_peek_request()).
-	 *
-	 * The resume hook will correct runtime PM status of the disk.
-	 */
-	if (scsi_is_sdev_device(dev) && pm_runtime_suspended(dev))
-		blk_set_runtime_active(to_scsi_device(dev)->request_queue);
-
 	if (fn) {
 		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
 
-- 
2.18.0
