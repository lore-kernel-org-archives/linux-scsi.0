Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5521F12CDBE;
	Thu, 12 Feb 2026 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924922; cv=none; b=Z9GVL7Khrq7Sqt1u/64YyDUB9m69kylZ4hoKz+cv7v7DM7mi1xyb5lxrNp96NbhUQpMbbgovb72nYygeCJ6IGnu03bHtcW4YQ531O+hOGU8+BipRM+yB6XzhB6VX374aka5V8Xnh0xyjRAUtxmAqUztK2s+0u6kfC0mpNgHro8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924922; c=relaxed/simple;
	bh=QGkKDUIgYYaaGn6DZfiAnu5+bDaOL45PZaSJPK7KlvU=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=ucO+qBm5G9qKTSOqBZR+qcDzyb5NGt+pImxm+ipKiRknaD3fZG68TNUSjXczrosPJFOQq2a9aEwt/Z+mfoen4+Sxoq80y5UYyz426KifV1OSvTYTC8Xz1XBFhGx/e3nksBNMXZPRTxrudwFCPfcGxo/aCpIM55zB1n1P65BQz0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=h4VQYxm2; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="h4VQYxm2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1770924917;
	bh=QGkKDUIgYYaaGn6DZfiAnu5+bDaOL45PZaSJPK7KlvU=;
	h=Message-ID:Subject:From:To:Date:From;
	b=h4VQYxm2nU79H2ExiibrJgYwXtNhwA41JUtUDh43iuJvtphu/vMgjtl3VDM0jRQsa
	 LJn3UMUoXoby0W62wHpUUiIqMUBXY1b4TuGsa82ercPziSVXd2P1uC6//EJLsIoaWn
	 vVYgkcdTw6OlVaIkbhB+sgF26uAkb89FW+KqSVaA=
Received: from [10.27.1.61] (unknown [131.107.9.125])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id F19B11C00E0;
	Thu, 12 Feb 2026 14:35:16 -0500 (EST)
Message-ID: <3a45b4e6edc8d66c33202c98d8b85a67678938bb.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.19+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 12 Feb 2026 11:34:50 -0800
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

Usual driver updates (qla2xxx, mpi3mr, mpt3sas, ufs) plus assorted
cleanups and fixes.=C2=A0 The biggest core change is the massive code motio=
n
in the sd driver to remove forward declarations and the most
significant change is to enumify the queuecommand return.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Anil Gurumurthy (5):
      scsi: qla2xxx: Fix bsg_done() causing double free
      scsi: qla2xxx: Query FW again before proceeding with login
      scsi: qla2xxx: Validate sp before freeing associated memory
      scsi: qla2xxx: Free sp in error path to fix system crash
      scsi: qla2xxx: Delay module unload while fabric scan in progress

Arnd Bergmann (2):
      scsi: buslogic: Reduce stack usage
      scsi: ufs: host: mediatek: Require CONFIG_PM

Bart Van Assche (17):
      scsi: ufs: core: Use a host-wide tagset in SDB mode
      scsi: Change the return type of the .queuecommand() callback
      scsi: qla2xxx: Declare qla2xxx_mqueuecommand() static
      scsi: megaraid_sas: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
      scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
      scsi: aha152x: Return SCSI_MLQUEUE_HOST_BUSY instead of 0x2003
      scsi: sd: Do not split error messages
      scsi: sd: Move the sd_fops definition
      scsi: sd: Move the scsi_disk_release() function definition
      scsi: sd: Move the sd_config_discard() function definition
      scsi: sd: Move the sd_remove() function definition
      scsi: core: Revert "Fix a regression triggered by scsi_host_busy()"
      scsi: ufs: core: Only call scsi_host_busy() after the SCSI host has b=
een added
      scsi: ufs: core: Improve the documentation of UFS data frames
      scsi: mpt3sas: Simplify the workqueue allocation code
      scsi: mpi3mr: Simplify the workqueue allocation code
      scsi: core: Introduce an enumeration type for the SCSI_MLQUEUE consta=
nts

Christophe JAILLET (1):
      scsi: target: Constify struct configfs_item_operations and configfs_g=
roup_operations

Colin Ian King (1):
      scsi: csiostor: Fix dereference of null pointer rn

Guixin Liu (1):
      scsi: mpi3mr: Make driver probing asynchronous

Gulam Mohamed (1):
      scsi: target: core: Add emulation for REPORT IDENTIFYING INFORMATION

Himanshu Madhani (1):
      scsi: qla2xxx: Add Speed in SFP print information

John Garry (3):
      scsi: scsi_debug: Drop NULL scsi_cmnd check in sdebug_q_cmd_complete(=
)
      scsi: scsi_debug: Stop using READ/WRITE_ONCE() when accessing sdebug_=
defer.defer_t
      scsi: scsi_debug: Stop printing extra function name in debug logs

Justin Tee (1):
      scsi: lpfc: Update lpfc version to 14.4.0.13

Keita Morisaki (1):
      scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale() trace eve=
nt

Keoseong Park (1):
      scsi: ufs: core: Handle sentinel value for dHIDAvailableSize

Manish Rangankar (4):
      scsi: qla2xxx: Add bsg interface to support firmware img validation
      scsi: qla2xxx: Validate MCU signature before executing MBC 03h
      scsi: qla2xxx: Add load flash firmware mailbox support for 28xxx
      scsi: qla2xxx: Add support for 64G SFP speed

Marco Crivellari (3):
      scsi: qla2xxx: target: Add WQ_PERCPU to alloc_workqueue() users
      scsi: qla2xxx: Add WQ_PERCPU to alloc_workqueue() users
      scsi: qla4xxx: Add WQ_PERCPU to alloc_workqueue() users

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.10.100-k

Peter Griffin (1):
      scsi: ufs: exynos: Call phy_notify_state() from hibern8 callbacks

Ram Kumar Dwivedi (4):
      scsi: ufs: ufs-qcom: Add support for firmware-managed resource abstra=
ction
      scsi: ufs: core: Enforce minimum PM level for sysfs configuration
      scsi: ufs: dt-bindings: Document bindings for SA8255P UFS Host Contro=
ller
      scsi: MAINTAINERS: Broaden UFS Qualcomm binding file pattern

Ranjan Kumar (13):
      scsi: mpi3mr: Driver version update to 8.17.0.3.50
      scsi: mpi3mr: Fixed the W=3D1 compilation warning
      scsi: mpi3mr: Record and report controller firmware faults
      scsi: mpi3mr: Update MPI Headers to revision 39
      scsi: mpi3mr: Use negotiated link rate from DevicePage0
      scsi: mpi3mr: Avoid redundant diag-fault resets
      scsi: mpi3mr: Rename log data save helper to reflect threaded/BH cont=
ext
      scsi: mpi3mr: Add module parameter to control threaded IRQ polling
      scsi: mpt3sas: Fixed the W=3D1 compilation warning
      scsi: mpt3sas: Add configurable command retry limit for slow-to-respo=
nd devices
      scsi: mpt3sas: Add firmware event requeue support for busy devices
      scsi: mpt3sas: Improve device discovery and readiness handling for sl=
ow devices
      scsi: mpt3sas: Added no_turs flag to device unblock logic

ReBeating (1):
      scsi: target: sbp: Potential integer overflow in sbp_make_tpg()

Sarah Catania (2):
      scsi: lpfc: Add support for reporting encryption events
      scsi: scsi_transport_fc: Introduce encryption group in fc_rport attri=
bute

Sebastian Andrzej Siewior (1):
      scsi: efct: Use IRQF_ONESHOT and default primary handler

Shreyas Deodhar (1):
      scsi: qla2xxx: Allow recovery for tape devices

Thomas Yen (1):
      scsi: ufs: core: Flush exception handling work when RPM level is zero

Uwe Kleine-K=C3=B6nig (8):
      scsi: ufs: core: Convert to SCSI bus methods
      scsi: st: Convert to SCSI bus methods
      scsi: sr: Convert to SCSI bus methods
      scsi: ses: Convert to SCSI bus methods
      scsi: sd: Convert to SCSI bus methods
      scsi: ch: Convert to SCSI bus methods
      scsi: core: sysfs: Make use of bus callbacks
      scsi: core: Pass a struct scsi_driver to scsi_{,un}register_driver()

Yury Norov (NVIDIA) (1):
      scsi: lpfc: Rework lpfc_sli4_fcf_rr_next_index_get()

Zilin Guan (1):
      scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()

vamshi gajjela (1):
      scsi: ufs: core: mcq: Use ufshcd_rmwl() instead of open-coding it

And the diffstat:

 .../bindings/ufs/qcom,sa8255p-ufshc.yaml           |   56 +
 Documentation/scsi/scsi_mid_low_api.rst            |    3 +-
 MAINTAINERS                                        |    2 +-
 drivers/ata/libata-scsi.c                          |    8 +-
 drivers/ata/libata.h                               |    3 +-
 drivers/base/transport_class.c                     |    8 +
 drivers/firewire/sbp2.c                            |    7 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    3 +-
 drivers/message/fusion/mptfc.c                     |    7 +-
 drivers/message/fusion/mptsas.c                    |    4 +-
 drivers/message/fusion/mptscsih.c                  |    3 +-
 drivers/message/fusion/mptscsih.h                  |    2 +-
 drivers/message/fusion/mptspi.c                    |    4 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    4 +-
 drivers/scsi/3w-9xxx.c                             |    2 +-
 drivers/scsi/3w-sas.c                              |    8 +-
 drivers/scsi/3w-xxxx.c                             |    2 +-
 drivers/scsi/53c700.c                              |    6 +-
 drivers/scsi/BusLogic.c                            |    8 +-
 drivers/scsi/BusLogic.h                            |    3 +-
 drivers/scsi/NCR5380.c                             |    4 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/aacraid/linit.c                       |    4 +-
 drivers/scsi/advansys.c                            |    5 +-
 drivers/scsi/aha152x.c                             |    8 +-
 drivers/scsi/aha1542.c                             |    3 +-
 drivers/scsi/aha1740.c                             |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |   12 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    5 +-
 drivers/scsi/arm/acornscsi.c                       |    2 +-
 drivers/scsi/arm/fas216.c                          |   11 +-
 drivers/scsi/arm/fas216.h                          |   11 +-
 drivers/scsi/atp870u.c                             |    2 +-
 drivers/scsi/bfa/bfad_im.c                         |    5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                       |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |    4 +-
 drivers/scsi/ch.c                                  |   18 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    7 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/esas2r/esas2r.h                       |    3 +-
 drivers/scsi/esas2r/esas2r_main.c                  |    3 +-
 drivers/scsi/esp_scsi.c                            |    2 +-
 drivers/scsi/fdomain.c                             |    3 +-
 drivers/scsi/fnic/fnic.h                           |    3 +-
 drivers/scsi/fnic/fnic_scsi.c                      |    3 +-
 drivers/scsi/hosts.c                               |    5 +-
 drivers/scsi/hpsa.c                                |    6 +-
 drivers/scsi/hptiop.c                              |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    3 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |    9 +-
 drivers/scsi/imm.c                                 |    2 +-
 drivers/scsi/initio.c                              |    2 +-
 drivers/scsi/ipr.c                                 |    4 +-
 drivers/scsi/ips.c                                 |    4 +-
 drivers/scsi/libfc/fc_fcp.c                        |    3 +-
 drivers/scsi/libiscsi.c                            |    3 +-
 drivers/scsi/libsas/sas_scsi_host.c                |    3 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   40 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    7 +
 drivers/scsi/lpfc/lpfc_disc.h                      |    7 +
 drivers/scsi/lpfc/lpfc_els.c                       |   57 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    1 +
 drivers/scsi/lpfc/lpfc_hw4.h                       |   11 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    5 +
 drivers/scsi/lpfc/lpfc_logmsg.h                    |    3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    8 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   62 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |    4 +
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/mac53c94.c                            |    2 +-
 drivers/scsi/megaraid.c                            |   17 +-
 drivers/scsi/megaraid.h                            |    6 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |   23 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |    4 +-
 drivers/scsi/mesh.c                                |    2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h               |   92 +-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h              |  102 +-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h               |    2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |    1 +
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h                |    2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h                |    2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h               |    6 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h          |    4 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   18 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   28 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  136 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  111 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   30 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   17 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 1460 ++++++++++++++++=
++--
 drivers/scsi/mvumi.c                               |    4 +-
 drivers/scsi/myrb.c                                |   12 +-
 drivers/scsi/myrs.c                                |    4 +-
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/nsp32.c                               |    5 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |    2 +-
 drivers/scsi/pcmcia/nsp_cs.h                       |    3 +-
 drivers/scsi/pcmcia/sym53c500_cs.c                 |    2 +-
 drivers/scsi/pmcraid.c                             |    4 +-
 drivers/scsi/ppa.c                                 |    2 +-
 drivers/scsi/ps3rom.c                              |    2 +-
 drivers/scsi/qedf/qedf.h                           |    4 +-
 drivers/scsi/qedf/qedf_io.c                        |    4 +-
 drivers/scsi/qla1280.c                             |   18 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  147 +-
 drivers/scsi/qla2xxx/qla_bsg.h                     |   12 +
 drivers/scsi/qla2xxx/qla_def.h                     |   30 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    5 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   41 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  232 +++-
 drivers/scsi/qla2xxx/qla_isr.c                     |   19 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   88 ++
 drivers/scsi/qla2xxx/qla_nx.h                      |    1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   16 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |   29 +
 drivers/scsi/qla2xxx/qla_target.c                  |    2 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    8 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    8 +-
 drivers/scsi/qlogicfas408.c                        |    2 +-
 drivers/scsi/qlogicfas408.h                        |    3 +-
 drivers/scsi/qlogicpti.c                           |    2 +-
 drivers/scsi/scsi_debug.c                          |  127 +-
 drivers/scsi/scsi_lib.c                            |   11 +-
 drivers/scsi/scsi_priv.h                           |    3 +-
 drivers/scsi/scsi_sysfs.c                          |   77 +-
 drivers/scsi/scsi_transport_fc.c                   |   42 +
 drivers/scsi/sd.c                                  |  295 ++--
 drivers/scsi/ses.c                                 |   15 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   16 +-
 drivers/scsi/snic/snic.h                           |    3 +-
 drivers/scsi/snic/snic_scsi.c                      |    4 +-
 drivers/scsi/sr.c                                  |   21 +-
 drivers/scsi/st.c                                  |   22 +-
 drivers/scsi/stex.c                                |    2 +-
 drivers/scsi/storvsc_drv.c                         |    3 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/scsi/virtio_scsi.c                         |    4 +-
 drivers/scsi/vmw_pvscsi.c                          |    2 +-
 drivers/scsi/wd33c93.c                             |    2 +-
 drivers/scsi/wd33c93.h                             |    3 +-
 drivers/scsi/wd719x.c                              |    3 +-
 drivers/scsi/xen-scsifront.c                       |    4 +-
 drivers/target/loopback/tcm_loop.c                 |    3 +-
 drivers/target/target_core_configfs.c              |   68 +-
 drivers/target/target_core_fabric_configfs.c       |   30 +-
 drivers/target/target_core_spc.c                   |   86 ++
 drivers/ufs/core/ufs-mcq.c                         |    5 +-
 drivers/ufs/core/ufs-sysfs.c                       |    6 +-
 drivers/ufs/core/ufshcd-priv.h                     |    7 +-
 drivers/ufs/core/ufshcd.c                          |   38 +-
 drivers/ufs/host/Kconfig                           |    1 +
 drivers/ufs/host/ufs-exynos.c                      |   10 +
 drivers/ufs/host/ufs-mediatek-trace.h              |    6 +-
 drivers/ufs/host/ufs-mediatek.c                    |   12 +-
 drivers/ufs/host/ufs-qcom.c                        |  156 ++-
 drivers/ufs/host/ufs-qcom.h                        |    1 +
 drivers/usb/image/microtek.c                       |    6 +-
 drivers/usb/storage/scsiglue.c                     |    2 +-
 drivers/usb/storage/uas.c                          |    2 +-
 include/linux/libata.h                             |    3 +-
 include/linux/transport_class.h                    |    1 +
 include/scsi/libfc.h                               |    3 +-
 include/scsi/libiscsi.h                            |    3 +-
 include/scsi/libsas.h                              |    3 +-
 include/scsi/scsi.h                                |   13 +-
 include/scsi/scsi_driver.h                         |    7 +-
 include/scsi/scsi_host.h                           |   12 +-
 include/scsi/scsi_transport_fc.h                   |   12 +
 include/target/target_core_base.h                  |    4 +
 include/uapi/scsi/scsi_bsg_ufs.h                   |   17 +-
 include/ufs/ufs.h                                  |    5 +-
 include/ufs/ufshcd.h                               |    6 +-
 include/ufs/ufshci.h                               |    1 +
 176 files changed, 3678 insertions(+), 829 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufsh=
c.yaml

Regards,

James

