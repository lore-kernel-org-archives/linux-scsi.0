From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 3/9] scsi: introduce new internal flag SUCCESS_REMOVE
Date: Fri, 30 May 2014 16:15:41 +0800
Message-ID: <1401437747-2097-4-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54455 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaE3INC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:13:02 -0400
Received: by mail-yh0-f46.google.com with SMTP id 29so1287536yhl.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:13:01 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

Currently when aborting a scsi_cmnd, we can not tell whether this cmd is
canceled or has not been found by scsi_try_to_abort_cmd(). So introducing
this new flag. (In the succeeding patch, if caller success to cancel
the scmd, then it should drop the ref on scmd, otherwise no ops)

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c | 8 +++++++-
 include/scsi/scsi.h       | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3b8b95b..8ddd8f5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -869,10 +869,16 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
+	int ret;
+
 	if (!hostt->eh_abort_handler)
 		return FAILED;
 
-	return hostt->eh_abort_handler(scmd);
+	ret = hostt->eh_abort_handler(scmd);
+	/* After introducing ref on scsi_cmnd, here will handle the ref */
+	if (ret == SUCCESS_REMOVE)
+		ret = SUCCESS;
+	return ret;
 }
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d477bfb..4183b01 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -488,6 +488,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
+#define SUCCESS_REMOVE 0x200a
 
 /*
  * Midlevel queue return values.
-- 
1.8.1.4

