From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: IOA Status Code(IOASC) update
Date: Mon, 03 Jun 2013 22:19:57 -0500
Message-ID: <20130604032041.917550613@linux.vnet.ibm.com>
References: <20130604031956.483531143@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:43977 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1757177Ab3FDDXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jun 2013 23:23:17 -0400
Content-Disposition: inline; filename=ioasc_update
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

The patch updates some new IOA Status Code(IOASC) in ipr driver.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-05-30 12:40:37.000000000 -0500
+++ b/drivers/scsi/ipr.c	2013-06-03 20:56:31.127964230 -0500
@@ -281,12 +281,22 @@ struct ipr_error_table_t ipr_error_table
 	"FFF6: Failure prediction threshold exceeded"},
 	{0x015D9200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"8009: Impending cache battery pack failure"},
+	{0x02040100, 0, 0,
+	"Logical Unit in process of becoming ready"},
+	{0x02040200, 0, 0,
+	"Initializing command required"},
 	{0x02040400, 0, 0,
 	"34FF: Disk device format in progress"},
+	{0x02040C00, 0, 0,
+	"Logical unit not accessible, target port in unavailable state"},
 	{0x02048000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9070: IOA requested reset"},
 	{0x023F0000, 0, 0,
 	"Synchronization required"},
+	{0x02408500, 0, 0,
+	"IOA microcode download required"},
+	{0x02408600, 0, 0,
+	"Device bus connection is prohibited by host"},
 	{0x024E0000, 0, 0,
 	"No ready, IOA shutdown"},
 	{0x025A0000, 0, 0,
@@ -385,6 +395,8 @@ struct ipr_error_table_t ipr_error_table
 	"4030: Incorrect multipath connection"},
 	{0x04679000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4110: Unsupported enclosure function"},
+	{0x04679800, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4120: SAS cable VPD cannot be read"},
 	{0x046E0000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"FFF4: Command to logical unit failed"},
 	{0x05240000, 1, 0,
@@ -407,10 +419,18 @@ struct ipr_error_table_t ipr_error_table
 	"Illegal request, command sequence error"},
 	{0x052C8000, 1, 0,
 	"Illegal request, dual adapter support not enabled"},
+	{0x052C8100, 1, 0,
+	"Illegal request, another cable connector was physically disable"},
+	{0x054E8000, 1, 0,
+	"Illegal request, inconsistent group id/group count"},
 	{0x06040500, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9031: Array protection temporarily suspended, protection resuming"},
 	{0x06040600, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9040: Array protection temporarily suspended, protection resuming"},
+	{0x060B0100, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4080: IOA exceeded maximum operating temperature"},
+	{0x060B8000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4085: Service required"},
 	{0x06288000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"3140: Device bus not ready to ready transition"},
 	{0x06290000, 0, IPR_DEFAULT_LOG_LEVEL,
@@ -423,6 +443,8 @@ struct ipr_error_table_t ipr_error_table
 	"FFFB: SCSI bus was reset by another initiator"},
 	{0x063F0300, 0, IPR_DEFAULT_LOG_LEVEL,
 	"3029: A device replacement has occurred"},
+	{0x063F8300, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4102: Device bus fabric performance degradation"},
 	{0x064C8000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9051: IOA cache data exists for a missing or failed device"},
 	{0x064C8100, 0, IPR_DEFAULT_LOG_LEVEL,
@@ -445,6 +467,14 @@ struct ipr_error_table_t ipr_error_table
 	"9076: Configuration error, missing remote IOA"},
 	{0x06679100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4050: Enclosure does not support a required multipath function"},
+	{0x06679800, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4121: Configuration error, required cable is missing"},
+	{0x06679900, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4122: Cable is not plugged into the correct location on remote IOA"},
+	{0x06679A00, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4123: Configuration error, invalid cable vital product data"},
+	{0x06679B00, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4124: Configuration error, both cable ends are plugged into the same IOA"},
 	{0x06690000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4070: Logically bad block written on device"},
 	{0x06690200, 0, IPR_DEFAULT_LOG_LEVEL,
@@ -507,10 +537,18 @@ struct ipr_error_table_t ipr_error_table
 	"9062: One or more disks are missing from an array"},
 	{0x07279900, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9063: Maximum number of functional arrays has been exceeded"},
+	{0x07279A00, 0, 0,
+	"Data protect, other volume set problem"},
 	{0x0B260000, 0, 0,
 	"Aborted command, invalid descriptor"},
+	{0x0B3F9000, 0, 0,
+	"Target operating conditions have changed, dua adapter takeover"},
+	{0x0B530200, 0, 0,
+	"Aborted command, medium removal prevented"},
 	{0x0B5A0000, 0, 0,
-	"Command terminated by host"}
+	"Command terminated by host"},
+	{0x0B5B8000, 0, 0,
+	"Aborted command, command terminated by host"}
 };
 
 static const struct ipr_ses_table_entry ipr_ses_table[] = {

-- 
