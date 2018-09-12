From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 4/5] scsi: libsas: check the ata device status by ata_dev_enabled()
Date: Wed, 12 Sep 2018 16:29:45 +0800
Message-ID: <20180912082946.34814-5-yanaijie@huawei.com>
References: <20180912082946.34814-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912082946.34814-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

When ata device IDENTIFY failed, the ata device status is
ATA_DEV_UNKNOWN. The libata reported like:

[113518.620433] ata5.00: qc timeout (cmd 0xec)
[113518.653646] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)

But libsas verifies the device status by ata_dev_disabled(), which
skiped ATA_DEV_UNKNOWN. This will make libsas think the ata device
probing succeed the device cannot be actually brought up. And even the
new bcast of this device will be considered as flutter and will not
probe this device again.

Change ata_dev_disabled() to !ata_dev_enabled() so that libsas can
deal with this if the ata device probe failed. New bcasts can let us
try to probe the device again and bring it up if it is fine to
IDENTIFY.

Tested-by: Zhou Yupeng <zhouyupeng1@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 64a958a99f6a..4f6cdf53e913 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -654,7 +654,7 @@ void sas_probe_sata(struct asd_sas_port *port)
 		/* if libata could not bring the link up, don't surface
 		 * the device
 		 */
-		if (ata_dev_disabled(sas_to_ata_dev(dev)))
+		if (!ata_dev_enabled(sas_to_ata_dev(dev)))
 			sas_fail_probe(dev, __func__, -ENODEV);
 	}
 
-- 
2.14.4
