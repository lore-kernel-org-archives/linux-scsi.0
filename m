From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: TCM v4 and TCM_Loop tree+patches for scsi-misc.git
Date: Thu, 27 May 2010 07:02:21 -0700
Message-ID: <1274968941.16907.31.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:33994 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754963Ab0E0OCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 10:02:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, Joel Becker <joel.becker@oracle.com>, Joe Eykholt <jeykholt@cisco.com>, Richard Sharpe <realrichardsharpe@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>

Good morning James,

Following your instructions the TCM Core v4 infrastructure and TCM_Loop
multi-fabric LLD code has been broken up from lio-core-2.6.git/lio-4.0
to be reviewable rather than historical.  I have made these commits into
a tree tracking your scsi-misc.git/master, that is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-misc-2.6.git master

The commits are also available as individual patches here:

http://www.kernel.org/pub/linux/kernel/people/nab/TCM-v4-patches-for-scsi-misc-v2.6.35-rc1/

I would be happy to post the individual commits to linux-scsi/lkml again
as the last review for v3 was in Sept 2009, but so far all v4 related
patches have been posted with little feedback on linux-scsi.   Please
let me know if you would like me to post this series again for review in
it's entirety to linux-scsi and LKML, or if you have any other comments
or questions.

Best,

--nab

Nicholas Bellinger (23):
  [SCSI]: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action
    definitions
  [configfs]: Add struct configfs_item_operations->check_link() in
    configfs_unlink()
  [TCM]: Add ConfigFS extended macro set
  [TCM]: Add v4 base data structures and struct target_core_fabric_ops
  [TCM]: Add SPC-4 explict and implict Asymmetric Logical Unit Access
    (ALUA)
  [TCM]: Add core subsystem backstore configfs infrastructure
  [TCM]: Add core fabric transport engine
  [TCM]: Add HBA core infrastructure
  [TCM]: Add device core infrastructure
  [TCM]: Add target portal group infrastructure
  [TCM]: Add SE object device infrastructure
  [TCM]: Add SPC-4 compliant Persistent Reservations
  [TCM]: Add Task Management infrastructure
  [TCM]: Add UNIT_ATTENTION infrastructure support
  [TCM]: Add support for SCSI MIB statistics
  [TCM]: Add FILEIO subsystem plugin
  [TCM]: Add IBLOCK subsystem plugin
  [TCM]: Add PSCSI subsystem plugin
  [TCM]: Add RAMDISK_DR and RAMDISK_MCP subsystem plugins
  [TCM]: Add generic fabric independent configfs infrastructure
  [TCM]: Add generic ProtoID and TransportID fabric handlers for SAS,
    FC, and iSCSI
  [TCM]: Add Kbuild and Kconfig and update drivers/
  [TCM_Loop]: Add multi-fabric Linux/SCSI LLD fabric module

 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    1 +
 drivers/target/Kbuild                          |   52 +
 drivers/target/Kconfig                         |   57 +
 drivers/target/target_core_alua.c              | 1990 ++++++
 drivers/target/target_core_configfs.c          | 3351 ++++++++++
 drivers/target/target_core_device.c            | 1632 +++++
 drivers/target/target_core_fabric_configfs.c   |  971 +++
 drivers/target/target_core_fabric_lib.c        |  456 ++
 drivers/target/target_core_file.c              | 1090 ++++
 drivers/target/target_core_hba.c               |  201 +
 drivers/target/target_core_iblock.c            | 1058 +++
 drivers/target/target_core_mib.c               | 1064 +++
 drivers/target/target_core_plugin.c            |  326 +
 drivers/target/target_core_pr.c                | 4248 ++++++++++++
 drivers/target/target_core_pscsi.c             | 1849 ++++++
 drivers/target/target_core_rd.c                | 1422 ++++
 drivers/target/target_core_scdb.c              |  154 +
 drivers/target/target_core_seobj.c             |  679 ++
 drivers/target/target_core_tmr.c               |  401 ++
 drivers/target/target_core_tpg.c               |  860 +++
 drivers/target/target_core_transport.c         | 8234 ++++++++++++++++++++++++
 drivers/target/target_core_ua.c                |  336 +
 drivers/target/tcm_loop/Kbuild                 |   11 +
 drivers/target/tcm_loop/Kconfig                |   13 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  678 ++
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 +
 drivers/target/tcm_loop/tcm_loop_core.h        |   79 +
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  567 ++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   45 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  659 ++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 fs/configfs/symlink.c                          |   13 +
 include/linux/configfs.h                       |    1 +
 include/scsi/scsi.h                            |   24 +
 include/target/configfs_macros.h               |  147 +
 include/target/target_core_alua.h              |  134 +
 include/target/target_core_base.h              | 1039 +++
 include/target/target_core_configfs.h          |   84 +
 include/target/target_core_device.h            |   85 +
 include/target/target_core_fabric_configfs.h   |  106 +
 include/target/target_core_fabric_lib.h        |   28 +
 include/target/target_core_fabric_ops.h        |   89 +
 include/target/target_core_file.h              |  223 +
 include/target/target_core_hba.h               |   43 +
 include/target/target_core_iblock.h            |  173 +
 include/target/target_core_mib.h               |   56 +
 include/target/target_core_plugin.h            |   73 +
 include/target/target_core_pr.h                |   67 +
 include/target/target_core_pscsi.h             |  202 +
 include/target/target_core_rd.h                |  259 +
 include/target/target_core_scdb.h              |   42 +
 include/target/target_core_seobj.h             |  114 +
 include/target/target_core_tmr.h               |   43 +
 include/target/target_core_tpg.h               |   65 +
 include/target/target_core_transport.h         |  557 ++
 include/target/target_core_transport_plugin.h  |   67 +
 include/target/target_core_ua.h                |   36 +
 58 files changed, 36268 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/Kbuild
 create mode 100644 drivers/target/Kconfig
 create mode 100644 drivers/target/target_core_alua.c
 create mode 100644 drivers/target/target_core_configfs.c
 create mode 100644 drivers/target/target_core_device.c
 create mode 100644 drivers/target/target_core_fabric_configfs.c
 create mode 100644 drivers/target/target_core_fabric_lib.c
 create mode 100644 drivers/target/target_core_file.c
 create mode 100644 drivers/target/target_core_hba.c
 create mode 100644 drivers/target/target_core_iblock.c
 create mode 100644 drivers/target/target_core_mib.c
 create mode 100644 drivers/target/target_core_plugin.c
 create mode 100644 drivers/target/target_core_pr.c
 create mode 100644 drivers/target/target_core_pscsi.c
 create mode 100644 drivers/target/target_core_rd.c
 create mode 100644 drivers/target/target_core_scdb.c
 create mode 100644 drivers/target/target_core_seobj.c
 create mode 100644 drivers/target/target_core_tmr.c
 create mode 100644 drivers/target/target_core_tpg.c
 create mode 100644 drivers/target/target_core_transport.c
 create mode 100644 drivers/target/target_core_ua.c
 create mode 100644 drivers/target/tcm_loop/Kbuild
 create mode 100644 drivers/target/tcm_loop/Kconfig
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_core.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h
 create mode 100644 include/target/configfs_macros.h
 create mode 100644 include/target/target_core_alua.h
 create mode 100644 include/target/target_core_base.h
 create mode 100644 include/target/target_core_configfs.h
 create mode 100644 include/target/target_core_device.h
 create mode 100644 include/target/target_core_fabric_configfs.h
 create mode 100644 include/target/target_core_fabric_lib.h
 create mode 100644 include/target/target_core_fabric_ops.h
 create mode 100644 include/target/target_core_file.h
 create mode 100644 include/target/target_core_hba.h
 create mode 100644 include/target/target_core_iblock.h
 create mode 100644 include/target/target_core_mib.h
 create mode 100644 include/target/target_core_plugin.h
 create mode 100644 include/target/target_core_pr.h
 create mode 100644 include/target/target_core_pscsi.h
 create mode 100644 include/target/target_core_rd.h
 create mode 100644 include/target/target_core_scdb.h
 create mode 100644 include/target/target_core_seobj.h
 create mode 100644 include/target/target_core_tmr.h
 create mode 100644 include/target/target_core_tpg.h
 create mode 100644 include/target/target_core_transport.h
 create mode 100644 include/target/target_core_transport_plugin.h
 create mode 100644 include/target/target_core_ua.h


