From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] Fixing signness of parameters in scsi module
Date: Wed, 19 Sep 2007 09:06:06 -0700
Message-ID: <20070919090606.372897d4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:10929 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759986AbXISQHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Sep 2007 12:07:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@linux-foundation.org>, jet@gyve.org

forwarding to linux-scsi mailing list:

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Begin forwarded message:

Date: Wed, 19 Sep 2007 22:59:16 +0900 (JST)
From: Masatake YAMATO <jet@gyve.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fixing signness of parameters in scsi module


Hi,

In scsi module I've found some inconsistency between variable type
used in module_param_named and type passed to module_param_named as an
argument. Especially the inconsistency of `max_scsi_luns' parameter is
a bit serious because the description text says "last scsi LUN (should
be between 1 and 2^32-1)". 


I'm not on the mailing list. so please put my address
to cc: of your reply.

Signed-off-by: Masatake YAMATO <jet@gyve.org>


diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1bd92b9..f6d7552 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -83,7 +83,7 @@ #else
 static unsigned int max_scsi_luns = 1;
 #endif
 
-module_param_named(max_luns, max_scsi_luns, int, S_IRUGO|S_IWUSR);
+module_param_named(max_luns, max_scsi_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
@@ -96,14 +96,14 @@ MODULE_PARM_DESC(max_luns,
  */
 static unsigned int max_scsi_report_luns = 511;
 
-module_param_named(max_report_luns, max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
+module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
 
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
 
-module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
+module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(inq_timeout, 
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 5. Some non-compliant devices need more.");
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b03aa85..61ca8cd 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -370,7 +370,7 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
  */
 static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
 
-module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
+module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
 		 "Maximum number of seconds that the FC transport should"
 		 " insulate the loss of a remote port. Once this value is"
-
