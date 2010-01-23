From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 3/8] be2iscsi: Fix for first_burst
Date: Sat, 23 Jan 2010 05:36:10 +0530
Message-ID: <20100123000558.GA12601@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:39900 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751548Ab0AWAGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:06:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch fixes the first_burst being modified
instead of max_burst

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 3847a58..d5712bc 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -274,8 +274,8 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 			conn->max_recv_dlength = 65536;
 		break;
 	case ISCSI_PARAM_MAX_BURST:
-		if (session->first_burst > 262144)
-			session->first_burst = 262144;
+		if (session->max_burst > 262144)
+			session->max_burst = 262144;
 		break;
 	default:
 		return 0;
-- 
1.6.4

