From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 00/10] FC Sysfs and FCoE attributes
Date: Fri, 11 Mar 2011 13:54:28 -0800
Message-ID: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1CKVyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 16:54:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

v2: First posting came from a scsi-misc tree with two
additional fcoe patches. The posting did not include the
two initial fcoe patches. Those first two patches are
unrelated to this body of work, but are needed for later
patches to apply. V2 includes these two patches.

---

The following series adds a new FC subsystem/sysfs layout
to the kernel. It also adds FCoE attributes to the new devices.
An initial usage by libfc, libfcoe, fcoe and fnic is also in
this series.

This change is quite large and touches a lot of things. My
current TODO list is:

1) target support
2) user space
   - libhbalinux: have a start on support, but not complete
   - libVirt
3) bnx2fc
4) sysfs usage: not sure I'm doing things correctly

At this point I have working code, but I would appreciate
any review comments as there are a lot of design decisions
to be made.

I apologize for the very large patches. I am not sure how
to break them up better. I have tried a few ways, but the
resultant patches tend to be more complicated than when
they are merged. Any suggestions on how to make these
patches smaller or more easily reviewable would be appreciated
as well.

---

Robert Love (10):
      libfcoe: Remove mutex_trylock/restart_syscall checks
      fcoe: Remove mutex_trylock/restart_syscall checks
      fc: Create FC sybsystem
      scsi_transport_fcp: Create FC/SCSI interaction layer
      libfc, libfcoe, fcoe: Make use of FC subsystem
      fc: Add FCoE attributes to FC sysfs
      libfcoe, fcoe: Use FCoE attributes
      fnic: Convert to new FC Sysfs infrastructure
      fc: Add a hbaapi_lib attribute to the fcport structure
      Documentation: Add fc_sysfs document


 Documentation/fc/fc_sysfs.txt           |  192 ++++
 Documentation/fc/libfc_libfcoe_fcoe.txt |   17 
 drivers/Kconfig                         |    2 
 drivers/Makefile                        |    1 
 drivers/fc/Kconfig                      |    8 
 drivers/fc/Makefile                     |   10 
 drivers/fc/fcfabric.c                   |  547 +++++++++++
 drivers/fc/fcfabric_fcoe.c              |  123 ++
 drivers/fc/fcport.c                     |  453 +++++++++
 drivers/fc/fcport_fcoe.c                |  134 +++
 drivers/fc/fcrport.c                    | 1012 ++++++++++++++++++++
 drivers/fc/fcsysfs.c                    |  176 +++
 drivers/fc/fcsysfs.h                    |  102 ++
 drivers/fc/fcvport.c                    |  695 ++++++++++++++
 drivers/fc/fcvport_fcoe.c               |  118 ++
 drivers/scsi/Kconfig                    |   12 
 drivers/scsi/Makefile                   |    1 
 drivers/scsi/fcoe/fcoe.c                |  770 ++++++++-------
 drivers/scsi/fcoe/fcoe.h                |    6 
 drivers/scsi/fcoe/fcoe_ctlr.c           |  310 ++++--
 drivers/scsi/fcoe/fcoe_transport.c      |   36 -
 drivers/scsi/fcoe/libfcoe.h             |    4 
 drivers/scsi/fnic/fnic.h                |   33 -
 drivers/scsi/fnic/fnic_fcs.c            |   32 -
 drivers/scsi/fnic/fnic_isr.c            |   13 
 drivers/scsi/fnic/fnic_main.c           |  412 ++++----
 drivers/scsi/fnic/fnic_res.c            |   47 -
 drivers/scsi/fnic/fnic_scsi.c           |  193 ++--
 drivers/scsi/libfc/fc_disc.c            |    4 
 drivers/scsi/libfc/fc_exch.c            |   11 
 drivers/scsi/libfc/fc_fcp.c             |  120 +-
 drivers/scsi/libfc/fc_libfc.h           |   40 -
 drivers/scsi/libfc/fc_lport.c           |  208 ++--
 drivers/scsi/libfc/fc_npiv.c            |   87 +-
 drivers/scsi/libfc/fc_rport.c           |   19 
 drivers/scsi/scsi_transport_fcp.c       | 1571 +++++++++++++++++++++++++++++++
 include/fc/fc.h                         | 1055 +++++++++++++++++++++
 include/scsi/fc_encode.h                |   40 -
 include/scsi/libfc.h                    |   96 +-
 include/scsi/libfcoe.h                  |   18 
 include/scsi/scsi_transport_fcp.h       |  307 ++++++
 41 files changed, 7926 insertions(+), 1109 deletions(-)
 create mode 100644 Documentation/fc/fc_sysfs.txt
 create mode 100644 Documentation/fc/libfc_libfcoe_fcoe.txt
 create mode 100644 drivers/fc/Kconfig
 create mode 100644 drivers/fc/Makefile
 create mode 100644 drivers/fc/fcfabric.c
 create mode 100644 drivers/fc/fcfabric_fcoe.c
 create mode 100644 drivers/fc/fcport.c
 create mode 100644 drivers/fc/fcport_fcoe.c
 create mode 100644 drivers/fc/fcrport.c
 create mode 100644 drivers/fc/fcsysfs.c
 create mode 100644 drivers/fc/fcsysfs.h
 create mode 100644 drivers/fc/fcvport.c
 create mode 100644 drivers/fc/fcvport_fcoe.c
 create mode 100644 drivers/scsi/scsi_transport_fcp.c
 create mode 100644 include/fc/fc.h
 create mode 100644 include/scsi/scsi_transport_fcp.h

-- 
Thanks, //Rob
