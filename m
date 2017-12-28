From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 28/37] qla2xxx: Allow relogin and session creation after reset
Date: Thu, 28 Dec 2017 12:33:36 -0800
Message-ID: <20171228203345.2702-29-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0043.outbound.protection.outlook.com ([104.47.41.43]:4111
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754128AbdL1UeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:23 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
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
index 61534b9bef7b..e9513ec344b1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1132,7 +1132,6 @@ static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		ql_dbg(ql_dbg_disc, vha, 0x20bf,
 		    "%s %d %8phC post login\n",
 		    __func__, __LINE__, fcport->port_name);
-		fcport->disc_state = DSC_LOGIN_PEND;
 		qla2x00_post_async_login_work(vha, fcport, NULL);
 	}
 }
-- 
2.12.0
