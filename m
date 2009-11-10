From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH1/2 version2] libosd: bug in osd_req_decode_sense_full()
Date: Tue, 10 Nov 2009 17:10:19 +0200
Message-ID: <4AF9825B.1030808@panasas.com>
References: <4AF6B946.8000106@panasas.com> <4AF6B9B1.5040002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:50576 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbZKJPKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 10:10:15 -0500
In-Reply-To: <4AF6B9B1.5040002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>


The (never tested) osd_sense_attribute_identification case
has never worked. The loop was never advanced on.
Fix it to work as intended.

On 10/30/2009 04:39 PM, Roel Kluin wrote:
  I found this by code analysis, searching for while
  loops that test a local variable, but do not modify
  the variable.

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 60b7ca1..5e90d19 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1583,15 +1583,14 @@ int osd_req_decode_sense_full(struct osd_request *or,
 		{
 			struct osd_sense_attributes_data_descriptor
 				*osadd = cur_descriptor;
-			int len = min(cur_len, sense_len);
-			int i = 0;
+			unsigned len = min(cur_len, sense_len);
 			struct osd_sense_attr *pattr = osadd->sense_attrs;
 
-			while (len < 0) {
+			while (len >= sizeof(*pattr)) {
 				u32 attr_page = be32_to_cpu(pattr->attr_page);
 				u32 attr_id = be32_to_cpu(pattr->attr_id);
 
-				if (i++ == 0) {
+				if (!osi->attr.attr_page) {
 					osi->attr.attr_page = attr_page;
 					osi->attr.attr_id = attr_id;
 				}
@@ -1602,6 +1601,8 @@ int osd_req_decode_sense_full(struct osd_request *or,
 					bad_attr_list++;
 					max_attr--;
 				}
+
+				len -= sizeof(*pattr);
 				OSD_SENSE_PRINT2(
 					"osd_sense_attribute_identification"
 					"attr_page=0x%x attr_id=0x%x\n",
-- 
1.6.5.1


