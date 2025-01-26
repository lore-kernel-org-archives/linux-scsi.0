Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4CC25A638;
	Mon, 27 Jan 2025 05:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737956523; cv=none; b=tMk39d/r5+CvyfHPQ9JvwsTBI1xMHxZ1OhugEqgJ2woBpe9VoiMbE7gKFVnFsSokh+wAE9wRa+ntMdrfaGIEtovCjXWQ3bKmU9VeoFmcJnJbITeVOOy7BPEXxqODtCavUPZ7p8cIK9DNXb99BQI33ibM8AUGdPRpDuuWa+c81xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737956523; c=relaxed/simple;
	bh=eSAwsrINHgdLeoC/TS3CugwINhtgrgVSWXZ4X8iPZ/U=;
	h=Message-ID:Subject:From:To:Cc:Content-Type:Date:MIME-Version; b=kTr1wJlKzd52tFYe1xdoCC7kqJI/nwp6+McC0/vJTEnwY8jPFL+NAPDarfHIHZZWC0PMb4MjRmlCp6BnYWS5CYRGHu4LJALlog0EzI32bj2xB+EGiP0C+MbvdZYdRGcRaIkPZnbYKvjNsSORX1E2rKJ3LfA4VaTRYOuy5y1pBUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+y1VRmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+y1VRmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D673C4CED2;
	Mon, 27 Jan 2025 05:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737956523;
	bh=eSAwsrINHgdLeoC/TS3CugwINhtgrgVSWXZ4X8iPZ/U=;
	h=Subject:From:To:Cc:Date:From;
	b=T+y1VRmLmy8Cd7NwScqssmPs6Dr+wZg9u24oPfO+9paf+k/r3dgf48DfpytdK7pjq
	 2qGbJrr1y/DkjqxZZkKCRX93itVqv8A7rTd8lOfLwr2aPHSifstbixNKrPCYtg1U03
	 NUaXfxWmMPn+h7yd87J4kgBYVbYTwyWMYqLKF9Wy1FUycCNlKMDh92iLRSvauiIt9Y
	 J8U7peYIzQ3LhtTVmEM6oZ+TSU7bTN0DH2Ehk2h5XB77bnDnUw1MI0ECJn2f91rSfz
	 rF69P9F+fzAArDoAGO7FcRcztd9eNvrntXwiFztY8QGrrSu2FGmww0yLUnYew1xr+3
	 msEAZnI7D1tSA==
Message-ID: <5ab4ebbbc02e818a0461f2129d7999ad9ad89ae5.camel@kernel.org>
Subject: [GIT PULL] SCSI updates for the 6.12+ merge window
From: James Bottomley <jejb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Jan 2025 10:10:05 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.42.4 
Content-Transfer-Encoding: 8bit

[From kernel.org for once because hansenpartnership.com is suffering a
prolonged outage due to data centre issues in Los Angeles]

[There are three obvious ata merge conflicts where the update to remove
the slave_ prefix  changed device_configure to sdev_configure and is
next to a different name change from tag_alloc_policy to
tag_alloc_policy_rr]

Updates to the usual drivers (ufs, lpfc, fnic, qla2xx, mpi3mr)  The
major core change is the renaming of the slave_ methods plus a bit of
constification. The rest are minor updates and fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Ariel Otilibili (1):
      scsi: myrb: Remove dead code

Artur Paszkiewicz (1):
      scsi: MAINTAINERS: Remove myself as isci driver maintainer

Arun Easi (2):
      scsi: fnic: Propagate SCSI error code from fnic_scsi_drv_init()
      scsi: fnic: Remove always-true IS_FNIC_FCP_INITIATOR macro

Avri Altman (6):
      scsi: Revert "scsi: ufs: core: Probe for EXT_IID support"
      scsi: ufs: core: Do not hold any lock in ufshcd_hba_stop()
      scsi: ufs: core: Introduce a new clock_scaling lock
      scsi: ufs: core: Introduce a new clock_gating lock
      scsi: ufs: core: Prepare to introduce a new clock_gating lock
      scsi: ufs: core: Introduce ufshcd_has_pending_tasks()

Bart Van Assche (6):
      scsi: scsi_debug: Skip host/bus reset settle delay
      scsi: core: Update API documentation
      scsi: core: Remove the .slave_configure() method
      scsi: Convert SCSI drivers to .sdev_configure()
      scsi: Rename .device_configure() into .sdev_configure()
      scsi: Rename .slave_alloc() and .slave_destroy()

Christophe JAILLET (1):
      scsi: Constify struct pci_device_id

Dan Carpenter (1):
      scsi: fnic: Delete incorrect debugfs error handling

Dheeraj Reddy Jonnalagadda (1):
      scsi: fnic: Fix use of uninitialized value in debug message

Dr. David Alan Gilbert (3):
      scsi: isci: Remove unused isci_remote_device_reset_complete()
      scsi: iscsi: Remove unused iscsi_create_session()
      scsi: target: Remove unused functions

Easwar Hariharan (1):
      scsi: storvsc: Ratelimit warning logs to prevent VM denial of service

Eric Biggers (4):
      scsi: ufs: crypto: Remove ufs_hba_variant_ops::program_key
      scsi: ufs: qcom: Convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
      scsi: ufs: crypto: Add ufs_hba_from_crypto_profile()
      scsi: ufs: qcom: Fix crypto key eviction

Fedor Loshakov (1):
      scsi: zfcp: Correct kdoc parameter description for sending ELS and CT

Frederic Weisbecker (3):
      scsi: qedi: Use kthread_create_on_cpu()
      scsi: bnx2i: Use kthread_create_on_cpu()
      scsi: bnx2fc: Use kthread_create_on_cpu()

Guixin Liu (3):
      scsi: mpi3mr: Fix possible crash when setting up bsg fails
      scsi: ufs: bsg: Set bsg_queue to NULL after removal
      scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails

Igor Pylypiv (2):
      scsi: pm80xx: Increase reserved tags from 8 to 128
      scsi: pm80xx: Do not use libsas port ID

John Garry (1):
      scsi: scsi_debug: Constify sdebug_driver_template

Jolly Shah (1):
      scsi: pm80xx: Use dynamic tag numbers for PHY start and stop

Justin Tee (10):
      scsi: lpfc: Copyright updates for 14.4.0.7 patches
      scsi: lpfc: Update lpfc version to 14.4.0.7
      scsi: lpfc: Add support for large fw object application layer reads
      scsi: lpfc: Update definition of firmware configuration mbox cmds
      scsi: lpfc: Change lpfc_nodelist save_flags member into a bitmask
      scsi: lpfc: Add handling for LS_RJT reason explanation authentication required
      scsi: lpfc: Modify handling of ADISC based on ndlp state and RPI registration
      scsi: lpfc: Delete NLP_TARGET_REMOVE flag due to obsolete usage
      scsi: lpfc: Restrict the REG_FCFI MAM field to FCoE adapters only
      scsi: lpfc: Redefine incorrect type in lpfc_create_device_data()

Kai Mäkisara (1):
      scsi: st: Don't set pos_unknown just after device recognition

Karan Tilak Kumar (21):
      scsi: fnic: Test for memory allocation failure and return error code
      scsi: fnic: Return appropriate error code from failure of scsi drv init
      scsi: fnic: Return appropriate error code for mem alloc failure
      scsi: fnic: Remove unnecessary else to fix warning in FDLS FIP
      scsi: fnic: Remove extern definition from .c files
      scsi: fnic: Remove unnecessary else and unnecessary break in FDLS
      scsi: fnic: Increment driver version
      scsi: fnic: Add support to handle port channel RSCN
      scsi: fnic: Code cleanup
      scsi: fnic: Add stats and related functionality
      scsi: fnic: Modify fnic interfaces to use FDLS
      scsi: fnic: Modify IO path to use FDLS
      scsi: fnic: Add functionality in fnic to support FDLS
      scsi: fnic: Add and integrate support for FIP
      scsi: fnic: Add and integrate support for FDMI
      scsi: fnic: Add Cisco hardware model names
      scsi: fnic: Add support for unsolicited requests and responses
      scsi: fnic: Add support for target based solicited requests and responses
      scsi: fnic: Add support for fabric based solicited requests and responses
      scsi: fnic: Add headers and definitions for FDLS
      scsi: fnic: Replace shost_printk() with dev_info()/dev_err()

Michael Kelley (1):
      scsi: storvsc: Don't assume cpu_possible_mask is dense

Paul Menzel (2):
      scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
      scsi: mpt3sas: Add details to EEDPTagMode error message

Prateek Singh Rathore (1):
      scsi: csiostor: Fix typo doesnt->doesn't

Quinn Tran (1):
      scsi: qla2xxx: Move FCE Trace buffer allocation to user control

Randy Dunlap (10):
      scsi: documentation: Corrections for struct updates
      scsi: driver-api: documentation: Change what is added to docbook
      scsi: transport: sas: spi: Fix kernel-doc for exported functions
      scsi: scsi_scan: Add kernel-doc for exported function
      scsi: scsi_lib: Add kernel-doc for exported functions
      scsi: scsi_ioctl: Add kernel-doc for exported functions
      scsi: scsi_error: Add kernel-doc for exported functions
      scsi: documentation: scsi_eh: updates for EH changes
      scsi: Eliminate scsi_register() and scsi_unregister() usage & docs
      scsi: docs: Remove init_this_scsi_driver()

Siddharth Menon (1):
      scsi: esp: Fix variable typo

Steffen Maier (2):
      scsi: MAINTAINERS: Update zfcp entry
      scsi: zfcp: Clarify zfcp_port refcount ownership during "link" test

Thomas Weißschuh (11):
      scsi: qla4xxx: Constify 'struct bin_attribute'
      scsi: qla2xxx: Constify 'struct bin_attribute'
      scsi: qedi: Constify 'struct bin_attribute'
      scsi: qedf: Constify 'struct bin_attribute'
      scsi: ipr: Constify 'struct bin_attribute'
      scsi: lpfc: Constify 'struct bin_attribute'
      scsi: ibmvfc: Constify 'struct bin_attribute'
      scsi: esas2r: Constify 'struct bin_attribute'
      scsi: arcmsr: Constify 'struct bin_attribute'
      scsi: 3w-sas: Constify 'struct bin_attribute'
      scsi: core: Constify 'struct bin_attribute'

Thorsten Blum (2):
      scsi: bsg: Replace zero-length array with flexible array member
      scsi: fnic: Use vcalloc() instead of vmalloc() and memset(0)

Vishakha Channapattan (1):
      scsi: pm80xx: Improve debugging for aborted commands

wangdicheng (1):
      scsi: aic7xxx: Fix build 'aicasm' warning

And the diffstat:

 Documentation/driver-api/scsi.rst               |    5 +-
 Documentation/scsi/scsi_eh.rst                  |   46 +-
 Documentation/scsi/scsi_mid_low_api.rst         |  206 +-
 MAINTAINERS                                     |    6 +-
 drivers/ata/ahci.h                              |    2 +-
 drivers/ata/libata-sata.c                       |    8 +-
 drivers/ata/libata-scsi.c                       |   19 +-
 drivers/ata/pata_macio.c                        |    8 +-
 drivers/ata/sata_mv.c                           |    2 +-
 drivers/ata/sata_nv.c                           |   24 +-
 drivers/ata/sata_sil24.c                        |    2 +-
 drivers/firewire/sbp2.c                         |   10 +-
 drivers/infiniband/ulp/srp/ib_srp.c             |    5 +-
 drivers/message/fusion/mptfc.c                  |   14 +-
 drivers/message/fusion/mptsas.c                 |   14 +-
 drivers/message/fusion/mptscsih.c               |   10 +-
 drivers/message/fusion/mptscsih.h               |    5 +-
 drivers/message/fusion/mptspi.c                 |   19 +-
 drivers/s390/scsi/zfcp_fc.c                     |    7 +-
 drivers/s390/scsi/zfcp_fsf.c                    |    4 +-
 drivers/s390/scsi/zfcp_scsi.c                   |   15 +-
 drivers/s390/scsi/zfcp_sysfs.c                  |    2 +-
 drivers/s390/scsi/zfcp_unit.c                   |    2 +-
 drivers/scsi/3w-9xxx.c                          |    9 +-
 drivers/scsi/3w-sas.c                           |   21 +-
 drivers/scsi/3w-xxxx.c                          |   10 +-
 drivers/scsi/53c700.c                           |   19 +-
 drivers/scsi/BusLogic.c                         |    9 +-
 drivers/scsi/BusLogic.h                         |    3 +-
 drivers/scsi/a100u2w.c                          |    2 +-
 drivers/scsi/aacraid/linit.c                    |    8 +-
 drivers/scsi/advansys.c                         |   25 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c              |    8 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |    8 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y       |    1 +
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y |    1 +
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l       |    3 +
 drivers/scsi/am53c974.c                         |    2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c               |   12 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                |   10 +-
 drivers/scsi/atp870u.c                          |    2 +-
 drivers/scsi/bfa/bfad_im.c                      |   26 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |   14 +-
 drivers/scsi/bnx2i/bnx2i_init.c                 |    7 +-
 drivers/scsi/csiostor/csio_scsi.c               |   20 +-
 drivers/scsi/cxlflash/main.c                    |    2 +-
 drivers/scsi/dc395x.c                           |   14 +-
 drivers/scsi/dmx3191d.c                         |    2 +-
 drivers/scsi/elx/efct/efct_driver.c             |    2 +-
 drivers/scsi/esas2r/esas2r.h                    |   12 +-
 drivers/scsi/esas2r/esas2r_main.c               |   32 +-
 drivers/scsi/esp_scsi.c                         |   14 +-
 drivers/scsi/esp_scsi.h                         |    2 +-
 drivers/scsi/fcoe/fcoe.c                        |    2 +-
 drivers/scsi/fdomain_pci.c                      |    2 +-
 drivers/scsi/fnic/Makefile                      |    5 +-
 drivers/scsi/fnic/fdls_disc.c                   | 4997 +++++++++++++++++++++++
 drivers/scsi/fnic/fdls_fc.h                     |  253 ++
 drivers/scsi/fnic/fip.c                         | 1005 +++++
 drivers/scsi/fnic/fip.h                         |  159 +
 drivers/scsi/fnic/fnic.h                        |  288 +-
 drivers/scsi/fnic/fnic_attrs.c                  |   12 +-
 drivers/scsi/fnic/fnic_debugfs.c                |   11 +-
 drivers/scsi/fnic/fnic_fcs.c                    | 1742 ++++----
 drivers/scsi/fnic/fnic_fdls.h                   |  434 ++
 drivers/scsi/fnic/fnic_fip.h                    |   48 -
 drivers/scsi/fnic/fnic_io.h                     |   14 +-
 drivers/scsi/fnic/fnic_isr.c                    |   28 +-
 drivers/scsi/fnic/fnic_main.c                   |  758 ++--
 drivers/scsi/fnic/fnic_pci_subsys_devid.c       |  131 +
 drivers/scsi/fnic/fnic_res.c                    |   77 +-
 drivers/scsi/fnic/fnic_scsi.c                   | 1161 ++++--
 drivers/scsi/fnic/fnic_stats.h                  |   49 +-
 drivers/scsi/fnic/fnic_trace.c                  |   97 +-
 drivers/scsi/hisi_sas/hisi_sas.h                |    5 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c           |   13 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c          |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c          |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c          |   10 +-
 drivers/scsi/hpsa.c                             |   20 +-
 drivers/scsi/hptiop.c                           |    8 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                  |   20 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                |    8 +-
 drivers/scsi/initio.c                           |    2 +-
 drivers/scsi/ipr.c                              |   48 +-
 drivers/scsi/ips.c                              |    6 +-
 drivers/scsi/ips.h                              |    3 +-
 drivers/scsi/isci/remote_device.c               |   29 -
 drivers/scsi/isci/remote_device.h               |   17 -
 drivers/scsi/iscsi_tcp.c                        |    6 +-
 drivers/scsi/libfc/fc_fcp.c                     |    6 +-
 drivers/scsi/libsas/sas_scsi_host.c             |   11 +-
 drivers/scsi/lpfc/lpfc_attr.c                   |   20 +-
 drivers/scsi/lpfc/lpfc_bsg.c                    |  210 +-
 drivers/scsi/lpfc/lpfc_bsg.h                    |   19 +-
 drivers/scsi/lpfc/lpfc_ct.c                     |    6 +-
 drivers/scsi/lpfc/lpfc_disc.h                   |   11 +-
 drivers/scsi/lpfc/lpfc_els.c                    |   55 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                |   13 +-
 drivers/scsi/lpfc/lpfc_hw.h                     |    3 +-
 drivers/scsi/lpfc/lpfc_hw4.h                    |   85 +-
 drivers/scsi/lpfc/lpfc_init.c                   |   11 +-
 drivers/scsi/lpfc/lpfc_mbox.c                   |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c              |   53 +-
 drivers/scsi/lpfc/lpfc_scsi.c                   |   64 +-
 drivers/scsi/lpfc/lpfc_sli4.h                   |    2 -
 drivers/scsi/lpfc/lpfc_version.h                |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c                  |   22 +-
 drivers/scsi/megaraid.c                         |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c           |    4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |   16 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                |    8 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                 |   20 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c             |    5 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |   24 +-
 drivers/scsi/mvsas/mv_init.c                    |    2 +-
 drivers/scsi/mvumi.c                            |    5 +-
 drivers/scsi/myrb.c                             |   23 +-
 drivers/scsi/myrs.c                             |   13 +-
 drivers/scsi/ncr53c8xx.c                        |    9 +-
 drivers/scsi/nsp32.c                            |    2 +-
 drivers/scsi/pm8001/pm8001_defs.h               |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                |    5 +-
 drivers/scsi/pm8001/pm8001_init.c               |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c                |   78 +-
 drivers/scsi/pm8001/pm8001_sas.h                |    2 +
 drivers/scsi/pm8001/pm80xx_hwi.c                |   59 +-
 drivers/scsi/pmcraid.c                          |   24 +-
 drivers/scsi/ps3rom.c                           |    5 +-
 drivers/scsi/qedf/qedf_attr.c                   |   10 +-
 drivers/scsi/qedf/qedf_dbg.h                    |    2 +-
 drivers/scsi/qedf/qedf_main.c                   |    5 +-
 drivers/scsi/qedi/qedi_dbg.h                    |    2 +-
 drivers/scsi/qedi/qedi_main.c                   |    8 +-
 drivers/scsi/qla1280.c                          |    8 +-
 drivers/scsi/qla2xxx/qla_attr.c                 |   80 +-
 drivers/scsi/qla2xxx/qla_def.h                  |    2 +
 drivers/scsi/qla2xxx/qla_dfs.c                  |  124 +-
 drivers/scsi/qla2xxx/qla_gbl.h                  |    3 +
 drivers/scsi/qla2xxx/qla_init.c                 |   28 +-
 drivers/scsi/qla2xxx/qla_os.c                   |   14 +-
 drivers/scsi/qla4xxx/ql4_attr.c                 |   12 +-
 drivers/scsi/qla4xxx/ql4_os.c                   |    8 +-
 drivers/scsi/qlogicpti.c                        |    5 +-
 drivers/scsi/scsi_debug.c                       |   32 +-
 drivers/scsi/scsi_error.c                       |   26 +-
 drivers/scsi/scsi_ioctl.c                       |   35 +-
 drivers/scsi/scsi_lib.c                         |   24 +-
 drivers/scsi/scsi_scan.c                        |   42 +-
 drivers/scsi/scsi_sysfs.c                       |   20 +-
 drivers/scsi/scsi_transport_iscsi.c             |   31 +-
 drivers/scsi/scsi_transport_sas.c               |   10 +-
 drivers/scsi/scsi_transport_spi.c               |    3 +-
 drivers/scsi/smartpqi/smartpqi_init.c           |   13 +-
 drivers/scsi/snic/snic_main.c                   |   14 +-
 drivers/scsi/st.c                               |    6 +
 drivers/scsi/st.h                               |    1 +
 drivers/scsi/stex.c                             |    6 +-
 drivers/scsi/storvsc_drv.c                      |   28 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c             |   17 +-
 drivers/scsi/virtio_scsi.c                      |    2 +-
 drivers/scsi/xen-scsifront.c                    |   11 +-
 drivers/target/iscsi/iscsi_target.c             |   15 -
 drivers/target/iscsi/iscsi_target.h             |    1 -
 drivers/target/iscsi/iscsi_target_erl2.c        |   48 -
 drivers/target/iscsi/iscsi_target_erl2.h        |    2 -
 drivers/target/iscsi/iscsi_target_parameters.c  |   48 -
 drivers/target/iscsi/iscsi_target_parameters.h  |    3 -
 drivers/target/iscsi/iscsi_target_tpg.c         |    5 -
 drivers/target/iscsi/iscsi_target_tpg.h         |    1 -
 drivers/target/iscsi/iscsi_target_util.c        |   58 -
 drivers/target/iscsi/iscsi_target_util.h        |    2 -
 drivers/ufs/core/ufs_bsg.c                      |    2 +
 drivers/ufs/core/ufshcd-crypto.c                |   26 +-
 drivers/ufs/core/ufshcd.c                       |  316 +-
 drivers/ufs/host/ufs-qcom.c                     |   93 +-
 drivers/usb/image/microtek.c                    |    4 +-
 drivers/usb/storage/scsiglue.c                  |   10 +-
 drivers/usb/storage/uas.c                       |   10 +-
 include/linux/libata.h                          |   19 +-
 include/scsi/libfc.h                            |    2 +-
 include/scsi/libsas.h                           |    9 +-
 include/scsi/scsi_bsg_iscsi.h                   |    2 +-
 include/scsi/scsi_device.h                      |    4 +-
 include/scsi/scsi_host.h                        |   26 +-
 include/scsi/scsi_transport_iscsi.h             |    4 -
 include/ufs/ufs.h                               |    5 -
 include/ufs/ufshcd.h                            |   38 +-
 include/ufs/ufshci.h                            |    5 -
 189 files changed, 10976 insertions(+), 3534 deletions(-)
 create mode 100644 drivers/scsi/fnic/fdls_disc.c
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fip.c
 create mode 100644 drivers/scsi/fnic/fip.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h
 delete mode 100644 drivers/scsi/fnic/fnic_fip.h
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

