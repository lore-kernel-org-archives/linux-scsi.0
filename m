From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4/6] scsi_error: fix invalid setting of host byte
Date: Tue,  3 Jun 2014 21:33:16 +0200
Message-ID: <1401823998-29167-5-git-send-email-pbonzini@redhat.com>
References: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46922 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929AbaFCTdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 15:33:31 -0400
In-Reply-To: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com, Ulrich Obergfell <uobergfe@redhat.com>, stable@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
already found that the command has completed in the device, causing
the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
this happens, ORing DID_TIME_OUT into the host byte will corrupt
the result field and initiate an unwanted command retry.

Fix this by using set_host_byte instead, following the model of
commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.

Cc: stable@vger.kernel.org
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7aa7879..ab06ef6fd726 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -131,7 +131,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 				    "aborting command %p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
-- 
1.8.3.1


