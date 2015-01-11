From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/4] scsi: ufs & ums-* & esp_scsi: fix module reference counting
Date: Sun, 11 Jan 2015 22:50:02 +0900
Message-ID: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

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

Cc: Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
