From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 00/10] Adding support to fcoe transport
Date: Wed, 12 Jan 2011 18:19:33 -0800
Message-ID: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1AMCW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:22:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

This is v3 of the series to add fcoe transport as a thin layer to the
existing Open-FCoE framework to allow third-party FCoE HBA drivers to
plug in easily if the default SW HBA fcoe.ko driver is sufficient for
the need. Related previous discussion are in the following threads:
RFC v1:
https://lists.open-fcoe.org/pipermail/devel/2010-December/010865.html
https://lists.open-fcoe.org/pipermail/devel/2011-January/010890.html

RFC v2:
https://lists.open-fcoe.org/pipermail/devel/2011-January/010900.html

Notes on v3:
1. Included 2 of Bhanu's ERESTARTSYS patches as patch 9 and 10.
2. Synced up w/ Open-FCoE's fcoe-next/master, so this series should apply
and build cleanly.
3. Did loop create-> i/o -> destroy test using default transport on
fcoe.ko, with the help from Bhanu on testing this framework using his
fcoe transport driver. 
4. Corresponding changes on fcoe-utils are required to reflect the above
changes, which I expect to follow soon.

thanks,
yi
---

Bhanu Gollapudi (2):
      fcoe: Return ERESTARTSYS on rtnl_trylock failure
      libfcoe: Handle ERESTARTSYS for fcoe transport

Yi Zou (8):
      fcoe: convert fcoe.ko to become an fcoe transport provider driver
      fcoe: prepare fcoe for using fcoe transport
      libfcoe: include fcoe_transport.c into kernel libfcoe module
      libfcoe: remove libfcoe.c, use the same fcoe_ctlr.c instead
      libfcoe: rename libfcoe.c to fcoe_cltr.c for the coming fcoe_transport.c
      libfcoe: add implementation to support fcoe transport
      libfcoe: add fcoe_transport structure defines to include/scsi/libfcoe.h
      libfcoe: move logging macros into the local libfcoe.h header file


 drivers/scsi/fcoe/Makefile         |    2 
 drivers/scsi/fcoe/fcoe.c           |  183 +-
 drivers/scsi/fcoe/fcoe_ctlr.c      | 2682 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_transport.c |  561 +++++++
 drivers/scsi/fcoe/libfcoe.c        | 2708 ------------------------------------
 drivers/scsi/fcoe/libfcoe.h        |   31 
 include/scsi/libfcoe.h             |   43 +
 7 files changed, 3380 insertions(+), 2830 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe_ctlr.c
 create mode 100644 drivers/scsi/fcoe/fcoe_transport.c
 delete mode 100644 drivers/scsi/fcoe/libfcoe.c
 create mode 100644 drivers/scsi/fcoe/libfcoe.h

-- 
Signature: Yi Zou <yi.zou@intel.com>
