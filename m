From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 2/2] scsi: storvsc: Use the specified target ID in device
 lookup
Date: Wed, 27 Jan 2016 18:22:45 -0800
Message-ID: <1453947765-28764-2-git-send-email-kys@microsoft.com>
References: <1453947739-28725-1-git-send-email-kys@microsoft.com>
 <1453947765-28764-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1453947765-28764-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

The current code assumes that there is only one target in device lookup.
Fix this bug. This will alow us to correctly handle hot reomoval of LUNs.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Alex Ng <alexng@microsoft.com>
Tested-by: Vivek Yadav <vyadav@microsoft.com>
---
	V2: Made lun and target_id unsigned 8 bit entities - Hannes Reinecke <hare@suse.de>

 drivers/scsi/storvsc_drv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 622f64a..132b168 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -478,19 +478,18 @@ struct hv_host_device {
 struct storvsc_scan_work {
 	struct work_struct work;
 	struct Scsi_Host *host;
-	uint lun;
+	u8 lun;
+	u8 tgt_id;
 };
 
 static void storvsc_device_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
-	uint lun;
 	struct scsi_device *sdev;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
-	lun = wrk->lun;
 
-	sdev = scsi_device_lookup(wrk->host, 0, 0, lun);
+	sdev = scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
 	if (!sdev)
 		goto done;
 	scsi_rescan_device(&sdev->sdev_gendev);
@@ -541,7 +540,7 @@ static void storvsc_remove_lun(struct work_struct *work)
 	if (!scsi_host_get(wrk->host))
 		goto done;
 
-	sdev = scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
+	sdev = scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
 
 	if (sdev) {
 		scsi_remove_device(sdev);
@@ -941,6 +940,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 
 	wrk->host = host;
 	wrk->lun = vm_srb->lun;
+	wrk->tgt_id = vm_srb->target_id;
 	INIT_WORK(&wrk->work, process_err_fn);
 	schedule_work(&wrk->work);
 }
-- 
1.7.4.1
