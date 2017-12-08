From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 5/7] scsi: libsas: use flush_workqueue to process disco events synchronously
Date: Fri, 8 Dec 2017 17:42:08 +0800
Message-ID: <20171208094210.24887-6-yanaijie@huawei.com>
References: <20171208094210.24887-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2269 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753030AbdLHJgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 04:36:45 -0500
In-Reply-To: <20171208094210.24887-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>

Now we are processing sas event and discover event in different workqueues.
It's safe to wait the discover event done in the sas event work. Use
flush_workqueue() to insure the disco and revalidate events processed
synchronously so that the whole discover and revalidate process will not
be interrupted by other events.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 9326628..64722f4 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -192,6 +192,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 		si->dft->lldd_port_formed(phy);
 
 	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
+	flush_workqueue(sas_ha->disco_q);
 }
 
 /**
@@ -277,6 +278,9 @@ void sas_porte_broadcast_rcvd(struct work_struct *work)
 
 	SAS_DPRINTK("broadcast received: %d\n", prim);
 	sas_discover_event(phy->port, DISCE_REVALIDATE_DOMAIN);
+
+	if (phy->port)
+		flush_workqueue(phy->port->ha->disco_q);
 }
 
 void sas_porte_link_reset_err(struct work_struct *work)
-- 
2.9.5
