From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 6/7] scsi: libsas: reset the phy address if discover failed
Date: Wed, 30 Jan 2019 16:24:11 +0800
Message-ID: <20190130082412.9357-7-yanaijie@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130082412.9357-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Xiaofei Tan <tanxiaofei@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

When we failed to discover the device, the phy address is still kept
in ex_phy. So when the next time we revalidate this phy the
address and device type is the same, it will be considered as flutter
and will not be discovered again. So the device will not be brought up.

Fix this by reset the phy address to the initial value. Then
in the next revalidation the device will be discovered agian.

Tested-by: Chen Liangfei <chenliangfei1@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: Xiaofei Tan <tanxiaofei@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_expander.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 6e56ebdc2148..e781941a7088 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1100,6 +1100,13 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 						 i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
 			}
 		}
+	} else {
+		/* if we failed to discover this device, we have to
+		 * reset the expander phy attached address so that we
+		 * will not treat the phy as flutter in the next
+		 * revalidation
+		 */
+		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	}
 
 	return res;
-- 
2.14.4
