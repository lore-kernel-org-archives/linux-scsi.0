Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD7367280;
	Sun, 21 Jun 2026 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782049921; cv=none; b=L27dXp+B+Ert1BowR6wMwKAxlspDLyYyk4xntpRZpwzFqFJhxsxSaaE4DLqzxeXlHIst/5p/FMNatCYbjgkuKeO8rRBGtJjrsq+hza3106RF64xUKrZkDZ7aiIOSna9wf6vpg8lQKOWpIJwQUun7kxe/QHBRR8PPhOTW7A4k1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782049921; c=relaxed/simple;
	bh=Pa4kNPPQDGkB7iGi4VZYqnxdfjjVlCzZwlyu46Q89nY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m7tL5uOJTsXvcSj5c18aHHQyHn2mKuGKpRmygsY9KYSBQzwQ1igTEHBvfr46ANI0TmQQZB/5EAnSmgq3O86nf8mC21ylwMerD3kPqpLXBXaQK86XQxsYphAD4ielBtRUQs9/vgGrD5/JRpmiQVUhfegBt4JCgzrGiurWlXc9Ng4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id E053F1C03B2;
	Sun, 21 Jun 2026 09:51:57 -0400 (EDT)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] SCSI updates for the 7.1+ merge window
Date: Sun, 21 Jun 2026 09:51:25 -0400
Message-ID: <20260621135133.12271-1-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The following changes since commit 85db7391310b1304d2dc8ae3b0b12105a9567147:

  scsi: target: iscsi: Validate CHAP_R length before base64 decode (2026-05-22 23:06:00 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc

for you to fetch changes up to 4f87e9068bf3aaf45f226261d5efd50bec42c12c:

  Merge branch 7.1/scsi-fixes into 7.2/scsi-staging (2026-06-15 21:01:30 -0400)

----------------------------------------------------------------

Only ufs driver updates this time, apart from which this is just an
assortment of bug fixes and AI assisted changes.  The biggest other
change is the reversion of the sas_user_scan patch which supported a
mpi3mr NVME behaviour but caused major issues for other sas
controllers. The next biggest is the removal of target reset in
tcm_loop.c.

----------------------------------------------------------------
Arnd Bergmann (3):
      scsi: advansys: Drop ISA_DMA_API remnants
      scsi: megaraid_mbox: Reduce stack usage in megaraid_cmm_register()
      scsi: megaraid_mbox: Avoid double kfree()

Bart Van Assche (8):
      scsi: scsi_debug: Remove unused variable sdebug_any_injecting_opt
      scsi: ufs: core: Inline two functions related to UIC commands
      scsi: ufs: core: Complain if UIC argument 2 is invalid
      scsi: ufs: core: Optimize ufshcd_add_uic_command_trace()
      scsi: core: target: Add INQUIRY-related constants to scsi_common.h
      scsi: core: Use the INQUIRY-related constants
      scsi: core: Convert INQUIRY information
      scsi: mailmap: Update Avri Altman's email address

Can Guo (4):
      scsi: ufs: core: Introduce function ufshcd_query_attr_qword()
      scsi: ufs: core: Add support to retrieve and store TX Equalization settings
      scsi: ufs: core: Add a quirk for extended TX EQTR Adapt L0L1L2L3 length
      scsi: ufs: ufs-qcom: Use quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3

Chanwoo Lee (4):
      scsi: ufs: core: Fix NULL pointer dereference in scsi_cmd_priv() calls
      scsi: ufs: Fix wrong value printed in unexpected UPIU response case
      scsi: ufs: Remove unnecessary return in void vops wrappers
      scsi: ufs: Remove redundant vops NULL check and trivial wrapper

Daejun Park (1):
      scsi: ufs: core: Skip link param validation when lanes_per_direction is unset

Dan Carpenter (1):
      scsi: pm8001: Fix error code in non_fatal_log_show()

David Disseldorp (2):
      scsi: target: Fix hexadecimal CHAP_I handling
      scsi: target: Use constant-time crypto_memneq() for CHAP digests

Deepti Jaggi (1):
      scsi: ufs: dt-bindings: Add compatible for SA8797P UFS Host Controller

Evgenii Burenchev (1):
      scsi: snic: vnic_dev: Remove dead store in vnic_dev_discover_res()

Hongjie Fang (1):
      scsi: ufs: core: Handle PM commands timeout before SCSI EH

Ionut Nechita (1):
      scsi: sas: Skip opt_sectors when DMA reports no real optimization hint

Krzysztof Kozlowski (1):
      scsi: ufs: qcom: Unify user-visible "Qualcomm" name

Kumar Meiyappan (2):
      scsi: pm8001: Reject firmware update in fatal error state
      scsi: pm8001: Reject non-fatal dump when controller is crashed

Marco Crivellari (1):
      scsi: scsi_transport_srp: Move long delayed work to system_dfl_long_wq

Martin K. Petersen (2):
      Merge patch series "scsi: ufs: Add persistent TX Equalization settings support"
      Merge branch 7.1/scsi-fixes into 7.2/scsi-staging

Martin Wilck (2):
      scsi: smartpqi: Use shost_to_hba() in pqi_scan_finished()
      scsi: Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans"

Md Shofiqul Islam (2):
      scsi: core: scsi_scan: Fix typo in comment
      scsi: storvsc: Replace symbolic permissions with octal

Mike Christie (1):
      scsi: target: Remove tcm_loop target reset handling

Palash Kambar (3):
      scsi: ufs: core: Configure only active lanes during link
      scsi: ufs: ufs-qcom: Enable Auto Hibern8 clock request support
      scsi: ufs: qcom: dt-bindings: Document the Hawi UFS controller

Piotr Zarycki (1):
      scsi: isci: Remove unused macro scu_get_command_request_logical_port()

Rajeshkumar Sambandham (1):
      scsi: ufs: ufs-pci: Add AMD device ID support

Rosen Penev (1):
      scsi: lpfc: Turn lpfc_queue q_pgs into a flexible array

Samuel Moelius (1):
      scsi: scsi_debug: Fix one-partition tape setup bounds

Sasha Levin (1):
      scsi: ncr53c8xx: Drop CONFIG_ prefix from Zalon-specific compiler defines

Shawn Guo (1):
      scsi: ufs: dt-bindings: Add compatible for Nord UFS Host Controller

Sowon Na (2):
      scsi: ufs: exynos: dt-bindings: Add ExynosAutov920 compatible string
      scsi: ufs: exynos: Add support for ExynosAutov920 SoC

Thorsten Blum (1):
      scsi: scsi_ioctl: Use strnlen() in scsi_ioctl_get_pci()

Uwe Kleine-König (The Capable Hub) (3):
      scsi: ufs: tc-dwc-g210-pci: Simplify initialization of pci_device_id array
      scsi: ufs: ufshcd-pci: Use PCI_VDEVICE and named initializers for pci array
      scsi: mvsas: Don't emit __LINE__ in debug messages

Wang Yan (1):
      scsi: libiscsi: Fix spelling and format errors

Wang Zihan (1):
      scsi: st: Fix typo in documentation

William Theesfeld (1):
      scsi: lpfc: Fix spelling mistakes in comments

Xose Vazquez Perez (1):
      scsi: devinfo: Broaden Promise VTrak E310/E610 identification

Yihang Li (1):
      scsi: hisi_sas: Add slave_destroy interface for v3 hw

 .mailmap                                           |   1 +
 .../bindings/ufs/qcom,sa8255p-ufshc.yaml           |   6 +-
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |   5 +
 .../bindings/ufs/samsung,exynos-ufs.yaml           |   1 +
 Documentation/scsi/st.rst                          |   2 +-
 drivers/hwmon/drivetemp.c                          |   5 +-
 drivers/scsi/Kconfig                               |   1 -
 drivers/scsi/Makefile                              |   4 +-
 drivers/scsi/advansys.c                            |   1 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  12 +-
 drivers/scsi/isci/scu_task_context.h               |   2 -
 drivers/scsi/libiscsi.c                            |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  10 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   6 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  12 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  12 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  12 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  25 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   5 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |  26 +-
 drivers/scsi/megaraid/megaraid_mm.c                |  32 +--
 drivers/scsi/mvsas/mv_sas.h                        |   6 +-
 drivers/scsi/ncr53c8xx.c                           |   2 +-
 drivers/scsi/ncr53c8xx.h                           |   4 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |  13 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   7 +
 drivers/scsi/scsi_debug.c                          |  13 +-
 drivers/scsi/scsi_devinfo.c                        |   4 +-
 drivers/scsi/scsi_ioctl.c                          |  11 +-
 drivers/scsi/scsi_scan.c                           |  37 ++-
 drivers/scsi/scsi_transport_sas.c                  | 101 ++++---
 drivers/scsi/scsi_transport_srp.c                  |  10 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   2 +-
 drivers/scsi/snic/vnic_dev.c                       |   1 -
 drivers/scsi/storvsc_drv.c                         |   8 +-
 drivers/target/iscsi/iscsi_target_auth.c           |   9 +-
 drivers/target/loopback/tcm_loop.c                 |  64 -----
 drivers/ufs/core/ufs-mcq.c                         |   7 +-
 drivers/ufs/core/ufs-sysfs.c                       |  30 ++-
 drivers/ufs/core/ufs-txeq.c                        | 295 +++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h                     |  11 +-
 drivers/ufs/core/ufshcd.c                          | 296 ++++++++++++---------
 drivers/ufs/host/Kconfig                           |   2 +-
 drivers/ufs/host/tc-dwc-g210-pci.c                 |   4 +-
 drivers/ufs/host/ufs-exynos.c                      | 110 ++++++++
 drivers/ufs/host/ufs-qcom.c                        |  13 +
 drivers/ufs/host/ufs-qcom.h                        |  11 +
 drivers/ufs/host/ufshcd-pci.c                      |  30 +--
 include/scsi/scsi_common.h                         |   8 +
 include/scsi/scsi_device.h                         |   7 +-
 include/target/target_core_base.h                  |   5 +-
 include/ufs/ufs.h                                  |   2 +
 include/ufs/ufshcd.h                               |  12 +-
 55 files changed, 899 insertions(+), 424 deletions(-)
