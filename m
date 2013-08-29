From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 2/6] SCSI: esas2r: smatch - Fix dereference that occurs prior to check
Date: Thu, 29 Aug 2013 15:55:40 -0400
Message-ID: <1377806144-4902-3-git-send-email-bgrove@attotech.com>
References: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:45379 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755963Ab3H2Uny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 16:43:54 -0400
In-Reply-To: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, dan.carpenter@oracle.com, fengguang.wu@intel.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 78b18c1..9aaad0d 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -665,7 +665,7 @@ void esas2r_kill_adapter(int i)
 
 int esas2r_cleanup(struct Scsi_Host *host)
 {
-	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
+	struct esas2r_adapter *a;
 	int index;
 
 	if (host == NULL) {
@@ -678,6 +678,7 @@ int esas2r_cleanup(struct Scsi_Host *host)
 	}
 
 	esas2r_debug("esas2r_cleanup called for host %p", host);
+	a = (struct esas2r_adapter *)host->hostdata;
 	index = a->index;
 	esas2r_kill_adapter(index);
 	return index;
-- 
1.8.1.4

