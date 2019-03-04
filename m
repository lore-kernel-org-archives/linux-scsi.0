From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/4] scsi: lpfc: fix 32-bit format string warning
Date: Mon,  4 Mar 2019 20:39:09 +0100
Message-ID: <20190304193917.702601-2-arnd@arndb.de>
References: <20190304193917.702601-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.de>, Colin Ian King <colin.king@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 32-bit architectures, we see a warning when %ld is used to
print a size_t:

In file included from drivers/scsi/lpfc/lpfc_init.c:62:
drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_new_io_buf':
drivers/scsi/lpfc/lpfc_logmsg.h:62:45: error: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Werror=format=]

This is harmless, but portable code should just use %zd to
avoid the warning.

Fixes: 0794d601d174 ("scsi: lpfc: Implement common IO buffers between NVME and SCSI")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3b5873f6751e..6e6bd1b3237d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4090,7 +4090,7 @@ lpfc_new_io_buf(struct lpfc_hba *phba, int num_to_alloc)
 	/* Sanity check to ensure our sizing is right for both SCSI and NVME */
 	if (sizeof(struct lpfc_io_buf) > LPFC_COMMON_IO_BUF_SZ) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-				"6426 Common buffer size %ld exceeds %d\n",
+				"6426 Common buffer size %zd exceeds %d\n",
 				sizeof(struct lpfc_io_buf),
 				LPFC_COMMON_IO_BUF_SZ);
 		return 0;
-- 
2.20.0
