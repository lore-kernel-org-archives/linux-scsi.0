From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: Improve ibmvfc_async_desc memory layout
Date: Thu, 9 Dec 2010 14:03:59 -0600
Message-ID: <20101209200359.GA7677@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:56437 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0LIUEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 15:04:06 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id oB9KtZOi005766
	for <linux-scsi@vger.kernel.org>; Thu, 9 Dec 2010 13:55:35 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oB9K41OT132638
	for <linux-scsi@vger.kernel.org>; Thu, 9 Dec 2010 13:04:02 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oB9K3x8x006860
	for <linux-scsi@vger.kernel.org>; Thu, 9 Dec 2010 13:04:01 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

By changing field ordering we can avoid a couple of memory holes in
the tables that use the ibmvfc_async_desc structure.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   28 ++++++++++++++--------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index df5ed28..1d19ba5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2496,23 +2496,23 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 }
 
 static const struct ibmvfc_async_desc ae_desc [] = {
-	{ IBMVFC_AE_ELS_PLOGI,		"PLOGI",		IBMVFC_DEFAULT_LOG_LEVEL + 1 },
-	{ IBMVFC_AE_ELS_LOGO,		"LOGO",		IBMVFC_DEFAULT_LOG_LEVEL + 1 },
-	{ IBMVFC_AE_ELS_PRLO,		"PRLO",		IBMVFC_DEFAULT_LOG_LEVEL + 1 },
-	{ IBMVFC_AE_SCN_NPORT,		"N-Port SCN",	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
-	{ IBMVFC_AE_SCN_GROUP,		"Group SCN",	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
-	{ IBMVFC_AE_SCN_DOMAIN,		"Domain SCN",	IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_SCN_FABRIC,		"Fabric SCN",	IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_LINK_UP,		"Link Up",		IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_LINK_DOWN,		"Link Down",	IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_LINK_DEAD,		"Link Dead",	IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_HALT,			"Halt",		IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_RESUME,		"Resume",		IBMVFC_DEFAULT_LOG_LEVEL },
-	{ IBMVFC_AE_ADAPTER_FAILED,	"Adapter Failed",	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "PLOGI",	IBMVFC_AE_ELS_PLOGI,	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ "LOGO",	IBMVFC_AE_ELS_LOGO,	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ "PRLO",	IBMVFC_AE_ELS_PRLO,	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ "N-Port SCN",	IBMVFC_AE_SCN_NPORT,	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ "Group SCN",	IBMVFC_AE_SCN_GROUP,	IBMVFC_DEFAULT_LOG_LEVEL + 1 },
+	{ "Domain SCN",	IBMVFC_AE_SCN_DOMAIN,	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Fabric SCN",	IBMVFC_AE_SCN_FABRIC,	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Link Up",	IBMVFC_AE_LINK_UP,	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Link Down",	IBMVFC_AE_LINK_DOWN,	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Link Dead",	IBMVFC_AE_LINK_DEAD,	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Halt",	IBMVFC_AE_HALT,		IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Resume",	IBMVFC_AE_RESUME,	IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "Adapter Failed", IBMVFC_AE_ADAPTER_FAILED, IBMVFC_DEFAULT_LOG_LEVEL },
 };
 
 static const struct ibmvfc_async_desc unknown_ae = {
-	0, "Unknown async", IBMVFC_DEFAULT_LOG_LEVEL
+	"Unknown async", 0, IBMVFC_DEFAULT_LOG_LEVEL
 };
 
 /**
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ef663e7..834c37f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -542,8 +542,8 @@ enum ibmvfc_async_event {
 };
 
 struct ibmvfc_async_desc {
-	enum ibmvfc_async_event ae;
 	const char *desc;
+	enum ibmvfc_async_event ae;
 	int log_level;
 };
 
-- 
1.7.0.4

