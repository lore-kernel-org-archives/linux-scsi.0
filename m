From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/11] qla2xxx: Correct issue where incorrect init-fw mailbox command was used on non-NPIV capable ISPs.
Date: Thu, 31 Jan 2008 12:33:53 -0800
Message-ID: <1201811634-19865-10-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760381AbYAaUeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:09 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

BIT_2 of the firmware attributes is only valid on FW-interface-2
type HBAs.  Code in commit
c48339decceec8e011498b0fc4c7c7d8b2ea06c1 would cause the
incorrect initialize-firmware mailbox command to be issued for
non-NPIV capable ISPs.  Correct this by reverting to previously
used (and correct) pre-condition 'if' check.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0c10c0b..99d29ff 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -980,7 +980,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    ha->host_no));
 
-	if (ha->fw_attributes & BIT_2)
+	if (ha->flags.npiv_supported)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
 	else
 		mcp->mb[0] = MBC_INITIALIZE_FIRMWARE;
-- 
1.5.4.rc5.5.gab98

