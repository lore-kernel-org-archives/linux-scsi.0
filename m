Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EF2C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCIT0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCIT0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:26:23 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914E3E8267
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:26:21 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id y11so3129849plg.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678389981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jIvNZpJ81sA1BdAg3dHE543o/j6unwNvmKCmX/pvn6s=;
        b=C/VSMQ12ulexTQB8XU0C/hEGPidIgmgQhmsAA6NJBhkBMFH6+QamADXSt5tBgQvdHH
         O6gCVkDjG2VZd8ch+nX3oM39JHqR+nvM9tOWK75LdeZHFm5RtTW+0JPYcIXYJiGmaazy
         A0MloNDKvtPeh0dUn7eC1XIGNLAhDRMV0sefo1nUXlXHnLxc7VS9kBrtyQ1YIDO3m5FI
         Pes/Aw8LCGPtEwAiPvmDBEaOJt43SClGoxM/W/1Iki8DGmbFIHJV2yORxaWJovddP8Sk
         0pjbtkAlS/7wyi0MAAN6xCqOorIHFOuzjYNOrHtHNBCs80zZLGQeYrRVL7yPjAcQ6pPW
         lJgA==
X-Gm-Message-State: AO0yUKUwDFBXCItj6VLe7Qb4G4sn51aN8mOeyqSohFW6EExdy6ceqTXE
        ND/nvWkJt9qMP1ZpbewVjDWYTu5kelk=
X-Google-Smtp-Source: AK7set/01ptM1yKB2jzot3OvrgD+Pnhhd8LwXN8nu6AnqiGUgwZ6RFioKWNTsBXFmVZ5lNryF4ViBg==
X-Received: by 2002:a05:6a20:8f0c:b0:cd:1ccf:2485 with SMTP id b12-20020a056a208f0c00b000cd1ccf2485mr8685769pzk.16.1678389980906;
        Thu, 09 Mar 2023 11:26:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:26:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/82] Constify most SCSI host templates
Date:   Thu,  9 Mar 2023 11:24:52 -0800
Message-Id: <20230309192614.2240602-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

It helps humans and the compiler if it is made explicit that SCSI host
templates are not modified. Hence this patch series that constifies most
SCSI host templates. Please consider this patch series for the next merge
window.

Thanks,

Bart.

Changes compared to v1:
- Simplified the qla2xxx patch as requested by John Garry.
- Removed a file from the ata patch that was added accidentally.
- Extracted the isci changes from the iscsi patch and moved these into a
  separate patch.
- Added Reviewed-by / Acked-by tags.

Bart Van Assche (82):
  scsi: qla2xxx: Refer directly to the qla2xxx_driver_template
  scsi: core: Declare most SCSI host template pointers const
  scsi: core: Declare SCSI host template pointer members const
  ata: Declare SCSI host templates const
  firewire: sbp2: Declare the SCSI host template const
  RDMA/srp: Declare the SCSI host template const
  scsi: message: fusion: Declare SCSI host template members const
  scsi: zfcp: Declare SCSI host template const
  scsi: 3w-9xxx: Declare SCSI host template const
  scsi: 3w-sas: Declare SCSI host template const
  scsi: 3w-xxxx: Declare SCSI host template const
  scsi: BusLogic: Declare SCSI host template const
  scsi: a100u2w: Declare SCSI host template const
  scsi: a2091: Declare SCSI host template const
  scsi: a3000: Declare SCSI host template const
  scsi: aacraid: Declare SCSI host template const
  scsi: advansys: Declare SCSI host template const
  scsi: aha152x: Declare SCSI host template const
  scsi: aha1542: Declare SCSI host template const
  scsi: aic94xx: Declare SCSI host template const
  scsi: arcmsr: Declare SCSI host template const
  scsi: acornscsi: Declare SCSI host template const
  scsi: arxescsi: Declare SCSI host template const
  scsi: aha1740: Declare SCSI host template const
  scsi: cumana: Declare SCSI host template const
  scsi: eesox: Declare SCSI host template const
  scsi: oak: Declare SCSI host template const
  scsi: powertec: Declare SCSI host template const
  scsi: atp870u: Declare SCSI host template const
  scsi: dc395x: Declare SCSI host template const
  scsi: dmx3191d: Declare SCSI host template const
  scsi: elx: efct: Declare SCSI host template const
  scsi: esas2r: Declare SCSI host template const
  scsi: esp_scsi: Declare SCSI host template const
  scsi: fcoe: Declare SCSI host template const
  scsi: fnic: Declare host template const
  scsi: qedf: Declare host template const
  scsi: fdomain: Declare SCSI host template const
  scsi: NCR5380: Declare SCSI host template const
  scsi: gvp11: Declare SCSI host template const
  scsi: hisi_sas: Declare SCSI host template const
  scsi: hpsa: Declare SCSI host template const
  scsi: hptiop: Declare SCSI host template const
  scsi: ibmvfc: Declare SCSI host template const
  scsi: imm: Declare SCSI host template const
  scsi: initio: Declare SCSI host template const
  scsi: ipr: Declare SCSI host template const
  scsi: isci: Declare SCSI host template const
  scsi: iscsi: Declare SCSI host template const
  scsi: mac53c94: Declare SCSI host template const
  scsi: mac_scsi: Declare SCSI host template const
  scsi: megaraid: Declare SCSI host template const
  scsi: mesh: Declare SCSI host template const
  scsi: mpi3mr: Declare SCSI host template const
  scsi: mpt3sas: Declare SCSI host template const
  scsi: mvme147: Declare SCSI host template const
  scsi: mvsas: Declare SCSI host template const
  scsi: mvumi: Declare SCSI host template const
  scsi: myrb: Declare SCSI host template const
  scsi: myrs: Declare SCSI host template const
  scsi: nsp32: Declare SCSI host template const
  scsi: pcmcia-sym53c500: Declare SCSI host template const
  scsi: pcmcia-pm8001: Declare SCSI host template const
  scsi: pmcraid: Declare SCSI host template const
  scsi: ppa: Declare SCSI host template const
  scsi: ps3rom: Declare SCSI host template const
  scsi: qla1280: Declare SCSI host template const
  scsi: qla2xxx: Declare SCSI host template const
  scsi: qlogicpti: Declare SCSI host template const
  scsi: sgiwd93: Declare SCSI host template const
  scsi: smartpqi: Declare SCSI host template const
  scsi: snic: Declare SCSI host template const
  scsi: stex: Declare SCSI host template const
  scsi: sym53c8xx: Declare SCSI host template const
  scsi: virtio-scsi: Declare SCSI host template const
  scsi: wd719x: Declare SCSI host template const
  scsi: xen-scsifront: Declare SCSI host template const
  scsi: rts5208: Declare SCSI host template const
  scsi: target: tcm-loop: Declare SCSI host template const
  scsi: ufs: Declare SCSI host template const
  usb: uas: Declare two host templates and host template pointers const
  scsi: core: Update a source code comment

 drivers/ata/acard-ahci.c                  |  2 +-
 drivers/ata/ahci.c                        |  2 +-
 drivers/ata/ahci.h                        |  2 +-
 drivers/ata/ahci_brcm.c                   |  2 +-
 drivers/ata/ahci_ceva.c                   |  2 +-
 drivers/ata/ahci_da850.c                  |  2 +-
 drivers/ata/ahci_dm816.c                  |  2 +-
 drivers/ata/ahci_dwc.c                    |  2 +-
 drivers/ata/ahci_imx.c                    |  2 +-
 drivers/ata/ahci_mtk.c                    |  2 +-
 drivers/ata/ahci_mvebu.c                  |  2 +-
 drivers/ata/ahci_platform.c               |  2 +-
 drivers/ata/ahci_qoriq.c                  |  2 +-
 drivers/ata/ahci_seattle.c                |  2 +-
 drivers/ata/ahci_st.c                     |  2 +-
 drivers/ata/ahci_sunxi.c                  |  2 +-
 drivers/ata/ahci_tegra.c                  |  2 +-
 drivers/ata/ahci_xgene.c                  |  2 +-
 drivers/ata/ata_generic.c                 |  2 +-
 drivers/ata/ata_piix.c                    |  6 +++---
 drivers/ata/libahci.c                     |  4 ++--
 drivers/ata/libahci_platform.c            |  2 +-
 drivers/ata/libata-core.c                 |  4 ++--
 drivers/ata/libata-scsi.c                 |  2 +-
 drivers/ata/libata-sff.c                  |  8 ++++----
 drivers/ata/libata.h                      |  2 +-
 drivers/ata/pata_acpi.c                   |  2 +-
 drivers/ata/pata_ali.c                    |  2 +-
 drivers/ata/pata_amd.c                    |  2 +-
 drivers/ata/pata_arasan_cf.c              |  2 +-
 drivers/ata/pata_artop.c                  |  2 +-
 drivers/ata/pata_atiixp.c                 |  2 +-
 drivers/ata/pata_atp867x.c                |  2 +-
 drivers/ata/pata_buddha.c                 |  2 +-
 drivers/ata/pata_cmd640.c                 |  2 +-
 drivers/ata/pata_cmd64x.c                 |  2 +-
 drivers/ata/pata_cs5520.c                 |  2 +-
 drivers/ata/pata_cs5530.c                 |  2 +-
 drivers/ata/pata_cs5535.c                 |  2 +-
 drivers/ata/pata_cs5536.c                 |  2 +-
 drivers/ata/pata_cypress.c                |  2 +-
 drivers/ata/pata_efar.c                   |  2 +-
 drivers/ata/pata_ep93xx.c                 |  2 +-
 drivers/ata/pata_falcon.c                 |  2 +-
 drivers/ata/pata_ftide010.c               |  2 +-
 drivers/ata/pata_gayle.c                  |  2 +-
 drivers/ata/pata_hpt366.c                 |  2 +-
 drivers/ata/pata_hpt37x.c                 |  2 +-
 drivers/ata/pata_hpt3x2n.c                |  2 +-
 drivers/ata/pata_hpt3x3.c                 |  2 +-
 drivers/ata/pata_icside.c                 |  2 +-
 drivers/ata/pata_imx.c                    |  2 +-
 drivers/ata/pata_isapnp.c                 |  2 +-
 drivers/ata/pata_it8213.c                 |  2 +-
 drivers/ata/pata_it821x.c                 |  2 +-
 drivers/ata/pata_ixp4xx_cf.c              |  2 +-
 drivers/ata/pata_jmicron.c                |  2 +-
 drivers/ata/pata_legacy.c                 |  2 +-
 drivers/ata/pata_macio.c                  |  2 +-
 drivers/ata/pata_marvell.c                |  2 +-
 drivers/ata/pata_mpc52xx.c                |  2 +-
 drivers/ata/pata_mpiix.c                  |  2 +-
 drivers/ata/pata_netcell.c                |  2 +-
 drivers/ata/pata_ninja32.c                |  2 +-
 drivers/ata/pata_ns87410.c                |  2 +-
 drivers/ata/pata_ns87415.c                |  2 +-
 drivers/ata/pata_octeon_cf.c              |  2 +-
 drivers/ata/pata_of_platform.c            |  2 +-
 drivers/ata/pata_oldpiix.c                |  2 +-
 drivers/ata/pata_opti.c                   |  2 +-
 drivers/ata/pata_optidma.c                |  2 +-
 drivers/ata/pata_parport/pata_parport.c   |  2 +-
 drivers/ata/pata_pcmcia.c                 |  2 +-
 drivers/ata/pata_pdc2027x.c               |  2 +-
 drivers/ata/pata_pdc202xx_old.c           |  2 +-
 drivers/ata/pata_piccolo.c                |  2 +-
 drivers/ata/pata_platform.c               |  4 ++--
 drivers/ata/pata_pxa.c                    |  2 +-
 drivers/ata/pata_radisys.c                |  2 +-
 drivers/ata/pata_rb532_cf.c               |  2 +-
 drivers/ata/pata_rdc.c                    |  2 +-
 drivers/ata/pata_rz1000.c                 |  2 +-
 drivers/ata/pata_sc1200.c                 |  2 +-
 drivers/ata/pata_sch.c                    |  2 +-
 drivers/ata/pata_serverworks.c            |  6 +++---
 drivers/ata/pata_sil680.c                 |  2 +-
 drivers/ata/pata_sis.c                    |  2 +-
 drivers/ata/pata_sl82c105.c               |  2 +-
 drivers/ata/pata_triflex.c                |  2 +-
 drivers/ata/pata_via.c                    |  2 +-
 drivers/ata/pdc_adma.c                    |  2 +-
 drivers/ata/sata_dwc_460ex.c              |  2 +-
 drivers/ata/sata_fsl.c                    |  2 +-
 drivers/ata/sata_highbank.c               |  2 +-
 drivers/ata/sata_inic162x.c               |  2 +-
 drivers/ata/sata_mv.c                     |  4 ++--
 drivers/ata/sata_nv.c                     |  8 ++++----
 drivers/ata/sata_promise.c                |  2 +-
 drivers/ata/sata_qstor.c                  |  2 +-
 drivers/ata/sata_rcar.c                   |  2 +-
 drivers/ata/sata_sil.c                    |  2 +-
 drivers/ata/sata_sil24.c                  |  2 +-
 drivers/ata/sata_sis.c                    |  2 +-
 drivers/ata/sata_svw.c                    |  2 +-
 drivers/ata/sata_sx4.c                    |  2 +-
 drivers/ata/sata_uli.c                    |  2 +-
 drivers/ata/sata_via.c                    |  2 +-
 drivers/ata/sata_vsc.c                    |  2 +-
 drivers/firewire/sbp2.c                   |  4 ++--
 drivers/infiniband/ulp/iser/iscsi_iser.c  |  4 ++--
 drivers/infiniband/ulp/srp/ib_srp.c       |  2 +-
 drivers/message/fusion/mptfc.c            |  2 +-
 drivers/message/fusion/mptsas.c           |  2 +-
 drivers/message/fusion/mptspi.c           |  2 +-
 drivers/s390/scsi/zfcp_scsi.c             |  2 +-
 drivers/scsi/3w-9xxx.c                    |  3 +--
 drivers/scsi/3w-sas.c                     |  3 +--
 drivers/scsi/3w-xxxx.c                    |  2 +-
 drivers/scsi/BusLogic.c                   |  4 ++--
 drivers/scsi/a100u2w.c                    |  2 +-
 drivers/scsi/a2091.c                      |  2 +-
 drivers/scsi/a3000.c                      |  2 +-
 drivers/scsi/aacraid/linit.c              |  2 +-
 drivers/scsi/advansys.c                   |  2 +-
 drivers/scsi/aha152x.c                    |  4 ++--
 drivers/scsi/aha1542.c                    |  5 +++--
 drivers/scsi/aha1740.c                    |  2 +-
 drivers/scsi/aic94xx/aic94xx_init.c       |  2 +-
 drivers/scsi/am53c974.c                   |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          |  2 +-
 drivers/scsi/arm/acornscsi.c              |  2 +-
 drivers/scsi/arm/arxescsi.c               |  2 +-
 drivers/scsi/arm/cumana_1.c               |  2 +-
 drivers/scsi/arm/cumana_2.c               |  2 +-
 drivers/scsi/arm/eesox.c                  |  2 +-
 drivers/scsi/arm/oak.c                    |  2 +-
 drivers/scsi/arm/powertec.c               |  2 +-
 drivers/scsi/atp870u.c                    |  4 ++--
 drivers/scsi/be2iscsi/be_main.c           |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |  4 ++--
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c        |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c             |  2 +-
 drivers/scsi/cxgbi/libcxgbi.h             |  2 +-
 drivers/scsi/dc395x.c                     |  2 +-
 drivers/scsi/dmx3191d.c                   |  2 +-
 drivers/scsi/elx/efct/efct_xport.c        |  2 +-
 drivers/scsi/esas2r/esas2r_main.c         |  2 +-
 drivers/scsi/esp_scsi.c                   |  2 +-
 drivers/scsi/esp_scsi.h                   |  2 +-
 drivers/scsi/fcoe/fcoe.c                  |  2 +-
 drivers/scsi/fdomain.c                    |  2 +-
 drivers/scsi/fnic/fnic_main.c             |  2 +-
 drivers/scsi/g_NCR5380.c                  |  4 ++--
 drivers/scsi/gvp11.c                      |  2 +-
 drivers/scsi/hisi_sas/hisi_sas.h          |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  2 +-
 drivers/scsi/hosts.c                      |  4 ++--
 drivers/scsi/hpsa.c                       |  2 +-
 drivers/scsi/hptiop.c                     |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |  2 +-
 drivers/scsi/imm.c                        |  2 +-
 drivers/scsi/initio.c                     |  2 +-
 drivers/scsi/ipr.c                        |  2 +-
 drivers/scsi/isci/init.c                  |  2 +-
 drivers/scsi/iscsi_tcp.c                  |  4 ++--
 drivers/scsi/jazz_esp.c                   |  2 +-
 drivers/scsi/libiscsi.c                   |  2 +-
 drivers/scsi/mac53c94.c                   |  2 +-
 drivers/scsi/mac_esp.c                    |  2 +-
 drivers/scsi/mac_scsi.c                   |  2 +-
 drivers/scsi/megaraid.c                   |  2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 drivers/scsi/mesh.c                       |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  4 ++--
 drivers/scsi/mvme147.c                    |  2 +-
 drivers/scsi/mvsas/mv_init.c              |  2 +-
 drivers/scsi/mvumi.c                      |  2 +-
 drivers/scsi/myrb.c                       |  2 +-
 drivers/scsi/myrs.c                       |  2 +-
 drivers/scsi/nsp32.c                      |  2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c        |  4 ++--
 drivers/scsi/pm8001/pm8001_init.c         |  2 +-
 drivers/scsi/pmcraid.c                    |  2 +-
 drivers/scsi/ppa.c                        |  2 +-
 drivers/scsi/ps3rom.c                     |  2 +-
 drivers/scsi/qedf/qedf_main.c             |  2 +-
 drivers/scsi/qedi/qedi_gbl.h              |  2 +-
 drivers/scsi/qedi/qedi_iscsi.c            |  2 +-
 drivers/scsi/qla1280.c                    |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h            |  2 +-
 drivers/scsi/qla2xxx/qla_mid.c            |  2 +-
 drivers/scsi/qla2xxx/qla_os.c             |  4 ++--
 drivers/scsi/qla2xxx/qla_target.c         |  3 +--
 drivers/scsi/qlogicpti.c                  |  2 +-
 drivers/scsi/scsi_error.c                 | 16 ++++++++--------
 drivers/scsi/scsi_sysfs.c                 |  6 +++---
 drivers/scsi/sgiwd93.c                    |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |  2 +-
 drivers/scsi/snic/snic_main.c             |  2 +-
 drivers/scsi/stex.c                       |  2 +-
 drivers/scsi/sun3x_esp.c                  |  2 +-
 drivers/scsi/sun_esp.c                    |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |  4 ++--
 drivers/scsi/virtio_scsi.c                |  2 +-
 drivers/scsi/wd719x.c                     |  2 +-
 drivers/scsi/xen-scsifront.c              |  2 +-
 drivers/scsi/zorro_esp.c                  |  2 +-
 drivers/staging/rts5208/rtsx.c            |  2 +-
 drivers/target/loopback/tcm_loop.c        |  2 +-
 drivers/ufs/core/ufshcd.c                 |  2 +-
 drivers/usb/image/microtek.c              |  2 +-
 drivers/usb/storage/uas.c                 |  2 +-
 drivers/usb/storage/usb.c                 |  2 +-
 drivers/usb/storage/usb.h                 |  2 +-
 include/linux/ahci_platform.h             |  2 +-
 include/linux/ata_platform.h              |  2 +-
 include/linux/libata.h                    | 10 +++++-----
 include/linux/raid_class.h                |  2 +-
 include/scsi/libfc.h                      |  2 +-
 include/scsi/libiscsi.h                   |  2 +-
 include/scsi/scsi_host.h                  |  6 +++---
 225 files changed, 269 insertions(+), 271 deletions(-)

