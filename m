From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 14/22] qla2xxx: Add logic to abort BSG commands for ISPFX00.
Date: Wed, 30 Oct 2013 03:38:21 -0400
Message-ID: <1383118709-5569-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:21035 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752394Ab3J3ILW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:22 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   11 ++++++++++-
 drivers/scsi/qla2xxx/qla_mr.h |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 3ac835e..b396c3b 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1885,6 +1885,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			goto done_free_sp;
 		}
 		break;
+	case FXDISC_ABORT_IOCTL:
 	default:
 		break;
 	}
@@ -2013,7 +2014,11 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0146,
 		    (uint8_t *)pinfo, 16);
 		memcpy(vha->hw->gid_list, pinfo, QLAFX00_TGT_NODE_LIST_SIZE);
-	}
+	} else if (fx_type == FXDISC_ABORT_IOCTL)
+		fdisc->u.fxiocb.result =
+		    (fdisc->u.fxiocb.result == cpu_to_le32(0x68)) ?
+		    cpu_to_le32(QLA_SUCCESS) : cpu_to_le32(QLA_FUNCTION_FAILED);
+
 	rval = le32_to_cpu(fdisc->u.fxiocb.result);
 
 done_unmap_dma:
@@ -2112,6 +2117,10 @@ qlafx00_abort_command(srb_t *sp)
 		/* Command not found. */
 		return QLA_FUNCTION_FAILED;
 	}
+	if (sp->type == SRB_FXIOCB_DCMD)
+		return qlafx00_fx_disc(vha, &vha->hw->mr.fcport,
+		    FXDISC_ABORT_IOCTL);
+
 	return qlafx00_async_abt_cmd(sp);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index a5ddea6..c8b8acd 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -343,6 +343,7 @@ struct config_info_data {
 #define FXDISC_GET_TGT_NODE_INFO	0x80
 #define FXDISC_GET_TGT_NODE_LIST	0x81
 #define FXDISC_REG_HOST_INFO		0x99
+#define FXDISC_ABORT_IOCTL		0xff
 
 #define QLAFX00_HBA_ICNTRL_REG		0x20B08
 #define QLAFX00_ICR_ENB_MASK            0x80000000
-- 
1.7.7

