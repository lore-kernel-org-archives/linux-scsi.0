From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/2] Fix a race condition between SPI domain validation and system suspend
Date: Fri,  5 Jan 2018 09:19:07 -0800
Message-ID: <20180105171909.11839-1-bart.vanassche@wdc.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Woody Suwalski <terraluna977@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello Martin,

Recently it was discovered that the v4.15 rework of suspend/resume handling
in the SCSI subsystem introduced a race condition between SPI domain validation
and system suspend. The two patches in this series fix that race. Please
consider these two patches for kernel v4.15.

Thanks,

Bart.

Bart Van Assche (2):
  PM / sleep: Make lock/unlock_system_sleep() available to kernel
    modules
  Fix a race condition between SPI domain validation and system suspend

 drivers/scsi/scsi_transport_spi.c | 16 ++++++++++++++--
 include/linux/suspend.h           | 28 ++--------------------------
 kernel/power/main.c               | 29 +++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 28 deletions(-)

-- 
2.15.1
