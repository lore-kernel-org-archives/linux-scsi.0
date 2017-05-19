From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 02/25] qla2xxx: Remove redundant fc_host_port_name call
Date: Fri, 19 May 2017 14:53:21 -0700
Message-ID: <20170519215344.2168-3-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0054.outbound.protection.outlook.com ([104.47.33.54]:46912
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756703AbdESVx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:53:58 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Remove redundant fc_host_port_name calls to prevent
early access of scsi_host->shost_data buffer. This
prevent null pointer access.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a113ab3592a7..12fea77e31c6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3676,15 +3676,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				qlt_update_host_map(vha, id);
 			}
 
-			fc_host_port_name(vha->host) =
-			    wwn_to_u64(vha->port_name);
-
-			if (qla_ini_mode_enabled(vha))
-				ql_dbg(ql_dbg_mbx, vha, 0x1018,
-				    "FA-WWN portname %016llx (%x)\n",
-				    fc_host_port_name(vha->host),
-				    rptid_entry->vp_status);
-
 			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 		} else {
-- 
2.12.0
