From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 32/43] qla2xxx: Allow relogin and session creation after reset
Date: Tue, 19 Dec 2017 22:56:33 -0800
Message-ID: <20171220065644.21511-33-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:62688
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932380AbdLTG51 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:27 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

When any kind of reset is issued, current code was setting
state of LOGIN pending too early. This resulted into driver
not retrying relogin until pervious reloin completes.

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ac3f82340315..80e9d80cce2b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1134,7 +1134,6 @@ static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		ql_dbg(ql_dbg_disc, vha, 0x20bf,
 		    "%s %d %8phC post login\n",
 		    __func__, __LINE__, fcport->port_name);
-		fcport->disc_state = DSC_LOGIN_PEND;
 		qla2x00_post_async_login_work(vha, fcport, NULL);
 	}
 }
-- 
2.12.0
