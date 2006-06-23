From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/13] qla2xxx: Add DMI (Diagnostics Monitoring Interface) support.
Date: Fri, 23 Jun 2006 16:10:50 -0700
Message-ID: <11511042452367-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:16816 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752157AbWFWXKu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:10:50 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   53 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    6 ++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |   36 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |   23 +++++++++++++++++
 5 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 78eec67..1a766b2 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -338,6 +338,53 @@ static struct bin_attribute sysfs_vpd_at
 	.write = qla2x00_sysfs_write_vpd,
 };
 
+static ssize_t
+qla2x00_sysfs_read_sfp(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	uint16_t iter, addr, offset;
+	int rval;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != SFP_DEV_SIZE * 2)
+		return 0;
+
+	addr = 0xa0;
+	for (iter = 0, offset = 0; iter < (SFP_DEV_SIZE * 2) / SFP_BLOCK_SIZE;
+	    iter++, offset += SFP_BLOCK_SIZE) {
+		if (iter == 4) {
+			/* Skip to next device address. */
+			addr = 0xa2;
+			offset = 0;
+		}
+
+		rval = qla2x00_read_sfp(ha, ha->sfp_data_dma, addr, offset,
+		    SFP_BLOCK_SIZE);
+		if (rval != QLA_SUCCESS) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to read SFP data (%x/%x/%x).\n", rval,
+			    addr, offset);
+			count = 0;
+			break;
+		}
+		memcpy(buf, ha->sfp_data, SFP_BLOCK_SIZE);
+		buf += SFP_BLOCK_SIZE;
+	}
+
+	return count;
+}
+
+static struct bin_attribute sysfs_sfp_attr = {
+	.attr = {
+		.name = "sfp",
+		.mode = S_IRUSR | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = SFP_DEV_SIZE * 2,
+	.read = qla2x00_sysfs_read_sfp,
+};
+
 void
 qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
 {
@@ -349,6 +396,9 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t
 	sysfs_create_bin_file(&host->shost_gendev.kobj,
 	    &sysfs_optrom_ctl_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_vpd_attr);
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		sysfs_create_bin_file(&host->shost_gendev.kobj,
+		    &sysfs_sfp_attr);
 }
 
 void
@@ -362,6 +412,9 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t 
 	sysfs_remove_bin_file(&host->shost_gendev.kobj,
 	    &sysfs_optrom_ctl_attr);
 	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_vpd_attr);
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		sysfs_remove_bin_file(&host->shost_gendev.kobj,
+		    &sysfs_sfp_attr);
 
 	if (ha->beacon_blink_led == 1)
 		ha->isp_ops.beacon_off(ha);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index dfcd3a2..bb0b5f5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -610,6 +610,7 @@ #define MBC_GET_IOCB_STATUS		0x12	/* Get
 #define MBC_GET_TIMEOUT_PARAMS		0x22	/* Get FW timeouts. */
 #define MBC_TRACE_CONTROL		0x27	/* Trace control command. */
 #define MBC_GEN_SYSTEM_ERROR		0x2a	/* Generate System Error. */
+#define MBC_READ_SFP			0x31	/* Read SFP Data. */
 #define MBC_SET_TIMEOUT_PARAMS		0x32	/* Set FW timeouts. */
 #define MBC_MID_INITIALIZE_FIRMWARE	0x48	/* MID Initialize firmware. */
 #define MBC_MID_GET_VP_DATABASE		0x49	/* MID Get VP Database. */
@@ -2242,6 +2243,11 @@ #define P2P_LOOP  3
 	struct sns_cmd_pkt	*sns_cmd;
 	dma_addr_t		sns_cmd_dma;
 
+#define SFP_DEV_SIZE	256
+#define SFP_BLOCK_SIZE	64
+	void			*sfp_data;
+	dma_addr_t		sfp_data_dma;
+
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fec1e1c..4edb5d1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -210,6 +210,9 @@ qla2x00_stop_firmware(scsi_qla_host_t *)
 extern int
 qla2x00_trace_control(scsi_qla_host_t *, uint16_t, dma_addr_t, uint16_t);
 
+extern int
+qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3b16d6f..f5e226f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2503,4 +2503,40 @@ qla2x00_trace_control(scsi_qla_host_t *h
 	return rval;
 }
 
+int
+qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
+    uint16_t off, uint16_t count)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
 
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_READ_SFP;
+	mcp->mb[1] = addr;
+	mcp->mb[2] = MSW(sfp_dma);
+	mcp->mb[3] = LSW(sfp_dma);
+	mcp->mb[6] = MSW(MSD(sfp_dma));
+	mcp->mb[7] = LSW(MSD(sfp_dma));
+	mcp->mb[8] = count;
+	mcp->mb[9] = off;
+	mcp->mb[10] = 0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c16154c..da84ee2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1979,6 +1979,26 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 				continue;
 			}
 			memset(ha->ct_sns, 0, sizeof(struct ct_sns_pkt));
+
+			if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+				/*
+				 * Get consistent memory allocated for SFP
+				 * block.
+				 */
+				ha->sfp_data = dma_pool_alloc(ha->s_dma_pool,
+				    GFP_KERNEL, &ha->sfp_data_dma);
+				if (ha->sfp_data == NULL) {
+					qla_printk(KERN_WARNING, ha,
+					    "Memory Allocation failed - "
+					    "sfp_data\n");
+
+					qla2x00_mem_free(ha);
+					msleep(100);
+
+					continue;
+				}
+				memset(ha->sfp_data, 0, SFP_BLOCK_SIZE);
+			}
 		}
 
 		/* Done all allocations without any error. */
@@ -2034,6 +2054,9 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
 		    ha->ct_sns, ha->ct_sns_dma);
 
+	if (ha->sfp_data)
+		dma_pool_free(ha->s_dma_pool, ha->sfp_data, ha->sfp_data_dma);
+
 	if (ha->ms_iocb)
 		dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 
-- 
1.4.1.rc1.gf603


