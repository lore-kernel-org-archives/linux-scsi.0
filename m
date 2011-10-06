From: Rob Evers <revers@redhat.com>
Subject: [PATCH] scsi_io_completion: soften unhandled error and sense messages
Date: Thu,  6 Oct 2011 18:08:51 -0400
Message-ID: <1317938931-6532-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935612Ab1JFWI6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2011 18:08:58 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p96M8w0W026124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 6 Oct 2011 18:08:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Rob Evers <revers@redhat.com>

We are receiving reports that users are seeing error messages during
fabric faults, but the systems are not malfunctioning.  I previously
submitted a patch which simply removed the offending messages but
James Bottomley rejected this as we were losing error information.

This patch softens the messages such that they don't appear to
be error indications from the user perspective.

new messages suggested by Mike Christie

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_lib.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..ef2a8a1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -920,12 +920,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
+			description =
+				"Extended sense description not available";
 			action = ACTION_FAIL;
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
+		description = "Extended error description not available";
 		action = ACTION_FAIL;
 	}
 
-- 
1.7.1

