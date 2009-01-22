From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/12] qla2xxx: Add checks for a valid fcport in dev-loss-tmo/terminate_rport_io callbacks.
Date: Thu, 22 Jan 2009 09:45:38 -0800
Message-ID: <1232646339-32503-12-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbZAVRqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:46:00 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Commit f78badb1ae07e7f8b835ab2ea0b456ed3fc4caf4 ([SCSI] fc
transport: pre-emptively terminate i/o upon dev_loss_tmo timeout)
changed the callback semantics of dev_loss_tmo and
terminate_rport_io such that repeated calls could be made.  This
could result in the the driver using stale (NULLed-out, in
dev_loss_tmo) data from the rport.  Correct this by addint a
simple check to ensure a valid fcport is attached.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c7acef5..33a3c13 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1016,6 +1016,9 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct Scsi_Host *host = rport_to_shost(rport);
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	if (!fcport)
+		return;
+
 	qla2x00_abort_fcport_cmds(fcport);
 
 	/*
@@ -1033,6 +1036,9 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	if (!fcport)
+		return;
+
 	/*
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
-- 
1.6.1.48.ge9b8

