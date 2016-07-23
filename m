From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 0/3] nvme-fabrics: Add NVME FC Transport support to lpfc
Date: Fri, 22 Jul 2016 17:24:00 -0700
Message-ID: <5792b920.7v71BUERlAKN8sK4%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34580 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbcGWAYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 20:24:03 -0400
Received: by mail-pf0-f177.google.com with SMTP id p64so45837574pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 17:24:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


This patchset adds NVME support to the lpfc FC driver.  It reworks
the core driver for both NVME and SCSI protocol support, then adds the
nvme-over-fabrics host and target interfaces which connect to the 
NVME FC transport lower-level api.

Patches are cut against the linux-nvme for-4.8/drivers branch

Dependent on:
-the u64 parser patch just posted
-the lpfc 11.2.0.0 patch set posted to linux-scsi a couple weeks back.
 http://www.spinics.net/lists/linux-scsi/msg97964.html
 http://www.spinics.net/lists/linux-scsi/msg98219.html


Caveats:

-Depends on the lpfc 11.2.0.0 patch set posted to linux-scsi being present
 in the tree:
 http://www.spinics.net/lists/linux-scsi/msg97964.html
 http://www.spinics.net/lists/linux-scsi/msg98219.html

-Depends on the NVME FC Transport patches

-cut against the linux-nvme for-4.8/drivers branch

-Individual patches not tested much individually. All testing has been
 with all 3 patches together - base, host, and target.

-Driver depends on NVME-supporting firmware which is not yet generally
 available. Contact me if there is a need to obtain the firmware.

-- james


James Smart (3):
  nvme_fabrics: Rework lpfc base driver to support the NVME protocol
  nvme-fabrics: Add nvme host FC transport support to lpfc driver
  nvme-fabrics: Add nvme target FC transport support to lpfc driver

 drivers/scsi/lpfc/Makefile         |    7 +-
 drivers/scsi/lpfc/lpfc.h           |   43 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   69 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   32 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  379 +++++++---
 drivers/scsi/lpfc/lpfc_debugfs.c   |  636 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_debugfs.h   |  119 ++-
 drivers/scsi/lpfc/lpfc_disc.h      |   17 +-
 drivers/scsi/lpfc/lpfc_els.c       |  212 ++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  352 ++++++++-
 drivers/scsi/lpfc/lpfc_hw.h        |   49 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  128 +++-
 drivers/scsi/lpfc/lpfc_init.c      |  744 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_logmsg.h    |    1 +
 drivers/scsi/lpfc/lpfc_mbox.c      |   19 +-
 drivers/scsi/lpfc/lpfc_mem.c       |  122 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  150 +++-
 drivers/scsi/lpfc/lpfc_nvme.c      | 1447 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvme.h      |   62 ++
 drivers/scsi/lpfc/lpfc_nvmet.c     | 1269 +++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h     |   72 ++
 drivers/scsi/lpfc/lpfc_scsi.c      |   12 +-
 drivers/scsi/lpfc/lpfc_scsi.h      |   19 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  785 +++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli.h       |   30 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   28 +-
 drivers/scsi/lpfc/lpfc_version.h   |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |    1 +
 28 files changed, 6121 insertions(+), 685 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h

-- 
2.5.0

