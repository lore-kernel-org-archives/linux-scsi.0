From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/4] scsi: qla2xxx: avoid printf format warning
Date: Mon,  4 Mar 2019 20:39:10 +0100
Message-ID: <20190304193917.702601-3-arnd@arndb.de>
References: <20190304193917.702601-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <qtran@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Depending on the target architecture and configuration, both phys_addr_t
and dma_addr_t may be smaller than 'long long', so we get a warning when
printing either of them using the %llx format string:

drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla24xx_walk_and_build_prot_sglist':
drivers/scsi/qla2xxx/qla_iocb.c:1140:46: error: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' {aka 'unsigned int'} [-Werror=format=]
         "%s: page boundary crossing (phys=%llx len=%x)\n",
                                           ~~~^
                                           %x
         __func__, sle_phys, sg->length);
                   ~~~~~~~~
drivers/scsi/qla2xxx/qla_iocb.c:1180:29: error: format '%llx' expects argument of type 'long long unsigned int', but argument 7 has type 'dma_addr_t' {aka 'unsigned int'} [-Werror=format=]
        "%s: sg[%x] (phys=%llx sglen=%x) ldma_sg_len: %x dif_bundl_len: %x ldma_needed: %x\n",
                          ~~~^

There are special %pad and %pap format strings in Linux that we could use here,
but since the driver already does 64-bit arithmetic on the values, using a
plain 'u64' seems more consistent here.

Note: A possible related issue may be that the driver possibly checks the
wrong kind of overflow: when an IOMMU is in use, buffers that cross a 32-bit
boundary in physical addresses would still be mapped into dma addresses
within the low 4GB space, so I suspect that we actually want to check
sg_dma_address() instead of sg_phys() here.

Fixes: 50b812755e97 ("scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 63f8e3c19841..456a41d2e2c6 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1132,7 +1132,7 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 	/* if initiator doing write or target doing read */
 	if (direction_to_device) {
 		for_each_sg(sgl, sg, tot_dsds, i) {
-			dma_addr_t sle_phys = sg_phys(sg);
+			u64 sle_phys = sg_phys(sg);
 
 			/* If SGE addr + len flips bits in upper 32-bits */
 			if (MSD(sle_phys + sg->length) ^ MSD(sle_phys)) {
@@ -1178,7 +1178,7 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 
 			ql_dbg(ql_dbg_tgt + ql_dbg_verbose, vha, 0xe023,
 			    "%s: sg[%x] (phys=%llx sglen=%x) ldma_sg_len: %x dif_bundl_len: %x ldma_needed: %x\n",
-			    __func__, i, sg_phys(sg), sglen, ldma_sg_len,
+			    __func__, i, (u64)sg_phys(sg), sglen, ldma_sg_len,
 			    difctx->dif_bundl_len, ldma_needed);
 
 			while (sglen) {
-- 
2.20.0
