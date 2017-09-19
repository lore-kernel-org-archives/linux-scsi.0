From: Jason Yan <yanaijie@huawei.com>
Subject: [RESEND PATCH v4 0/6] Enhance libsas hotplug feature
Date: Tue, 19 Sep 2017 15:09:00 +0800
Message-ID: <1505804946-39266-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Thanks Martin K. Petersen for applied some of the tidy-up patches. So I do not
have to maintain these patches out of the tree. I will only send the reset
of them in the next days if needed.

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

v3->v4: -use dynamic alloced work and support shutting down the phy if active event reached the threshold
        -use flush_workqueue instead of wait-completion to process discover events synchronously
        -direct call probe and destruct function
v2->v3: some code improvements suggested by Johannes and John,
        split v2 patch 2 into several small pathes.
v1->v2: some code improvements suggested by John Garry

Jason Yan (6):
  libsas: Use dynamic alloced work to avoid sas event lost
  libsas: shut down the PHY if events reached the threshold
  libsas: make the event threshold configurable
  libsas: Use new workqueue to run sas event and disco event
  libsas: libsas: use flush_workqueue to process disco events
    synchronously
  libsas: direct call probe and destruct

 drivers/scsi/hisi_sas/hisi_sas_main.c |  6 +++
 drivers/scsi/libsas/sas_ata.c         |  1 -
 drivers/scsi/libsas/sas_discover.c    | 36 ++++++++------
 drivers/scsi/libsas/sas_event.c       | 79 ++++++++++++++++++++++--------
 drivers/scsi/libsas/sas_expander.c    |  2 +-
 drivers/scsi/libsas/sas_init.c        | 91 +++++++++++++++++++++++++++++++++--
 drivers/scsi/libsas/sas_internal.h    |  7 +++
 drivers/scsi/libsas/sas_phy.c         | 73 ++++++++++++++--------------
 drivers/scsi/libsas/sas_port.c        | 25 ++++++----
 include/scsi/libsas.h                 | 29 ++++++++---
 include/scsi/scsi_transport_sas.h     |  1 +
 11 files changed, 258 insertions(+), 92 deletions(-)

-- 
2.5.0
