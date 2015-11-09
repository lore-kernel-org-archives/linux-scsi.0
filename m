From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v5 1/2] ibmvscsi: display default value for max_id, max_lun and max_channel.
Date: Mon,  9 Nov 2015 17:49:08 +0100
Message-ID: <1447087749-10828-2-git-send-email-lvivier@redhat.com>
References: <1447087749-10828-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447087749-10828-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com
List-Id: linux-scsi@vger.kernel.org

As devices with values greater than that are silently ignored,
this gives some hints to the sys admin to know why he doesn't see
his devices...

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6a41c36..b153150 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -106,9 +106,9 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(IBMVSCSI_VERSION);
 
 module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
+MODULE_PARM_DESC(max_id, "Largest ID value for each channel [Default=64]");
 module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(max_channel, "Largest channel value");
+MODULE_PARM_DESC(max_channel, "Largest channel value [Default=3]");
 module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
 module_param_named(max_requests, max_requests, int, S_IRUGO);
@@ -2294,6 +2294,10 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	host->max_channel = max_channel;
 	host->max_cmd_len = 16;
 
+	dev_info(dev,
+		 "Maximum ID: %d Maximum LUN: %llu Maximum Channel: %d\n",
+		 host->max_id, host->max_lun, host->max_channel);
+
 	if (scsi_add_host(hostdata->host, hostdata->dev))
 		goto add_host_failed;
 
-- 
2.1.0
