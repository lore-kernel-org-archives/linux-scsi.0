From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/10] qla2xxx: Return correct port_type to FC-transport for Vports.
Date: Mon, 12 May 2008 22:21:07 -0700
Message-ID: <1210656076-54720-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbYEMFVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:17 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

For Vports, the port_type should be set to FC_PORTTYPE_NPIV.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2876908..2caf841 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -886,9 +886,13 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_port_type(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
+	scsi_qla_host_t *ha = shost_priv(shost);
 	uint32_t port_type = FC_PORTTYPE_UNKNOWN;
 
+	if (ha->parent) {
+		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
+		return;
+	}
 	switch (ha->current_topology) {
 	case ISP_CFG_NL:
 		port_type = FC_PORTTYPE_LPORT;
-- 
1.5.5.1.211.g65ea3

