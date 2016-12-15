From: kys@exchange.microsoft.com
Subject: [PATCH 6/6] storvsc: properly set residual data length on errors
Date: Wed, 14 Dec 2016 18:46:03 -0800
Message-ID: <1481769963-2069-6-git-send-email-kys@exchange.microsoft.com>
References: <1481769928-2026-1-git-send-email-kys@exchange.microsoft.com>
 <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys@microsoft.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, James.Bottomley@HansenPartnership.com
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

On I/O errors, the Windows driver doesn't set data_transfer_length
on error conditions other than SRB_STATUS_DATA_OVERRUN.
In these cases we need to set data_transfer_length to 0,
indicating there is no data transferred. On SRB_STATUS_DATA_OVERRUN,
data_transfer_length is set by the Windows driver to the actual data transferred.

Reported-by: Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c92dc2..888e16e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -377,6 +377,7 @@ enum storvsc_request_type {
 #define SRB_STATUS_SUCCESS	0x01
 #define SRB_STATUS_ABORTED	0x02
 #define SRB_STATUS_ERROR	0x04
+#define SRB_STATUS_DATA_OVERRUN	0x12
 
 #define SRB_STATUS(status) \
 	(status & ~(SRB_STATUS_AUTOSENSE_VALID | SRB_STATUS_QUEUE_FROZEN))
@@ -996,6 +997,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
+	u32 data_transfer_length;
 	struct Scsi_Host *host;
 	u32 payload_sz = cmd_request->payload_sz;
 	void *payload = cmd_request->payload;
@@ -1003,6 +1005,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	host = stor_dev->host;
 
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
+	data_transfer_length = vm_srb->data_transfer_length;
 
 	scmnd->result = vm_srb->scsi_status;
 
@@ -1016,13 +1019,20 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 					     &sense_hdr);
 	}
 
-	if (vm_srb->srb_status != SRB_STATUS_SUCCESS)
+	if (vm_srb->srb_status != SRB_STATUS_SUCCESS) {
 		storvsc_handle_error(vm_srb, scmnd, host, sense_hdr.asc,
 					 sense_hdr.ascq);
+		/*
+		 * The Windows driver set data_transfer_length on
+		 * SRB_STATUS_DATA_OVERRUN. On other errors, this value
+		 * is untouched.  In these cases we set it to 0.
+		 */
+		if (vm_srb->srb_status != SRB_STATUS_DATA_OVERRUN)
+			data_transfer_length = 0;
+	}
 
 	scsi_set_resid(scmnd,
-		cmd_request->payload->range.len -
-		vm_srb->data_transfer_length);
+		cmd_request->payload->range.len - data_transfer_length);
 
 	scmnd->scsi_done(scmnd);
 
-- 
1.7.4.1
