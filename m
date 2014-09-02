From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Date: Tue,  2 Sep 2014 16:43:16 -0700
Message-ID: <1409701396-20226-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Get rid of the warning messages since they will clutter up various system logs
and are of questionable value to the end user. For debugging purposes, this
information can be gotten by setting the scsi log level appropriately.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fecac5d0..733e5f7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1152,24 +1152,12 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	stor_pkt->vm_srb.sense_info_length =
 	vstor_packet->vm_srb.sense_info_length;
 
-	if (vstor_packet->vm_srb.scsi_status != 0 ||
-		vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS){
-		dev_warn(&device->device,
-			 "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
-			 stor_pkt->vm_srb.cdb[0],
-			 vstor_packet->vm_srb.scsi_status,
-			 vstor_packet->vm_srb.srb_status);
-	}
 
 	if ((vstor_packet->vm_srb.scsi_status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
 		if (vstor_packet->vm_srb.srb_status &
 			SRB_STATUS_AUTOSENSE_VALID) {
 			/* autosense data available */
-			dev_warn(&device->device,
-				 "stor pkt %p autosense data valid - len %d\n",
-				 request,
-				 vstor_packet->vm_srb.sense_info_length);
 
 			memcpy(request->sense_buffer,
 			       vstor_packet->vm_srb.sense_data,
-- 
1.7.4.1
