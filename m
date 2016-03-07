From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] scsi: storvsc: fix SRB_STATUS_ABORTED handling
Date: Mon,  7 Mar 2016 11:59:44 +0100
Message-ID: <1457348384-11869-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbcCGK7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2016 05:59:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Cathy Avery <cavery@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen\"" <martin.petersen@oracle.com>

Commit 3209f9d780d1 ("scsi: storvsc: Fix a bug in the handling of SRB
status flags") filtered SRB_STATUS_AUTOSENSE_VALID out effectively making
the (SRB_STATUS_ABORTED | SRB_STATUS_AUTOSENSE_VALID) case a dead code. The
logic from this branch (e.g. storvsc_device_scan() call) is still required,
fix the check.

Fixes: 3209f9d780d1 ("scsi: storvsc: Fix a bug in the handling of SRB status flags")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 292c04e..3ddcabb 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -914,8 +914,9 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		do_work = true;
 		process_err_fn = storvsc_remove_lun;
 		break;
-	case (SRB_STATUS_ABORTED | SRB_STATUS_AUTOSENSE_VALID):
-		if ((asc == 0x2a) && (ascq == 0x9)) {
+	case SRB_STATUS_ABORTED:
+		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
+		    (asc == 0x2a) && (ascq == 0x9)) {
 			do_work = true;
 			process_err_fn = storvsc_device_scan;
 			/*
-- 
2.5.0

