From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/10] qla2xxx: Re-register FDMI information after a LIP.
Date: Thu, 24 Apr 2008 15:21:26 -0700
Message-ID: <1209075691-6539-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbYDXWVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:36 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code would (incorrectly) only re-register after a
loop-down condition.  Also, FDMI registration should be enabled
by default.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 285479b..5d9a64a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -409,6 +409,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		}
 
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
+		set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 
 		ha->flags.management_server_logged_in = 0;
 		qla2x00_post_aen_work(ha, FCH_EVT_LIP, mb[1]);
@@ -454,8 +455,6 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		ha->flags.management_server_logged_in = 0;
 		ha->link_data_rate = PORT_SPEED_UNKNOWN;
-		if (ql2xfdmienable)
-			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 		qla2x00_post_aen_work(ha, FCH_EVT_LINKDOWN, 0);
 		break;
 
@@ -511,6 +510,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 			set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		}
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
+		set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 
 		ha->flags.gpsc_supported = 1;
 		ha->flags.management_server_logged_in = 0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 978d8bd..a7c20f8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -67,7 +67,7 @@ static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
 
-int ql2xfdmienable;
+int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registratons "
-- 
1.5.5.1.67.gbdb8

