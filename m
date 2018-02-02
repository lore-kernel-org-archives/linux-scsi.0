From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] scsi: fixes for building with LTO
Date: Fri,  2 Feb 2018 14:12:14 +0100
Message-ID: <20180202131225.1658853-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:60364 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeBBNMn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 08:12:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>

I experimented with link time optimization after Nico's
article at https://lwn.net/Articles/744507/

Here is a set of patches that came out of it for the scsi
subsystem.

Arnd Bergmann (6):
  scsi: fc_encode: work around strncpy size warnings
  scsi: NCR53c406a: avoid section mismatch with LTO
  scsi: sym53c416: avoid section mismatch with LTO
  scsi: qedf: fix LTO-enabled build
  scsi: qedi: fix building with LTO
  scsi: qedf: use correct strncpy() size

 drivers/scsi/NCR53c406a.c        |  2 +-
 drivers/scsi/qedf/qedf_dbg.c     |  2 +-
 drivers/scsi/qedf/qedf_dbg.h     | 17 ++++++++++-------
 drivers/scsi/qedf/qedf_debugfs.c |  6 +++---
 drivers/scsi/qedf/qedf_main.c    |  8 +++-----
 drivers/scsi/qedi/qedi_dbg.h     |  2 +-
 drivers/scsi/qedi/qedi_debugfs.c |  4 ++--
 drivers/scsi/qedi/qedi_gbl.h     |  4 ++--
 drivers/scsi/qedi/qedi_main.c    |  4 ++--
 drivers/scsi/sym53c416.c         |  2 +-
 include/scsi/fc/fc_ms.h          |  2 +-
 11 files changed, 27 insertions(+), 26 deletions(-)

-- 
2.9.0
