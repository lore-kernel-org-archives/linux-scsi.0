From: madhu.iyengar@qlogic.com
Subject: [PATCH 06/18] qla2xxx: Free firmware PCB on logout request.
Date: Wed, 30 Mar 2011 11:46:21 -0700
Message-ID: <1301510793-2492-7-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45793 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755627Ab1C3SvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:14 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index fae75ca..db2e4b1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1883,7 +1883,8 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->handle = MAKE_HANDLE(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags =
-	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
+	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO|
+		LCF_FREE_NPORT);
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-- 
1.6.0.2

