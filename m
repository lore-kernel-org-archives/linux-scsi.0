From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: fix remoteport access
Date: Fri,  2 Nov 2018 16:35:48 +0100
Message-ID: <20181102153601.1599945-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Vasyl Gomonovych <gomonovych@gmail.com>, YueHaibing <yuehaibing@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The addition of a spinlock in lpfc_debugfs_nodelist_data() introduced
a bug that lets us not skip NULL pointers correctly, as noticed by
gcc-8:

drivers/scsi/lpfc/lpfc_debugfs.c: In function 'lpfc_debugfs_nodelist_data.constprop':
drivers/scsi/lpfc/lpfc_debugfs.c:728:13: error: 'nrport' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR)

This changes the logic back to what it was, while keeping the added
spinlock.

Fixes: 9e210178267b ("scsi: lpfc: Synchronize access to remoteport via rport")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 0c8005bb0f53..34d311a7dbef 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -698,6 +698,8 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
+		else
+			nrport = NULL;
 		spin_unlock(&phba->hbalock);
 		if (!nrport)
 			continue;
-- 
2.18.0
