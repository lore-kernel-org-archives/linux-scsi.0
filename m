From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/2] Fix sysfs recursive removal splats in isci
Date: Wed, 29 Mar 2017 11:41:07 +0200
Message-ID: <cover.1490775958.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755033AbdC2Jlo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 05:41:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

This series fixes a sysfs warning caused by isci not being able to cope with
recursive sysfs path removals which are in place since commit bcdde7e
("sysfs: make __sysfs_remove_dir() recursive").

The mvsas, aic94xx and pm8001 and hisi_sas patches have been compile tested
only hence they have no callstack of the affected path in their changelogs.

I'm not sure whether to mark this patches as stable or not. I tend to say no
here, although we've seen complaints/bug reports on lkml and the scsi list.

Johannes Thumshirn (6):
      scsi: sas: flush destruct workqueue on device unregister
      scsi: isci: remove the SAS host after the SCSI host
      aic94xx: remove the SAS host after the SCSI host
      scsi: hisi_sas: remove the SAS host after the SCSI host
      mvsas: remove the SAS host after the SCSI host
      scsi: pm8001: remove the SAS host after the SCSI host

 drivers/scsi/aic94xx/aic94xx_init.c   | 13 ++++++++++---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 10 ++++++++--
 drivers/scsi/isci/init.c              |  9 ++++++++-
 drivers/scsi/libsas/sas_discover.c    |  4 ++++
 drivers/scsi/mvsas/mv_init.c          | 13 +++++++++++--
 drivers/scsi/pm8001/pm8001_init.c     | 14 ++++++++++++--
 6 files changed, 53 insertions(+), 10 deletions(-)
-- 
1.8.5.6
