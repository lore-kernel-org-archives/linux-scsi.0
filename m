From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/2] Honor VPD check in usb/storage for SanDisk device
Date: Mon, 17 Jun 2019 22:31:44 -0300
Message-ID: <20190618013146.21961-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Before this patch, USB storage devices disabled VPD check by always setting
skip_vpd_check.

The first patch add a new entry to scsi_static_device_list related to SanDisk
Cruzer Blade, which have VPD, adding BLIST_TRY_VPD_PAGES flag, which implies
try_vpd_pages.

The second patch check try_vpd_pages, and only set skip_vpd_pages if
try_vpd_pages is not set.

This patches along the wwid one [1], makes SanDisk Cruzer Blade device to
present correctly wwid, vpd_pg80 and vpd_pg83 in sysfs, and let the window open
to support another USB storage devices to support and present VPD.

[1]: https://lkml.org/lkml/2019/6/11/1408

Marcos Paulo de Souza (2):
  scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk Cruzer Blade
  usb: storage: scsiglue: Do not skip VPD if try_vpd_pages is set

 drivers/scsi/scsi_devinfo.c    | 2 ++
 drivers/usb/storage/scsiglue.c | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.21.0
