From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/3] qla2xxx: Correct PLOGI retry logic.
Date: Wed, 23 Aug 2006 14:54:54 -0700
Message-ID: <11563700962249-git-send-email-andrew.vasquez@qlogic.com>
References: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32499 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965227AbWHWVy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Aug 2006 17:54:59 -0400
In-Reply-To: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code attempts to retry PLOGIs to fcports that are
FCP_TARGETs only.  If the driver never performed a successful
PLOGI/PRLI, the port-type would never be assigned, and the
relogin logic would silently drop the request (and thus the port
would not be recognized and registered).

The fix is relatively straightforward, drop the FCP_TARGET-only
check.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e2b95b..65cbe2f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2238,9 +2238,6 @@ qla2x00_do_dpc(void *data)
 
 			next_loopid = 0;
 			list_for_each_entry(fcport, &ha->fcports, list) {
-				if (fcport->port_type != FCT_TARGET)
-					continue;
-
 				/*
 				 * If the port is not ONLINE then try to login
 				 * to it if we haven't run out of retries.
-- 
1.4.2.g44c10

