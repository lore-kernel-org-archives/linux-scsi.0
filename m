From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/18] qla2xxx: Allow the user the option of disabling iIDMA.
Date: Thu, 10 Jul 2008 16:55:52 -0700
Message-ID: <1215734163-40825-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414AbYGJX4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:12 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

iIDMA support requires the driver issue several additional
fabric-managegment (FM) commands per port discovered during SNS
scanning -- GFPN (Get Fabric Port Name) and GPSC (Get Port Speed
Capabilities).  It has been found during testing that some
switches do not respond as *well* as expected to these commands
(silence -- no ACC nor BS_RJT).  So, to handle such conditions,
allow the user the ability to indirectly disable the FM commands
by disabling iIDMA with the ql2xiidmaenable module-parameter.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1d57ddd..f921ccd 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -62,6 +62,7 @@ extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
+extern int ql2xiidmaenable;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 833a642..f4cd2cd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2559,7 +2559,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 		} else if (qla2x00_gnn_id(ha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
-		} else if (qla2x00_gfpn_id(ha, swl) == QLA_SUCCESS) {
+		} else if (ql2xiidmaenable &&
+		    qla2x00_gfpn_id(ha, swl) == QLA_SUCCESS) {
 			qla2x00_gpsc(ha, swl);
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e98d502..9c3a57f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -86,6 +86,13 @@ MODULE_PARM_DESC(ql2xqfullrampup,
 		"depth for a device after a queue-full condition has been "
 		"detected.  Default is 120 seconds.");
 
+int ql2xiidmaenable=1;
+module_param(ql2xiidmaenable, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xiidmaenable,
+		"Enables iIDMA settings "
+		"Default is 1 - perform iIDMA. 0 - no iIDMA.");
+
+
 /*
  * SCSI host template entry points
  */
-- 
1.5.6.2.292.ga9a3

