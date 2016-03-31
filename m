From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 2/3] qla2xxx: Remove set-but-not-used variables
Date: Thu, 31 Mar 2016 09:29:59 -0700
Message-ID: <56FD5087.2000904@sandisk.com>
References: <56FD5046.7000509@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0074.outbound.protection.outlook.com ([65.55.169.74]:26688
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753043AbcCaQaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 12:30:05 -0400
In-Reply-To: <56FD5046.7000509@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Detected these variables by building the qla2xxx driver with W=1.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 +--
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4dc06a13..db85c5c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -839,7 +839,6 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	int type;
-	int rval = 0;
 	port_id_t did;
 
 	type = simple_strtol(buf, NULL, 10);
@@ -853,7 +852,7 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 
 	ql_log(ql_log_info, vha, 0x70e4, "%s: %d\n", __func__, type);
 
-	rval = qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
+	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
 	return count;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 968b846..bf2d357 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -607,7 +607,6 @@ qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha, dma_addr_t phys_addr)
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
-	int configured_count;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x111a,
 	    "Entered %s.\n", __func__);
@@ -630,7 +629,6 @@ qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha, dma_addr_t phys_addr)
 		/*EMPTY*/
 		ql_dbg(ql_dbg_mbx, vha, 0x111b, "Failed=%x.\n", rval);
 	} else {
-		configured_count = mcp->mb[11];
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x118c,
 		    "Done %s.\n", __func__);
 	}
-- 
2.7.4

