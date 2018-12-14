From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: [PATCH 0/6] Add support of the HBA mode on HP Smart Array P410i controllers
Date: Fri, 14 Dec 2018 18:21:09 +0500
Message-ID: <20181214132115.21440-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, mironov.ivan@gmail.com
Cc: linux-kernel@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

This series of patches adds support of the HBA mode on HP Smart Array
P410i RAID controllers.

This is not guaranteed to be correct as I do not have any access to
documentation on these controllers. However, this works fine for me
on hardware that I have. Also, these changes successfully passes blktests[1]
and xfstests[2].

To make sure that this new functionality does not break anything, it is
disabled by default and may be enabled only manually using new module
parameter.

[1] https://github.com/osandov/blktests
[2] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

Ivan Mironov (6):
  scsi: hpsa: Add function to check if device is a disk or a zoned
    device
  scsi: hpsa: Support HBA mode on HP Smart Array P410i controllers
  scsi: hpsa: Add/mask existing devices on rescan if visibility changes
  scsi: hpsa: Ignore HBA flag from NVRAM if logical devices exist
  scsi: hpsa: Name more fields in "struct bmic_identify_controller"
  scsi: hpsa: Do not use HBA flag from NVRAM if HBA is not supported

 drivers/scsi/hpsa.c     | 145 ++++++++++++++++++++++++++++++++++++----
 drivers/scsi/hpsa.h     |   3 +
 drivers/scsi/hpsa_cmd.h | 113 ++++++++++++++++++++++++++++++-
 3 files changed, 244 insertions(+), 17 deletions(-)

-- 
2.19.2
