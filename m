From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/19] qla2xxx: Correct infinite-login-retry issue.
Date: Thu, 20 Sep 2007 14:07:40 -0700
Message-ID: <1190322470-15543-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXITVHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:52 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

Where the DPC logic would get jammed into continuously
reloging-into a port.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a8ab2d3..4314f94 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2437,7 +2437,6 @@ qla2x00_do_dpc(void *data)
 				if (atomic_read(&fcport->state) != FCS_ONLINE &&
 				    fcport->login_retry) {
 
-					fcport->login_retry--;
 					if (fcport->flags & FCF_FABRIC_DEVICE) {
 						if (fcport->flags &
 						    FCF_TAPE_PRESENT)
@@ -2453,6 +2452,7 @@ qla2x00_do_dpc(void *data)
 						    qla2x00_local_device_login(
 							ha, fcport);
 
+					fcport->login_retry--;
 					if (status == QLA_SUCCESS) {
 						fcport->old_loop_id = fcport->loop_id;
 
@@ -2470,6 +2470,8 @@ qla2x00_do_dpc(void *data)
 					} else {
 						fcport->login_retry = 0;
 					}
+					if (fcport->login_retry == 0)
+						fcport->loop_id = FC_NO_LOOP_ID;
 				}
 				if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
 					break;
-- 
1.5.3.2.80.g077d6f

