From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that may
 have been removed.
Date: Sat, 16 Aug 2014 20:09:48 -0700
Message-ID: <1408244988-27456-2-git-send-email-kys@microsoft.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1408244988-27456-1-git-send-email-kys@microsoft.com>
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

The host asks the guest to scan when a LUN is removed or added.
The only way a guest can identify the removed LUN is when an I/O is
attempted on a removed LUN - the SRB status code indicates that the LUN
is invalid. We currently handle this SRB status and remove the device.

Rather than waiting for an I/O to remove the device, force the discovery of
LUNs that may have been removed prior to discovering LUNs that may have
been added.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 02d1db6..fb38ca9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -430,10 +430,36 @@ static void storvsc_host_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
 	struct Scsi_Host *host;
+	struct scsi_device *sdev;
+	unsigned long flags;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
 	host = wrk->host;
 
+	/*
+	 * Before scanning the host, first check to see if any of the
+	 * currrently known devices have been hot removed. We issue a
+	 * "unit ready" command against all currently known devices.
+	 * This I/O will result in an error for devices that have been
+	 * removed. As part of handling the I/O error, we remove the device.
+	 *
+	 * When a LUN is added or removed, the host sends us a signal to
+	 * scan the host. Thus we are forced to discover the LUNs that
+	 * may have been removed this way.
+	 */
+	mutex_lock(&host->scan_mutex);
+	spin_lock_irqsave(host->host_lock, flags);
+	list_for_each_entry(sdev, &host->__devices, siblings) {
+		spin_unlock_irqrestore(host->host_lock, flags);
+		scsi_test_unit_ready(sdev, 1, 1, NULL);
+		spin_lock_irqsave(host->host_lock, flags);
+		continue;
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+	mutex_unlock(&host->scan_mutex);
+	/*
+	 * Now scan the host to discover LUNs that may have been added.
+	 */
 	scsi_scan_host(host);
 
 	kfree(wrk);
-- 
1.7.4.1
