From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 0/7] libsas: fix issue of swapping or replacing disks
Date: Wed, 30 Jan 2019 16:24:05 +0800
Message-ID: <20190130082412.9357-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The work flow of revalidation now is scanning expander phy by the
sequence of the phy and check if the phy have changed. This will leads
to some issues of swapping disks or replacing a disk with a new one.

This patchset addresses the issues above by these main changes:
1. Let the revalidation first scan all phys, mark all changed phys, then
revalidate in two steps. First check if we need to unregister some devices.
if we need to unregister some devices, tell the upper revalidation that we
need to revalidate again. Second, if no devices need to be unregistered,
discover new devices.
2. For sata disk, checking the ata devices class and id to ensure
the same device after flutter.

v1->v2:
1. Do not raise a new bcast but use a loop in sas_revalidate_domain() to
retry revalidation if we need to revalidate again. So that we can do the 
bcast event processing synchronised to the original event
2. Drop some patches splitted from this patchset:
   https://lkml.org/lkml/2018/9/25/153
3. Drop the SATA PHY connection rate matching patch since John had a better
solution for the device discovery phase.
   https://lkml.org/lkml/2019/1/4/340
4. Re-init negotiated_linkrate when PHY is down.
5. Fix an issue when event in queue reached the limit.

Jason Yan (7):
  scsi: libsas: reset the negotiated_linkrate when phy is down
  scsi: libsas: only clear phy->in_shutdown after shutdown event done
  scsi: libsas: optimize the debug print of the revalidate process
  scsi: libsas: split the replacement of sas disks in two steps
  scsi: libsas: check if the same device when flutter
  scsi: libsas: reset the phy address if discover failed
  scsi: libsas: fix issue of swapping two sas disks

 drivers/ata/libata-core.c          |   3 +-
 drivers/scsi/libsas/sas_ata.c      |  18 +++
 drivers/scsi/libsas/sas_discover.c |  25 ++--
 drivers/scsi/libsas/sas_expander.c | 239 +++++++++++++++++++++++++++----------
 drivers/scsi/libsas/sas_phy.c      |   3 +-
 include/linux/libata.h             |   2 +
 include/scsi/libsas.h              |   6 +-
 7 files changed, 224 insertions(+), 72 deletions(-)

-- 
2.14.4
