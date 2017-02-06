From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/18] lpfc: Add NVME Fabrics support (11.2.0.7)
Date: Mon, 06 Feb 2017 15:08:49 -0800
Message-ID: <58990201.sRvo7csmw7wowCeB%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33908 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdBFXIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:08:55 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so24972115wmi.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:08:54 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


This patch set add support for NVME over Fabrics FC transport.

The internals of the driver are reworked to support being either:
a SCSI initiator; a NVME intiator; both a SCSI initiator and a
NVME initiator; or a NVME target. More background on the internals
is given in patch 3 - for the nvme initiator base modifications.

The driver effectively has parallel NVME and SCSI stacks that
utilize their own set of resources. They intersect only at the 
hardware level, mainly in the interrupt handling.

A few new files are added to support the interfaces of the
FC transport LLDD api for NVME fabrics.

The patches were cut against 2/3 scsi.git tree, misc branch.
** THEY ARE INTENDED FOR THE SCSI.GIT TREE, MISC BRANCH **

Note: The lpfc version in the linux-block.git tree is rather old.
I have a recipe for how to get it to a version that syncs with the
scsi.git/misc tree so that these patches can apply there as well.
Contact me if you would like it.

-- james


James Smart (18):
  lpfc: Correct WQ creation for pagesize
  Christophs patch 2
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

 drivers/scsi/lpfc/Makefile         |   11 +-
 drivers/scsi/lpfc/lpfc.h           |  155 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  567 ++++++-
 drivers/scsi/lpfc/lpfc_attr.h      |    4 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   33 +-
 drivers/scsi/lpfc/lpfc_bsg.h       |    6 +-
 drivers/scsi/lpfc/lpfc_compat.h    |    4 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   74 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  388 +++--
 drivers/scsi/lpfc/lpfc_debugfs.c   | 1919 +++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_debugfs.h   |  275 ++--
 drivers/scsi/lpfc/lpfc_disc.h      |   24 +-
 drivers/scsi/lpfc/lpfc_els.c       |  334 ++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  363 +++--
 drivers/scsi/lpfc/lpfc_hw.h        |   84 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  506 ++++++-
 drivers/scsi/lpfc/lpfc_ids.h       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c      | 2919 +++++++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_logmsg.h    |    8 +-
 drivers/scsi/lpfc/lpfc_mbox.c      |  116 +-
 drivers/scsi/lpfc/lpfc_mem.c       |  278 +++-
 drivers/scsi/lpfc/lpfc_nl.h        |    4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  238 ++-
 drivers/scsi/lpfc/lpfc_nvme.c      | 2384 +++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvme.h      |  103 ++
 drivers/scsi/lpfc/lpfc_nvmet.c     | 1948 ++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h     |  117 ++
 drivers/scsi/lpfc/lpfc_scsi.c      |  114 +-
 drivers/scsi/lpfc/lpfc_scsi.h      |   22 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 2210 +++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.h       |   42 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   98 +-
 drivers/scsi/lpfc/lpfc_version.h   |   10 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   21 +-
 drivers/scsi/lpfc/lpfc_vport.h     |    4 +-
 35 files changed, 12588 insertions(+), 2799 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h

-- 
2.5.0
