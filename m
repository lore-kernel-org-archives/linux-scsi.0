From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 7/9] libosd: Bugfix of error handling in attributes-list decoding
Date: Mon, 16 Nov 2009 20:47:47 +0200
Message-ID: <1258397267-300-1-git-send-email-bharrosh@panasas.com>
References: <4B019BEC.3080909@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35512 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753514AbZKPSwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 13:52:51 -0500
In-Reply-To: <4B019BEC.3080909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

When an error was detected in an attribute list do to
a target bug. We would print an error but spin endlessly
regardless. Fix it.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 5e90d19..ba25b1e 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1167,6 +1167,7 @@ int osd_req_decode_get_attr_list(struct osd_request *or,
 				"c=%d r=%d n=%d\n",
 				cur_bytes, returned_bytes, n);
 			oa->val_ptr = NULL;
+			cur_bytes = returned_bytes; /* break the caller loop */
 			break;
 		}
 
-- 
1.6.5.2

