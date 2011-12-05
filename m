From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v5 0/6] ata port runtime power management support
Date: Mon,  5 Dec 2011 09:20:22 +0800
Message-ID: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi Jeff,

This is the v5 patches to add ata port runtime pm support.
Applied on top of v3.2-rc4.

Patch 1 was acked by Tejun Heo.
Patch 2, 3, 4 were signed/acked by Alan Stern.

Could you consider merging these patches?

Chanes in v5(no functional change):
- add SCSI patches acks by Alan Stern
- rebase to v3.2-rc4

Changes in v4:
- check SCSI device runtime PM status in system PM (Alan Stern, Tejun Heo)

Changes in v3:
- runtime resume scsi device before system suspend (Alan Stern)
- check runtime status in sd_shutdown

v1:
https://lkml.org/lkml/2011/11/2/23

v2:
https://lkml.org/lkml/2011/11/10/71
Acked-by: Tejun Heo <tj@kernel.org>
Kay Sievers reviewed sysfs change

v3:
https://lkml.org/lkml/2011/11/23/37

v4:
https://lkml.org/lkml/2011/11/27/275

Lin Ming (6):
   ata: make ata port as parent device of scsi host
   [SCSI] add flag to skip the runtime PM calls on the host
   [SCSI] check runtime PM status in system PM
   [SCSI] sd: check runtime PM status in sd_shutdown
   ata: add ata port system PM callbacks
   ata: add ata port runtime PM callbacks

 drivers/ata/libata-core.c      |  154 ++++++++++++++++++++++------------------
 drivers/ata/libata-scsi.c      |    3 +-
 drivers/ata/libata-transport.c |    5 ++
 drivers/ata/libata.h           |    1 +
 drivers/scsi/scsi_error.c      |    5 +-
 drivers/scsi/scsi_pm.c         |   16 ++++-
 drivers/scsi/sd.c              |    5 ++
 include/scsi/scsi_host.h       |    3 +
 8 files changed, 118 insertions(+), 74 deletions(-)

Thanks for any comment,
Lin Ming
