From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 11/19]  be2iscsi: Limit max_xmit_length
Date: Thu, 22 Jul 2010 04:26:45 +0530
Message-ID: <20100721225634.GA9582@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:25325 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758985Ab0GUW4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:56:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch limits max_xmit_length to 64K incase older
utilities are used

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index de79b7c..a131a57 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -277,6 +277,10 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		if (session->max_burst > 262144)
 			session->max_burst = 262144;
 		break;
+	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		if ((conn->max_xmit_dlength > 65536) ||
+		    (conn->max_xmit_dlength == 0))
+			conn->max_xmit_dlength = 65536;
 	default:
 		return 0;
 	}
-- 
1.6.5.2

