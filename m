From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/17] lpfc: Add NVME Fabrics support
Date: Tue, 17 Jan 2017 17:20:43 -0800
Message-ID: <587ec2eb.tS3xUguWSaMxUpim%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35913 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdARBUs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:20:48 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so254849wmr.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:20:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


This patch set add support for NVME over Fabrics FC transport.

The internals of the driver are reworked to support being either:
a SCSI initiator; a NVME intiator; both a SCSI initiator and a
NVME initiator; or a NVME target. More background on the internals
is given in patch2 - for the nvme initiator base modifications.

The driver effectively has parallel NVME and SCSI stacks that
utilize their own set of resources. They intersect only at the 
hardware level, mainly in the interrupt handling.

A few new files are added to support the interfaces of the
FC transport LLDD api for NVME fabrics.

The patches were cut against 1/17 scsi.git tree, misc branch.
** THEY ARE INTENDED FOR THE SCSI.GIT TREE, MISC BRANCH **

To avoid fuzz, the following patches should also be present on
top of the branch:
https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?h=fixes&id=cd60be4916ae689387d04b86b6fc15931e4c95ae
http://www.spinics.net/lists/linux-scsi/msg103766.html

The lpfc version in the linux-block.git tree is rather old. I have a
recipe for how to get it to a version that syncs with the
scsi.git/misc tree so that these patches can apply there as well.
Contact me if you would like it.

-- james


James Smart (17):
  lpfc: Move to new pci_alloc_irq_vectors() interface for intx/msi/msix
  lpfc: NVME Initiator: Base modifications Part A
  lpfc: NVME Initiator: Base modifications Part B
  lpfc: NVME Initiator: Base modifications Part C
  lpfc: NVME Initiator: Base modifications Part D
  lpfc: NVME Initiator: Base modifications Part E
  lpfc: NVME Initiator: Base modifications Part F
  lpfc: NVME Initiator: Merge into FC discovery
  lpfc: NVME Initiator: bind to nvme_fc api
  lpfc: NVME Initiator: Add debugfs support
  lpfc: NVME Target: Base modifications
  lpfc: NVME Target: Receive buffer updates
  lpfc: NVME Target: Merge into FC discovery
  lpfc: NVME Target: bind to nvmet_fc api
  lpfc: NVME Target: Add debugfs support
  lpfc: Update copyrights
  lpfc: Update lpfc version to 11.2.0.7

 drivers/scsi/lpfc/Makefile         |    9 +-
 drivers/scsi/lpfc/lpfc.h           |  147 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  664 ++++++++-
 drivers/scsi/lpfc/lpfc_attr.h      |    3 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   39 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   74 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  470 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c   | 1692 +++++++++++++++++----
 drivers/scsi/lpfc/lpfc_debugfs.h   |  215 ++-
 drivers/scsi/lpfc/lpfc_disc.h      |   22 +-
 drivers/scsi/lpfc/lpfc_els.c       |  405 +++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  345 +++--
 drivers/scsi/lpfc/lpfc_hw.h        |   84 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  502 ++++++-
 drivers/scsi/lpfc/lpfc_init.c      | 2887 +++++++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_logmsg.h    |    6 +-
 drivers/scsi/lpfc/lpfc_mbox.c      |  136 +-
 drivers/scsi/lpfc/lpfc_mem.c       |  280 +++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  240 ++-
 drivers/scsi/lpfc/lpfc_nvme.c      | 2374 +++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvme.h      |  100 ++
 drivers/scsi/lpfc/lpfc_nvmet.c     | 1640 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h     |  110 ++
 drivers/scsi/lpfc/lpfc_scsi.c      |  142 +-
 drivers/scsi/lpfc/lpfc_scsi.h      |   20 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 2250 ++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.h       |   40 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   95 +-
 drivers/scsi/lpfc/lpfc_version.h   |    5 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   19 +-
 30 files changed, 12774 insertions(+), 2241 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h

-- 
2.5.0

