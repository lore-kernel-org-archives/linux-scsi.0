From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Tue,  3 Nov 2015 15:33:59 +0100
Message-ID: <1446561239-29324-3-git-send-email-lvivier@redhat.com>
References: <1446561239-29324-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446561239-29324-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com
List-Id: linux-scsi@vger.kernel.org

QEMU allows until 32 LUNs.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index f9d7ec4..e5478b0 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -84,6 +84,7 @@
  */
 static int max_id = 64;
 static int max_channel = 3;
+static int max_lun = 8;
 static int init_timeout = 300;
 static int login_timeout = 60;
 static int info_timeout = 30;
@@ -117,6 +118,8 @@ module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
 module_param_named(client_reserve, client_reserve, int, S_IRUGO );
 MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
+module_param(max_lun, int, S_IRUGO);
+MODULE_PARM_DESC(max_lun, "Maximum LUN value [Default=8]");
 
 static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 				struct ibmvscsi_host_data *hostdata);
@@ -2289,7 +2292,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto init_pool_failed;
 	}
 
-	host->max_lun = 8;
+	host->max_lun = max_lun;
 	host->max_id = max_id;
 	host->max_channel = max_channel;
 	host->max_cmd_len = 16;
-- 
2.1.0
