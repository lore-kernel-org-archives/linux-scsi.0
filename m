From: <Don.Brace@microchip.com>
Subject: RE: [PATCH 0/6] Add support of the HBA mode on HP Smart Array P410i
 controllers
Date: Fri, 14 Dec 2018 19:38:52 +0000
Message-ID: <BYAPR11MB285586623125DD1C98EE87F1E1A10@BYAPR11MB2855.namprd11.prod.outlook.com>
References: <20181214132115.21440-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181214132115.21440-1-mironov.ivan@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: mironov.ivan@gmail.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Ivan Mironov
Sent: Friday, December 14, 2018 7:21 AM
To: linux-scsi@vger.kernel.org; mironov.ivan@gmail.com
Cc: linux-kernel@vger.kernel.org; Don Brace <don.brace@microsemi.com>; Jame=
s E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen <martin.pete=
rsen@oracle.com>; esc.storagedev@microsemi.com
Subject: [PATCH 0/6] Add support of the HBA mode on HP Smart Array P410i co=
ntrollers

This series of patches adds support of the HBA mode on HP Smart Array P410i=
 RAID controllers.

This is not guaranteed to be correct as I do not have any access to documen=
tation on these controllers. However, this works fine for me on hardware th=
at I have. Also, these changes successfully passes blktests[1] and xfstests=
[2].

To make sure that this new functionality does not break anything, it is dis=
abled by default and may be enabled only manually using new module paramete=
r.

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

NAKing this series.
- The P410 controllers do not fully support HBA mode and we do not support =
adding it to the hpsa driver.
