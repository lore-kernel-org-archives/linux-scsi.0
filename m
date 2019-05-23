From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 1/2] zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove
Date: Thu, 23 May 2019 15:23:45 +0200
Message-ID: <1558617826-30129-2-git-send-email-maier@linux.ibm.com>
References: <1558617826-30129-1-git-send-email-maier@linux.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1558617826-30129-1-git-send-email-maier@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With this early return due to zfcp_unit child(ren), we don't use the
zfcp_port reference from the earlier zfcp_get_port_by_wwpn()any more
and need to put it.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: d99b601b6338 ("[SCSI] zfcp: restore refcount check on port_remove")
Cc: <stable@vger.kernel.org> #3.7+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index b277be6f7611..2d78732b270b 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -261,6 +261,7 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 	if (atomic_read(&port->units) > 0) {
 		retval = -EBUSY;
 		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
 		goto out;
 	}
 	/* port is about to be removed, so no more unit_add */
-- 
2.17.1
