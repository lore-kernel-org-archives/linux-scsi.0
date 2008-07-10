From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 14/18] qla2xxx: Skip FDMI registration on ISP21xx/22xx parts.
Date: Thu, 10 Jul 2008 16:55:59 -0700
Message-ID: <1215734163-40825-14-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbYGJX4P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:15 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Firmware does not have the facilities to issue management server
IOCBs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 4cb80b4..c2a4bfb 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1661,6 +1661,12 @@ qla2x00_fdmi_register(scsi_qla_host_t *ha)
 {
 	int rval;
 
+	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
+		DEBUG2(printk("scsi(%ld): FDMI unsupported on "
+		    "ISP2100/ISP2200.\n", ha->host_no));
+		return QLA_SUCCESS;
+	}
+
 	rval = qla2x00_mgmt_svr_login(ha);
 	if (rval)
 		return rval;
-- 
1.5.6.2.292.ga9a3

