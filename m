From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: qla4xxx: Don't call dma_free_coherent without dma_alloc_coherent
Date: Thu,  7 Mar 2019 11:41:25 -0700
Message-ID: <20190307184125.21419-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

When building with -Wsometimes-uninitialized, Clang warns:

drivers/scsi/qla4xxx/ql4_os.c:5915:7: warning: variable 'buf_dma' is
used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

buf_dma is initialized by dma_alloc_coherent, which is only called in
the middle conditional statement. Use that same conditional to call
dma_free_coherent so that buf_dma is always initialized when used.

Fixes: 2a991c215978 ("[SCSI] qla4xxx: Boot from SAN support for open-iscsi")
Link: https://github.com/ClangBuiltLinux/linux/issues/391
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 16a18d5d856f..88bb52456efd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5982,7 +5982,8 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 			  ddb_index[1]));
 
 exit_boot_info_free:
-	dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
+	if (is_qla80XX(ha))
+		dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
 exit_boot_info:
 	ha->pri_ddb_idx = ddb_index[0];
 	ha->sec_ddb_idx = ddb_index[1];
-- 
2.21.0
