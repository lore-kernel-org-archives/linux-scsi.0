From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 0/5] Re-order scsi_remove_host and sas_remove_host in SAS HBA LLDDs
Date: Fri, 21 Apr 2017 10:04:45 +0200
Message-ID: <cover.1492760075.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>, tj@kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This series re-orders the calls to scsi_remove_host() and sas_remove_host() in
all SAS HBA drivers (apart from mpt3sas which is doing it correctly). This is
for two reasons:
	1) After the change to recursive removal of sysfs entries, we're
	   trying to remove already removed kobjects when doing a
	   sas_remove_host() _after_ a scsi_remove_host()
	2) the documentation mandates it even (becuase of 1)

Unfortunately this does not completely solve issues with recursive sysfs
removals in SAS, as libsas has asynchronous behaviour where strong ordering
would be needed. But I am working on it and I do know other do as well. So if
anyone else (James, Christoph, Bart, I'm looking at you) has an idea, I do
have test setups and I'm willing to take input in form of ideas and patches.

I also dropped the SDEV_CANCEL state change for now. We re-evaluate it once we
have an idea how to tackle the ordering issues and place it into
sas_unregister_ha() as per James' comment.

Thanks,
	Johannes

Johannes Thumshirn (5):
  scsi: isci: remove the SAS host after the SCSI host
  aic94xx: remove the SAS host after the SCSI host
  scsi: hisi_sas: remove the SAS host after the SCSI host
  mvsas: remove the SAS host after the SCSI host
  scsi: pm8001: remove the SAS host after the SCSI host

 drivers/scsi/aic94xx/aic94xx_init.c   | 7 ++++---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 drivers/scsi/isci/init.c              | 3 ++-
 drivers/scsi/mvsas/mv_init.c          | 6 ++++--
 drivers/scsi/pm8001/pm8001_init.c     | 8 ++++++--
 5 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.12.0
