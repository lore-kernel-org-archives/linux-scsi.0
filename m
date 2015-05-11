From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v7] scsi: ufs & esp_scsi: fix module reference counting
Date: Mon, 11 May 2015 22:18:31 +0900
Message-ID: <1431350313-5009-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35605 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbEKNTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 09:19:01 -0400
Received: by pdbqd1 with SMTP id qd1so146284919pdb.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2015 06:19:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>

While accessing a scsi_device, the use count of the underlying LLDD
module is incremented.  The module reference is retrieved through
.module field of struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except ufs and esp scsi drivers.  These drivers consist with core
driver and actual LLDDs, and scsi_host_template is defined in the core
driver.  Since the module reference count isn't incremented, the
actual LLDDs can be unloaded while the scsi_device is being accessed.

This fixes it by preparing scsi host template for each LLDDs, which
is initialized at module_init().

* v7:
- Patch series is almost rewritten again and no scsi mid layer change
  anymore.  This fixes the issue by preparing scsi host template for
  each LLDDs, which is initialized at module_init(). 
  The idea is provided by James Bottomley
- The patch for usb-storage was removed as it was added to usb-testing

* v6:
- Rebased as v5 doesn't apply cleanly to the latest tree anymore.

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

Akinobu Mita (2):
  scsi: ufs: fix module reference for scsi host
  scsi: esp_scsi: fix module reference for scsi host

 drivers/scsi/am53c974.c          |  7 +++++--
 drivers/scsi/esp_scsi.c          | 13 +++++++++++--
 drivers/scsi/esp_scsi.h          |  9 +++++++--
 drivers/scsi/jazz_esp.c          |  7 +++++--
 drivers/scsi/mac_esp.c           |  7 +++++--
 drivers/scsi/sun3x_esp.c         |  7 +++++--
 drivers/scsi/sun_esp.c           |  7 +++++--
 drivers/scsi/ufs/ufshcd-pci.c    | 19 +++++++++++++++++--
 drivers/scsi/ufs/ufshcd-pltfrm.c | 19 +++++++++++++++++--
 drivers/scsi/ufs/ufshcd.c        | 19 +++++++++++++++----
 drivers/scsi/ufs/ufshcd.h        |  5 ++++-
 11 files changed, 96 insertions(+), 23 deletions(-)

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
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

