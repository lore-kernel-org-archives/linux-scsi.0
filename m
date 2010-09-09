From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Log link up/down events
Date: Thu, 09 Sep 2010 16:20:42 -0500
Message-ID: <201009092120.o89LKZXd030398@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49477 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0IIVUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 17:20:37 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o89LC7HZ003600
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2010 15:12:07 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o89LKb9a192988
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2010 15:20:37 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o89LKaQK030625
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2010 15:20:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


By default, ibmvfc does not log any async events in order
to avoid flooding the log with them. Improve on this by
logging by default events that are not likely to flood the
log, such as link up/down. Having these events in the log
will improve the ability to debug issues with ibmvfc.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   74 +++++++++++++++++++++++++++--------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    6 +++
 2 files changed, 56 insertions(+), 24 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_async_log_level drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_async_log_level	2010-08-30 08:45:09.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-08-30 17:30:04.000000000 -0500
@@ -2496,41 +2496,66 @@ static void ibmvfc_terminate_rport_io(st
 	LEAVE;
 }
 
-static const struct {
-	enum ibmvfc_async_event ae;
-	const char *desc;
-} ae_desc [] = {
-	{ IBMVFC_AE_ELS_PLOGI,		"PLOGI" },
-	{ IBMVFC_AE_ELS_LOGO,		"LOGO" },
-	{ IBMVFC_AE_ELS_PRLO,		"PRLO" },
-	{ IBMVFC_AE_SCN_NPORT,		"N-Port SCN" },
-	{ IBMVFC_AE_SCN_GROUP,		"Group SCN" },
-	{ IBMVFC_AE_SCN_DOMAIN,		"Domain SCN" },
-	{ IBMVFC_AE_SCN_FABRIC,		"Fabric SCN" },
-	{ IBMVFC_AE_LINK_UP,		"Link Up" },
-	{ IBMVFC_AE_LINK_DOWN,		"Link Down" },
-	{ IBMVFC_AE_LINK_DEAD,		"Link Dead" },
-	{ IBMVFC_AE_HALT,			"Halt" },
-	{ IBMVFC_AE_RESUME,		"Resume" },
-	{ IBMVFC_AE_ADAPTER_FAILED,	"Adapter Failed" },
+static const struct ibmvfc_async_desc ae_desc [] = {
+	{ IBMVFC_AE_ELS_PLOGI,		"PLOGI",		IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ IBMVFC_AE_ELS_LOGO,		"LOGO",		IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ IBMVFC_AE_ELS_PRLO,		"PRLO",		IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ IBMVFC_AE_SCN_NPORT,		"N-Port SCN",	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ IBMVFC_AE_SCN_GROUP,		"Group SCN",	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ IBMVFC_AE_SCN_DOMAIN,		"Domain SCN",	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_SCN_FABRIC,		"Fabric SCN",	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_LINK_UP,		"Link Up",		IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_LINK_DOWN,		"Link Down",	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_LINK_DEAD,		"Link Dead",	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_HALT,			"Halt",		IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_RESUME,		"Resume",		IBMVFC_DEFAULT_LOG_LEVEL },
+	{ IBMVFC_AE_ADAPTER_FAILED,	"Adapter Failed",	IBMVFC_DEFAULT_LOG_LEVEL },
 };
 
-static const char *unknown_ae = "Unknown async";
+static const struct ibmvfc_async_desc unknown_ae = {
+	0, "Unknown async", IBMVFC_DEFAULT_LOG_LEVEL
+};
 
 /**
  * ibmvfc_get_ae_desc - Get text description for async event
  * @ae:	async event
  *
  **/
-static const char *ibmvfc_get_ae_desc(u64 ae)
+static const struct ibmvfc_async_desc *ibmvfc_get_ae_desc(u64 ae)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ae_desc); i++)
 		if (ae_desc[i].ae == ae)
-			return ae_desc[i].desc;
+			return &ae_desc[i];
+
+	return &unknown_ae;
+}
+
+static const struct {
+	enum ibmvfc_ae_link_state state;
+	const char *desc;
+} link_desc [] = {
+	{ IBMVFC_AE_LS_LINK_UP,		" link up" },
+	{ IBMVFC_AE_LS_LINK_BOUNCED,	" link bounced" },
+	{ IBMVFC_AE_LS_LINK_DOWN,	" link down" },
+	{ IBMVFC_AE_LS_LINK_DEAD,	" link dead" },
+};
+
+/**
+ * ibmvfc_get_link_state - Get text description for link state
+ * @state:	link state
+ *
+ **/
+static const char *ibmvfc_get_link_state(enum ibmvfc_ae_link_state state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(link_desc); i++)
+		if (link_desc[i].state == state)
+			return link_desc[i].desc;
 
-	return unknown_ae;
+	return "";
 }
 
 /**
@@ -2542,11 +2567,12 @@ static const char *ibmvfc_get_ae_desc(u6
 static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 				struct ibmvfc_host *vhost)
 {
-	const char *desc = ibmvfc_get_ae_desc(crq->event);
+	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(crq->event);
 	struct ibmvfc_target *tgt;
 
-	ibmvfc_log(vhost, 3, "%s event received. scsi_id: %llx, wwpn: %llx,"
-		   " node_name: %llx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
+	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
+		   " node_name: %llx%s\n", desc->desc, crq->scsi_id, crq->wwpn, crq->node_name,
+		   ibmvfc_get_link_state(crq->link_state));
 
 	switch (crq->event) {
 	case IBMVFC_AE_RESUME:
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_async_log_level drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_async_log_level	2010-08-30 08:45:09.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-08-30 17:30:04.000000000 -0500
@@ -541,6 +541,12 @@ enum ibmvfc_async_event {
 	IBMVFC_AE_ADAPTER_FAILED	= 0x1000,
 };
 
+struct ibmvfc_async_desc {
+	enum ibmvfc_async_event ae;
+	const char *desc;
+	int log_level;
+};
+
 struct ibmvfc_crq {
 	volatile u8 valid;
 	volatile u8 format;
_
