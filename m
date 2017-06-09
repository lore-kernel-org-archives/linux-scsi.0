From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qla2xxx: fix printk format string warning on 32-bit
Date: Fri,  9 Jun 2017 12:46:54 +0200
Message-ID: <20170609104711.3471894-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <quinn.tran@cavium.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 32-bit architectures, we using %lx to print a size_t causes a harmless
warning:

qla2xxx/qla_init.c: In function 'qla24xx_load_risc_flash':
qla2xxx/qla_init.c:6407:7: error: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Werror=format=]
qla2xxx/qla_init.c: In function 'qla24xx_load_risc_blob':
qla2xxx/qla_init.c:6709:7: error: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Werror=format=]

The correct format string is %zx.

Fixes: 0f110b54d157 ("scsi: qla2xxx: Retain loop test for fwdump length exceeding buffer length")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 436968ad4484..730e7fe4344a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6404,7 +6404,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*dcode)) {
 		ql_log(ql_log_warn, vha, 0x0167,
-		    "Failed fwdump template exceeds array by %lx bytes\n",
+		    "Failed fwdump template exceeds array by %zx bytes\n",
 		    (size_t)(dlen - risc_size * sizeof(*dcode)));
 		goto default_template;
 	}
@@ -6706,7 +6706,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*fwcode)) {
 		ql_log(ql_log_warn, vha, 0x0177,
-		    "Failed fwdump template exceeds array by %lx bytes\n",
+		    "Failed fwdump template exceeds array by %zx bytes\n",
 		    (size_t)(dlen - risc_size * sizeof(*fwcode)));
 		goto default_template;
 	}
-- 
2.9.0
