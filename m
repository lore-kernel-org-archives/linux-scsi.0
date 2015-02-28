From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v5 0/4] scsi: ufs & ums-* & esp_scsi: fix module reference counting
Date: Sat, 28 Feb 2015 23:16:53 +0900
Message-ID: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43589 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbbB1ORW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 09:17:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a scsi_device, the use count of the underlying LLDD module
is incremented.  The module reference is retrieved through .module field of
struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except ufs, unusual usb storage drivers, and sub drivers for esp_scsi.
These drivers consist with core driver and actual LLDDs, and
scsi_host_template is defined in the core driver.  So the actual LLDDs can
be unloaded even if the scsi_device is being accessed.

This patch series first adds ability to adjust module reference for
scsi host by LLDDs and then fixes actual LLDDs by adjusting module
reference after scsi host allocation.

* v5:
- Discard v4 changes and restore to v3.  Because v4 shows that
  moving owner module field from scsi_host_template to Scsi_Host
  requires a lot of changes and introduces complication to existing
  drivers which don't have the module reference mismatch issue.
- Rebased to the 4.0-rc1

* v4:
- Patch series is almost rewritten as module reference field in
  struct scsi_host_template has been unused anymore.  So Acked-by: and
  Reviewed-by: tags that have been received are deleted.

* v3:
- Add fix for ESP SCSI drivers

* v2:
- Pass correct module reference to usb_stor_probe1() instead of touching
  all ums-* drivers, suggested by Alan Stern

Akinobu Mita (4):
  scsi: add ability to adjust module reference for scsi host
  scsi: ufs: adjust module reference for scsi host
  usb: storage: adjust module reference for scsi host
  scsi: esp_scsi: adjust module reference for scsi host

 drivers/scsi/am53c974.c          |  3 +--
 drivers/scsi/esp_scsi.c          | 16 +++++++++++++---
 drivers/scsi/esp_scsi.h          | 11 +++++++----
 drivers/scsi/hosts.c             |  1 +
 drivers/scsi/jazz_esp.c          |  3 +--
 drivers/scsi/mac_esp.c           |  3 +--
 drivers/scsi/scsi.c              |  4 ++--
 drivers/scsi/sun3x_esp.c         |  3 +--
 drivers/scsi/sun_esp.c           |  3 +--
 drivers/scsi/ufs/ufshcd-pci.c    |  1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c |  1 +
 drivers/scsi/ufs/ufshcd.c        |  1 -
 drivers/usb/storage/usb.c        |  8 +++++---
 drivers/usb/storage/usb.h        |  7 +++++--
 include/scsi/scsi_host.h         |  1 +
 15 files changed, 41 insertions(+), 25 deletions(-)

Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

