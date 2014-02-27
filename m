From: Ales Novak <alnovak@suse.cz>
Subject: [PATCH] scsi: storvsc_device_destroy NULL pointer fix
Date: Thu, 27 Feb 2014 11:03:30 +0100
Message-ID: <1393495410-17575-1-git-send-email-alnovak@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz, Ales Novak <alnovak@suse.cz>, Thomas Abraham <tabraham@suse.com>
List-Id: linux-scsi@vger.kernel.org

If the initialization of storvsc fails, the storvsc_device_destroy()
causes NULL pointer dereference.

storvsc_bus_scan()
  scsi_scan_target()
    __scsi_scan_target()
      scsi_probe_and_add_lun(hostdata=NULL)
        scsi_alloc_sdev(hostdata=NULL)

	  sdev->hostdata = hostdata

	  now the host allocation fails

          __scsi_remove_device(sdev)

	  calls sdev->host->hostt->slave_destroy() ==
	  storvsc_device_destroy(sdev)
	    access of sdev->hostdata->request_mempool

Signed-off-by: Ales Novak <alnovak@suse.cz>
Signed-off-by: Thomas Abraham <tabraham@suse.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/scsi/storvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 17d7404..9969fa1 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1419,6 +1419,9 @@ static void storvsc_device_destroy(struct scsi_device *sdevice)
 {
 	struct stor_mem_pools *memp = sdevice->hostdata;
 
+	if (!memp)
+		return;
+
 	mempool_destroy(memp->request_mempool);
 	kmem_cache_destroy(memp->request_pool);
 	kfree(memp);
-- 
1.8.1.4
