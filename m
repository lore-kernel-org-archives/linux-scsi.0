Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DE1C8611;
	Fri,  5 Dec 2025 04:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909422; cv=none; b=Wa4fCQDZ2RiAwsTta1MeXJTnSmyhEZoH46zlVttBJ5/cOYBFkrhyrO8Li5UuSscULohOMN/8O4llWkQ5WXWM+3B3h0xVJZf4y4lp9vgW6VZwjj3WzJMIJMao1BsqaRByVm5N/Bwui6bpEIEJOf/FM+xOTGLesmnVtngYB//ktcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909422; c=relaxed/simple;
	bh=MeouZ+HbiEV570GsN0gJaidyRN+8OeQ3LE/djjHzQ9E=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=DKrlmlknmalmrCccLs9VQOUwwnqETRe+PBu5CQaHPz8OjDjjoYL4A74zG8f87nKpg3MBNrBEZQDTC4uLMi0rsrHn3Y7dhOSmBdNR9/q2UA6WpNkOtNv2YRKZ4CQHmj6U9I/4LhypQbCc4WmbpYO6gqaZqNeMCdpUxbHITNu4TQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=dow6uxFG; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="dow6uxFG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764909417;
	bh=MeouZ+HbiEV570GsN0gJaidyRN+8OeQ3LE/djjHzQ9E=;
	h=Message-ID:Subject:From:To:Date:From;
	b=dow6uxFGRPp86i4TiCoGgMleqkACkceevhEPykKSMGWazxwYkcJqFc3lWVWxJ0/ZV
	 0Xrv8Rk8D38HZPKOLwd0IA4tEHtExmPa6B1K6RDbrD4WQRK1anXBKxW8TQopuRlcw9
	 5Lq8Tm8WWfpT+5qQu1TXeHlpj9F3/HXGPF1FwQbE=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 9BA191C0160;
	Thu, 04 Dec 2025 23:36:57 -0500 (EST)
Message-ID: <2a61116be868f8cc576deed89455534860200a2a.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.18+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2025 23:36:56 -0500
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Usual driver updates (ufs, lpfc, target, qla2xxx) plus assorted
cleanups and fixes including the WQ_PERCPU series.=C2=A0 The biggest core
change is the new allocation of pseudo-devices which allow the sending
of internal commands to a given SCSI target.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (4):
      scsi: ufs: core: Fix invalid probe error return value
      scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for In=
tel ADL
      scsi: ufs: core: Add a quirk to suppress link_startup_again
      scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers

Ajay Neeli (1):
      scsi: firmware: xilinx: Add APIs for UFS PHY initialization

Ally Heev (1):
      scsi: scsi_debug: Fix uninitialized pointers with __free attr

Alok Tiwari (2):
      scsi: qla4xxx: Use correct variable in memset for clarity
      scsi: qla4xxx: Fix typos in comments

Andr=C3=A9 Draszik (1):
      scsi: ufs: dt-bindings: exynos: Add power-domains

Bao D. Nguyen (2):
      scsi: ufs: core: Replace hard coded vcc-off delay with a variable
      scsi: ufs: core: Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk

Bart Van Assche (46):
      scsi: MAINTAINERS: Add the UFS include directory
      scsi: scsi_debug: Support injecting unaligned write errors
      scsi: ufs: core: Use scsi_device_busy()
      scsi: ufs: core: Fix single doorbell mode support
      scsi: ufs: core: Remove an unnecessary NULL pointer check
      scsi: ufs: core: Switch to scsi_get_internal_cmd()
      scsi: ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
      scsi: ufs: core: Make blk_mq_tagset_busy_iter() skip reserved request=
s
      scsi: ufs: core: Remove the ufshcd_lrb task_tag member
      scsi: ufs: core: Pass a SCSI pointer instead of an LRB pointer
      scsi: ufs: core: Optimize the hot path
      scsi: ufs: core: Do not clear driver-private command data
      scsi: ufs: core: Make the reserved slot a reserved request
      scsi: ufs: core: Use hba->reserved_slot
      scsi: ufs: core: Call ufshcd_init_lrb() later
      scsi: ufs: core: Allocate the SCSI host earlier
      scsi: ufs: core: Rework the SCSI host queue depth calculation code
      scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()
      scsi: ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
      scsi: ufs: core: Change the monitor function argument types
      scsi: ufs: core: Only call ufshcd_should_inform_monitor() for SCSI co=
mmands
      scsi: ufs: core: Change the type of one ufshcd_send_command() argumen=
t
      scsi: ufs: core: Change the type of one ufshcd_add_command_trace() ar=
gument
      scsi: ufs: core: Only call ufshcd_add_command_trace() for SCSI comman=
ds
      scsi: ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() a=
rgument
      scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
      scsi: scsi_debug: Abort SCSI commands via an internal command
      scsi: core: Make the budget map optional
      scsi: core: Move two statements
      scsi: core: Improve sdev_store_timeout()
      scsi: core: Remove unused code from scsi_sysfs.c
      scsi: target: Simplify target_lu_gp_members_show()
      scsi: target: Do not write NUL characters into ASCII configfs output
      scsi: ufs: core: Revert "Make HID attributes visible"
      scsi: aacraid: Improve code readability
      scsi: ufs: core: Simplify ufshcd_mcq_sq_cleanup() using guard()
      scsi: ufs: core: Remove a goto label from ufshcd_uic_cmd_compl()
      scsi: ufs: core: Move the ufshcd_enable_intr() declaration
      scsi: ufs: core: Remove UFS_DEV_COMP
      scsi: ufs: core: Change the type of uic_command::cmd_active
      scsi: ufs: core: Improve documentation in include/ufs/ufshci.h
      scsi: ufs: core: Reduce link startup failure logging
      scsi: ufs: core: Fix a race condition related to the "hid" attribute =
group
      scsi: core: Do not declare scsi_cmnd pointers const
      scsi: core: Fix the unit attention counter implementation
      scsi: core: Fix a regression triggered by scsi_host_busy()

Bean Huo (3):
      scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices
      scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_stri=
ng_desc()
      scsi: ufs: core: Convert string descriptor format macros to enum

Bhanu Seshu Kumar Valluri (1):
      scsi: smartpqi: Prefer kmalloc_array() over kmalloc()

Dan Carpenter (1):
      scsi: libfc: Prevent integer overflow in fc_fcp_recv_data()

David Jeffery (2):
      scsi: st: Skip buffer flush for information ioctls
      scsi: st: Separate st-unique ioctl handling from SCSI common ioctl ha=
ndling

David Strahan (1):
      scsi: smartpqi: Add support for Hurray Data new controller PCI device

Don Brace (1):
      scsi: smartpqi: Update version to 2.1.36-026

Gustavo A. R. Silva (2):
      scsi: megaraid_sas: Avoid a couple -Wflex-array-member-not-at-end war=
nings
      scsi: isci: Avoid -Wflex-array-member-not-at-end warning

Hannes Reinecke (3):
      scsi: core: Add scsi_{get,put}_internal_cmd() helpers
      scsi: core: Support allocating a pseudo SCSI device
      scsi: core: Support allocating reserved commands

Haotian Zhang (2):
      scsi: sim710: Fix resource leak by adding missing ioport_unmap() call=
s
      scsi: stex: Fix reboot_notifier leak in probe error path

Izhar Ameer Shaikh (1):
      scsi: firmware: xilinx: Add support for secure read/write ioctl inter=
face

Jingyi Wang (1):
      scsi: ufs: phy: dt-bindings: Add QMP UFS PHY compatible for Kaanapali

John Garry (3):
      scsi: core: Introduce .queue_reserved_command()
      scsi: advansys: Don't call asc_prt_scsi_host() -> scsi_host_busy()
      scsi: core: Minor comment fixes for scsi_host_busy()

Junrui Luo (1):
      scsi: aic94xx: fix use-after-free in device removal path

Justin Tee (10):
      scsi: lpfc: Update lpfc version to 14.4.0.12
      scsi: lpfc: Add capability to register Platform Name ID to fabric
      scsi: lpfc: Allow support for BB credit recovery in point-to-point to=
pology
      scsi: lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLO=
GI
      scsi: lpfc: Modify kref handling for Fabric Controller ndlps
      scsi: lpfc: Fix leaked ndlp krefs when in point-to-point topology
      scsi: lpfc: Ensure unregistration of rpis for received PLOGIs
      scsi: lpfc: Remove redundant NULL ptr assignment in lpfc_els_free_ioc=
b()
      scsi: lpfc: Revise discovery related function headers and comments
      scsi: lpfc: Update various NPIV diagnostic log messaging

Krzysztof Kozlowski (1):
      scsi: ufs: dt-bindings: qcom: Drop redundant "reg" constraints

Long Li (1):
      scsi: storvsc: Prefer returning channel with the same CPU as on the I=
/O issuing CPU

Magnus Lindholm (1):
      scsi: qla1280: Fix compiler warnings (DEBUG mode)

Marco Crivellari (16):
      scsi: pm80xx: Add WQ_PERCPU to alloc_workqueue() users
      scsi: target: Add WQ_PERCPU to alloc_workqueue() users
      scsi: qedi: Add WQ_PERCPU to alloc_workqueue() users
      scsi: target: ibmvscsi: Add WQ_PERCPU to alloc_workqueue() users
      scsi: qedf: Add WQ_PERCPU to alloc_workqueue() users
      scsi: bnx2fc: Add WQ_PERCPU to alloc_workqueue() users
      scsi: be2iscsi: Add WQ_PERCPU to alloc_workqueue() users
      scsi: message: fusion: Add WQ_PERCPU to alloc_workqueue() users
      scsi: lpfc: WQ_PERCPU added to alloc_workqueue() users
      scsi: scsi_transport_fc: WQ_PERCPU added to alloc_workqueue users()
      scsi: scsi_dh_alua: WQ_PERCPU added to alloc_workqueue() users
      scsi: qla2xxx: WQ_PERCPU added to alloc_workqueue() users
      scsi: target: sbp: Replace use of system_unbound_wq with system_dfl_w=
q
      scsi: scsi_transport_iscsi: Replace use of system_unbound_wq with sys=
tem_dfl_wq
      scsi: qla2xxx: Replace use of system_unbound_wq with system_dfl_wq
      scsi: fcoe: Add WQ_PERCPU to alloc_workqueue() users

Markus Probst (3):
      scsi: ata: Stop disk on restart if ACPI power resources are found
      scsi: ata: Use ACPI methods to power on disks
      scsi: sd: Add manage_restart device attribute to scsi_disk

Mike Christie (10):
      scsi: target: Move LUN stats to per-CPU
      scsi: target: Create and use macro helpers for per-CPU stats
      scsi: target: Fix LUN/device R/W and total command stats
      scsi: target: Add atomic support to target_core_iblock
      scsi: target: Add WRITE_ATOMIC_16 support to RSOC
      scsi: target: Report atomic values in INQUIRY
      scsi: target: Add WRITE_ATOMIC_16 handler
      scsi: target: Add helper to set up atomic values from block_device
      scsi: target: Add atomic se_device fields
      scsi: target: Rename target_configure_unmap_from_queue()

Mike McGowen (2):
      scsi: smartpqi: Fix device resources accessed after device removal
      scsi: smartpqi: Add timeout value to RAID path requests to physical d=
evices

Naomi Chu (1):
      scsi: ufs: host: mediatek: Support new features for MT6991

Nitin Rawat (2):
      scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3D3)
      scsi: ufs: qcom: dt-bindings: Document the Kaanapali UFS controller

Nuno S=C3=A1 (1):
      scsi: pm: Drop unneeded call to pm_runtime_mark_last_busy()

Peter Wang (13):
      scsi: dt-bindings: phy: mediatek,ufs-phy: Update maintainer informati=
on in mediatek,ufs-phy.yaml
      scsi: ufs: dt-bindings: mediatek,ufs: Update maintainer information i=
n mediatek,ufs.yaml
      scsi: ufs: mediatek: Add the maintainer for MediaTek UFS hooks
      scsi: ufs: host: mediatek: Add support for new platform with MMIO_OTS=
D_CTR
      scsi: ufs: host: mediatek: Remove duplicate function
      scsi: ufs: host: mediatek: Fix shutdown/suspend race condition
      scsi: ufs: host: mediatek: Adjust sync length for FASTAUTO mode
      scsi: ufs: host: mediatek: Handle clock scaling for high gear in PM f=
low
      scsi: ufs: host: mediatek: Adjust clock scaling for PM flow
      scsi: ufs: host: mediatek: Correct clock scaling with PM QoS flow
      scsi: ufs: core: Support dumping CQ entry in MCQ Mode
      scsi: ufs: core: Update CQ Entry to UFS 4.1 format
      scsi: ufs: core: Fix error handler host_sem issue

Qiang Liu (1):
      scsi: fnic: Self-assignment of intr_time_type has no effect

Sai Krishna Potthuri (2):
      scsi: ufs: amd-versal2: Add UFS support for AMD Versal Gen 2 SoC
      scsi: ufs: dt-bindings: amd-versal2: Add UFS Host Controller for AMD =
Versal Gen 2 SoC

Shawn Lin (2):
      scsi: ufs: rockchip: Fix compile error without CONFIG_GPIOLIB
      scsi: ufs: rockchip: Reset controller on PRE_CHANGE of hce enable not=
ify

Thomas Richard (TI.com) (1):
      scsi: ufs: ti-j721e: Add suspend-resume support

Tony Battersby (16):
      scsi: qla2xxx: target: Improve safety of cmd lookup by handle
      scsi: qla2xxx: target: Add back SRR support
      scsi: qla2xxx: target: Improve cmd logging
      scsi: qla2xxx: target: Add cmd->rsp_sent
      scsi: qla2xxx: target: Fix invalid memory access with big CDBs
      scsi: qla2xxx: Fix TMR failure handling
      scsi: qla2xxx: target: Improve checks in qlt_xmit_response() / qlt_rd=
y_to_xfer()
      scsi: qla2xxx: target: Fix races with aborting commands
      scsi: qla2xxx: Clear cmds after chip reset
      scsi: qla2xxx: target: Fix term exchange when cmd_sent_to_fw =3D=3D 1
      scsi: qla2xxx: target: Improve debug output for term exchange
      scsi: qla2xxx: target: Remove code for unsupported hardware
      scsi: qla2xxx: Use reinit_completion on mbx_intr_comp
      scsi: qla2xxx: Fix lost interrupts with qlini_mode=3Ddisabled
      scsi: qla2xxx: Fix initiator mode with qlini_mode=3Dexclusive
      scsi: Revert "scsi: qla2xxx: Perform lockless command completion in a=
bort path"

Wonkon Kim (2):
      scsi: ufs: core: Declare tx_lanes witout initialization
      scsi: ufs: core: Initialize value of an attribute returned by uic cmd

Zilin Guan (1):
      scsi: qla2xxx: Fix improper freeing of purex item

And the diffstat:

 .../devicetree/bindings/phy/mediatek,ufs-phy.yaml  |    3 +-
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |    4 +
 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   |   61 +
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      |    3 +-
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |    2 +
 .../devicetree/bindings/ufs/qcom,ufs.yaml          |    3 -
 .../bindings/ufs/samsung,exynos-ufs.yaml           |    3 +
 MAINTAINERS                                        |   10 +
 drivers/ata/libata-acpi.c                          |   67 +
 drivers/ata/libata-core.c                          |    2 +
 drivers/ata/libata-scsi.c                          |    1 +
 drivers/ata/libata.h                               |    4 +
 drivers/firmware/xilinx/Makefile                   |    2 +-
 drivers/firmware/xilinx/zynqmp-ufs.c               |  118 ++
 drivers/firmware/xilinx/zynqmp.c                   |   46 +
 drivers/message/fusion/mptbase.c                   |    7 +-
 drivers/misc/Kconfig                               |    2 +-
 drivers/scsi/aacraid/linit.c                       |    2 +-
 drivers/scsi/advansys.c                            |    3 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |    3 +
 drivers/scsi/be2iscsi/be_main.c                    |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |    2 +-
 drivers/scsi/fcoe/fcoe.c                           |    2 +-
 drivers/scsi/fnic/fnic_res.c                       |    1 -
 drivers/scsi/hosts.c                               |   24 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |    3 +-
 drivers/scsi/isci/task.h                           |   10 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |    4 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   36 +
 drivers/scsi/lpfc/lpfc_disc.h                      |    3 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  249 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    6 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |   25 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   14 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   21 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   79 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |   17 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    2 +-
 drivers/scsi/qedf/qedf_main.c                      |   15 +-
 drivers/scsi/qedi/qedi_main.c                      |    2 +-
 drivers/scsi/qla1280.c                             |   35 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |    3 +-
 drivers/scsi/qla2xxx/qla_def.h                     |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h                     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c                    |    1 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   32 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |    2 +
 drivers/scsi/qla2xxx/qla_mid.c                     |    4 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   39 +-
 drivers/scsi/qla2xxx/qla_target.c                  | 1791 ++++++++++++++++=
----
 drivers/scsi/qla2xxx/qla_target.h                  |  112 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   17 +
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    8 +-
 drivers/scsi/scsi.c                                |   12 +-
 drivers/scsi/scsi_debug.c                          |  132 +-
 drivers/scsi/scsi_error.c                          |    7 +-
 drivers/scsi/scsi_lib.c                            |  104 +-
 drivers/scsi/scsi_logging.c                        |   21 +-
 drivers/scsi/scsi_pm.c                             |    1 -
 drivers/scsi/scsi_priv.h                           |    1 +
 drivers/scsi/scsi_scan.c                           |   74 +-
 drivers/scsi/scsi_sysfs.c                          |   79 +-
 drivers/scsi/scsi_transport_fc.c                   |    5 +-
 drivers/scsi/scsi_transport_iscsi.c                |    2 +-
 drivers/scsi/sd.c                                  |   34 +-
 drivers/scsi/sim710.c                              |    2 +
 drivers/scsi/smartpqi/smartpqi_init.c              |   49 +-
 drivers/scsi/st.c                                  |   89 +-
 drivers/scsi/stex.c                                |    1 +
 drivers/scsi/storvsc_drv.c                         |   96 +-
 drivers/target/sbp/sbp_target.c                    |    8 +-
 drivers/target/target_core_configfs.c              |   38 +-
 drivers/target/target_core_device.c                |   24 +-
 drivers/target/target_core_fabric_configfs.c       |    2 +-
 drivers/target/target_core_file.c                  |    4 +-
 drivers/target/target_core_iblock.c                |    9 +-
 drivers/target/target_core_internal.h              |    1 +
 drivers/target/target_core_sbc.c                   |   51 +
 drivers/target/target_core_spc.c                   |   49 +-
 drivers/target/target_core_stat.c                  |  268 +--
 drivers/target/target_core_tpg.c                   |   23 +-
 drivers/target/target_core_transport.c             |   26 +-
 drivers/target/target_core_xcopy.c                 |    2 +-
 drivers/target/tcm_fc/tfc_conf.c                   |    2 +-
 drivers/ufs/core/Makefile                          |    1 +
 drivers/ufs/core/ufs-mcq.c                         |   62 +-
 drivers/ufs/core/ufs-rpmb.c                        |  254 +++
 drivers/ufs/core/ufs-sysfs.c                       |    5 +-
 drivers/ufs/core/ufs-sysfs.h                       |    1 -
 drivers/ufs/core/ufs_bsg.c                         |    2 +-
 drivers/ufs/core/ufs_trace.h                       |    1 -
 drivers/ufs/core/ufs_trace_types.h                 |    1 -
 drivers/ufs/core/ufshcd-crypto.h                   |   18 +-
 drivers/ufs/core/ufshcd-priv.h                     |   54 +-
 drivers/ufs/core/ufshcd.c                          |  979 ++++++-----
 drivers/ufs/host/Kconfig                           |   13 +
 drivers/ufs/host/Makefile                          |    1 +
 drivers/ufs/host/ti-j721e-ufs.c                    |   37 +-
 drivers/ufs/host/ufs-amd-versal2.c                 |  564 ++++++
 drivers/ufs/host/ufs-mediatek.c                    |  130 +-
 drivers/ufs/host/ufs-mediatek.h                    |    4 +
 drivers/ufs/host/ufs-qcom.c                        |   18 +-
 drivers/ufs/host/ufs-rockchip.c                    |   20 +-
 drivers/ufs/host/ufshcd-dwc.h                      |   46 +
 drivers/ufs/host/ufshcd-pci.c                      |   70 +-
 include/linux/firmware/xlnx-zynqmp-ufs.h           |   38 +
 include/linux/firmware/xlnx-zynqmp.h               |   16 +
 include/scsi/scsi_dbg.h                            |    4 +-
 include/scsi/scsi_device.h                         |   40 +-
 include/scsi/scsi_host.h                           |   33 +-
 include/target/target_core_backend.h               |    6 +-
 include/target/target_core_base.h                  |   26 +-
 include/ufs/ufs.h                                  |    5 +
 include/ufs/ufs_quirks.h                           |    7 -
 include/ufs/ufshcd.h                               |   36 +-
 include/ufs/ufshci.h                               |   25 +-
 include/ufs/unipro.h                               |    8 +-
 122 files changed, 5113 insertions(+), 1551 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-ufs.y=
aml
 create mode 100644 drivers/firmware/xilinx/zynqmp-ufs.c
 create mode 100644 drivers/ufs/core/ufs-rpmb.c
 create mode 100644 drivers/ufs/host/ufs-amd-versal2.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-ufs.h

Regards,

James

