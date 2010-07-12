From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 13/20] be2iscsi: Limit max_xmit_length
Date: Mon, 12 Jul 2010 23:26:16 +0530
Message-ID: <20100712175604.GA11699@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:33535 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756395Ab0GLR4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:56:12 -0400
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
index e1505fa..2a924db 100644
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

