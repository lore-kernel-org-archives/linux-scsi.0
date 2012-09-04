From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 8/8] zfcp: only access zfcp_scsi_dev for valid scsi_device
Date: Tue, 04 Sep 2012 15:23:36 +0200
Message-ID: <20120904132349.060952854@linux.vnet.ibm.com>
References: <20120904132328.564402930@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41982 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2IDN3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 09:29:44 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 4 Sep 2012 14:29:43 +0100
Content-Disposition: inline; filename=714-zfcp-only-access-zfcp_scsi_dev-for-valid-scsi_device.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, stable@vger.kernel.org

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

__scsi_remove_device (e.g. due to dev_loss_tmo) calls
zfcp_scsi_slave_destroy which in turn sends a close LUN FSF request to
the adapter. After 30 seconds without response,
zfcp_erp_timeout_handler kicks the ERP thread failing the close LUN
ERP action. zfcp_erp_wait in zfcp_erp_lun_shutdown_wait and thus
zfcp_scsi_slave_destroy returns and then scsi_device is no longer
valid. Sometime later the response to the close LUN FSF request may
finally come in. However, commit
b62a8d9b45b971a67a0f8413338c230e3117dff5
"[SCSI] zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit"
introduced a number of attempts to unconditionally access struct
zfcp_scsi_dev through struct scsi_device causing a use-after-free.
This leads to an Oops due to kernel page fault in one of:
zfcp_fsf_abort_fcp_command_handler, zfcp_fsf_open_lun_handler,
zfcp_fsf_close_lun_handler, zfcp_fsf_req_trace,
zfcp_fsf_fcp_handler_common.
Move dereferencing of zfcp private data zfcp_scsi_dev allocated in
scsi_device via scsi_transport_reserve_device after the check for
potentially aborted FSF request and thus no longer valid scsi_device.
Only then assign sdev_to_zfcp(sdev) to the local auto variable struct
zfcp_scsi_dev *zfcp_sdev.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #2.6.37+
---
 drivers/s390/scsi/zfcp_fsf.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -801,12 +801,14 @@ out:
 static void zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_device *sdev = req->data;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	union fsf_status_qual *fsq = &req->qtcb->header.fsf_status_qual;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
@@ -1769,13 +1771,15 @@ static void zfcp_fsf_open_lun_handler(st
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct scsi_device *sdev = req->data;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_COMMON_ACCESS_BOXED |
 			  ZFCP_STATUS_LUN_SHARED |
@@ -1886,11 +1890,13 @@ out:
 static void zfcp_fsf_close_lun_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_device *sdev = req->data;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fscuh_1");
@@ -1980,7 +1986,7 @@ static void zfcp_fsf_req_trace(struct zf
 {
 	struct fsf_qual_latency_info *lat_in;
 	struct latency_cont *lat = NULL;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scsi->device);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	struct zfcp_blk_drv_data blktrc;
 	int ticks = req->adapter->timer_ticks;
 
@@ -1995,6 +2001,7 @@ static void zfcp_fsf_req_trace(struct zf
 
 	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA &&
 	    !(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
+		zfcp_sdev = sdev_to_zfcp(scsi->device);
 		blktrc.flags |= ZFCP_BLK_LAT_VALID;
 		blktrc.channel_lat = lat_in->channel_lat * ticks;
 		blktrc.fabric_lat = lat_in->fabric_lat * ticks;
@@ -2032,12 +2039,14 @@ static void zfcp_fsf_fcp_handler_common(
 {
 	struct scsi_cmnd *scmnd = req->data;
 	struct scsi_device *sdev = scmnd->device;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
 	case FSF_PORT_HANDLE_NOT_VALID:

