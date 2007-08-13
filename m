From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/6] qla2xxx: Don't modify parity bits during ISP25XX restart.
Date: Sun, 12 Aug 2007 18:22:53 -0700
Message-ID: <1186968177814-git-send-email-andrew.vasquez@qlogic.com>
References: <20070813012218.GD1067@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31584 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765795AbXHMBXV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 21:23:21 -0400
In-Reply-To: <20070813012218.GD1067@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 374abe1..8da0586 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3354,7 +3354,8 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)) {
+			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha) &&
+			    !IS_QLA25XX(ha)) {
 				/*
 				 * Disable SRAM, Instruction RAM and GP RAM
 				 * parity.
@@ -3370,7 +3371,8 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)) {
+			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha) &&
+			    !IS_QLA25XX(ha)) {
 				/* Enable proper parity */
 				if (IS_QLA2300(ha))
 					/* SRAM parity */
-- 
1.5.3.rc4.41.g7efe

