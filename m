From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] zfcp: bugfix and compile fixes
Date: Sun, 28 Aug 2005 01:33:23 +0200
Message-ID: <20050827233323.GA11194@osiris.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:34251 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750779AbVH0Xdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 19:33:36 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7RNXZd7134230
	for <linux-scsi@vger.kernel.org>; Sat, 27 Aug 2005 23:33:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7RNXZJl092964
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2005 01:33:35 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7RNXYPE027396
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2005 01:33:35 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org
Cc: Andreas Herrmann <aherrman@de.ibm.com>, Andrew Morton <akpm@osdl.org>

Hi James,

unfortunately the last zfcp patch introduces a bug and the driver doesn't
compile anymore in addition. If possible the patch below should go into 2.6.13.

Thanks,
Heiko

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Bugfix (usage of uninitialized pointer in zfcp_port_dequeue) and compile fixes
for the zfcp device driver.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

diffstat:
 drivers/s390/scsi/zfcp_aux.c        |    5 ++---
 drivers/s390/scsi/zfcp_ccw.c        |    2 +-
 drivers/s390/scsi/zfcp_sysfs_port.c |    2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -1403,15 +1403,14 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 void
 zfcp_port_dequeue(struct zfcp_port *port)
 {
-	struct fc_port *rport;
-
 	zfcp_port_wait(port);
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&port->list);
 	port->adapter->ports--;
 	write_unlock_irq(&zfcp_data.config_lock);
 	if (port->rport)
-		fc_remote_port_delete(rport);
+		fc_remote_port_delete(port->rport);
+	port->rport = NULL;
 	zfcp_adapter_put(port->adapter);
 	zfcp_sysfs_port_remove_files(&port->sysfs_device,
 				     atomic_read(&port->status));
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -203,7 +203,7 @@ zfcp_ccw_set_offline(struct ccw_device *
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
-	struct fc_port *rport;
+	struct fc_rport *rport;
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
diff --git a/drivers/s390/scsi/zfcp_sysfs_port.c b/drivers/s390/scsi/zfcp_sysfs_port.c
--- a/drivers/s390/scsi/zfcp_sysfs_port.c
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c
@@ -67,7 +67,6 @@ static DEVICE_ATTR(_name, S_IRUGO, zfcp_
 ZFCP_DEFINE_PORT_ATTR(status, "0x%08x\n", atomic_read(&port->status));
 ZFCP_DEFINE_PORT_ATTR(wwnn, "0x%016llx\n", port->wwnn);
 ZFCP_DEFINE_PORT_ATTR(d_id, "0x%06x\n", port->d_id);
-ZFCP_DEFINE_PORT_ATTR(scsi_id, "0x%x\n", port->scsi_id);
 ZFCP_DEFINE_PORT_ATTR(in_recovery, "%d\n", atomic_test_mask
 		      (ZFCP_STATUS_COMMON_ERP_INUSE, &port->status));
 ZFCP_DEFINE_PORT_ATTR(access_denied, "%d\n", atomic_test_mask
@@ -263,7 +262,6 @@ static struct attribute_group zfcp_port_
 static struct attribute *zfcp_port_no_ns_attrs[] = {
 	&dev_attr_unit_add.attr,
 	&dev_attr_unit_remove.attr,
-	&dev_attr_scsi_id.attr,
 	NULL
 };
 
