From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 22/44] qla2xxx: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
Date: Tue, 11 Oct 2016 13:28:53 +0200
Message-ID: <2a9d8b66d04227c63eab091089795ffc42e870f4.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 54 +++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9293d5a..109b852 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1,4 +1,4 @@
-/*
+	/*
  * QLogic Fibre Channel HBA Driver
  * Copyright (c)  2003-2014 QLogic Corporation
  *
@@ -122,7 +122,7 @@ qla24xx_fcp_prio_cfg_valid(scsi_qla_host_t *vha,
 static int
 qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 {
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
@@ -271,7 +271,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		ha = vha->hw;
 		type = "FC_BSG_RPT_ELS";
 	} else {
-		host = bsg_job->shost;
+		host = fc_bsg_to_shost(bsg_job);
 		vha = shost_priv(host);
 		ha = vha->hw;
 		type = "FC_BSG_HST_ELS_NOLOGIN";
@@ -432,7 +432,7 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 {
 	srb_t *sp;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = (DRIVER_ERROR << 16);
@@ -710,7 +710,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
@@ -950,7 +950,7 @@ static int
 qla84xx_reset(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -987,7 +987,7 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct verify_chip_entry_84xx *mn = NULL;
@@ -1099,7 +1099,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct access_chip_84xx *mn = NULL;
@@ -1297,7 +1297,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
 	struct qla_port_param *port_param = NULL;
@@ -1455,7 +1455,7 @@ static int
 qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1492,7 +1492,7 @@ static int
 qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1528,7 +1528,7 @@ static int
 qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1580,7 +1580,7 @@ static int
 qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1630,7 +1630,7 @@ static int
 qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1676,7 +1676,7 @@ static int
 qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1721,7 +1721,7 @@ static int
 qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1770,7 +1770,7 @@ static int
 qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t rval = EXT_STATUS_OK;
@@ -1949,7 +1949,7 @@ static int
 qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = (DRIVER_ERROR << 16);
@@ -2072,7 +2072,7 @@ static int
 qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
 	struct qla_serdes_reg sr;
@@ -2114,7 +2114,7 @@ static int
 qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
 	struct qla_serdes_reg_ex sr;
@@ -2156,7 +2156,7 @@ static int
 qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_flash_update_caps cap;
@@ -2188,7 +2188,7 @@ static int
 qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	uint64_t online_fw_attr = 0;
@@ -2234,7 +2234,7 @@ static int
 qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_bbcr_data bbcr;
@@ -2294,7 +2294,7 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
@@ -2354,7 +2354,7 @@ static int
 qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval;
 	struct qla_dport_diag *dd;
@@ -2489,7 +2489,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
-		host = bsg_job->shost;
+		host = fc_bsg_to_shost(bsg_job);
 		vha = shost_priv(host);
 	}
 
@@ -2528,7 +2528,7 @@ int
 qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	int cnt, que;
-- 
1.8.5.6
