From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/6] qla2xxx: Honor NVRAM port-down-retry-count settings.
Date: Mon,  7 May 2007 07:42:59 -0700
Message-ID: <11785489832308-git-send-email-andrew.vasquez@qlogic.com>
References: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47139 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187AbXEGOna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:43:30 -0400
In-Reply-To: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Hardcoding the qlport_down_retry module-parameter
effectively disallowed any user-defined NVRAM setting to go
into effect.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a36912..dd076da 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -36,7 +36,7 @@ module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xlogintimeout,
 		"Login timeout value in seconds.");
 
-int qlport_down_retry = 30;
+int qlport_down_retry;
 module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(qlport_down_retry,
 		"Maximum number of command retries to a port that returns "
-- 
1.5.2.rc1.9.g6644

