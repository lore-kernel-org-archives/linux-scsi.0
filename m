From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvscsi: Protect ibmvscsi_head from concurrent modificaiton
Date: Wed, 20 Mar 2019 13:41:50 -0500
Message-ID: <20190320184151.31321-1-tyreld@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For each ibmvscsi host created during a probe or destroyed during a
remove we either add or remove that host to/from the global ibmvscsi_head
list. This runs the risk of concurrent modification.

This patch adds a simple spinlock around the list modification calls to
prevent concurrent updates as is done similarly in the ibmvfc driver and
ipr driver.

Fixes: 32d6e4b6e4ea ("scsi: ibmvscsi: add vscsi hosts to global list_head")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 1135e74646e2..2b22969f3f63 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -96,6 +96,7 @@ static int client_reserve = 1;
 static char partition_name[96] = "UNKNOWN";
 static unsigned int partition_number = -1;
 static LIST_HEAD(ibmvscsi_head);
+static DEFINE_SPINLOCK(ibmvscsi_driver_lock);
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -2270,7 +2271,9 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	}
 
 	dev_set_drvdata(&vdev->dev, hostdata);
+	spin_lock(&ibmvscsi_driver_lock);
 	list_add_tail(&hostdata->host_list, &ibmvscsi_head);
+	spin_unlock(&ibmvscsi_driver_lock);
 	return 0;
 
       add_srp_port_failed:
@@ -2292,7 +2295,9 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
+	spin_lock(&ibmvscsi_driver_lock);
 	list_del(&hostdata->host_list);
+	spin_unlock(&ibmvscsi_driver_lock);
 	unmap_persist_bufs(hostdata);
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
-- 
2.12.3
