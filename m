From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/15] qla2xxx: Add an override option to specify ISP firmware load semantics.
Date: Mon,  6 Apr 2009 22:33:49 -0700
Message-ID: <1239082431-19496-14-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZDGFeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:01 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

As it may be useful during debugging to use a specific firmware
image.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    6 ++++++
 drivers/scsi/qla2xxx/qla_os.c   |   10 ++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5347e35..f17d525 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -69,6 +69,7 @@ extern int ql2xqfulltracking;
 extern int ql2xiidmaenable;
 extern int ql2xmaxqueues;
 extern int ql2xmultique_tag;
+extern int ql2xfwloadbin;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 138ae88..4952fc1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4111,6 +4111,9 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int rval;
 
+	if (ql2xfwloadbin == 1)
+		return qla81xx_load_risc(vha, srisc_addr);
+
 	/*
 	 * FW Load priority:
 	 * 1) Firmware via request-firmware interface (.bin file).
@@ -4128,6 +4131,9 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int rval;
 
+	if (ql2xfwloadbin == 2)
+		return qla24xx_load_risc(vha, srisc_addr);
+
 	/*
 	 * FW Load priority:
 	 * 1) Firmware residing in flash.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6ffd518..eecb76e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -111,6 +111,16 @@ MODULE_PARM_DESC(ql2xmultique_tag,
 		"Enables CPU affinity settings for the driver "
 		"Default is 0 for no affinity of request and response IO. "
 		"Set it to 1 to turn on the cpu affinity.");
+
+int ql2xfwloadbin;
+module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xfwloadbin,
+		"Option to specify location from which to load ISP firmware:\n"
+		" 2 -- load firmware via the request_firmware() (hotplug)\n"
+		"      interface.\n"
+		" 1 -- load firmware from flash.\n"
+		" 0 -- use default semantics.\n");
+
 /*
  * SCSI host template entry points
  */
-- 
1.6.2.2.404.ge96f3

