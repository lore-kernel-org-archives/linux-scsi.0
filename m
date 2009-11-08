From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] libosd: Bugfix of error handling in attributes-list decoding
Date: Sun, 08 Nov 2009 14:30:40 +0200
Message-ID: <4AF6B9F0.9020803@panasas.com>
References: <4AF6B946.8000106@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:1790 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753946AbZKHMag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 07:30:36 -0500
In-Reply-To: <4AF6B946.8000106@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>


When an error was detected in an attribute list, do to
a target bug. We would print an error but spin endlessly
regardless. Fix it.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d504e82..26d8dc0 100644
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
1.6.5.1

