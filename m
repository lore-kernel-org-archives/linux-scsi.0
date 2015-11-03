From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH 2/3] ibmvscsi: display default value for max_id, max_lun and max_channel.
Date: Tue,  3 Nov 2015 15:33:58 +0100
Message-ID: <1446561239-29324-2-git-send-email-lvivier@redhat.com>
References: <1446561239-29324-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446561239-29324-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com
List-Id: linux-scsi@vger.kernel.org

As devices with values greater than that are silently ignored,
this gives some hints to the sys admin to know why he doesn't see
his devices...

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3e76490..f9d7ec4 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -106,9 +106,9 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(IBMVSCSI_VERSION);
 
 module_param_named(max_id, max_id, int, S_IRUGO);
-MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
+MODULE_PARM_DESC(max_id, "Largest ID value for each channel [Default=64]");
 module_param_named(max_channel, max_channel, int, S_IRUGO);
-MODULE_PARM_DESC(max_channel, "Largest channel value");
+MODULE_PARM_DESC(max_channel, "Largest channel value [Default=3]");
 module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
 module_param_named(max_requests, max_requests, int, S_IRUGO);
@@ -2294,6 +2294,10 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	host->max_channel = max_channel;
 	host->max_cmd_len = 16;
 
+	dev_info(dev,
+		 "Maximum ID: %d Maximum LUN: %d Maximum Channel: %d\n",
+		 host->max_id, host->max_lun, host->max_channel);
+
 	if (scsi_add_host(hostdata->host, hostdata->dev))
 		goto add_host_failed;
 
-- 
2.1.0
