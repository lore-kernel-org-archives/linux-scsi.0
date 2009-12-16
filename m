From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/5] qla2xxx: Get the link data rate explicitly during device resync.
Date: Tue, 15 Dec 2009 21:29:44 -0800
Message-ID: <1260941388-548-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57213 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751880AbZLPF3u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 00:29:50 -0500
In-Reply-To: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Michael Hernandez <michael.hernandez@qlogic.com>

From: Michael Hernandez <michael.hernandez@qlogic.com>

When the hba port gets logged out of the fabric, or other
such transitional state when the physical link is still present,
the driver doesn't receive a loop up asyn event (where the link
data rate currently gets set). Hence send a explicit mailbox command
to get the link rate in such conditions.
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0b6801f..f61fb8d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -324,6 +324,7 @@ qla2x00_read_ram_word(scsi_qla_host_t *, uint32_t, uint32_t *);
 extern int
 qla2x00_write_ram_word(scsi_qla_host_t *, uint32_t, uint32_t);
 
+extern int qla2x00_get_data_rate(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 73a7935..0f7ea6c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2266,6 +2266,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	clear_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 	clear_bit(RSCN_UPDATE, &vha->dpc_flags);
 
+	qla2x00_get_data_rate(vha);
+
 	/* Determine what we need to do */
 	if (ha->current_topology == ISP_CFG_FL &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 05d595d..e91f3d8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3643,3 +3643,36 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 
 	return rval;
 }
+
+int
+qla2x00_get_data_rate(scsi_qla_host_t *vha)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_DATA_RATE;
+	mcp->mb[1] = 0;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk(KERN_INFO "%s(%ld): failed=%x mb[0]=%x.\n",
+		    __func__, vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk(KERN_INFO
+		    "%s(%ld): done.\n", __func__, vha->host_no));
+		if (mcp->mb[1] != 0x7)
+			ha->link_data_rate = mcp->mb[1];
+	}
+
+	return rval;
+}
-- 
1.6.2.rc1.30.gd43c

