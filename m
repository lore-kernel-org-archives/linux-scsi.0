Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601CB33F58D;
	Mon, 20 Apr 2026 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776704275; cv=none; b=JAAUOq7G7FWpmoyz7vT7OjoZBtYogLiaTGM+5reSLB4d7pdsqMM484TMjRTvJotHvxbrQEe1f5CAhllM/uQp2U0rp9Hq7U1ldJMw+jcCZjx0j25L62QfZBPi+kiOEytpozG6g5hHb+EiDko0OGrq0Ubn3UlPXJlGOsBdDfcmEfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776704275; c=relaxed/simple;
	bh=Kv/2IydUXxtUQdWhisAIyvXAlnKWTuyC+jx9q1NqdsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EQEQ2JWpZfX6OY+h8v4ohIb0HdDU5uR9SKs21LtLhlFj+30C39Wv7499j2mnZmxIGxajQUuA7nsjjIAfkd14jx1HOyWg2tdjBzxdRQBwndB1ezD0sXq3RUoYZUEOwA10xDK5Re8Ohcq7D7edFSBwDOerEuFv5AWeTUwNIN9Uu90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=SFk1HzjD; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SFk1HzjD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1776704271;
	bh=Kv/2IydUXxtUQdWhisAIyvXAlnKWTuyC+jx9q1NqdsI=;
	h=From:To:Subject:Date:Message-ID:From;
	b=SFk1HzjDGmUXjXpyHxTXByHp1adK4X2+HdQ34jB9HJn8t2pqeZaPW1my71l7KLSJG
	 ZfEyPHmxYYtrVARvxfcFStI4UPcIjxuFCUlowiiEPz/4CJp93cXgMcTvYh5rPzO8RQ
	 AbtbNxtiBHtithVPeRGEpghi6bunc0ER0DP/L3/c=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 1E9BF1C02AB;
	Mon, 20 Apr 2026 12:57:51 -0400 (EDT)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] SCSI updates for the 7.0+ merge window
Date: Mon, 20 Apr 2026 12:57:20 -0400
Message-ID: <20260420165721.21651-1-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Usual driver updates (ufs, lpfc, fnic, target, mpi3mr).  The
substantive core changes are adding a 'serial' sysfs attribute and
getting sd to support > PAGE_SIZE sectors.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Aaron Kling (1):
      scsi: ufs: core: Disable timestamp for Kioxia THGJFJT0E25BAIP

Abel Vesa (1):
      scsi: ufs: qcom: dt-bindings: Document the Eliza UFS controller

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Add support for Intel Nova Lake

Alexey Charkov (1):
      scsi: ufs: core: Fix RPMB region size detection for UFS 2.2

Andy Shevchenko (1):
      scsi: ufs: rockchip: Drop unused include

Arnd Bergmann (1):
      scsi: esas2r: Fix __printf annotation on esas2r_log_master()

Bart Van Assche (6):
      scsi: ufs: core: Make the header files self-contained
      scsi: ufs: core: Remove an include directive from ufshcd-crypto.h
      scsi: ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()
      scsi: aic7xxx: Fix compiler warnings triggered by user space code
      scsi: megaraid_sas: Protect more code with instance->reset_mutex
      scsi: fnic: Make fnic_queuecommand() easier to analyze

Can Guo (13):
      scsi: ufs: ufs-qcom: Enable TX Equalization
      scsi: ufs: ufs-qcom: Implement vops apply_tx_eqtr_settings()
      scsi: ufs: ufs-qcom: Implement vops get_rx_fom()
      scsi: ufs: ufs-qcom: Implement vops tx_eqtr_notify()
      scsi: ufs: ufs-qcom: Fixup PAM-4 TX L0_L1_L2_L3 adaptation pattern length
      scsi: ufs: core: Add support to retrain TX Equalization via debugfs
      scsi: ufs: core: Add helpers to pause and resume command processing
      scsi: ufs: core: Add debugfs entries for TX Equalization params
      scsi: ufs: core: Add support for TX Equalization
      scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
      scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a parameter
      scsi: ufs: core: Introduce a new ufshcd vops negotiate_pwr_mode()
      scsi: ufs: core: Add support to notify userspace of UniPro QoS events

Chaohai Chen (1):
      scsi: core: Drop using the host_lock to protect async_scan race condition

Claudiu Beznea (1):
      scsi: mpi3mr: Fix typo

Colin Ian King (1):
      scsi: ufs: ufs-qcom: Fix spelling mistake "retore" -> "restore"

Dave Marquardt (1):
      scsi: fc: Fix typo in fc_els.h

Ed Tsai (2):
      scsi: ufs: host: mediatek: Add VCC on delay for stability
      scsi: ufs: core: Add quirks for VCC ramp-up delay

Eric Biggers (2):
      scsi: iscsi_tcp: Remove unneeded selections of CRYPTO and CRYPTO_MD5
      scsi: lpfc: Use the crc32c() function

Florian Fuchs (1):
      scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP

Greg Kroah-Hartman (1):
      scsi: ses: Handle positive SCSI error from ses_recv_diag()

Igor Pylypiv (1):
      scsi: core: Add 'serial' sysfs attribute for SCSI/SATA

Jan Kiszka (1):
      scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT

Josef Bacik (1):
      scsi: target: tcm_loop: Drain commands in target_reset handler

Joshua Daley (2):
      scsi: virtio_scsi: Kick event_list unconditionally
      scsi: virtio_scsi: Move INIT_WORK calls to virtscsi_probe()

Junrui Luo (1):
      scsi: target: core: Fix integer overflow in UNMAP bounds check

Junxiao Bi (2):
      scsi: core: Fix error handling for scsi_alloc_sdev()
      scsi: core: Fix refcount leak for tagset_refcnt

Justin Tee (23):
      scsi: lpfc: Update lpfc version to 15.0.0.0
      scsi: lpfc: Add PCI ID support for LPe42100 series adapters
      scsi: lpfc: Introduce 128G link speed selection and support
      scsi: lpfc: Check ASIC_ID register to aid diagnostics during failed fw updates
      scsi: lpfc: Update construction of SGL when XPSGL is enabled
      scsi: lpfc: Remove deprecated PBDE feature
      scsi: lpfc: Add REG_VFI mailbox cmd error handling
      scsi: lpfc: Log MCQE contents for mbox commands with no context
      scsi: lpfc: Select mailbox rq_create cmd version based on SLI4 if_type
      scsi: lpfc: Break out of IRQ affinity assignment when mask reaches nr_cpu_ids
      scsi: lpfc: Update lpfc version to 14.4.0.14
      scsi: lpfc: Update copyright year string for 2026
      scsi: lpfc: Restrict first burst to non-FCoE and SLI4 adapters only
      scsi: lpfc: Update class of service bit field to 3 bits for WQE submissions
      scsi: lpfc: Add clean up of aborted NVMe commands during PCI fcn reset
      scsi: lpfc: Fix incorrect txcmplq_cnt during cleanup in lpfc_sli_abort_ring()
      scsi: lpfc: Cleanup error exit paths in lpfc_fdmi_cmd() and associated messages
      scsi: lpfc: Remove unnecessary ndlp kref get in lpfc_check_nlp_post_devloss
      scsi: lpfc: Reduce pointer chasing when accessing vmid_flag
      scsi: lpfc: Use min_t() instead of min() in lpfc_sli4_driver_resource_setup
      scsi: lpfc: Add log messages to fabric login error labels
      scsi: lpfc: Log discarded and insufficient RQE buffer events
      scsi: lpfc: Update log message when ndlp kref get is unsuccessful

Karan Tilak Kumar (6):
      scsi: fnic: Bump up version number
      scsi: fnic: Refactor in_remove flag and call to fnic_fcpio_reset()
      scsi: fnic: Rename fnic_scsi_fcpio_reset()
      scsi: fnic: Do not use GFP_ZERO for mempools
      scsi: fnic: Use mempool for receive frames
      scsi: snic: MAINTAINERS: Update snic maintainers

Kees Cook (1):
      scsi: target: Replace strncpy() with strscpy() in VPD dump functions

Kexin Sun (2):
      scsi: iscsi_tcp: update outdated comment for renamed iscsi_conn_set_callbacks()
      scsi: lpfc: Update outdated comment for renamed lpfc_freenode()

Li RongQing (1):
      scsi: qla2xxx: Use nr_cpu_ids instead of NR_CPUS for qp_cpu_map allocation

Li Tian (1):
      scsi: storvsc: Handle PERSISTENT_RESERVE_IN truncation for Hyper-V vFC

Luca Weiss (1):
      scsi: ufs: qcom,sc7180-ufshc: dt-bindings: Document the Milos UFS Controller

Mathias Krause (1):
      scsi: lpfc: Properly set WC for DPP mapping

Mike Christie (5):
      scsi: target: core: Fix complete_type use
      scsi: vhost-scsi: Report direction completion support
      scsi: target: Allow userspace to set the completion type
      scsi: target: Use driver completion preference by default
      scsi: target: Add support for completing commands from backend context

Nilesh Javali (1):
      scsi: qla2xxx: Add support to report MPI FW state

Pengpeng Hou (1):
      scsi: hpsa: Enlarge controller and IRQ name buffers

Peter Wang (6):
      scsi: ufs: core: Avoid IRQ thread wakeup during active UIC command
      scsi: ufs: core: Support UFSHCI 4.1 CQ entry tag
      scsi: ufs: core: Add debug log for MCQ command timeout
      scsi: ufs: core: Add debug log for UIC command timeout
      scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume
      scsi: ufs: core: Fix possible NULL pointer dereference in ufshcd_add_command_trace()

Pradeep P V K (1):
      scsi: ufs: qcom,sc7180-ufshc: dt-bindings: Add UFSHC compatible for x1e80100

Prithvi Tambewagh (1):
      scsi: target: Fix recursive locking in __configfs_open_file()

Randy Dunlap (1):
      scsi: lpfc: ELIMINATE kernel-doc warnings in lpfc.h

Ranjan Kumar (5):
      scsi: mpi3mr: Add retry mechanism for IOC shutdown with timeout reset
      scsi: mpi3mr: Add queue-full tracking for operational request queues
      scsi: mpi3mr: Reset controller on invalid I/O completion
      scsi: mpi3mr: Clear reset history on ready and recheck state after timeout
      scsi: mpi3mr: Add NULL checks when resetting request and reply queues

Salomon Dushimirimana (1):
      scsi: pm8001: Fix use-after-free in pm8001_queue_command()

Shawn Lin (1):
      scsi: ufs: rockchip,rk3576-ufshc: dt-bindings: Add new mphy reset item

Stefan Hajnoczi (1):
      scsi: target: Don't validate ignored fields in PROUT PREEMPT

Swarna Prabhu (1):
      scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver

Thinh Nguyen (1):
      scsi: target: file: Use kzalloc_flex for aio_cmd

Thomas Fourier (1):
      scsi: snic: Remove unused linkstatus

Thomas Weißschuh (1):
      scsi: libsas: Delete unused to_dom_device() and to_dev_attr()

Thorsten Blum (1):
      scsi: BusLogic: Replace deprecated strcpy() + strcat() in blogic_rdconfig()

Tomas Henzl (1):
      scsi: ses: Fix devices attaching to different hosts

Tyllis Xu (1):
      scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()

Vladimir Riabchun (1):
      scsi: qla2xxx: Completely fix fcport double free

Wang Shuaiwei (1):
      scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend

Won Jung (1):
      scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode

Xingui Yang (1):
      scsi: hisi_sas: Fix NULL pointer exception during user_scan()

Yang Erkun (3):
      scsi: sg: Remove deprecated sg-big-buff
      scsi: sg: Resolve soft lockup issue when opening /dev/sgX
      scsi: sg: Fix sysctl sg-big-buff register during sg_init()

Yang Xiuwei (1):
      scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails

Yihang Li (3):
      scsi: scsi_transport_sas: Fix the maximum channel scanning issue
      scsi: hisi_sas: Fix the risk of overflow in bitwise logical operations
      scsi: hisi_sas: Correct printing format issues

vamshi gajjela (1):
      scsi: ufs: core: Handle MCQ IAG events

wangshuaiwei (1):
      scsi: ufs: core: Fix shift out of bounds when MAXQ=32

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs         |   23 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |   38 +-
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |   14 +
 .../bindings/ufs/rockchip,rk3576-ufshc.yaml        |    7 +-
 MAINTAINERS                                        |    1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    1 +
 drivers/scsi/BusLogic.c                            |    4 +-
 drivers/scsi/Kconfig                               |    3 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.h               |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y          |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l          |    2 +-
 drivers/scsi/elx/efct/efct_lio.c                   |    2 +
 drivers/scsi/esas2r/esas2r_log.c                   |   14 +-
 drivers/scsi/fnic/fdls_disc.c                      |    4 +-
 drivers/scsi/fnic/fip.c                            |    2 +-
 drivers/scsi/fnic/fnic.h                           |    7 +-
 drivers/scsi/fnic/fnic_fcs.c                       |  112 +-
 drivers/scsi/fnic/fnic_fdls.h                      |    2 +-
 drivers/scsi/fnic/fnic_main.c                      |   28 +-
 drivers/scsi/fnic/fnic_scsi.c                      |   70 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   14 +-
 drivers/scsi/hpsa.h                                |    4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    3 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |    1 +
 drivers/scsi/iscsi_tcp.c                           |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |   22 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   27 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    5 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   13 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |    5 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   54 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   44 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |    3 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   37 +-
 drivers/scsi/lpfc/lpfc_ids.h                       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  119 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |    7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   38 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  106 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   37 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  147 ++-
 drivers/scsi/lpfc/lpfc_sli.c                       |  146 +--
 drivers/scsi/lpfc/lpfc_sli4.h                      |    9 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   15 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   16 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  101 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   11 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |    5 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   62 +-
 drivers/scsi/qla2xxx/qla_init.c                    |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |    2 -
 drivers/scsi/qla2xxx/qla_mbx.c                     |    9 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |    2 +
 drivers/scsi/scsi_devinfo.c                        |    2 +-
 drivers/scsi/scsi_lib.c                            |   47 +
 drivers/scsi/scsi_scan.c                           |   17 +-
 drivers/scsi/scsi_sysfs.c                          |   16 +
 drivers/scsi/scsi_transport_sas.c                  |    2 +-
 drivers/scsi/sd.c                                  |   81 +-
 drivers/scsi/ses.c                                 |    7 +-
 drivers/scsi/sg.c                                  |   88 +-
 drivers/scsi/snic/vnic_dev.c                       |    9 -
 drivers/scsi/storvsc_drv.c                         |   37 +-
 drivers/scsi/virtio_scsi.c                         |   14 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |    1 +
 drivers/target/loopback/tcm_loop.c                 |   53 +-
 drivers/target/sbp/sbp_target.c                    |    1 +
 drivers/target/target_core_configfs.c              |   37 +-
 drivers/target/target_core_device.c                |    1 +
 drivers/target/target_core_fabric_configfs.c       |   24 +
 drivers/target/target_core_file.c                  |    2 +-
 drivers/target/target_core_pr.c                    |   59 +-
 drivers/target/target_core_sbc.c                   |    3 +-
 drivers/target/target_core_transport.c             |   68 +-
 drivers/target/tcm_fc/tfc_conf.c                   |    1 +
 drivers/ufs/core/Makefile                          |    2 +-
 drivers/ufs/core/ufs-debugfs.c                     |  290 +++++
 drivers/ufs/core/ufs-debugfs.h                     |    3 +
 drivers/ufs/core/ufs-fault-injection.h             |    2 +
 drivers/ufs/core/ufs-mcq.c                         |   30 +-
 drivers/ufs/core/ufs-sysfs.c                       |   30 +
 drivers/ufs/core/ufs-txeq.c                        | 1293 ++++++++++++++++++++
 drivers/ufs/core/ufshcd-crypto.h                   |    1 -
 drivers/ufs/core/ufshcd-priv.h                     |   61 +-
 drivers/ufs/core/ufshcd.c                          |  307 ++++-
 drivers/ufs/host/ufs-amd-versal2.c                 |    3 -
 drivers/ufs/host/ufs-exynos.c                      |   34 +-
 drivers/ufs/host/ufs-hisi.c                        |   23 +-
 drivers/ufs/host/ufs-mediatek.c                    |   51 +-
 drivers/ufs/host/ufs-mediatek.h                    |    4 +
 drivers/ufs/host/ufs-qcom.c                        |  591 ++++++++-
 drivers/ufs/host/ufs-qcom.h                        |   42 +
 drivers/ufs/host/ufs-rockchip.c                    |    1 -
 drivers/ufs/host/ufs-sprd.c                        |    3 -
 drivers/ufs/host/ufshcd-pci.c                      |    8 +-
 drivers/usb/gadget/function/f_tcm.c                |    1 +
 drivers/vhost/scsi.c                               |    2 +
 drivers/xen/xen-scsiback.c                         |    1 +
 include/scsi/libsas.h                              |    4 -
 include/scsi/scsi_device.h                         |    1 +
 include/scsi/scsi_host.h                           |    7 +-
 include/target/target_core_base.h                  |   10 +
 include/target/target_core_fabric.h                |   12 +-
 include/uapi/scsi/fc/fc_els.h                      |    2 +-
 include/ufs/ufshcd.h                               |  189 ++-
 include/ufs/ufshci.h                               |    3 +
 include/ufs/unipro.h                               |  141 ++-
 110 files changed, 4244 insertions(+), 900 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-txeq.c

Regards,

James
