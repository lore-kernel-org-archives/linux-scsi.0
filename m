From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qla4xxx: avoid freeing unallocated dma memory
Date: Fri, 22 Mar 2019 15:25:03 +0100
Message-ID: <20190322142530.904080-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Manish Rangankar <mrangankar@marvell.com>, Chengguang Xu <cgxu519@gmx.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Clang -Wuninitialized notices that on is_qla40XX we never allocate
any DMA memory in get_fw_boot_info() but attempt to free it anyway:

drivers/scsi/qla4xxx/ql4_os.c:5915:7: error: variable 'buf_dma' is used uninitialized whenever 'if' condition is false
      [-Werror,-Wsometimes-uninitialized]
                if (!(val & 0x07)) {
                    ^~~~~~~~~~~~~
drivers/scsi/qla4xxx/ql4_os.c:5985:47: note: uninitialized use occurs here
        dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
                                                     ^~~~~~~
drivers/scsi/qla4xxx/ql4_os.c:5915:3: note: remove the 'if' if its condition is always true
                if (!(val & 0x07)) {
                ^~~~~~~~~~~~~~~~~~~
drivers/scsi/qla4xxx/ql4_os.c:5885:20: note: initialize the variable 'buf_dma' to silence this warning
        dma_addr_t buf_dma;
                          ^
                           = 0

Skip the call to dma_free_coherent() here.

Fixes: 2a991c215978 ("[SCSI] qla4xxx: Boot from SAN support for open-iscsi")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 16a18d5d856f..daa884fa43f4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5928,7 +5928,7 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		val = rd_nvram_byte(ha, sec_addr);
 		if (val & BIT_7)
 			ddb_index[1] = (val & 0x7f);
-
+		goto exit_boot_info;
 	} else if (is_qla80XX(ha)) {
 		buf = dma_alloc_coherent(&ha->pdev->dev, size,
 					 &buf_dma, GFP_KERNEL);
-- 
2.20.0
