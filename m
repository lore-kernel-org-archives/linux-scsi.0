From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: Remove restriction on starting remote device discovery on port update.
Date: Fri, 8 Aug 2014 07:38:09 -0400
Message-ID: <1407497889-4814-3-git-send-email-chad.dupuis@qlogic.com>
References: <1407497889-4814-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:46434 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756187AbaHHMKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 08:10:22 -0400
In-Reply-To: <1407497889-4814-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de
Cc: giridhar.malavali@qlogic.com

Limiting which port update events will allow the driver to kick off a
name server scan has been problematic in some corner cases so remove the
restriction and restore the previous semantic. Also move the link
up/down informational messages to the LOOP_UP and LOOP_DOWN events.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index c72ee97b..41117b3 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -34,7 +34,7 @@
  * |                              |                    | 0x5047,0x5052  |
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
- * |                              |                    | 0x507b		|
+ * |                              |                    | 0x507b,0x505f	|
  * | Timer Routines               |       0x6012       |                |
  * | User Space Interactions      |       0x70e2       | 0x7018,0x702e  |
  * |				  |		       | 0x7020,0x7024  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 550a4a3..d89e3c4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -730,7 +730,7 @@ skip_rio:
 		else
 			ha->link_data_rate = mb[1];
 
-		ql_dbg(ql_dbg_async, vha, 0x500a,
+		ql_log(ql_log_info, vha, 0x500a,
 		    "LOOP UP detected (%s Gbps).\n",
 		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
 
@@ -743,7 +743,7 @@ skip_rio:
 			? RD_REG_WORD(&reg24->mailbox4) : 0;
 		mbx = (IS_P3P_TYPE(ha)) ? RD_REG_WORD(&reg82->mailbox_out[4])
 			: mbx;
-		ql_dbg(ql_dbg_async, vha, 0x500b,
+		ql_log(ql_log_info, vha, 0x500b,
 		    "LOOP DOWN detected (%x %x %x %x).\n",
 		    mb[1], mb[2], mb[3], mbx);
 
@@ -908,7 +908,8 @@ skip_rio:
 		 * it.  Otherwise ignore it and Wait for RSCN to come in.
 		 */
 		atomic_set(&vha->loop_down_timer, 0);
-		if (mb[1] != 0xffff || (mb[2] != 0x6 && mb[2] != 0x4)) {
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN &&
+		    atomic_read(&vha->loop_state) != LOOP_DEAD) {
 			ql_dbg(ql_dbg_async, vha, 0x5011,
 			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
 			    mb[1], mb[2], mb[3]);
@@ -920,9 +921,6 @@ skip_rio:
 		ql_dbg(ql_dbg_async, vha, 0x5012,
 		    "Port database changed %04x %04x %04x.\n",
 		    mb[1], mb[2], mb[3]);
-		ql_log(ql_log_warn, vha, 0x505f,
-		    "Link is operational (%s Gbps).\n",
-		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
 
 		/*
 		 * Mark all devices as missing so we will login again.
-- 
1.8.5.2

