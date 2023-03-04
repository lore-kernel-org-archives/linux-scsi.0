Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BC9C64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCDAbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDAbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:15 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7CC69214
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:10 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so3935599pjz.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kzwkSug2S/LETrh9uQa8LXpd+pJWg9C3yCUK20kcafE=;
        b=FV5FxEimwK25yl9alFJjw23FK/U3fCKgyNe4AkJghD8We8vyydiWjg1RroIYkVV/mr
         IXpG80Rk6trEtW3LCeh8XfLSMYQeWv3pImkqojUHgH7C7AWTNoc7qouuRgM9jdJ9zJf7
         t8SkwQdD9lSy2FZDdJ2ZNr6PAYSsStYh/amoK65TrvT25xunYGkFW+Wj1m3m27eiDyq7
         gZ9mK3E4sapLzcHeDZrUv7xoGOsrPPAinmb6dpUUPNdmVAYar028lH5SrHBg9Rmku1rg
         tSOKWQKjdByuRSymOjeuT0HNXzzXZmsTWBmhL7IC/JYZnPfh947YP3YIwZ+qi7Ghjegx
         ewgQ==
X-Gm-Message-State: AO0yUKXiUPS1lmTohDD2i67o2aNXe7x37WSUhhupjmpMNse5GuxSjHsE
        yt1cQmwh3Vp4L61OtYOqZZns8q4++UQ=
X-Google-Smtp-Source: AK7set9JrNVCwRHEfAtVk2cv5WJCHHS1mISdhzonINs3oGrI7kZixBclIXgwPJXXUzFpW9rHXOIOmw==
X-Received: by 2002:a17:902:eb49:b0:19c:a5dd:cea6 with SMTP id i9-20020a170902eb4900b0019ca5ddcea6mr3542213pli.43.1677889869620;
        Fri, 03 Mar 2023 16:31:09 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/81] Constify most SCSI host templates
Date:   Fri,  3 Mar 2023 16:29:42 -0800
Message-Id: <20230304003103.2572793-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
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

Bart Van Assche (81):
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

 drivers/ata/acard-ahci.c                  |   2 +-
 drivers/ata/ahci.c                        |   2 +-
 drivers/ata/ahci.h                        |   2 +-
 drivers/ata/ahci_brcm.c                   |   2 +-
 drivers/ata/ahci_ceva.c                   |   2 +-
 drivers/ata/ahci_da850.c                  |   2 +-
 drivers/ata/ahci_dm816.c                  |   2 +-
 drivers/ata/ahci_imx.c                    |   2 +-
 drivers/ata/ahci_mtk.c                    |   2 +-
 drivers/ata/ahci_mvebu.c                  |   2 +-
 drivers/ata/ahci_platform.c               |   2 +-
 drivers/ata/ahci_qoriq.c                  |   2 +-
 drivers/ata/ahci_seattle.c                |   2 +-
 drivers/ata/ahci_st.c                     |   2 +-
 drivers/ata/ahci_sunxi.c                  |   2 +-
 drivers/ata/ahci_tegra.c                  |   2 +-
 drivers/ata/ahci_xgene.c                  |   2 +-
 drivers/ata/ata_generic.c                 |   2 +-
 drivers/ata/ata_piix.c                    |   6 +-
 drivers/ata/libahci.c                     |   4 +-
 drivers/ata/libahci_platform.c            |   2 +-
 drivers/ata/libata-core.c                 |   4 +-
 drivers/ata/libata-scsi.c                 |   2 +-
 drivers/ata/libata-sff.c                  |   8 +-
 drivers/ata/libata.h                      |   2 +-
 drivers/ata/pata_acpi.c                   |   2 +-
 drivers/ata/pata_ali.c                    |   2 +-
 drivers/ata/pata_amd.c                    |   2 +-
 drivers/ata/pata_arasan_cf.c              |   2 +-
 drivers/ata/pata_artop.c                  |   2 +-
 drivers/ata/pata_atiixp.c                 |   2 +-
 drivers/ata/pata_atp867x.c                |   2 +-
 drivers/ata/pata_bk3710.c                 | 380 ++++++++++++++++++++++
 drivers/ata/pata_buddha.c                 |   2 +-
 drivers/ata/pata_cmd640.c                 |   2 +-
 drivers/ata/pata_cmd64x.c                 |   2 +-
 drivers/ata/pata_cs5520.c                 |   2 +-
 drivers/ata/pata_cs5530.c                 |   2 +-
 drivers/ata/pata_cs5535.c                 |   2 +-
 drivers/ata/pata_cs5536.c                 |   2 +-
 drivers/ata/pata_cypress.c                |   2 +-
 drivers/ata/pata_efar.c                   |   2 +-
 drivers/ata/pata_ep93xx.c                 |   2 +-
 drivers/ata/pata_falcon.c                 |   2 +-
 drivers/ata/pata_ftide010.c               |   2 +-
 drivers/ata/pata_gayle.c                  |   2 +-
 drivers/ata/pata_hpt366.c                 |   2 +-
 drivers/ata/pata_hpt37x.c                 |   2 +-
 drivers/ata/pata_hpt3x2n.c                |   2 +-
 drivers/ata/pata_hpt3x3.c                 |   2 +-
 drivers/ata/pata_icside.c                 |   2 +-
 drivers/ata/pata_imx.c                    |   2 +-
 drivers/ata/pata_isapnp.c                 |   2 +-
 drivers/ata/pata_it8213.c                 |   2 +-
 drivers/ata/pata_it821x.c                 |   2 +-
 drivers/ata/pata_ixp4xx_cf.c              |   2 +-
 drivers/ata/pata_jmicron.c                |   2 +-
 drivers/ata/pata_legacy.c                 |   2 +-
 drivers/ata/pata_macio.c                  |   2 +-
 drivers/ata/pata_marvell.c                |   2 +-
 drivers/ata/pata_mpc52xx.c                |   2 +-
 drivers/ata/pata_mpiix.c                  |   2 +-
 drivers/ata/pata_netcell.c                |   2 +-
 drivers/ata/pata_ninja32.c                |   2 +-
 drivers/ata/pata_ns87410.c                |   2 +-
 drivers/ata/pata_ns87415.c                |   2 +-
 drivers/ata/pata_octeon_cf.c              |   2 +-
 drivers/ata/pata_of_platform.c            |   2 +-
 drivers/ata/pata_oldpiix.c                |   2 +-
 drivers/ata/pata_opti.c                   |   2 +-
 drivers/ata/pata_optidma.c                |   2 +-
 drivers/ata/pata_pcmcia.c                 |   2 +-
 drivers/ata/pata_pdc2027x.c               |   2 +-
 drivers/ata/pata_pdc202xx_old.c           |   2 +-
 drivers/ata/pata_piccolo.c                |   2 +-
 drivers/ata/pata_platform.c               |   4 +-
 drivers/ata/pata_pxa.c                    |   2 +-
 drivers/ata/pata_radisys.c                |   2 +-
 drivers/ata/pata_rb532_cf.c               |   2 +-
 drivers/ata/pata_rdc.c                    |   2 +-
 drivers/ata/pata_rz1000.c                 |   2 +-
 drivers/ata/pata_sc1200.c                 |   2 +-
 drivers/ata/pata_sch.c                    |   2 +-
 drivers/ata/pata_serverworks.c            |   6 +-
 drivers/ata/pata_sil680.c                 |   2 +-
 drivers/ata/pata_sis.c                    |   2 +-
 drivers/ata/pata_sl82c105.c               |   2 +-
 drivers/ata/pata_triflex.c                |   2 +-
 drivers/ata/pata_via.c                    |   2 +-
 drivers/ata/pdc_adma.c                    |   2 +-
 drivers/ata/sata_dwc_460ex.c              |   2 +-
 drivers/ata/sata_fsl.c                    |   2 +-
 drivers/ata/sata_highbank.c               |   2 +-
 drivers/ata/sata_inic162x.c               |   2 +-
 drivers/ata/sata_mv.c                     |   4 +-
 drivers/ata/sata_nv.c                     |   8 +-
 drivers/ata/sata_promise.c                |   2 +-
 drivers/ata/sata_qstor.c                  |   2 +-
 drivers/ata/sata_rcar.c                   |   2 +-
 drivers/ata/sata_sil.c                    |   2 +-
 drivers/ata/sata_sil24.c                  |   2 +-
 drivers/ata/sata_sis.c                    |   2 +-
 drivers/ata/sata_svw.c                    |   2 +-
 drivers/ata/sata_sx4.c                    |   2 +-
 drivers/ata/sata_uli.c                    |   2 +-
 drivers/ata/sata_via.c                    |   2 +-
 drivers/ata/sata_vsc.c                    |   2 +-
 drivers/firewire/sbp2.c                   |   4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c  |   4 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |   2 +-
 drivers/message/fusion/mptfc.c            |   2 +-
 drivers/message/fusion/mptsas.c           |   2 +-
 drivers/message/fusion/mptspi.c           |   2 +-
 drivers/s390/scsi/zfcp_scsi.c             |   2 +-
 drivers/scsi/3w-9xxx.c                    |   3 +-
 drivers/scsi/3w-sas.c                     |   3 +-
 drivers/scsi/3w-xxxx.c                    |   2 +-
 drivers/scsi/BusLogic.c                   |   4 +-
 drivers/scsi/a100u2w.c                    |   2 +-
 drivers/scsi/a2091.c                      |   2 +-
 drivers/scsi/a3000.c                      |   2 +-
 drivers/scsi/aacraid/linit.c              |   2 +-
 drivers/scsi/advansys.c                   |   2 +-
 drivers/scsi/aha152x.c                    |   4 +-
 drivers/scsi/aha1542.c                    |   5 +-
 drivers/scsi/aha1740.c                    |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c       |   2 +-
 drivers/scsi/am53c974.c                   |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          |   2 +-
 drivers/scsi/arm/acornscsi.c              |   2 +-
 drivers/scsi/arm/arxescsi.c               |   2 +-
 drivers/scsi/arm/cumana_1.c               |   2 +-
 drivers/scsi/arm/cumana_2.c               |   2 +-
 drivers/scsi/arm/eesox.c                  |   2 +-
 drivers/scsi/arm/oak.c                    |   2 +-
 drivers/scsi/arm/powertec.c               |   2 +-
 drivers/scsi/atp870u.c                    |   4 +-
 drivers/scsi/be2iscsi/be_main.c           |   2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |   4 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c        |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c             |   2 +-
 drivers/scsi/cxgbi/libcxgbi.h             |   2 +-
 drivers/scsi/dc395x.c                     |   2 +-
 drivers/scsi/dmx3191d.c                   |   2 +-
 drivers/scsi/elx/efct/efct_xport.c        |   2 +-
 drivers/scsi/esas2r/esas2r_main.c         |   2 +-
 drivers/scsi/esp_scsi.c                   |   2 +-
 drivers/scsi/esp_scsi.h                   |   2 +-
 drivers/scsi/fcoe/fcoe.c                  |   2 +-
 drivers/scsi/fdomain.c                    |   2 +-
 drivers/scsi/fnic/fnic_main.c             |   2 +-
 drivers/scsi/g_NCR5380.c                  |   4 +-
 drivers/scsi/gvp11.c                      |   2 +-
 drivers/scsi/hisi_sas/hisi_sas.h          |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |   2 +-
 drivers/scsi/hosts.c                      |   4 +-
 drivers/scsi/hpsa.c                       |   2 +-
 drivers/scsi/hptiop.c                     |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |   2 +-
 drivers/scsi/imm.c                        |   2 +-
 drivers/scsi/initio.c                     |   2 +-
 drivers/scsi/ipr.c                        |   2 +-
 drivers/scsi/isci/init.c                  |   2 +-
 drivers/scsi/iscsi_tcp.c                  |   4 +-
 drivers/scsi/jazz_esp.c                   |   2 +-
 drivers/scsi/libiscsi.c                   |   2 +-
 drivers/scsi/mac53c94.c                   |   2 +-
 drivers/scsi/mac_esp.c                    |   2 +-
 drivers/scsi/mac_scsi.c                   |   2 +-
 drivers/scsi/megaraid.c                   |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   2 +-
 drivers/scsi/mesh.c                       |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |   4 +-
 drivers/scsi/mvme147.c                    |   2 +-
 drivers/scsi/mvsas/mv_init.c              |   2 +-
 drivers/scsi/mvumi.c                      |   2 +-
 drivers/scsi/myrb.c                       |   2 +-
 drivers/scsi/myrs.c                       |   2 +-
 drivers/scsi/nsp32.c                      |   2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c        |   4 +-
 drivers/scsi/pm8001/pm8001_init.c         |   2 +-
 drivers/scsi/pmcraid.c                    |   2 +-
 drivers/scsi/ppa.c                        |   2 +-
 drivers/scsi/ps3rom.c                     |   2 +-
 drivers/scsi/qedf/qedf_main.c             |   2 +-
 drivers/scsi/qedi/qedi_gbl.h              |   2 +-
 drivers/scsi/qedi/qedi_iscsi.c            |   2 +-
 drivers/scsi/qla1280.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h            |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c            |   2 +-
 drivers/scsi/qla2xxx/qla_os.c             |   4 +-
 drivers/scsi/qla2xxx/qla_target.c         |   4 +-
 drivers/scsi/qlogicpti.c                  |   2 +-
 drivers/scsi/scsi_error.c                 |  16 +-
 drivers/scsi/scsi_sysfs.c                 |   6 +-
 drivers/scsi/sgiwd93.c                    |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |   2 +-
 drivers/scsi/snic/snic_main.c             |   2 +-
 drivers/scsi/stex.c                       |   2 +-
 drivers/scsi/sun3x_esp.c                  |   2 +-
 drivers/scsi/sun_esp.c                    |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |   4 +-
 drivers/scsi/virtio_scsi.c                |   2 +-
 drivers/scsi/wd719x.c                     |   2 +-
 drivers/scsi/xen-scsifront.c              |   2 +-
 drivers/scsi/zorro_esp.c                  |   2 +-
 drivers/staging/rts5208/rtsx.c            |   2 +-
 drivers/target/loopback/tcm_loop.c        |   2 +-
 drivers/ufs/core/ufshcd.c                 |   2 +-
 drivers/usb/image/microtek.c              |   2 +-
 drivers/usb/storage/uas.c                 |   2 +-
 drivers/usb/storage/usb.c                 |   2 +-
 drivers/usb/storage/usb.h                 |   2 +-
 include/linux/ahci_platform.h             |   2 +-
 include/linux/ata_platform.h              |   2 +-
 include/linux/libata.h                    |  10 +-
 include/linux/raid_class.h                |   2 +-
 include/scsi/libfc.h                      |   2 +-
 include/scsi/libiscsi.h                   |   2 +-
 include/scsi/scsi_host.h                  |   6 +-
 224 files changed, 648 insertions(+), 269 deletions(-)
 create mode 100644 drivers/ata/pata_bk3710.c

