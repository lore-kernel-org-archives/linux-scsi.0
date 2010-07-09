From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 00/24] bfa: Update driver to 2.2.2.1 (resubmit)
Date: Thu, 8 Jul 2010 19:44:13 -0700
Message-ID: <1278643453-26418-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55459 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab0GICob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:44:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Hi James,

This patch set has been redone by removing its dependency on the previous
patch that enables sysfs based debug feature. The sysfs debug feature, as you
suggested, has been re-implemented using debugfs (patch 24/24).
 
Changes in patch 1/24 ~ 23/24 remain the same as the last submission.
As a summary, we are adding support of two new mezzanine cards for HP
(Brocade 804 FCHBA) and IBM (Brocade 1007 CNA) blade server. Features such
PBC configuration, PBC vport create, and BOFM support etc. are added along with
the new hardware enablement. And we are submitting all the bug fixes
implemented in our internal 2.2 driver development cycle. The driver
version is updated to 2.2.2.1 to reflect all the changes.

Thanks

Jing

Jing Huang (24):
  bfa: enable new hardware
  bfa: enable basic PBC support
  bfa: PBC vport create
  bfa: vport state machine fix
  bfa: ioc attributes fix
  bfa: statistics and typo fix
  bfa: use standards defined timeout for ELS/CT
  bfa: fix interrupt coalescing setting
  bfa: fix rport speed setting
  bfa: fix prli retry issues
  bfa: add PBC port disable handling
  bfa: update to support firmware configuation
  bfa: fix chip and memory initialization
  bfa: fix uf post and rport fcpim state machine
  bfa: add dynamic queue selection
  bfa: fix link state structure
  bfa: fix possible IO double completion
  bfa: update to support BOFM
  bfa: add description for module parameters
  bfa: add ioc state checking
  bfa: fix wrong arg to callback
  bfa: vport fixes
  bfa: update driver version string
  bfa: add debugfs support

 drivers/scsi/bfa/Makefile                        |    2 +-
 drivers/scsi/bfa/bfa_cb_ioim_macros.h            |    7 +-
 drivers/scsi/bfa/bfa_core.c                      |    1 +
 drivers/scsi/bfa/bfa_fcpim.c                     |   29 +-
 drivers/scsi/bfa/bfa_fcpim_priv.h                |    6 +-
 drivers/scsi/bfa/bfa_fcport.c                    |  139 +++++--
 drivers/scsi/bfa/bfa_fcs.c                       |   10 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                 |    3 +
 drivers/scsi/bfa/bfa_fcxp.c                      |   14 +-
 drivers/scsi/bfa/bfa_fwimg_priv.h                |   25 +-
 drivers/scsi/bfa/bfa_hw_cb.c                     |    7 +-
 drivers/scsi/bfa/bfa_hw_ct.c                     |    7 +-
 drivers/scsi/bfa/bfa_intr.c                      |    1 +
 drivers/scsi/bfa/bfa_ioc.c                       |  172 +++----
 drivers/scsi/bfa/bfa_ioc.h                       |   12 +-
 drivers/scsi/bfa/bfa_ioc_cb.c                    |   36 +-
 drivers/scsi/bfa/bfa_ioc_ct.c                    |   71 ++--
 drivers/scsi/bfa/bfa_iocfc.c                     |  107 +++--
 drivers/scsi/bfa/bfa_iocfc.h                     |   19 +-
 drivers/scsi/bfa/bfa_ioim.c                      |   63 ++-
 drivers/scsi/bfa/bfa_log_module.c                |   86 ++++
 drivers/scsi/bfa/bfa_lps.c                       |    6 -
 drivers/scsi/bfa/bfa_port.c                      |   31 ++-
 drivers/scsi/bfa/bfa_port_priv.h                 |    7 +-
 drivers/scsi/bfa/bfa_priv.h                      |    3 -
 drivers/scsi/bfa/bfa_rport.c                     |    5 -
 drivers/scsi/bfa/bfa_sgpg.c                      |    5 -
 drivers/scsi/bfa/bfa_uf.c                        |   10 +-
 drivers/scsi/bfa/bfad.c                          |  114 +++++-
 drivers/scsi/bfa/bfad_attr.c                     |   46 ++-
 drivers/scsi/bfa/bfad_debugfs.c                  |  547 ++++++++++++++++++++++
 drivers/scsi/bfa/bfad_drv.h                      |   36 +-
 drivers/scsi/bfa/bfad_fwimg.c                    |   76 +++-
 drivers/scsi/bfa/bfad_im.c                       |   33 ++-
 drivers/scsi/bfa/bfad_im_compat.h                |   13 +-
 drivers/scsi/bfa/bfad_intr.c                     |    8 +-
 drivers/scsi/bfa/fabric.c                        |   44 ++-
 drivers/scsi/bfa/fcpim.c                         |   32 +-
 drivers/scsi/bfa/fcs_fabric.h                    |    5 +
 drivers/scsi/bfa/fcs_rport.h                     |    3 +
 drivers/scsi/bfa/fcs_vport.h                     |    1 +
 drivers/scsi/bfa/fdmi.c                          |    6 +-
 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h       |    8 +
 drivers/scsi/bfa/include/bfa.h                   |    4 +
 drivers/scsi/bfa/include/bfa_fcpim.h             |   20 +-
 drivers/scsi/bfa/include/bfa_svc.h               |    1 +
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h         |    3 +
 drivers/scsi/bfa/include/bfi/bfi_ioc.h           |   20 +-
 drivers/scsi/bfa/include/bfi/bfi_iocfc.h         |    2 +
 drivers/scsi/bfa/include/bfi/bfi_pbc.h           |   62 +++
 drivers/scsi/bfa/include/cna/port/bfa_port.h     |    1 +
 drivers/scsi/bfa/include/cs/bfa_debug.h          |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h    |    6 +-
 drivers/scsi/bfa/include/defs/bfa_defs_boot.h    |   10 +
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h  |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h  |   26 +-
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h     |    7 +-
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h   |   12 +-
 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h   |   10 +
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h     |   41 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pci.h     |   11 +-
 drivers/scsi/bfa/include/defs/bfa_defs_port.h    |   14 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h   |   29 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h  |   46 ++-
 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h     |    3 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs.h           |    4 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h     |    1 +
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h     |    1 +
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h     |    4 +
 drivers/scsi/bfa/include/log/bfa_log_linux.h     |    6 +-
 drivers/scsi/bfa/include/protocol/fc.h           |    1 +
 drivers/scsi/bfa/lport_api.c                     |   30 +-
 drivers/scsi/bfa/ms.c                            |    9 +-
 drivers/scsi/bfa/ns.c                            |   14 +-
 drivers/scsi/bfa/rport.c                         |   88 ++++-
 drivers/scsi/bfa/rport_api.c                     |   11 +-
 drivers/scsi/bfa/rport_ftrs.c                    |   14 +-
 drivers/scsi/bfa/scn.c                           |    2 +-
 drivers/scsi/bfa/vport.c                         |   54 ++-
 80 files changed, 1900 insertions(+), 531 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad_debugfs.c
 create mode 100644 drivers/scsi/bfa/include/bfi/bfi_pbc.h

