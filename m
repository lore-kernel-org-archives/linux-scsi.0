From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2 00/03] target: Initial merge of v4.0.0-rc6 for .38
Date: Fri, 17 Dec 2010 13:11:15 -0800
Message-ID: <1292620296-22822-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.218]:29899 "HELO
	nm20-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756355Ab0LQVLv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 16:11:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings James,

Here is a resend of the series with a broken out patch #2 for the core
target logic.  This following series is based on scsi-misc-2.6.git/master
and has been cut against v2.6.37-rc5.  It contains 21 seperate patches to add
Target v4.0.0-rc6 and TCM_Loop virtual SCSI LLD code for the .38 merge window.
Please git rebase+squash target patches 02a -> 02s into a single commit.

A pullable version of this series is available from:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-misc-2.6.git merge-for-38-v2

and the individual patches are also available as individual files here:

http://www.kernel.org/pub/linux/kernel/people/nab/TCM-v4-patches-for-v2.6.38-v2/

The individual respective RFCv3, RFCv2 and RFCv1 patches of TCM v4.0 for .37
can be found here:

[RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
http://marc.info/?l=linux-kernel&m=128744135522606&w=2

[RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
http://marc.info/?l=linux-kernel&m=128519571622744&w=2

[RFC 00/22] TCM Core and TCM_Loop patches for v2.6.37
http://marc.info/?l=linux-scsi&m=128316004105485&w=2

The individual TCM v4.0.0-rc announcements can be found here:

[ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
http://marc.info/?l=linux-scsi&m=129255806118306&w=2

[ANNOUNCE] TCM/LIO v4.0.0-rc5 for 2.6.36-rc8
http://marc.info/?l=linux-scsi&m=128739657813518&w=2

[ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
http://marc.info/?l=linux-scsi&m=128497455919041&w=2

[ANNOUNCE] TCM/LIO v4.0.0-rc3 for 2.6.36-rc3
http://marc.info/?l=linux-scsi&m=128312775110418&w=2

[ANNOUNCE] TCM/LIO: v4.0.0-rc2 for v2.6.35
http://marc.info/?l=linux-scsi&m=128090716528454&w=2

Best Regards,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

*** BLURB HERE ***

Nicholas Bellinger (21):
  scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action
    definitions
  target: Add ConfigFS extended macro set
  target: Add v4 base data structures and struct target_core_fabric_ops
  target: Add SPC-4 explict and implict Asymmetric Logical Unit Access
    (ALUA)
  target: Add ConfigFS subsystem backstore infrastructure
  target: Add fabric and subsystem transport engine core
  target: Add HBA core infrastructure
  target: Add device core infrastructure
  target: Add target portal group infrastructure
  target: Add SPC-4 compliant Persistent Reservations (PR)
  target: Add Task Management infrastructure
  target: Add UNIT_ATTENTION infrastructure support
  target: Add SCSI MIB statistics support
  target: Add FILEIO subsystem plugin
  target: Add IBLOCK subsystem plugin
  target: Add PSCSI subsystem plugin
  target: Add RAMDISK_DR and RAMDISK_MCP subsystem plugins
  target: Add generic fabric independent ConfigFS infrastructure
  target: Add generic ProtoID and TransportID fabric handlers for SAS,
    FC, and iSCSI
  target: Add Kbuild and Kconfig for drivers/target and
    Documentation/target/
  tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module

 Documentation/target/tcm_mod_builder.py        | 1094 +++++
 Documentation/target/tcm_mod_builder.txt       |  145 +
 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    1 +
 drivers/target/Kconfig                         |   33 +
 drivers/target/Makefile                        |   27 +
 drivers/target/target_core_alua.c              | 1991 ++++++++
 drivers/target/target_core_alua.h              |  126 +
 drivers/target/target_core_cdb.c               | 1131 +++++
 drivers/target/target_core_configfs.c          | 3231 +++++++++++++
 drivers/target/target_core_device.c            | 1694 +++++++
 drivers/target/target_core_fabric_configfs.c   | 1001 ++++
 drivers/target/target_core_fabric_lib.c        |  451 ++
 drivers/target/target_core_file.c              |  688 +++
 drivers/target/target_core_file.h              |   50 +
 drivers/target/target_core_hba.c               |  185 +
 drivers/target/target_core_hba.h               |    7 +
 drivers/target/target_core_iblock.c            |  808 ++++
 drivers/target/target_core_iblock.h            |   40 +
 drivers/target/target_core_mib.c               | 1078 +++++
 drivers/target/target_core_mib.h               |   28 +
 drivers/target/target_core_pr.c                | 4251 ++++++++++++++++
 drivers/target/target_core_pr.h                |   67 +
 drivers/target/target_core_pscsi.c             | 1471 ++++++
 drivers/target/target_core_pscsi.h             |   65 +
 drivers/target/target_core_rd.c                | 1091 +++++
 drivers/target/target_core_rd.h                |   73 +
 drivers/target/target_core_scdb.c              |  105 +
 drivers/target/target_core_scdb.h              |   10 +
 drivers/target/target_core_tmr.c               |  395 ++
 drivers/target/target_core_tpg.c               |  826 ++++
 drivers/target/target_core_transport.c         | 6133 ++++++++++++++++++++++++
 drivers/target/target_core_ua.c                |  332 ++
 drivers/target/target_core_ua.h                |   36 +
 drivers/target/tcm_loop/Kconfig                |   11 +
 drivers/target/tcm_loop/Makefile               |   11 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  647 +++
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 +
 drivers/target/tcm_loop/tcm_loop_core.h        |   77 +
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  473 ++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   40 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  605 +++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 include/scsi/scsi.h                            |   28 +
 include/target/configfs_macros.h               |  147 +
 include/target/target_core_base.h              |  936 ++++
 include/target/target_core_configfs.h          |   52 +
 include/target/target_core_device.h            |   61 +
 include/target/target_core_fabric_configfs.h   |  106 +
 include/target/target_core_fabric_lib.h        |   28 +
 include/target/target_core_fabric_ops.h        |  100 +
 include/target/target_core_tmr.h               |   43 +
 include/target/target_core_tpg.h               |   35 +
 include/target/target_core_transport.h         |  350 ++
 54 files changed, 32428 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/target/tcm_mod_builder.py
 create mode 100644 Documentation/target/tcm_mod_builder.txt
 create mode 100644 drivers/target/Kconfig
 create mode 100644 drivers/target/Makefile
 create mode 100644 drivers/target/target_core_alua.c
 create mode 100644 drivers/target/target_core_alua.h
 create mode 100644 drivers/target/target_core_cdb.c
 create mode 100644 drivers/target/target_core_configfs.c
 create mode 100644 drivers/target/target_core_device.c
 create mode 100644 drivers/target/target_core_fabric_configfs.c
 create mode 100644 drivers/target/target_core_fabric_lib.c
 create mode 100644 drivers/target/target_core_file.c
 create mode 100644 drivers/target/target_core_file.h
 create mode 100644 drivers/target/target_core_hba.c
 create mode 100644 drivers/target/target_core_hba.h
 create mode 100644 drivers/target/target_core_iblock.c
 create mode 100644 drivers/target/target_core_iblock.h
 create mode 100644 drivers/target/target_core_mib.c
 create mode 100644 drivers/target/target_core_mib.h
 create mode 100644 drivers/target/target_core_pr.c
 create mode 100644 drivers/target/target_core_pr.h
 create mode 100644 drivers/target/target_core_pscsi.c
 create mode 100644 drivers/target/target_core_pscsi.h
 create mode 100644 drivers/target/target_core_rd.c
 create mode 100644 drivers/target/target_core_rd.h
 create mode 100644 drivers/target/target_core_scdb.c
 create mode 100644 drivers/target/target_core_scdb.h
 create mode 100644 drivers/target/target_core_tmr.c
 create mode 100644 drivers/target/target_core_tpg.c
 create mode 100644 drivers/target/target_core_transport.c
 create mode 100644 drivers/target/target_core_ua.c
 create mode 100644 drivers/target/target_core_ua.h
 create mode 100644 drivers/target/tcm_loop/Kconfig
 create mode 100644 drivers/target/tcm_loop/Makefile
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_core.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h
 create mode 100644 include/target/configfs_macros.h
 create mode 100644 include/target/target_core_base.h
 create mode 100644 include/target/target_core_configfs.h
 create mode 100644 include/target/target_core_device.h
 create mode 100644 include/target/target_core_fabric_configfs.h
 create mode 100644 include/target/target_core_fabric_lib.h
 create mode 100644 include/target/target_core_fabric_ops.h
 create mode 100644 include/target/target_core_tmr.h
 create mode 100644 include/target/target_core_tpg.h
 create mode 100644 include/target/target_core_transport.h

-- 
1.7.3.4

