From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/8] qla2xxx: Ignore payload reserved-bits during RSCN processing.
Date: Thu, 11 Sep 2008 21:22:53 -0700
Message-ID: <1221193374-77635-8-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYILEXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:23:01 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

As the driver is only interested in bits 0-9 of the 1st
RSCN-payload word:

	rsvd[15:14]RscnEventQualifier[13:10]Fmt[9:8]Domain[7:0]
	Area[15:8]Alpa[7:0]

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1b17161..e50752e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -589,7 +589,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    "scsi(%ld): RSCN database changed -- %04x %04x %04x.\n",
 		    ha->host_no, mb[1], mb[2], mb[3]));
 
-		rscn_entry = (mb[1] << 16) | mb[2];
+		rscn_entry = ((mb[1] & 0xff) << 16) | mb[2];
 		host_pid = (ha->d_id.b.domain << 16) | (ha->d_id.b.area << 8) |
 		    ha->d_id.b.al_pa;
 		if (rscn_entry == host_pid) {
@@ -600,6 +600,8 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 			break;
 		}
 
+		/* Ignore reserved bits from RSCN-payload. */
+		rscn_entry = ((mb[1] & 0x3ff) << 16) | mb[2];
 		rscn_queue_index = ha->rscn_in_ptr + 1;
 		if (rscn_queue_index == MAX_RSCN_COUNT)
 			rscn_queue_index = 0;
-- 
1.6.0.1.294.gda06a

