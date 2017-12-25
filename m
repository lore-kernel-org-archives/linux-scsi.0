From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v1 0/9] ufs: sysfs: read-only access to device descriptors, attributes and flags
Date: Mon, 25 Dec 2017 10:34:29 +0200
Message-ID: <1514190878-5571-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces sysfs entries that will provide read-only access to
device management data that could be received with UFS query requests.
User-space applications will be able to read UFS device descriptors,
flags and attributes. This will allow to get full UFS device configuration
and its status. The descriptors are provided as set of files representing
its parameters. The flags are using "true"/"false" representation of
their value. The attributes are shown as hexadecimal value. The
descriptors, attributes and flags are placed in separate subfolders under
the UFS device sysfs entry (/sys/bus/platform/drivers/ufshcd/*/). The
string descriptor subfolder contains five string descriptors defined by
UFS specification 2.1. The LUN specific descriptor and attribute are 
placed under corresponding SCSI device sysfs entries
(/sys/class/scsi_device/*/device/).
In addition the patch presents an additional field in the
scsi_host_template structure - struct attribute_group **sdev_group.
This field allows to define groups of attributes. It will provide an
ability to use binary attributes in addition to device attributes and
to group them under subfolders if necessary.

Stanislav Nijnikov (9):
  ufs: sysfs: device descriptor
  ufs: sysfs: interconnect descriptor
  ufs: sysfs: geometry descriptor
  ufs: sysfs: health descriptor
  ufs: sysfs: power descriptor
  ufs: sysfs: string descriptors
  ufs: sysfs: unit descriptor
  ufs: sysfs: flags
  ufs: sysfs: attributes

 Documentation/ABI/testing/sysfs-driver-ufs | 804 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  |  14 +
 drivers/scsi/ufs/Makefile                  |   2 +-
 drivers/scsi/ufs/ufs-sysfs.c               | 643 +++++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.h               |  14 +
 drivers/scsi/ufs/ufs.h                     | 115 ++++-
 drivers/scsi/ufs/ufshcd.c                  |  52 +-
 drivers/scsi/ufs/ufshcd.h                  |  25 +
 include/scsi/scsi_host.h                   |   6 +
 9 files changed, 1642 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs
 create mode 100644 drivers/scsi/ufs/ufs-sysfs.c
 create mode 100644 drivers/scsi/ufs/ufs-sysfs.h

-- 
2.7.4
