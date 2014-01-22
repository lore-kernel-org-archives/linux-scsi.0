From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.13+ merge window
Date: Wed, 22 Jan 2014 10:04:22 -0800
Message-ID: <1390413862.2372.45.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36872 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbaAVSEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jan 2014 13:04:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch set is a lot of driver updates for qla4xxx, bfa, hpsa,
qla2xxx.  It also removes the aic7xxx_old driver (which has been
deprecated for nearly a decade) and adds support for deadlines in error
handling.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Aaron Lu (1):
      sr: use block layer runtime PM

Adheer Chandravanshi (5):
      qla4xxx: Recreate chap data list during get chap operation
      qla4xxx: Add support for ISCSI_PARAM_LOCAL_IPADDR sysfs attr
      libiscsi: Add local_ipaddr parameter in iscsi_conn struct
      scsi_transport_iscsi: Export ISCSI_PARAM_LOCAL_IPADDR attr for iscsi_connection
      qla4xxx: Update driver version to 5.04.00-k2

Akinobu Mita (1):
      scsi_debug: simplify creation and destruction of driver attribute files

Alan (1):
      mac_scsi: Fix crash on out of memory

Armen Baloyan (5):
      qla2xxx: Replace a constant with a macro definition for host->canqueue assigmnment.
      qla2xxx: Add changes to obtain ISPFX00 adapters product information in accordance with firmware update.
      qla2xxx: Add logic to abort BSG commands for ISPFX00.
      qla2xxx: Fix issue with not displaying node name after system reboot.
      qla2xxx: Print proper QLAFX00 product name at probe.

Atul Deshmukh (1):
      qla2xxx: Clear RISC INT reg only for an event and not always while polling.

Ben Collins (1):
      megaraid: Use resource_size_t for PCI resources, not long

Bodo Stroesser (1):
      st: fix enlarge_buffer

Chad Dupuis (7):
      qla2xxx: Only complete dcbx_comp and lb_portup_comp for virtual port index 0.
      qla2xxx: Use the correct mailbox registers when acknowledging an IDC request on ISP8044.
      qla2xxx: Disable adapter when we encounter a PCI disconnect.
      qla2xxx: Refactor shutdown code so some functionality can be reused.
      Revert "qla2xxx: Ramp down queue depth for attached SCSI devices when driver resources are low."
      qla2xxx: Add BPM support for ISP25xx.
      qla2xxx: Honor execute firmware failures.

Dan Carpenter (1):
      qla4xxx: overflow in qla4xxx_set_chap_entry()

Douglas Gilbert (1):
      MAINTAINERS: update sg entry

Felipe Pena (1):
      lpfc: Fix wrong assignment in lpfc_debugfs.c

Geert Uytterhoeven (1):
      sd: Do not call do_div() with a 64-bit divisor

Geyslan G. Bem (1):
      be2iscsi: fix memory leak in error path

Hannes Reinecke (3):
      Update documentation
      Unlock accesses to eh_deadline
      improved eh timeout handler

Harish Zunjarrao (3):
      qla4xxx: Add support for additional network parameters settings
      iscsi_transport: Additional parameters for network settings
      iscsi_transport: Remove net param enum values

James Bottomley (1):
      Fix erratic device offline during EH

Joe Carnuccio (3):
      qla2xxx: Fix undefined behavior in call to snprintf().
      qla2xxx: Add BSG interface for read/write serdes register.
      qla2xxx: Correctly set mailboxes for extended init control block.

Lalit Chandivade (2):
      qla4xxx: Add host statistics support
      scsi_transport_iscsi: Add host statistics support

Matt Gates (1):
      hpsa: allow SCSI mid layer to handle unit attention

Meelis Roos (1):
      qla1280: Annotate timer on stack so object debug does not complain

Mike Miller (1):
      hpsa: remove P822se PCI ID

Paul Gortmaker (1):
      aci7xxx_old: delete decade+ obsolete driver

Ren Mingxin (1):
      Set the minimum valid value of 'eh_deadline' as 0

Saurav Kashyap (4):
      qla2xxx: Fix warning reported by smatch.
      qla2xxx: Update the driver version to 8.06.00.12-k.
      qla2xxx: Adding MAINTAINERS for qla2xxx FC-SCSI driver
      qla2xxx: Don't consider the drivers knocked out of IDC participation for future reset recovery process.

Sawan Chandak (3):
      qla2xxx: Reset nic_core_reset_owner on moving from COLD to READY for ISP8044
      qla2xxx: Use scnprintf() instead of snprintf() in the sysfs handlers.
      qla2xxx: Disable INTx interrupt for ISP82XX

Stephen M. Cameron (11):
      hpsa: do not require board "not ready" status after hard reset
      hpsa: enable unit attention reporting
      hpsa: rename scsi prefetch field
      hpsa: use workqueue instead of kernel thread for lockup detection
      hpsa: prevent stalled i/o
      hpsa: cap CCISS_PASSTHRU at 20 concurrent commands.
      hpsa: add MSA 2040 to list of external target devices
      hpsa: fix memory leak in CCISS_BIG_PASSTHRU ioctl
      hpsa: remove unneeded include of seq_file.h
      hpsa: add 5 second delay after doorbell reset
      hpsa: do not attempt to flush the cache on locked up controllers

Vijaya Mohan Guvva (8):
      bfa: Driver version upgrade to 3.2.23.0
      bfa: change FC_ELS_TOV to 20sec
      bfa: Observed auto D-port mode instead of manual
      bfa: Fix for bcu or hcm faa query hang
      bfa: LUN discovery issue in direct attach mode
      bfa: Register port with SCSI even on port init failure
      bfa: Firmware patch simplification
      bfa: Chinook quad port 16G FC HBA claim issue

Vikas Chaudhary (2):
      qla4xxx: Update driver version to 5.04.00-k3
      qla4xxx: Added support for Diagnostics MBOX command

wenxiong@linux.vnet.ibm.com (2):
      ipr: increase dump size in ipr driver
      ipr: Increase msi-x interrupt vectors to 16

and the diffstat

 Documentation/scsi/00-INDEX               |     2 -
 Documentation/scsi/aic7xxx_old.txt        |   511 --
 Documentation/scsi/scsi_eh.txt            |    69 +-
 Documentation/scsi/scsi_mid_low_api.txt   |     9 +-
 MAINTAINERS                               |     7 +-
 drivers/scsi/Kconfig                      |    41 -
 drivers/scsi/Makefile                     |     1 -
 drivers/scsi/aic7xxx_old.c                | 11149 ----------------------------
 drivers/scsi/aic7xxx_old/aic7xxx.h        |    28 -
 drivers/scsi/aic7xxx_old/aic7xxx.reg      |  1401 ----
 drivers/scsi/aic7xxx_old/aic7xxx.seq      |  1539 ----
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c   |   270 -
 drivers/scsi/aic7xxx_old/aic7xxx_reg.h    |   629 --
 drivers/scsi/aic7xxx_old/aic7xxx_seq.c    |   817 --
 drivers/scsi/aic7xxx_old/scsi_message.h   |    49 -
 drivers/scsi/aic7xxx_old/sequencer.h      |   135 -
 drivers/scsi/be2iscsi/be_iscsi.c          |     8 +-
 drivers/scsi/bfa/bfa_core.c               |     8 +-
 drivers/scsi/bfa/bfa_defs.h               |     1 +
 drivers/scsi/bfa/bfa_fc.h                 |     2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c          |    15 +-
 drivers/scsi/bfa/bfa_ioc.c                |   727 +-
 drivers/scsi/bfa/bfa_ioc.h                |     7 +-
 drivers/scsi/bfa/bfa_ioc_cb.c             |    23 +
 drivers/scsi/bfa/bfa_svc.c                |     2 +-
 drivers/scsi/bfa/bfad.c                   |    97 +-
 drivers/scsi/bfa/bfad_bsg.c               |    15 +
 drivers/scsi/bfa/bfad_bsg.h               |     1 +
 drivers/scsi/bfa/bfad_drv.h               |     6 +-
 drivers/scsi/bfa/bfi.h                    |    42 +-
 drivers/scsi/hosts.c                      |    31 +-
 drivers/scsi/hpsa.c                       |   241 +-
 drivers/scsi/hpsa.h                       |     9 +-
 drivers/scsi/hpsa_cmd.h                   |     4 +-
 drivers/scsi/ipr.c                        |     2 +-
 drivers/scsi/ipr.h                        |     4 +-
 drivers/scsi/libiscsi.c                   |     6 +
 drivers/scsi/lpfc/lpfc_debugfs.c          |     2 +-
 drivers/scsi/mac_scsi.c                   |     2 +
 drivers/scsi/megaraid/megaraid_sas.h      |     1 -
 drivers/scsi/megaraid/megaraid_sas_base.c |     5 +-
 drivers/scsi/qla1280.c                    |     2 +-
 drivers/scsi/qla2xxx/qla_attr.c           |   116 +-
 drivers/scsi/qla2xxx/qla_bsg.c            |    44 +
 drivers/scsi/qla2xxx/qla_bsg.h            |    13 +
 drivers/scsi/qla2xxx/qla_dbg.c            |     7 +-
 drivers/scsi/qla2xxx/qla_def.h            |    22 +-
 drivers/scsi/qla2xxx/qla_gbl.h            |    15 +-
 drivers/scsi/qla2xxx/qla_init.c           |     2 +
 drivers/scsi/qla2xxx/qla_inline.h         |    19 -
 drivers/scsi/qla2xxx/qla_isr.c            |    82 +-
 drivers/scsi/qla2xxx/qla_mbx.c            |    73 +-
 drivers/scsi/qla2xxx/qla_mr.c             |    39 +-
 drivers/scsi/qla2xxx/qla_mr.h             |    12 +-
 drivers/scsi/qla2xxx/qla_nx.c             |    22 +-
 drivers/scsi/qla2xxx/qla_nx2.c            |    33 +-
 drivers/scsi/qla2xxx/qla_os.c             |   368 +-
 drivers/scsi/qla2xxx/qla_version.h        |     2 +-
 drivers/scsi/qla4xxx/ql4_bsg.c            |   360 +
 drivers/scsi/qla4xxx/ql4_bsg.h            |    13 +
 drivers/scsi/qla4xxx/ql4_def.h            |    40 +
 drivers/scsi/qla4xxx/ql4_fw.h             |   140 +-
 drivers/scsi/qla4xxx/ql4_glbl.h           |     3 +
 drivers/scsi/qla4xxx/ql4_isr.c            |    51 +-
 drivers/scsi/qla4xxx/ql4_mbx.c            |   154 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  2330 ++++--
 drivers/scsi/qla4xxx/ql4_version.h        |     2 +-
 drivers/scsi/scsi.c                       |     9 +-
 drivers/scsi/scsi_debug.c                 |   266 +-
 drivers/scsi/scsi_error.c                 |   229 +-
 drivers/scsi/scsi_pm.c                    |    62 +-
 drivers/scsi/scsi_priv.h                  |     2 +
 drivers/scsi/scsi_sysfs.c                 |    36 +-
 drivers/scsi/scsi_transport_iscsi.c       |   414 +-
 drivers/scsi/sd.c                         |    28 +-
 drivers/scsi/sr.c                         |    37 +-
 drivers/scsi/st.c                         |     5 +-
 include/scsi/iscsi_if.h                   |   230 +-
 include/scsi/libiscsi.h                   |     1 +
 include/scsi/scsi_cmnd.h                  |     1 +
 include/scsi/scsi_driver.h                |     2 +-
 include/scsi/scsi_host.h                  |    10 +
 include/scsi/scsi_transport_iscsi.h       |     4 +
 83 files changed, 5068 insertions(+), 18150 deletions(-)
 delete mode 100644 Documentation/scsi/aic7xxx_old.txt
 delete mode 100644 drivers/scsi/aic7xxx_old.c
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.h
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.reg
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.seq
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_proc.c
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_reg.h
 delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_seq.c
 delete mode 100644 drivers/scsi/aic7xxx_old/scsi_message.h
 delete mode 100644 drivers/scsi/aic7xxx_old/sequencer.h

James


