From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/6] qla2xxx: Correct management-server login-state synchronization issue.
Date: Sun, 12 Aug 2007 18:22:54 -0700
Message-ID: <11869681773913-git-send-email-andrew.vasquez@qlogic.com>
References: <20070813012218.GD1067@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31584 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbXHMBXV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 21:23:21 -0400
In-Reply-To: <20070813012218.GD1067@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Transitioning link-state via NOS/OLS requires a relogin to a
fabric's Management Server.  Request relogin when the firmware
issues a point-to-point asynchronous event (0x8030).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 50539da..eecae99 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -490,6 +490,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
 
 		ha->flags.gpsc_supported = 1;
+		ha->flags.management_server_logged_in = 0;
 		break;
 
 	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode */
-- 
1.5.3.rc4.41.g7efe

