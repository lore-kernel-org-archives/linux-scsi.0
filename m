From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/8] libsas: Support swapping disks and SATA phy link rate matching the pathway
Date: Tue, 29 May 2018 10:23:01 +0800
Message-ID: <20180529022309.21071-1-yanaijie@huawei.com>
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

And when an expander phy attached to a SATA phy is using a physical link
rate greater than the expander host phys's linkrate, the disk will failed
to be discovered(ATA commands all failed). This is described in sas
protocal spec as:

"If an expander phy attached to a SATA phy is using a physical link rate
greater than the maximum connection rate supported by the pathway from
an STP initiator port, a management application client should use the
SMP PHY CONTROL function (see 10.4.3.10) to set the PROGRAMMED MAXIMUM
PHYSICAL LINK RATE field of the expander phy to the maximum connection
rate supported by the pathway from that STP initiator port."

This patchset addresses the issues above by these main changes:
1. Let the revalidation first scan all phys, mark all changed phys, then
revalidate in two steps. First check if we need to unregister some devices.
if we need to unregister some devices, raise a new bcast and return.
Second, if no devices need to be unregistered, discover new devices.
2. Check the SATA phy's linkrate to see if it is greater than any phy's 
linkrate it may pass through. Remember the minimum linkrate of the pathway
and set the SATA phy linkrate to it using the SMP PHY CONTROL function.
3. Other changes such as checking the ata devices class and id to ensure
the same device after flutter and so on.

Jason Yan (8):
  scsi: libsas: delete dead code in scsi_transport_sas.c
  scsi: libsas: check the lldd callback correctly
  scsi: libsas: always unregister the old device if going to discover
    new
  scsi: libsas: trigger a new revalidation to discover the device
  scsi: libsas: check if the same sata device when flutter
  scsi: libsas: reset the phy state and address if discover failed
  scsi: libsas: fix issue of swapping two sas disks
  scsi: libsas: support SATA phy link rate unmatch the pathway

 drivers/ata/libata-core.c          |   3 +-
 drivers/scsi/libsas/sas_ata.c      | 131 ++++++++++++++++++++++++
 drivers/scsi/libsas/sas_discover.c |   4 +-
 drivers/scsi/libsas/sas_expander.c | 198 +++++++++++++++++++++++++++++--------
 drivers/scsi/libsas/sas_port.c     |   2 +
 drivers/scsi/scsi_transport_sas.c  |   2 -
 include/linux/libata.h             |   2 +
 include/scsi/libsas.h              |   1 +
 include/scsi/sas_ata.h             |   6 ++
 9 files changed, 305 insertions(+), 44 deletions(-)

-- 
2.13.6
