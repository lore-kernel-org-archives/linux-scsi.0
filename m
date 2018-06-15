From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 0/4] Enable UFS provisioning via Linux
Date: Fri, 15 Jun 2018 14:00:45 -0700
Message-ID: <20180615210049.126123-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This series enables provisioning UFS devices using the existing sysfs
interface. This functionality is primarily useful along the assembly
line, but might also be useful for end users that receive devices that
aren't locked down.

Changes since v1:
	- Reworked the interface to show each unit of the config
descriptor as a separate directory, rather than the previous method I
had of a file for selecting the unit, and then a common set of files
that interacted with whichever unit was selected. I did some kobject
magic to accomplish this. I noticed from Greg KH's reply to Sayali's
patches [1] that configfs might be the preferred method. Let me know
if I should abandon this series in favor of Sayali's, with the
possible exception of "Make sysfs attributes writable".
	- Squashed documentation changes into their respective code
changes.
	- I decided to keep the config descriptor attributes as their
own files, rather than hiding writes behind device descriptor and unit
descriptor, as I think that's more future proof and true to the UFS spec.

[1] https://lkml.org/lkml/2018/6/8/210

Evan Green (4):
  scsi: ufs: Add Configuration Descriptor to sysfs
  scsi: ufs: Make sysfs attributes writable
  scsi: ufs: Refactor descriptor read for write
  scsi: ufs: Enable writing config descriptor

 Documentation/ABI/testing/sysfs-driver-ufs | 156 ++++++++++--
 drivers/scsi/ufs/ufs-sysfs.c               | 367 +++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufs-sysfs.h               |   1 +
 drivers/scsi/ufs/ufs.h                     |  29 +++
 drivers/scsi/ufs/ufshcd.c                  | 110 ++++++---
 drivers/scsi/ufs/ufshcd.h                  |  30 ++-
 6 files changed, 620 insertions(+), 73 deletions(-)

-- 
2.13.5
