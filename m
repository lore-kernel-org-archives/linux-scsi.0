From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] final set of SCSI updates for the merge window
Date: Wed, 16 Dec 2009 23:51:36 +0100
Message-ID: <1261003896.14435.157.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48524 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZLPWvr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 17:51:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

It contains the new cciss scsi driver (hpsa) and an assortment of driver
updates and bug fixes.

The patch is available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

It's been well tested and integrated in linux-next, so there should be
no merge surprises.

The short changelog is:

Abhijeet Joglekar (1):
      libfc: remote port gets stuck in restart state without really restarting

Adam Radford (1):
      3w-9xxx fix bug in sgl loading

Anil Ravindranath (1):
      pmcraid: support SMI-S object model of storage pool

Anil Veerabhadrappa (5):
      bnx2i: minor code cleanup and update driver version
      bnx2i: Task management ABORT TASK fixes
      bnx2i: update CQ arming algorith for 5771x chipsets
      bnx2i: Adjust sq_size module parametr to power of 2 only if a non-zero value is specified
      bnx2i: Add 5771E device support to bnx2i driver

Anirban Chakraborty (1):
      qla2xxx: fix for multiqueue in MISX disabled case

Boaz Harrosh (1):
      libosd: Fix blk_put_request locking again

Chris Leech (1):
      libfc: reduce hold time on SCSI host lock

FUJITA Tomonori (1):
      st: fix mdata->page_order handling

Giridhar Malavali (2):
      qla2xxx: Update version number to 8.03.01-k8.
      qla2xxx: Queue depth ramp up/down modification changes.

James Bottomley (1):
      enclosure: fix oops while iterating enclosure_status array

Jayamohan Kallickal (1):
      be2iscsi: Adding support for various Async messages from chip

Kashyap, Desai (1):
      mpt2sas: add missing initialization of scsih_cmds

Kleber Sacilotto de Souza (1):
      ipr: fix EEH recovery

Martin K. Petersen (2):
      Correctly handle thin provisioning write error
      sd: WRITE SAME(16) / UNMAP support

Michael Reed (2):
      qla2xxx: dpc thread can execute before scsi host has been added
      lpfc: fix hang on SGI ia64 platform

Mike Christie (1):
      fc class: fix fc_transport_init error handling

Moger, Babu (1):
      scsi_dh_rdac: Add two new IBM devices to rdac_dev_list

Noriyuki Fujii (1):
      megaraid_sas: make driver PCI legacy I/O port free driver

Pravin Bathija (1):
      mpt fusion: Fix 32 bit platforms with 64 bit resources.

Srinivas (1):
      mvsas: add support for Adaptec ASC-1045/1405 SAS/SATA HBA

Stephen M. Cameron (1):
      hpsa: add driver for HP Smart Array controllers.

Vasu Dev (1):
      fcoe, libfc: adds enable/disable for fcoe interface

Yi Zou (1):
      fcoe: Use LLD's WWPN and WWNN for lport if LLD supports ndo_fcoe_get_wwn

jack wang (9):
      pm8001: misc code cleanup
      pm8001: enable read HBA SAS address from VPD
      pm8001: do not reset local sata as it will not be found if reset
      pm8001: bit set pm8001_ha->flags
      pm8001:fix potential NULL pointer dereference
      pm8001: set SSC down-spreading only to get less errors on some 6G device.
      pm8001: fix endian issues with SAS address
      pm8001: enhance error handle for IO patch
      pm8001: Fix for sata io circular lock dependency.

kxie@chelsio.com (1):
      cxgb3i: always use negative errno in case of error

and the diffstat:

 drivers/message/fusion/mptbase.c           |    6 
 drivers/misc/enclosure.c                   |    1 
 drivers/scsi/3w-9xxx.c                     |   11 
 drivers/scsi/Kconfig                       |   10 
 drivers/scsi/Makefile                      |    1 
 drivers/scsi/be2iscsi/be_cmds.c            |   12 
 drivers/scsi/bnx2i/bnx2i.h                 |    1 
 drivers/scsi/bnx2i/bnx2i_hwi.c             |   51 
 drivers/scsi/bnx2i/bnx2i_init.c            |   16 
 drivers/scsi/bnx2i/bnx2i_iscsi.c           |    2 
 drivers/scsi/cxgb3i/cxgb3i_offload.c       |   24 
 drivers/scsi/cxgb3i/cxgb3i_pdu.c           |    4 
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 
 drivers/scsi/fcoe/fcoe.c                   |  135 +
 drivers/scsi/hpsa.c                        | 3531 +++++++++++++++++++++++++++++
 drivers/scsi/hpsa.h                        |  273 ++
 drivers/scsi/hpsa_cmd.h                    |  326 ++
 drivers/scsi/ipr.c                         |    1 
 drivers/scsi/libfc/fc_fcp.c                |   65 
 drivers/scsi/libfc/fc_lport.c              |    7 
 drivers/scsi/libfc/fc_rport.c              |    1 
 drivers/scsi/lpfc/lpfc_init.c              |   16 
 drivers/scsi/megaraid/megaraid_sas.c       |   14 
 drivers/scsi/mpt2sas/mpt2sas_base.c        |    5 
 drivers/scsi/mvsas/mv_init.c               |    1 
 drivers/scsi/osd/osd_initiator.c           |   88 
 drivers/scsi/pm8001/pm8001_ctl.h           |   10 
 drivers/scsi/pm8001/pm8001_hwi.c           |  149 -
 drivers/scsi/pm8001/pm8001_hwi.h           |    3 
 drivers/scsi/pm8001/pm8001_init.c          |   19 
 drivers/scsi/pm8001/pm8001_sas.c           |   57 
 drivers/scsi/pm8001/pm8001_sas.h           |   32 
 drivers/scsi/pmcraid.c                     |   34 
 drivers/scsi/pmcraid.h                     |    5 
 drivers/scsi/qla2xxx/qla_def.h             |    5 
 drivers/scsi/qla2xxx/qla_gbl.h             |    2 
 drivers/scsi/qla2xxx/qla_init.c            |   12 
 drivers/scsi/qla2xxx/qla_isr.c             |  103 
 drivers/scsi/qla2xxx/qla_mid.c             |    4 
 drivers/scsi/qla2xxx/qla_os.c              |   75 
 drivers/scsi/qla2xxx/qla_version.h         |    2 
 drivers/scsi/scsi_lib.c                    |    1 
 drivers/scsi/scsi_transport_fc.c           |   17 
 drivers/scsi/sd.c                          |  107 
 drivers/scsi/sd.h                          |    2 
 drivers/scsi/st.c                          |   23 
 drivers/scsi/st.h                          |    1 
 include/linux/enclosure.h                  |    2 
 include/scsi/osd_initiator.h               |    5 
 49 files changed, 4914 insertions(+), 360 deletions(-)

James


