From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH v2 0/2] Hard disk S3 resume time optimization
Date: Fri, 17 May 2013 19:00:21 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A16B97BD5F@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-pm-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

The vast majority of time spent in S3 resume is consumed by the ATA 
subsystem as it resumes the computer's hard drives. For large hard disks
this time can be upwards of 10 seconds, which makes S3 suspend/resume too
costly to use frequently. This time needs to be reduced.

More details here:
https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-worst-offender

This patch set effectively reduces S3 resume time from multiple seconds
to less than 700ms. The idea is to allow the ATA/SCSI subsystems to resume
asynchronously without blocking system resume completion. The dpm_resume
call currently waits for all asynchronous devices to finish resuming before
it gives control back to the user. But in the case of ATA/SCSI we can give
control back immediately, since the hard disks won't be needed immediately
in lieu of RAM and cache.

Patch 1/2 goes through and sets the power.async_suspend flag for every device
in the ATA/SCSI resume path. This includes the ata port, link, and dev
devices, the scsi host and target devices, all their associated transport
devices, the block devices, and block partitions. This allows the entire
ATA resume path to be added to the async device queue in
drivers/base/power/main.c. Without this, the ATA resume path ends up in
both queues (sync and async), which causes interdependencies and backs up
the two queues.

Patch 2/2 updates the drivers/base/power subsystem to allow any devices which
have registred as asynchronous and who have not registered "complete"
callbacks to be non-blocking. The ATA/SCSI subsystem devices don't
register complete callbacks, so they automatically use the new feature.

Testing was done with kernel 3.8.0-20.31_i386 and 3.8.0-20.31_amd64

Changelog:
v2:
        - Updated patch submission. Incorporates comments from Tejun Heo.
          Fixed comment format, removed camelcase. No functional changes.

 block/genhd.c                      |    2 ++
 block/partition-generic.c          |    1 +
 drivers/ata/libata-transport.c     |    4 +++-
 drivers/base/attribute_container.c |    1 +
 drivers/base/core.c                |    7 ++++++-
 drivers/scsi/scsi_sysfs.c          |    2 +-
 drivers/scsi/sd.c                  |    3 +++
 drivers/base/power/main.c          |   20 ++++++++++++++++----
 8 files changed, 33 insertions(+), 7 deletions(-)
