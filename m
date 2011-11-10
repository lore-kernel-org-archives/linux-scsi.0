From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v2 0/4] ata port runtime power management support
Date: Thu, 10 Nov 2011 14:22:42 +0800
Message-ID: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi, all

These 4 patches add ata port runtime pm support.

v1:
https://lkml.org/lkml/2011/11/2/23

v2 is totally different than v1.

v1 performed ata port runtime pm through scsi layer.
Added hook to scsi host runtime suspend/resume code.

I realized that this is not the natural way to do ata port runtime pm.
It does not deal with the races with ata port system suspend/resume.

With v2, ata port is made to be parent device of scsi host.

Currently, the device tree of ata port and scsi host looks as below,

        /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
        |-- ata1                                (ata port)
        |-- host0                               (scsi host)
           |-- target0:0:0                      (scsi target)
               |-- 0:0:0:0                      (disk)

v2 changes it to:

        /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
        |-- ata1                                (ata port)
            |-- host0                           (scsi host)
                |-- target0:0:0                 (scsi target)
                    |-- 0:0:0:0                 (disk)

So ata port runtime PM will happen as:

disk suspend --> scsi target suspend --> scsi host suspend --> ata port
suspend.

This is much cleaner and natural.

Lin Ming (4):
      ata: make ata port as parent device of scsi host
      scsi: add flag to skip the runtime PM calls on host in EH
      ata: add ata port system PM callbacks
      ata: add ata port runtime PM callbacks

 drivers/ata/libata-core.c      |  158 ++++++++++++++++++++++------------------
 drivers/ata/libata-scsi.c      |    3 +-
 drivers/ata/libata-transport.c |    5 +
 drivers/ata/libata.h           |    1 +
 drivers/scsi/scsi_error.c      |    5 +-
 include/scsi/scsi_host.h       |    3 +
 6 files changed, 102 insertions(+), 73 deletions(-)

Thanks for any comment.
Lin Min
