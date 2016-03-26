From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.5+ merge window
Date: Sat, 26 Mar 2016 07:35:56 -0400
Message-ID: <1458992156.4161.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52894 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbcCZLgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Mar 2016 07:36:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

The only new stuff which missed the first pull request is an update to
the UFS driver.  The rest is an assortment of bug fixes and minor
tweaks which appeared recently (some are fixes for recent code and some
are stuff spotted recently by the checkers or the new gcc-6 compiler
[most of Arnd's stuff]). 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (5):
      scsi: ufs: select CONFIG_NLS
      scsi: fc: use get/put_unaligned64 for wwn access
      qla2xxx: avoid maybe_uninitialized warning
      megaraid_sas: add missing curly braces in ioctl handler
      lpfc: fix misleading indentation

Dan Carpenter (1):
      scsi_dh_alua: uninitialized variable in alua_check_vpd()

Douglas Gilbert (1):
      sg: fix dxferp in from_to case

Hannes Reinecke (3):
      scsi_common: do not clobber fixed sense information
      scsi_transport_sas: add 'scsi_target_id' sysfs attribute
      scsi_sysfs: Fix typo in is_bin_visible()

Martin K. Petersen (1):
      sd: Fix discard granularity when LBPRZ=1

Maurizio Lombardi (2):
      fnic: move printk()s outside of the critical code section.
      be2iscsi: set the boot_kset pointer to NULL in case of failure

Sumit Saxena (1):
      megaraid_sas: Don't issue kill adapter for MFI controllers in case of PD list DCMD failure

Vitaly Kuznetsov (1):
      scsi: storvsc: fix SRB_STATUS_ABORTED handling

Yaniv Gardi (17):
      scsi: ufs-qcom: add printouts of testbus debug registers
      scsi: ufs-qcom: enable/disable the device ref clock
      scsi: ufs-qcom: set PA_Local_TX_LCC_Enable before link startup
      scsi: ufs: add device quirk delay before putting UFS rails in LPM
      scsi: ufs: fix leakage during link off state
      scsi: ufs: tune UniPro parameters to optimize hibern8 exit time
      scsi: ufs: handle non spec compliant bkops behaviour by device
      scsi: ufs: add retry for query descriptors
      scsi: ufs: add error recovery after DL NAC error
      scsi: ufs: make error handling bit faster
      scsi: ufs: disable vccq if it's not needed by UFS device
      scsi: ufs: separate device and host quirks
      scsi: ufs: add support to read device and string descriptors
      scsi: ufs: verify hba controller hce reg value
      scsi: ufs: implement scsi host timeout handler
      scsi: ufs: avoid spurious UFS host controller interrupts
      scsi: ufs-qcom: add number of lanes per direction

And the diffstat:

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   3 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   5 +-
 drivers/scsi/megaraid/megaraid_sas.h               |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  17 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  16 +-
 drivers/scsi/scsi_common.c                         |  12 +-
 drivers/scsi/scsi_sas_internal.h                   |   2 +-
 drivers/scsi/scsi_sysfs.c                          |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |   2 +
 drivers/scsi/ufs/Kconfig                           |   1 +
 drivers/scsi/ufs/ufs-qcom.c                        | 155 +++-
 drivers/scsi/ufs/ufs-qcom.h                        |   9 +
 drivers/scsi/ufs/ufs.h                             |  33 +
 drivers/scsi/ufs/ufs_quirks.h                      | 151 ++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  19 +
 drivers/scsi/ufs/ufshcd.c                          | 818 ++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h                          |  40 +-
 drivers/scsi/ufs/ufshci.h                          |   4 +
 drivers/scsi/ufs/unipro.h                          |  22 +
 include/scsi/scsi_transport_fc.h                   |  15 +-
 22 files changed, 1177 insertions(+), 166 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_quirks.h

James


