From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/6] qla2xxx: Allow the extended-error-logging flag to be dynamic.
Date: Mon, 12 Mar 2007 10:41:30 -0700
Message-ID: <117372129130-git-send-email-andrew.vasquez@qlogic.com>
References: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25532 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXCLRlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 13:41:35 -0400
In-Reply-To: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The module parameter, ql2xextended_error_logging, can now be
set dynamically by writing to the following sysfs entry:

	/sys/module/qla2xxx/parameters/ql2xextended_error_logging

This alleviates the need for the driver to be unloaded and
reloaded in order to enable logging.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f67ef38..b6c96a8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(ql2xallocfwdump,
 		"vary by ISP type.  Default is 1 - allocate memory.");
 
 int ql2xextended_error_logging;
-module_param(ql2xextended_error_logging, int, S_IRUGO|S_IRUSR);
+module_param(ql2xextended_error_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xextended_error_logging,
 		"Option to enable extended error logging, "
 		"Default is 0 - no logging. 1 - log errors.");
-- 
1.5.0.3.382.g34572

