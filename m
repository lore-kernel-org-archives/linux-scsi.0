From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH 1/1] scsi: storvsc: Filter out storvsc messages CD-ROM medium not present
Date: Mon, 23 May 2016 10:29:17 -0400
Message-ID: <1464013757-30357-1-git-send-email-cavery@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kys@microsoft.com, haiyangz@microsoft.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When a virtual scsi DVD device is present with no image file
attached the storvsc driver logs all resulting unnecessary sense errors
whenever IO is issued to the device.

[storvsc] Sense Key : Not Ready [current]
[storvsc] Add. Sense: Medium not present - tray closed

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3ddcabb..f0efa07 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -966,7 +966,9 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	if (scmnd->result) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE, &sense_hdr) &&
-		    do_logging(STORVSC_LOGGING_ERROR))
+		    !(sense_hdr.sense_key == NOT_READY &&
+				 sense_hdr.asc == 0x03A) &&
+		    do_logging(STORVSC_LOGGING_ERROR)) 
 			scsi_print_sense_hdr(scmnd->device, "storvsc",
 					     &sense_hdr);
 	}
-- 
2.5.0
