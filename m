From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: [PATCH] [RFC] qla2xxx: Change parameter permissions in sysfs
Date: Thu, 18 Nov 2010 05:05:46 -0600
Message-ID: <1290078346-3521-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:34448 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0KRTW4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 14:22:56 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id oAIKEcqL002338
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 13:14:38 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oAIJMrp3187352
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 12:22:53 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oAIJMqDG028411
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 12:22:52 -0700
Received: from us.ibm.com (dyn9414181.austin.ibm.com [9.41.41.81])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id oAIJMqCu028382
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 12:22:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, Milton Miller <miltonm@bga.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Many of the module parameter definitions in qla2xxx
look like S_IRUGO|S_IRUSR which is effectively doing 0400 | 0444
which is pointless. It seems like the intention is to allow a user
to change these parameters in sysfs.  So this patch changes it to
S_IRUGO|S_IWUSR to enable that.  Most of these copied into
a device-specific structure at init time, so the user would have to
re-probe or re-bind the adapters for these to take effect.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1644eab..f949959 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -37,12 +37,12 @@ static struct kmem_cache *srb_cachep;
 static struct kmem_cache *ctx_cachep;

 int ql2xlogintimeout = 20;
-module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
+module_param(ql2xlogintimeout, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xlogintimeout,
 		"Login timeout value in seconds.");

 int qlport_down_retry;
-module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
+module_param(qlport_down_retry, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(qlport_down_retry,
 		"Maximum number of command retries to a port that returns "
 		"a PORT-DOWN status.");
@@ -55,12 +55,12 @@ MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");

 int ql2xloginretrycount = 0;
-module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
+module_param(ql2xloginretrycount, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");

 int ql2xallocfwdump = 1;
-module_param(ql2xallocfwdump, int, S_IRUGO|S_IRUSR);
+module_param(ql2xallocfwdump, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xallocfwdump,
 		"Option to enable allocation of memory for a firmware dump "
 		"during HBA initialization.  Memory allocation requirements "
@@ -73,7 +73,7 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 		"Default is 0 - no logging. 1 - log errors.");

 int ql2xshiftctondsd = 6;
-module_param(ql2xshiftctondsd, int, S_IRUGO|S_IRUSR);
+module_param(ql2xshiftctondsd, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xshiftctondsd,
 		"Set to control shifting of command type processing "
 		"based on total number of SG elements.");
@@ -81,7 +81,7 @@ MODULE_PARM_DESC(ql2xshiftctondsd,
 static void qla2x00_free_device(scsi_qla_host_t *);

 int ql2xfdmienable=1;
-module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xfdmienable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
 		"0 - no FDMI. Default is 1 - perform FDMI.");
@@ -106,27 +106,27 @@ MODULE_PARM_DESC(ql2xenablehba_err_chk,
 		" Default is 0 - Error isolation disabled, 1 - Enable it");

 int ql2xiidmaenable=1;
-module_param(ql2xiidmaenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xiidmaenable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xiidmaenable,
 		"Enables iIDMA settings "
 		"Default is 1 - perform iIDMA. 0 - no iIDMA.");

 int ql2xmaxqueues = 1;
-module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
+module_param(ql2xmaxqueues, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqueues,
 		"Enables MQ settings "
 		"Default is 1 for single queue. Set it to number "
 		"of queues in MQ mode.");

 int ql2xmultique_tag;
-module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
+module_param(ql2xmultique_tag, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmultique_tag,
 		"Enables CPU affinity settings for the driver "
 		"Default is 0 for no affinity of request and response IO. "
 		"Set it to 1 to turn on the cpu affinity.");

 int ql2xfwloadbin;
-module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
+module_param(ql2xfwloadbin, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfwloadbin,
 		"Option to specify location from which to load ISP firmware:\n"
 		" 2 -- load firmware via the request_firmware() (hotplug)\n"
@@ -135,39 +135,39 @@ MODULE_PARM_DESC(ql2xfwloadbin,
 		" 0 -- use default semantics.\n");

 int ql2xetsenable;
-module_param(ql2xetsenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xetsenable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xetsenable,
 		"Enables firmware ETS burst."
 		"Default is 0 - skip ETS enablement.");

 int ql2xdbwr = 1;
-module_param(ql2xdbwr, int, S_IRUGO|S_IRUSR);
+module_param(ql2xdbwr, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xdbwr,
 	"Option to specify scheme for request queue posting\n"
 	" 0 -- Regular doorbell.\n"
 	" 1 -- CAMRAM doorbell (faster).\n");

 int ql2xdontresethba;
-module_param(ql2xdontresethba, int, S_IRUGO|S_IRUSR);
+module_param(ql2xdontresethba, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xdontresethba,
 	"Option to specify reset behaviour\n"
 	" 0 (Default) -- Reset on failure.\n"
 	" 1 -- Do not reset on failure.\n");

 int ql2xtargetreset = 1;
-module_param(ql2xtargetreset, int, S_IRUGO|S_IRUSR);
+module_param(ql2xtargetreset, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xtargetreset,
 		 "Enable target reset."
 		 "Default is 1 - use hw defaults.");

 int ql2xgffidenable;
-module_param(ql2xgffidenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xgffidenable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xgffidenable,
 		"Enables GFF_ID checks of port type. "
 		"Default is 0 - Do not use GFF_ID information.");

 int ql2xasynctmfenable;
-module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xasynctmfenable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xasynctmfenable,
 		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
 		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
-- 
1.5.6.5

