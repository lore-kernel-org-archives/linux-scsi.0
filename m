From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 9/9] scsi: ibmvscsi: return SUCCESS_REMOVE when finding a abort cmd
Date: Fri, 30 May 2014 16:15:47 +0800
Message-ID: <1401437747-2097-10-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:60953 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE3INj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:13:39 -0400
Received: by mail-yh0-f42.google.com with SMTP id t59so1296985yho.29
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:13:39 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

When return SUCCESS_REMOVE, it can benifit the ref on scsi_cmnd

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index d0fa4b6..cf78be5 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1583,7 +1583,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 	free_event_struct(&found_evt->hostdata->pool, found_evt);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	atomic_inc(&hostdata->request_limit);
-	return SUCCESS;
+	return SUCCESS_REMOVE;
 }
 
 /**
-- 
1.8.1.4

