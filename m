From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/17] qla2xxx: Correct maximum supported lun and target-id definitions.
Date: Wed,  6 Jul 2005 10:32:37 -0700 (PDT)
Message-ID: <20050706173237.10568.9917.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:27479 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262440AbVGFRci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:32:38 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Correct maximum supported lun and target-id definitions.

The driver uses command-IOCBs which support a maximum lun
value of 0xffff -- correct #define to reflect the change.
Also, remove superfluous MAX_TARGET definition.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_def.h  |    3 +--
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

900dd480ecb76a28cf910f53d1757264b6911c0b
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -181,7 +181,7 @@
  */
 #define WWN_SIZE		8	/* Size of WWPN, WWN & WWNN */
 #define MAX_FIBRE_DEVICES	512
-#define MAX_FIBRE_LUNS  	256
+#define MAX_FIBRE_LUNS  	0xFFFF
 #define	MAX_RSCN_COUNT		32
 #define	MAX_HOST_COUNT		16
 
@@ -191,7 +191,6 @@
 #define MAX_BUSES		1  /* We only have one bus today */
 #define MAX_TARGETS_2100	MAX_FIBRE_DEVICES
 #define MAX_TARGETS_2200	MAX_FIBRE_DEVICES
-#define MAX_TARGETS		MAX_FIBRE_DEVICES
 #define MIN_LUNS		8
 #define MAX_LUNS		MAX_FIBRE_LUNS
 #define MAX_CMDS_PER_LUN	255
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2094,7 +2094,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocate fc remote port!\n");
 
-	if (rport->scsi_target_id != -1 && rport->scsi_target_id < MAX_TARGETS)
+	if (rport->scsi_target_id != -1 &&
+	    rport->scsi_target_id < ha->host->max_id)
 		fcport->os_target_id = rport->scsi_target_id;
 
 	rport->dd_data = fcport;

-- 
Andrew Vasquez
