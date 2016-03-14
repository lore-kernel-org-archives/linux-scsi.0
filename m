From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Avoid that long log lines are truncated
Date: Mon, 14 Mar 2016 07:19:55 -0700
Message-ID: <56E6C88B.6010201@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0072.outbound.protection.outlook.com ([65.55.169.72]:28564
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755123AbcCNOUD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 10:20:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>, "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

While testing the latest version of the SRP initiator and target
drivers I encountered the following message in the kernel log:

sd 16:0:0:0: Warning! Received an indication that the LUN assignments on this target have changed. The Linux SCSI layer does not automatical

This is a truncated message. Avoid that such truncation happens
by increasing the SCSI_LOG_BUFSIZE constant.

Fixes: ded85c193a39 (scsi: Implement per-cpu logging buffer)
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Elliott <elliott@hp.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: <stable@vger.kernel.org> # v4.0+
---
 include/scsi/scsi_dbg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 56710e0..05d36eb 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -5,7 +5,7 @@ struct scsi_cmnd;
 struct scsi_device;
 struct scsi_sense_hdr;
 
-#define SCSI_LOG_BUFSIZE 128
+#define SCSI_LOG_BUFSIZE 256
 
 extern void scsi_print_command(struct scsi_cmnd *);
 extern size_t __scsi_format_command(char *, size_t,
-- 
2.7.2

