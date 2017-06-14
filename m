From: Yijing Wang <wangyijing@huawei.com>
Subject: [Resend][PATCH v2 0/2] Enhance libsas hotplug feature
Date: Wed, 14 Jun 2017 15:36:39 +0800
Message-ID: <1497425801-19249-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Now the libsas hotplug has some issues, Dan Williams report
a similar bug here before
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html

The issues we have found
1. if LLDD burst reports lots of phy-up/phy-down sas events, some events
   may lost because a same sas events is pending now, finally libsas topo
   may different the hardware.
2. receive a phy down sas event, libsas call sas_deform_port to remove
   devices, it would first delete the sas port, then put a destruction
   discovery event in a new work, and queue it at the tail of workqueue,
   once the sas port be deleted, its children device will be deleted too,
   when the destruction work start, it will found the target device has
   been removed, and report a sysfs warnning.
3. since a hotplug process will be devided into several works, if a phy up
   sas event insert into phydown works, like
   destruction work  ---> PORTE_BYTES_DMAED (sas_form_port) ---->PHYE_LOSS_OF_SIGNAL
   the hot remove flow would broken by PORTE_BYTES_DMAED event, it's not
   we expected, and issues would occur.

The first patch fix the sas events lost, and the second one introudce wait-complete
to fix the hotplug order issues.

v1->v2: some code improvements suggested by John Garry

Yijing Wang (2):
  libsas: Don't process sas events in static works
  libsas: Enhance libsas hotplug

 drivers/scsi/libsas/sas_discover.c | 58 +++++++++++++++++-------
 drivers/scsi/libsas/sas_event.c    | 90 ++++++++++++++++++++++++++------------
 drivers/scsi/libsas/sas_expander.c |  9 +++-
 drivers/scsi/libsas/sas_init.c     | 29 +++++++++---
 drivers/scsi/libsas/sas_internal.h | 64 +++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_phy.c      | 45 ++++---------------
 drivers/scsi/libsas/sas_port.c     | 22 +++++-----
 include/scsi/libsas.h              | 19 ++++----
 8 files changed, 232 insertions(+), 104 deletions(-)

-- 
2.5.0
