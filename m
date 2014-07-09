From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Tue,  8 Jul 2014 17:46:51 -0700
Message-ID: <1404866812-26950-7-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Correctly set SRB flags for all valid I/O directions. Some IHV drivers on the
Windows host require this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 82fb590..6540fb6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1613,26 +1613,24 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
 	vm_srb->win8_extension.time_out_value = 60;
 
+	vm_srb->win8_extension.srb_flags |=
+		(SRB_FLAGS_QUEUE_ACTION_ENABLE |
+		SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
 		vm_srb->data_in = WRITE_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_OUT;
-		vm_srb->win8_extension.srb_flags |=
-			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
-			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 		break;
 	case DMA_FROM_DEVICE:
 		vm_srb->data_in = READ_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_IN;
-		vm_srb->win8_extension.srb_flags |=
-			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
-			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 		break;
 	default:
 		vm_srb->data_in = UNKNOWN_TYPE;
-		vm_srb->win8_extension.srb_flags = 0;
+		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
+						     SRB_FLAGS_DATA_OUT);
 		break;
 	}
 
-- 
1.7.4.1
