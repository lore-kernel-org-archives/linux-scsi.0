From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] advansys: fix build warning for PCI=n
Date: Mon, 24 Oct 2016 17:51:55 +0200
Message-ID: <20161024155207.3027347-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The advansys probe function tries to handle both ISA and PCI cases,
each hidden in an #ifdef when unused. This leads to a warning
indicating that when PCI is disabled we could be using uninitialized
data:

drivers/scsi/advansys.c: In function ‘advansys_board_found’:
drivers/scsi/advansys.c:11036:5: error: ‘ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/advansys.c:10928:28: note: ‘ret’ was declared here
drivers/scsi/advansys.c:11309:8: error: ‘share_irq’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/advansys.c:10928:6: note: ‘share_irq’ was declared here

This cannot happen in practice because the hardware in question
only exists for PCI, but changing the code to just error out
here is better for consistency and avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/advansys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index febbd83e2ecd..81dd0927246b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11030,6 +11030,9 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		ASC_DBG(2, "AdvInitGetConfig()\n");
 
 		ret = AdvInitGetConfig(pdev, shost) ? -ENODEV : 0;
+#else
+		share_irq = 0;
+		ret = -ENODEV;
 #endif /* CONFIG_PCI */
 	}
 
-- 
2.9.0
