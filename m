From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v3 0/7] Enhance libsas hotplug feature
Date: Mon, 10 Jul 2017 15:06:02 +0800
Message-ID: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9294 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbdGJHCU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2017 03:02:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>

This patchset is based Johannes's patch
"scsi: sas: scsi_queue_work can fail, so make callers aware"

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

v2->v3: some code improvements suggested by Johannes and John,
	    split v2 patch 2 into several small pathes.
v1->v2: some code improvements suggested by John Garry

Yijing Wang (7):
  libsas: Use static sas event pool to appease sas event lost
  libsas: remove unused port_gone_completion
  libsas: Use new workqueue to run sas event
  libsas: add sas event wait-complete support
  libsas: add a new workqueue to run probe/destruct discovery event
  libsas: add wait-complete support to sync discovery event
  libsas: release disco mutex during waiting in sas_ex_discover_end_dev

 drivers/scsi/libsas/sas_discover.c |  58 +++++++---
 drivers/scsi/libsas/sas_event.c    | 212 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/libsas/sas_expander.c |  22 +++-
 drivers/scsi/libsas/sas_init.c     |  21 ++--
 drivers/scsi/libsas/sas_internal.h |  64 +++++++++++
 drivers/scsi/libsas/sas_phy.c      |  48 +++------
 drivers/scsi/libsas/sas_port.c     |  22 ++--
 include/scsi/libsas.h              |  27 +++--
 8 files changed, 373 insertions(+), 101 deletions(-)

-- 
2.5.0
