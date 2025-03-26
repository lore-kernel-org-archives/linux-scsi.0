Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D7C18027;
	Wed, 26 Mar 2025 19:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743016297; cv=none; b=ZwElQvEYCt9QsDtZ1spg8uqxaML5uaG2NB3opBucnyxXE+bfRmqj/2MicwiGpX0nERCtjSB597KvK2pROkZR469KxCDPL1fMHxii0z68D556c/alDUZKC36ai2HmAX80w7RqlQPj5xZcfI2nRijJJweEBNBxPmmXazqVKdppp0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743016297; c=relaxed/simple;
	bh=rnRJxgCOK21p6t0wuXrz0XvqGe0IA41946B7SuzwRKo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=kKalE5MpMUJ6r+SapHoLCMeJAOH0FyIRGMjXucCGebotAHSvwwK00JqEVpLXDipa9QvYp76omVdHQRhjgYO73hxChCWoH5g3vP2oBOzfR3SZa/etjMsTzwKGLUl56dzIlQTTMkqOOMC/DvKlX+YkMFHOLAtE5SH0q+lnXCJMTs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=sYZFhBat; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="sYZFhBat"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1743016292;
	bh=rnRJxgCOK21p6t0wuXrz0XvqGe0IA41946B7SuzwRKo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=sYZFhBatH3WLY1hGUILo/rkRBey/RbFEw/me93f5AvwId9TAQ2enkrGMxTOdAXZVb
	 DKZTyZvjWGM8A+PxIJG4+gJ5cr/nCL3NUvnkpeGRBFQOX0IN3sZS5SCOP3fV6z7Ldk
	 mpmj1KM0/EED24BUFJmFXcZLWy953RXnvcX26oho=
Received: from [172.20.0.78] (unknown [99.209.85.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 5E62B1C001A;
	Wed, 26 Mar 2025 15:11:32 -0400 (EDT)
Message-ID: <e9a26bbadd5e1b7d263a88d70cde134200d2c57c.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.14+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 26 Mar 2025 15:11:31 -0400
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

Updates to the usual drivers (scsi_debug, ufs, lpfc, st, fnic, mpi3mr,
mpt3sas) and the removal of cxlflash.=C2=A0The only non-trivial core change
is an addition to unit attention handling to recognize UAs for power
on/reset and new media so the tape driver can use it.

There's a merge conflict in scsi_debug.c between the hrtimer work
outside of our tree and the simplify command handling in our tree.  To
fix this you need to know the hrtimer setup moved to
sdebug_init_cmd_priv() in the latter change.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andrew Donnellan (1):
      scsi: cxlflash: Remove driver

Andrew Kreimer (1):
      scsi: target: iscsi: Fix typos

Arnd Bergmann (2):
      scsi: hisi_sas: Remove incorrect ACPI_PTR annotations
      scsi: scsi_debug: Fix uninitialized variable use

Avri Altman (1):
      scsi: ufs: core: Critical health condition

Bao D. Nguyen (1):
      scsi: ufs: qcom: Remove dead code in ufs_qcom_cfg_timers()

Bart Van Assche (7):
      scsi: scsi_debug: Do not sleep in atomic sections
      scsi: scsi_debug: Simplify command handling
      scsi: scsi_debug: Remove a reference to in_use_bm
      scsi: mpt3sas: Fix a locking bug in an error path
      scsi: mpi3mr: Fix locking in an error path
      scsi: ufs: Constify the third pwr_change_notify() argument
      scsi: usb: Rename the RESERVE and RELEASE constants

Can Guo (6):
      scsi: ufs: core: Toggle Write Booster during clock scaling base on ge=
ar speed
      scsi: ufs: core: Enable multi-level gear scaling
      scsi: ufs: qcom: Implement the freq_to_gear_speed() vop
      scsi: ufs: core: Add a vop to map clock frequency to gear speed
      scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
      scsi: ufs: core: Pass target_freq to clk_scale_notify() vop

Chandrakanth Patil (1):
      scsi: mpi3mr: Task Abort EH Support

Chaohai Chen (4):
      scsi: core: Use a switch statement when attaching VPD pages
      scsi: core: Fix missing lock protection
      scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()
      scsi: target: spc: Fix RSOC parameter data header size

Charles Han (1):
      scsi: isci: Fix double word in comments

Chen Ni (1):
      scsi: fnic: Remove redundant flush_workqueue() calls

Christophe JAILLET (1):
      scsi: Constify struct pci_error_handlers

Colin Ian King (4):
      scsi: lpfc: Fix spelling mistake 'Toplogy' -> 'Topology'
      scsi: ufs: rockchip: Fix spelling mistake 'susped' -> 'suspend'
      scsi: mpt3sas: Fix spelling mistake "receveid" -> "received"
      scsi: mpi3mr: Fix spelling mistake "skiping" -> "skipping"

Damien Le Moal (1):
      scsi: scsi_error: Add comments to scsi_check_sense()

Dan Carpenter (1):
      scsi: mpt3sas: Fix buffer overflow in mpt3sas_send_mctp_passthru_req(=
)

Dr. David Alan Gilbert (5):
      scsi: isci: Make most module parameters static
      scsi: megaraid_sas: Make most module parameters static
      scsi: mpt3sas: Remove unused config functions
      scsi: message: fusion: Remove unused mptscsih_target_reset()
      scsi: mvsas: Remove unused mvs_phys_reset()

Easwar Hariharan (1):
      scsi: lpfc: Convert timeouts to secs_to_jiffies()

Eric Biggers (1):
      scsi: iscsi_tcp: Switch to using the crc32c library

Ewan D. Milne (1):
      scsi: lpfc: Restore clearing of NLP_UNREG_INP in ndlp->nlp_flag

Geert Uytterhoeven (1):
      scsi: ufs: dt-bindings: renesas,ufs: Add calibration data

Guixin Liu (1):
      scsi: target: tcm_loop: Fix wrong abort tag

Jiapeng Chong (1):
      scsi: ufs: rockchip: Simplify bool conversion

John Garry (1):
      scsi: scsi_debug: Remove sdebug_device_access_info

Justin Tee (6):
      scsi: lpfc: Copyright updates for 14.4.0.8 patches
      scsi: lpfc: Update lpfc version to 14.4.0.8
      scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
      scsi: lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
      scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vect=
or() fails
      scsi: lpfc: Reduce log message generation during ELS ring clean up

Kai M=C3=A4kisara (14):
      scsi: st: Tighten the page format heuristics with MODE SELECT
      scsi: st: ERASE does not change tape location
      scsi: st: Fix array overflow in st_setup()
      scsi: scsi_debug: Add support for partitioning the tape
      scsi: scsi_debug: Reset tape setting at device reset
      scsi: scsi_debug: Add compression mode page for tapes
      scsi: scsi_debug: Add read support and update locate for tapes
      scsi: scsi_debug: Add write support with block lengths and 4 bytes of=
 data
      scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
      scsi: scsi_debug: First fixes for tapes
      scsi: st: Add sysfs file position_lost_in_reset
      scsi: st: Modify st.c to use the new scsi_error counters
      scsi: core: Add counters for New Media and Power On/Reset UNIT ATTENT=
IONs
      scsi: st: Restore some drive settings after reset

Karan Tilak Kumar (5):
      scsi: fnic: Remove unnecessary spinlock locking and unlocking
      scsi: fnic: Replace fnic->lock_flags with local flags
      scsi: fnic: Replace use of sizeof with standard usage
      scsi: fnic: Fix indentation and remove unnecessary parenthesis
      scsi: fnic: Remove unnecessary debug print

Nicolas Bouchinet (1):
      scsi: logging: Fix scsi_logging_level bounds

Paul Menzel (1):
      scsi: mpt3sas: Reduce log level of ignore_delay_remove message to KER=
N_INFO

Peter Wang (1):
      scsi: ufs: core: Add hba parameter to trace events

Ram Kumar Dwivedi (1):
      scsi: ufs: qcom: Enable UFS Shared ICE Feature

Ranjan Kumar (8):
      scsi: mpi3mr: Update driver version to 8.13.0.5.50
      scsi: mpi3mr: Check admin reply queue from Watchdog
      scsi: mpi3mr: Update timestamp only for supervisor IOCs
      scsi: mpi3mr: Update MPI Headers to revision 35
      scsi: mpi3mr: Update driver version to 8.12.1.0.50
      scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply qu=
eue
      scsi: mpi3mr: Support for Segmented Hardware Trace buffer
      scsi: mpi3mr: Avoid reply queue full condition

Roman Kisel (1):
      scsi: storvsc: Don't report the host packet status as the hv status

Shawn Lin (5):
      scsi: ufs: rockchip: Fix devm_clk_bulk_get_all_enabled() return value
      scsi: arm64: dts: rockchip: Add UFS support for RK3576 SoC
      scsi: ufs: rockchip: Initial support for UFS
      scsi: ufs: core: Export ufshcd_dme_reset() and ufshcd_dme_enable()
      scsi: ufs: dt-bindings: Document Rockchip UFS host controller

Shivasharan S (5):
      scsi: mpt3sas: update driver version to 52.100.00.00
      scsi: mpt3sas: Send a diag reset if target reset fails
      scsi: mpt3sas: Report driver capability as part of IOCINFO command
      scsi: mpt3sas: Add support for MCTP Passthrough commands
      scsi: mpt3sas: Update MPI headers to 02.00.62 version

Thorsten Blum (4):
      scsi: fnic: Remove unnecessary NUL-terminations
      scsi: target: Replace deprecated strncpy() with strscpy()
      scsi: hpsa: Replace deprecated strncpy() with strscpy_pad()
      scsi: hpsa: Remove deprecated and unnecessary strncpy()

Xingui Yang (1):
      scsi: hisi_sas: Fixed failure to issue vendor specific commands

Yoshihiro Shimoda (6):
      scsi: ufs: renesas: Add initialization code for R-Car S4-8 ES1.2
      scsi: ufs: renesas: Add reusable functions
      scsi: ufs: renesas: Refactor 0x10ad/0x10af PHY settings
      scsi: ufs: renesas: Remove register control helper function
      scsi: ufs: renesas: Add register read to remove save/set/restore
      scsi: ufs: renesas: Replace init data by init code

Yuichiro Tsuji (1):
      scsi: qla2xxx: Fix typos in a comment

Ziqi Chen (2):
      scsi: ABI: sysfs-driver-ufs: Add missing UFS sysfs attributes
      scsi: ufs: core: Check if scaling up is required when disable clkscal=
e

and the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs         |   45 +
 Documentation/arch/powerpc/cxlflash.rst            |  433 ---
 Documentation/arch/powerpc/index.rst               |    1 -
 .../devicetree/bindings/ufs/renesas,ufs.yaml       |   12 +
 .../bindings/ufs/rockchip,rk3576-ufshc.yaml        |  105 +
 Documentation/scsi/st.rst                          |    5 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    2 +-
 MAINTAINERS                                        |    9 -
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   24 +
 drivers/message/fusion/mptscsih.c                  |   64 +-
 drivers/message/fusion/mptscsih.h                  |    1 -
 drivers/scsi/Kconfig                               |    3 +-
 drivers/scsi/Makefile                              |    1 -
 drivers/scsi/aacraid/aachba.c                      |    4 +-
 drivers/scsi/aacraid/linit.c                       |    2 +-
 drivers/scsi/arm/acornscsi.c                       |    2 +-
 drivers/scsi/be2iscsi/be_main.c                    |    2 +-
 drivers/scsi/bfa/bfad.c                            |    2 +-
 drivers/scsi/csiostor/csio_init.c                  |    2 +-
 drivers/scsi/cxlflash/Kconfig                      |   15 -
 drivers/scsi/cxlflash/Makefile                     |    5 -
 drivers/scsi/cxlflash/backend.h                    |   48 -
 drivers/scsi/cxlflash/common.h                     |  340 --
 drivers/scsi/cxlflash/cxl_hw.c                     |  177 -
 drivers/scsi/cxlflash/lunmgt.c                     |  278 --
 drivers/scsi/cxlflash/main.c                       | 3970 ----------------=
----
 drivers/scsi/cxlflash/main.h                       |  129 -
 drivers/scsi/cxlflash/ocxl_hw.c                    | 1399 -------
 drivers/scsi/cxlflash/ocxl_hw.h                    |   72 -
 drivers/scsi/cxlflash/sislite.h                    |  560 ---
 drivers/scsi/cxlflash/superpipe.c                  | 2218 -----------
 drivers/scsi/cxlflash/superpipe.h                  |  150 -
 drivers/scsi/cxlflash/vlun.c                       | 1336 -------
 drivers/scsi/cxlflash/vlun.h                       |   82 -
 drivers/scsi/elx/efct/efct_driver.c                |    2 +-
 drivers/scsi/fnic/fdls_disc.c                      |   57 +-
 drivers/scsi/fnic/fnic_main.c                      |    5 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   28 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |    6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    4 +-
 drivers/scsi/hpsa.c                                |   19 +-
 drivers/scsi/ips.c                                 |    8 +-
 drivers/scsi/isci/init.c                           |   14 +-
 drivers/scsi/isci/isci.h                           |    7 -
 drivers/scsi/isci/remote_device.h                  |    2 +-
 drivers/scsi/iscsi_tcp.c                           |   60 +-
 drivers/scsi/iscsi_tcp.h                           |    4 +-
 drivers/scsi/libiscsi_tcp.c                        |   91 +-
 drivers/scsi/lpfc/lpfc.h                           |    3 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   23 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   35 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   14 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   12 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   43 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    6 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |    2 +-
 drivers/scsi/megaraid.c                            |   10 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |   10 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   10 +-
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h               |    4 +
 drivers/scsi/mpi3mr/mpi/mpi30_image.h              |    8 +
 drivers/scsi/mpi3mr/mpi/mpi30_init.h               |   11 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |   21 +
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h               |    1 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h          |   20 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   34 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  129 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  159 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  101 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h                    |    9 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |    5 +
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h                |   54 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   23 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   10 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   79 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  279 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h                 |   49 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |    4 +-
 drivers/scsi/mvsas/mv_sas.c                        |   10 -
 drivers/scsi/mvsas/mv_sas.h                        |    1 -
 drivers/scsi/qedi/qedi_main.c                      |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |    4 +-
 drivers/scsi/scsi.c                                |   28 +-
 drivers/scsi/scsi_debug.c                          |  928 ++++-
 drivers/scsi/scsi_error.c                          |   19 +
 drivers/scsi/scsi_scan.c                           |    5 +-
 drivers/scsi/scsi_sysctl.c                         |    4 +-
 drivers/scsi/st.c                                  |   80 +-
 drivers/scsi/st.h                                  |    6 +
 drivers/scsi/storvsc_drv.c                         |    4 +-
 drivers/target/iscsi/iscsi_target_nego.c           |    6 +-
 drivers/target/loopback/tcm_loop.c                 |    5 +-
 drivers/target/target_core_configfs.c              |    6 +-
 drivers/target/target_core_device.c                |    8 +-
 drivers/target/target_core_pr.c                    |    6 +-
 drivers/target/target_core_spc.c                   |   36 +-
 drivers/ufs/core/ufs-sysfs.c                       |   10 +
 drivers/ufs/core/ufs_trace.h                       |  135 +-
 drivers/ufs/core/ufshcd-priv.h                     |   21 +-
 drivers/ufs/core/ufshcd.c                          |  148 +-
 drivers/ufs/host/Kconfig                           |   12 +
 drivers/ufs/host/Makefile                          |    1 +
 drivers/ufs/host/ufs-exynos.c                      |   10 +-
 drivers/ufs/host/ufs-exynos.h                      |    2 +-
 drivers/ufs/host/ufs-hisi.c                        |    6 +-
 drivers/ufs/host/ufs-mediatek.c                    |   11 +-
 drivers/ufs/host/ufs-qcom.c                        |  126 +-
 drivers/ufs/host/ufs-qcom.h                        |   39 +-
 drivers/ufs/host/ufs-renesas.c                     |  723 ++--
 drivers/ufs/host/ufs-rockchip.c                    |  354 ++
 drivers/ufs/host/ufs-rockchip.h                    |   90 +
 drivers/ufs/host/ufs-sprd.c                        |    6 +-
 drivers/ufs/host/ufshcd-pci.c                      |    2 +-
 drivers/usb/gadget/function/f_mass_storage.c       |    4 +-
 drivers/usb/storage/debug.c                        |    4 +-
 include/scsi/libiscsi_tcp.h                        |   16 +-
 include/scsi/scsi_device.h                         |    9 +
 include/scsi/scsi_proto.h                          |    4 +-
 include/trace/events/scsi.h                        |    4 +-
 include/trace/events/target.h                      |    4 +-
 include/uapi/scsi/cxlflash_ioctl.h                 |  276 --
 include/ufs/ufs.h                                  |    1 +
 include/ufs/ufshcd.h                               |   22 +-
 .../filesystems/statmount/statmount_test.c         |   13 +-
 126 files changed, 3510 insertions(+), 12679 deletions(-)
 delete mode 100644 Documentation/arch/powerpc/cxlflash.rst
 create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-u=
fshc.yaml
 delete mode 100644 drivers/scsi/cxlflash/Kconfig
 delete mode 100644 drivers/scsi/cxlflash/Makefile
 delete mode 100644 drivers/scsi/cxlflash/backend.h
 delete mode 100644 drivers/scsi/cxlflash/common.h
 delete mode 100644 drivers/scsi/cxlflash/cxl_hw.c
 delete mode 100644 drivers/scsi/cxlflash/lunmgt.c
 delete mode 100644 drivers/scsi/cxlflash/main.c
 delete mode 100644 drivers/scsi/cxlflash/main.h
 delete mode 100644 drivers/scsi/cxlflash/ocxl_hw.c
 delete mode 100644 drivers/scsi/cxlflash/ocxl_hw.h
 delete mode 100644 drivers/scsi/cxlflash/sislite.h
 delete mode 100644 drivers/scsi/cxlflash/superpipe.c
 delete mode 100644 drivers/scsi/cxlflash/superpipe.h
 delete mode 100644 drivers/scsi/cxlflash/vlun.c
 delete mode 100644 drivers/scsi/cxlflash/vlun.h
 create mode 100644 drivers/ufs/host/ufs-rockchip.c
 create mode 100644 drivers/ufs/host/ufs-rockchip.h
 delete mode 100644 include/uapi/scsi/cxlflash_ioctl.h

