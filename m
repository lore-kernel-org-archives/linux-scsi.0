From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/3] scsi: ufs & ums-*: fix module reference counting
Date: Mon,  5 Jan 2015 23:34:36 +0900
Message-ID: <1420468479-4508-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56908 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbbAEOex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 09:34:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a scsi_device, the use count of the underlying LLDD module
is incremented.  The module reference is retrieved through .module field of
struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except some scsi drivers (ufs and unusual usb storage drivers).  These
drivers consist with core driver and actual LLDDs, and scsi_host_template
is defined in the core driver.  So the actual LLDDs can be unloaded even if
the scsi_device is being accessed.

This patch series first adds ability to adjust module reference for
scsi host by LLDDs and then fixes ufs and unusual usb storage drivers
by adjusting module reference after scsi host allocation.

Akinobu Mita (3):
  scsi: add ability to adjust module reference for scsi host
  scsi: ufs: adjust module reference for scsi host
  usb: storage: adjust module reference for scsi host

 drivers/scsi/hosts.c                | 1 +
 drivers/scsi/scsi.c                 | 4 ++--
 drivers/scsi/ufs/ufshcd-pci.c       | 1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c    | 1 +
 drivers/scsi/ufs/ufshcd.c           | 1 -
 drivers/usb/storage/alauda.c        | 1 +
 drivers/usb/storage/cypress_atacb.c | 2 ++
 drivers/usb/storage/datafab.c       | 1 +
 drivers/usb/storage/ene_ub6250.c    | 1 +
 drivers/usb/storage/freecom.c       | 1 +
 drivers/usb/storage/isd200.c        | 1 +
 drivers/usb/storage/jumpshot.c      | 1 +
 drivers/usb/storage/karma.c         | 1 +
 drivers/usb/storage/onetouch.c      | 2 ++
 drivers/usb/storage/realtek_cr.c    | 2 ++
 drivers/usb/storage/sddr09.c        | 2 ++
 drivers/usb/storage/sddr55.c        | 1 +
 drivers/usb/storage/shuttle_usbat.c | 1 +
 include/scsi/scsi_host.h            | 1 +
 19 files changed, 23 insertions(+), 3 deletions(-)

Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

