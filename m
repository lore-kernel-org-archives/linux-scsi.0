From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 00/11] scsi: fix module reference mismatch for scsi host
Date: Mon, 19 Jan 2015 00:05:58 +0900
Message-ID: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Robert Love <robert.w.love@intel.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, fcoe-devel@open-fcoe.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

While accessing a scsi_device, the use count of the underlying LLDD
module is incremented.  The module reference is retrieved through
.module field of struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except some drivers which consist with the core driver and the actual
LLDDs and scsi_host_template is defined in the core driver.  In these
cases, the actual LLDDs can be unloaded even if the scsi_device is
being accessed.

This patch series fixes the module reference mismatch problem for
ufs, usb-storage, esp_scsi, ahci_platform, and pata_platform drivers
by moving owner module reference field from struct scsi_host_template
to struct Scsi_Host and allowing the LLDDs to set their correct module
reference.

* v4:
- Patch series is almost rewritten as module reference field in
  struct scsi_host_template has been unused anymore.  So Acked-by: and
  Reviewed-by: tags that have been received are deleted.

* v3:
- Add fix for ESP SCSI drivers

* v2:
- Pass correct module reference to usb_stor_probe1() instead of touching
  all ums-* drivers, suggested by Alan Stern

Akinobu Mita (11):
  ata: prepare to move module reference from scsi_host_template to
    Scsi_Host
  iscsi: prepare to move module reference from scsi_host_template to
    Scsi_Host
  cxgbi: prepare to move module reference from scsi_host_template to
    Scsi_Host
  libfc: prepare to move module reference from scsi_host_template to
    Scsi_Host
  53c700: prepare move module reference from scsi_host_template to
    Scsi_Host
  scsi: legacy: prepare to move module reference from scsi_host_template
    to Scsi_Host
  scsi: move module reference from scsi_host_template to Scsi_Host
  scsi: ufs: adjust module reference for scsi host
  usb: storage: adjust module reference for scsi host
  ata: ahci_platform: adjust module reference for scsi host
  ata: pata_of_platform: adjust module reference for scsi host

 drivers/ata/libahci_platform.c | 14 +++++-----
 drivers/ata/libata-core.c      | 22 ++++++++-------
 drivers/ata/libata-scsi.c      |  2 +-
 drivers/ata/libata-sff.c       | 61 +++++++++++++++++++++++-------------------
 drivers/ata/pata_platform.c    | 18 +++++++------
 drivers/scsi/53c700.c          |  9 ++++---
 drivers/scsi/53c700.h          |  7 +++--
 drivers/scsi/cxgbi/libcxgbi.c  |  8 +++---
 drivers/scsi/cxgbi/libcxgbi.h  |  6 +++--
 drivers/scsi/hosts.c           | 16 ++++++-----
 drivers/scsi/libfc/fc_lport.c  | 26 ++++++++++++++++++
 drivers/scsi/libfc/fc_npiv.c   |  2 +-
 drivers/scsi/libiscsi.c        | 12 +++++----
 drivers/scsi/scsi.c            |  4 +--
 drivers/scsi/ufs/ufshcd.c      | 13 ++++-----
 drivers/scsi/ufs/ufshcd.h      |  5 +++-
 drivers/usb/storage/scsiglue.c |  3 ---
 drivers/usb/storage/usb.c      |  9 ++++---
 drivers/usb/storage/usb.h      |  7 +++--
 include/linux/ahci_platform.h  |  9 ++++---
 include/linux/ata_platform.h   | 16 ++++++-----
 include/linux/libata.h         | 52 ++++++++++++++++++++++++-----------
 include/scsi/libfc.h           | 27 +++----------------
 include/scsi/libiscsi.h        |  9 ++++---
 include/scsi/scsi_host.h       | 13 +++++++--
 25 files changed, 224 insertions(+), 146 deletions(-)

Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Karen Xie <kxie@chelsio.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: open-iscsi@googlegroups.com
Cc: fcoe-devel@open-fcoe.org
Cc: linux-ide@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

