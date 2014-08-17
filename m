From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: scsi: storvsc: In responce to a scan event,
 scan the host
Date: Sat, 16 Aug 2014 20:09:47 -0700
Message-ID: <1408244988-27456-1-git-send-email-kys@microsoft.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1408244954-27417-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: hare@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The virtual HBA that storvsc implements can support multiple channels and
targets. So, scan the host when the host notifies that a scan is needed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 15ba695..02d1db6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -426,21 +426,16 @@ done:
 	kfree(wrk);
 }
 
-static void storvsc_bus_scan(struct work_struct *work)
+static void storvsc_host_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
-	int id, order_id;
+	struct Scsi_Host *host;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
-	for (id = 0; id < wrk->host->max_id; ++id) {
-		if (wrk->host->reverse_ordering)
-			order_id = wrk->host->max_id - id - 1;
-		else
-			order_id = id;
-
-		scsi_scan_target(&wrk->host->shost_gendev, 0,
-				order_id, SCAN_WILD_CARD, 1);
-	}
+	host = wrk->host;
+
+	scsi_scan_host(host);
+
 	kfree(wrk);
 }
 
@@ -1209,7 +1204,7 @@ static void storvsc_on_receive(struct hv_device *device,
 		if (!work)
 			return;
 
-		INIT_WORK(&work->work, storvsc_bus_scan);
+		INIT_WORK(&work->work, storvsc_host_scan);
 		work->host = stor_device->host;
 		schedule_work(&work->work);
 		break;
-- 
1.7.4.1
