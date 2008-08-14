From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/8] qla2xxx: Set npiv_supported flag for FCoE HBAs.
Date: Wed, 13 Aug 2008 21:36:59 -0700
Message-ID: <1218688622-71361-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:58064 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHNEhJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:09 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Mike Hernandez <mike.hernandez@qlogic.com>

From: Mike Hernandez <mike.hernandez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e1de7a6..ee89ddd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -976,8 +976,9 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_attributes, &ha->fw_memory_size);
 				qla2x00_resize_request_q(ha);
 				ha->flags.npiv_supported = 0;
-				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha)) &&
-				    (ha->fw_attributes & BIT_2)) {
+				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha) ||
+				     IS_QLA84XX(ha)) &&
+					 (ha->fw_attributes & BIT_2)) {
 					ha->flags.npiv_supported = 1;
 					if ((!ha->max_npiv_vports) ||
 					    ((ha->max_npiv_vports + 1) %
-- 
1.6.0.rc2.22.g71b9

