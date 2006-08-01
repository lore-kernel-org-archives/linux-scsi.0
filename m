From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/4] qla2xxx: Correct endianess problem while issuing a Marker IOCB on ISP24xx.
Date: Tue,  1 Aug 2006 13:48:13 -0700
Message-ID: <1154465296625-git-send-email-andrew.vasquez@qlogic.com>
References: <20060801204542.GR4154@jdlab1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26783 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750708AbWHAUtR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 16:49:17 -0400
In-Reply-To: <20060801204542.GR4154@jdlab1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 2b60a27..c5b3c61 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -471,6 +471,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, ui
 			mrk24->nport_handle = cpu_to_le16(loop_id);
 			mrk24->lun[1] = LSB(lun);
 			mrk24->lun[2] = MSB(lun);
+			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun = cpu_to_le16(lun);
-- 
1.4.2.rc2.gbc9e

