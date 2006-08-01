From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/4] qla2xxx: Fix to allow to reset devices using sg interface (sg_reset).
Date: Tue,  1 Aug 2006 13:48:15 -0700
Message-ID: <11544652964142-git-send-email-andrew.vasquez@qlogic.com>
References: <20060801204542.GR4154@jdlab1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35231 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750723AbWHAUtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 16:49:19 -0400
In-Reply-To: <20060801204542.GR4154@jdlab1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Vladislav Bolkhovitin <vst@vlnb.net>

From: Vladislav Bolkhovitin <vst@vlnb.net>

Currently it is impossible to reset provided by Qlogic QLA2xxx driver
SCSI devices externally using corresponding sg devices, particularly via
sg_reset utility, because qla2xxx driver in qla2xxx_eh_device_reset()
function checks if the input scsi_cmnd has its private data (CMD_SP())
attached. Then the found pointer isn't used anywhere inside of
qla2xxx_eh_device_reset(). If the RESET request comes from sg device, it
doesn't have such private data.

The attached patch removes check for non-NULL CMD_SP() from
qla2xxx_eh_device_reset(), hence allows to reset QLA2xxx's devices using
corresponding sg devices.

AV: change applies to bus/host reset handlers as well.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ec7ebb6..1e2b95b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -744,7 +744,6 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
 	unsigned long serial;
@@ -755,8 +754,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
 
-	sp = (srb_t *) CMD_SP(cmd);
-	if (!sp || !fcport)
+	if (!fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -875,7 +873,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
 	unsigned long serial;
@@ -886,8 +883,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
 
-	sp = (srb_t *) CMD_SP(cmd);
-	if (!sp || !fcport)
+	if (!fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -936,7 +932,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
 	unsigned long serial;
@@ -947,8 +942,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
 
-	sp = (srb_t *) CMD_SP(cmd);
-	if (!sp || !fcport)
+	if (!fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
-- 
1.4.2.rc2.gbc9e

