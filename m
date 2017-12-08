From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] qla2xxx: Suppress gcc 7 fall-through warnings
Date: Thu,  7 Dec 2017 16:02:46 -0800
Message-ID: <20171208000246.19617-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:15671 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdLHACr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 19:02:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.com>

Avoid that building with gcc 7 and W=1 triggers warnings similar
to the following:

drivers/scsi/qla2xxx/qla_isr.c:1189:27: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_gs.c     | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c    | 5 +++--
 drivers/scsi/qla2xxx/qla_sup.c    | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7d715e58901f..07fe17a986b0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -177,7 +177,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			break;
 		case CS_TIMEOUT:
 			rval = QLA_FUNCTION_TIMEOUT;
-			/* drop through */
+			/* fall through */
 		default:
 			ql_dbg(ql_dbg_disc, vha, 0x2033,
 			    "%s failed, completion status (%x) on port_id: "
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 85382387a52b..a55bfaa790a3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1202,6 +1202,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 				qla2xxx_wake_dpc(vha);
 			}
 		}
+		/* fall through */
 	case MBA_IDC_COMPLETE:
 		if (ha->notify_lb_portup_comp && !vha->vp_idx)
 			complete(&ha->lb_portup_comp);
@@ -1769,7 +1770,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		}
-		/* drop through */
+		/* fall through */
 	default:
 		data[0] = MBS_COMMAND_ERROR;
 		break;
@@ -2967,9 +2968,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				    (response_t *)pkt);
 				break;
 			} else {
-				/* drop through */
 				qlt_24xx_process_atio_queue(vha, 1);
 			}
+			/* fall through */
 		case ABTS_RESP_24XX:
 		case CTIO_TYPE7:
 		case CTIO_CRC2:
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b4336e0cd85f..d2db86ea06b2 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2461,6 +2461,7 @@ qla2x00_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 				sec_mask = 0x1e000;
 				break;
 			}
+			/* fall through */
 		default:
 			/* Default to 16 kb sector size. */
 			rest_addr = 0x3fff;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a23107b1ec06..067bcc57a9ad 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -450,6 +450,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha,
 		ql_dbg(ql_dbg_tgt, vha, 0xe073,
 			"qla_target(%d):%s: CRC2 Response pkt\n",
 			vha->vp_idx, __func__);
+		/* fall through */
 	case CTIO_TYPE7:
 	{
 		struct ctio7_from_24xx *entry = (struct ctio7_from_24xx *)pkt;
@@ -4889,7 +4890,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			res = 1;
 			break;
 		}
-		/* drop through */
+		/* fall through */
 	case ELS_LOGO:
 	case ELS_PRLO:
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-- 
2.15.0
