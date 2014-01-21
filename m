From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] qla2xxx: fix error handling of qla2x00_mem_alloc()
Date: Tue, 21 Jan 2014 10:00:10 +0300
Message-ID: <20140121070010.GD31535@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

qla2x00_mem_alloc() returns 1 on success and -ENOMEM on failure.  On the
one hand the caller assumes non-zero is success but on the other hand
the caller also assumes that it returns an error code.

I've fixed it to return zero on success and a negative error code on
failure.  This matches the documentation as well.

Fixes: e315cd28b9ef ('[SCSI] qla2xxx: Code changes for qla data structure refactoring')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 89a53002b585..8d5a67fcffa1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2536,7 +2536,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    ha->flags.enable_64bit_addressing ? "enable" :
 	    "disable");
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
-	if (!ret) {
+	if (ret) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0031,
 		    "Failed to allocate memory for adapter, aborting.\n");
 
@@ -3481,7 +3481,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		    "loop_id_map=%p. \n", ha->loop_id_map);
 	}
 
-	return 1;
+	return 0;
 
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
