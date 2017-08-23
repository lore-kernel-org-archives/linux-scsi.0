From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: avoid false-positive gcc-8 warning
Date: Wed, 23 Aug 2017 17:01:33 +0200
Message-ID: <20170823150143.2746796-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an interesting regression with gcc-8, showing a harmless
warning for correct code:

In file included from include/linux/kernel.h:13:0,
                 ...
                 from drivers/scsi/lpfc/lpfc_debugfs.c:23:
include/linux/printk.h:301:2: error: 'eq' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~
In file included from drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was declared here

I tried to come up with a reduced test case for gcc here
a few times, but every time ended up with code that is actually
wrong with older gcc versions missing the bug and gcc-8 finding
it. As this is the only false-positive -Wmaybe-uninitialized
warnign I got with gcc-8 randconfig builds, I'd suggest we
work around it.

Making the index variable 'unsigned' is enough to shut up
the warning, as gcc can then see that comparing eqidx to
phba->io_channel_irqs is fine here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 7b7d314af0e0..7b7f53a37fd8 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -450,7 +450,7 @@ lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 {
 	struct lpfc_queue *wq, *cq, *eq;
 	char *qtypestr;
-	int eqidx;
+	unsigned int eqidx;
 
 	/* fcp/nvme wq and cq are 1:1, thus same indexes */
 
-- 
2.9.0
