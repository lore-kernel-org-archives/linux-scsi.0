From: andrew.vasquez@qlogic.com
Subject: [PATCH 2/4] qla2xxx: Correct lun assignment during IOCB submission.
Date: Tue, 7 Feb 2006 08:45:35 -0800
Message-ID: <11393307301725-git-send-email-andrew.vasquez@qlogic.com>
References: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51850 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750792AbWBGQpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 11:45:35 -0500
In-Reply-To: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

4gb products require an IOCB's FCP-LUN to be formatted in
wire-format prior to submission.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_iocb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

a5930f606b8637134a62d1217424c82ca67df60f
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7ec0b8d..6544b6d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -814,6 +814,7 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
 
 	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
-- 
1.1.6.ga2c6


