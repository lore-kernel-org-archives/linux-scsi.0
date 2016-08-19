From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 26/29] be2iscsi: Fix queue and connection parameters
Date: Fri, 19 Aug 2016 15:20:23 +0530
Message-ID: <1471600226-22055-27-git-send-email-jitendra.bhivare@broadcom.com>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37570 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754480AbcHSJwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 05:52:09 -0400
Received: by mail-wm0-f54.google.com with SMTP id i5so32764420wmg.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:52:07 -0700 (PDT)
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Current EQ delay is set to 0 to receive very high max interrupt per sec.
Set EQ delay to 32 - reducing max interrupt rate from 65K to 20K per sec.

Set TCP connection window size to 64K with scale shift count 2.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 drivers/scsi/be2iscsi/be_mgmt.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 50d865e..7c372b8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3729,7 +3729,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 	phwi_context->max_eqd = 128;
 	phwi_context->min_eqd = 0;
-	phwi_context->cur_eqd = 0;
+	phwi_context->cur_eqd = 32;
 	/* set port optic state to unknown */
 	phba->optic_state = 0xff;
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 736eca3..adc827b 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -338,7 +338,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 
 	if (!is_chip_be2_be3r(phba)) {
 		req->hdr.version = MBX_CMD_VER1;
-		req->tcp_window_size = 0;
+		req->tcp_window_size = 0x8000;
 		req->tcp_window_scale_count = 2;
 	}
 
-- 
1.9.1

