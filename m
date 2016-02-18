From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/7] Runtime PM support for AHCI host controller driver
Date: Thu, 18 Feb 2016 10:54:10 +0200
Message-ID: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Linux already supports runtime PM of disks (drivers/scsi/sd.c) so that
after certain amount of idle time the disk is suspended automatically. This
series extends the support to AHCI host controllers. Whenever SATA ports
are determined to be idle (all children are runtime suspended) the host
controller is also suspended.

On recent Intel CPUs like Broxton this allows the CPU to go low power idle
states like S0ix runtime (given that all necessary blocks are also in their
correesponding low power states).

Patches [1-2/7] fix a lockup where disk is runtime suspended and the system
is put to sleep. They are independent of the rest of the series.

Patch [3/7] makes it possible for SATA ports to be runtime suspended when
there is not disk connected. For example on Lenovo Yoga 900 there are two
SATA ports which only one of them has disk connected. This patch allows the
host controller to runtime suspend whenever the disk is idle.

Rest of the patches bring runtime PM support for the AHCI driver. By
default runtime PM is blocked and needs to be unblocked from userspace
(following what other PCI drivers do). I've used following script to
unblock runtime PM for the whole stack (with 15 seconds of idle time):

------8<------8<------8<------8<------8<------8<------8<------
#!/bin/sh

TIMEOUT=${1:-15}
HOST=$(lspci -D | grep "SATA controller" | cut -f 1 -d ' ')
DISK=sda

# Enable runtime PM for all SATA ports
for port in /sys/bus/pci/devices/$HOST/ata*; do
	echo auto > $port/power/control
done
# Then for the host controller
echo auto > /sys/bus/pci/devices/$HOST/power/control

# And last for the disk
echo auto > /sys/block/$DISK/device/power/control
echo $(($TIMEOUT * 1000)) > /sys/block/$DISK/device/power/autosuspend_delay_ms
------8<------8<------8<------8<------8<------8<------8<------

Mika Westerberg (7):
  block: Add blk_set_runtime_active()
  scsi: Set request queue runtime PM status back to active on resume
  scsi: Drop runtime PM usage count after host is added
  ahci: Cache host controller version
  ahci: Convert driver to use modern PM hooks
  ahci: Add functions to manage runtime PM of AHCI ports
  ahci: Add runtime PM support for the host controller

 block/blk-core.c       |  24 ++++++++++++
 drivers/ata/ahci.c     | 102 +++++++++++++++++++++++++++++++++++--------------
 drivers/ata/ahci.h     |   1 +
 drivers/ata/libahci.c  |  55 +++++++++++++++++++++++---
 drivers/scsi/hosts.c   |   7 ++++
 drivers/scsi/scsi_pm.c |  10 +++++
 include/linux/blkdev.h |   2 +
 7 files changed, 167 insertions(+), 34 deletions(-)

-- 
2.7.0
