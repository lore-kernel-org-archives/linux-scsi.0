From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/9] qla2xxx: Correct endianess issue while interrogating MS status.
Date: Wed, 13 Dec 2006 19:20:26 -0800
Message-ID: <11660664332858-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbWLNDdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:45 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 97fbc62..f8bd33e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -127,8 +127,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
 		    ha->host_no, routine, ms_pkt->entry_status));
 	} else {
 		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
-			comp_status =
-			    ((struct ct_entry_24xx *)ms_pkt)->comp_status;
+			comp_status = le16_to_cpu(
+			    ((struct ct_entry_24xx *)ms_pkt)->comp_status);
 		else
 			comp_status = le16_to_cpu(ms_pkt->status);
 		switch (comp_status) {
-- 
1.4.4.2.g4cfec

