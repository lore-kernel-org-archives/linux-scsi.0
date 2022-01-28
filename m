Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DA2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbiA1WUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:33 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:36663 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiA1WUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:33 -0500
Received: by mail-pf1-f182.google.com with SMTP id 192so7451252pfz.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sByoMNKaUkt7cnWImXbtJRisj7SLJ1wzUHpnIXtSIUk=;
        b=WEeeZtSu6KTlAAY3QhSQi/v8eKZ3/4rIq0SzePFmCxRY+6zfqoYnHwyfBiE4gSp67Q
         4+dhBkDCALkvFD/HjFkFNnpHUQF4pdrp7OMW+sEeVAhFbdNDvlTtwu6eh5O5wyTgLPUb
         s71awsFerZn1pebm01E/rG07acE/i9bhrOZGVxN+52CO7PxAAPqBUg6uYN+kBoBHLHxW
         nFd+exSllAdY2aFocglGke6O6Kt1BIGqummd9YEKzuaDdAPCLZ8fED25Oiqivj93Rimt
         BvQbQs5lR79Nf4JYGMzvcKBxHnxudW5rhdYTXMRpL4P2hsevJ74OumIcHZkPWlGI+yug
         rKOA==
X-Gm-Message-State: AOAM533BHT2qOJumghhJFH4IRsYhqHjg25akKhZOjVsZPUTUnarnvWRe
        nxtYl8BhYlS7ujkNOSuERVM=
X-Google-Smtp-Source: ABdhPJyuKDiB9nO44SNbUMYVi/wit+lQEVhtj3ECeXD8JoOHCfpb7XGxoHe5Ty2EKe7xjK4F8OjU+w==
X-Received: by 2002:a63:f20b:: with SMTP id v11mr2811801pgh.398.1643408432258;
        Fri, 28 Jan 2022 14:20:32 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/44] Remove the SCSI pointer from struct scsi_cmnd
Date:   Fri, 28 Jan 2022 14:18:25 -0800
Message-Id: <20220128221909.8141-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The size of struct scsi_cmnd matters for embedded devices. One of the
largest members of that structure is the SCSI pointer. That structure is
only relevant for SCSI-II drivers but not for modern SCSI drivers. Hence
this patch series that removes the SCSI pointer from struct scsi_cmnd.
Please consider this patch series for kernel v5.18.

Thanks,

Bart.

Bart Van Assche (44):
  ips: Use true and false instead of TRUE and FALSE
  nsp_cs: Use true and false instead of TRUE and FALSE
  scsi: Remove drivers/scsi/scsi.h
  NCR5380: Remove the NCR5380_CMD_SIZE macro
  NCR5380: Move the SCSI pointer to private command data
  scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
  scsi: arm: Move the SCSI pointer to private command data
  53c700: Stop clearing SCSI pointer fields
  aacraid: Move the SCSI pointer to private command data
  advansys: Move the SCSI pointer to private command data
  aha1542: Remove a set-but-not-used array
  aha152x: Move the SCSI pointer to private command data
  bfa: Stop using the SCSI pointer
  csio: Stop using the SCSI pointer
  dc395x: Stop using the SCSI pointer
  esp_scsi: Stop using the SCSI pointer
  fdomain: Move the SCSI pointer to private command data
  fnic: Fix a tracing statement
  fnic: Stop using the SCSI pointer
  hptiop: Stop using the SCSI pointer
  imm: Move the SCSI pointer to private command data
  iscsi: Stop using the SCSI pointer
  initio: Stop using the SCSI pointer
  libfc: Stop using the SCSI pointer
  mac53c94: Fix a set-but-not-used compiler warning
  mac53c94: Move the SCSI pointer to private command data
  megaraid: Stop using the SCSI pointer
  megasas: Stop using the SCSI pointer
  mesh: Move the SCSI pointer to private command data
  mvsas: Fix a set-but-not-used warning
  mvumi: Stop using the SCSI pointer
  nsp32: Stop using the SCSI pointer
  nsp_cs: Move the SCSI pointer to private command data
  sym53c500_cs: Move the SCSI pointer to private command data
  ppa: Move the SCSI pointer to private command data
  qla1280: Move the SCSI pointer to private command data
  qla2xxx: Stop using the SCSI pointer
  smartpqi: Stop using the SCSI pointer
  sym53c8xx_2: Move the SCSI pointer to private command data
  scsi: usb: Stop using the SCSI pointer
  wd719x: Stop using the SCSI pointer
  wdc33c93: Move the SCSI pointer to private command data
  zalon: Stop using the SCSI pointer
  scsi: core: Remove struct scsi_pointer from struct scsi_cmnd

 drivers/infiniband/ulp/iser/iscsi_iser.c    |   1 +
 drivers/scsi/53c700.c                       |   2 -
 drivers/scsi/NCR5380.c                      |  83 +++---
 drivers/scsi/NCR5380.h                      |   8 +-
 drivers/scsi/a2091.c                        |  25 +-
 drivers/scsi/a3000.c                        |  25 +-
 drivers/scsi/aacraid/aachba.c               |  43 +--
 drivers/scsi/aacraid/aacraid.h              |  24 +-
 drivers/scsi/aacraid/comminit.c             |   2 +-
 drivers/scsi/aacraid/linit.c                |  21 +-
 drivers/scsi/advansys.c                     |  22 +-
 drivers/scsi/aha152x.c                      | 268 ++++++++++--------
 drivers/scsi/aha1542.c                      |   3 +-
 drivers/scsi/aha1740.c                      |   6 +-
 drivers/scsi/arm/acornscsi.c                |  28 +-
 drivers/scsi/arm/{scsi.h => arm_scsi.h}     |  37 ++-
 drivers/scsi/arm/arxescsi.c                 |   6 +-
 drivers/scsi/arm/cumana_1.c                 |   2 +-
 drivers/scsi/arm/cumana_2.c                 |   8 +-
 drivers/scsi/arm/eesox.c                    |   8 +-
 drivers/scsi/arm/fas216.c                   |  36 ++-
 drivers/scsi/arm/fas216.h                   |   1 +
 drivers/scsi/arm/oak.c                      |   2 +-
 drivers/scsi/arm/powertec.c                 |   8 +-
 drivers/scsi/arm/queue.c                    |   6 +-
 drivers/scsi/atari_scsi.c                   |   8 +-
 drivers/scsi/be2iscsi/be_main.c             |   3 +-
 drivers/scsi/bfa/bfad_im.c                  |  27 +-
 drivers/scsi/bfa/bfad_im.h                  |  16 ++
 drivers/scsi/bnx2fc/bnx2fc.h                |  10 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |   1 +
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  20 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |   1 +
 drivers/scsi/csiostor/csio_scsi.c           |  20 +-
 drivers/scsi/csiostor/csio_scsi.h           |  10 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |   1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |   1 +
 drivers/scsi/dc395x.c                       |   3 -
 drivers/scsi/dmx3191d.c                     |   2 +-
 drivers/scsi/esp_scsi.c                     |   1 +
 drivers/scsi/esp_scsi.h                     |   3 +-
 drivers/scsi/fcoe/fcoe.c                    |   1 +
 drivers/scsi/fdomain.c                      |  70 +++--
 drivers/scsi/fnic/fnic.h                    |  28 +-
 drivers/scsi/fnic/fnic_main.c               |   1 +
 drivers/scsi/fnic/fnic_scsi.c               | 289 ++++++++++----------
 drivers/scsi/g_NCR5380.c                    |   7 +-
 drivers/scsi/gvp11.c                        |  25 +-
 drivers/scsi/hptiop.c                       |   1 +
 drivers/scsi/hptiop.h                       |   4 +-
 drivers/scsi/imm.c                          |  88 +++---
 drivers/scsi/imm.h                          |  11 +
 drivers/scsi/initio.c                       |  14 +-
 drivers/scsi/initio.h                       |   9 +
 drivers/scsi/ips.c                          |  50 ++--
 drivers/scsi/iscsi_tcp.c                    |   1 +
 drivers/scsi/libfc/fc_fcp.c                 |  26 +-
 drivers/scsi/libiscsi.c                     |  22 +-
 drivers/scsi/mac53c94.c                     |  27 +-
 drivers/scsi/mac53c94.h                     |  11 +
 drivers/scsi/mac_scsi.c                     |   8 +-
 drivers/scsi/megaraid.c                     |  21 +-
 drivers/scsi/megaraid.h                     |  15 +-
 drivers/scsi/megaraid/megaraid_sas.h        |  12 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |   8 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  15 +-
 drivers/scsi/mesh.c                         |  20 +-
 drivers/scsi/mesh.h                         |  11 +
 drivers/scsi/mvme147.c                      |  16 +-
 drivers/scsi/mvsas/mv_init.c                |   7 +-
 drivers/scsi/mvumi.c                        |   9 +-
 drivers/scsi/mvumi.h                        |   9 +
 drivers/scsi/ncr53c8xx.c                    |  22 +-
 drivers/scsi/ncr53c8xx.h                    |   6 +
 drivers/scsi/nsp32.c                        |  21 +-
 drivers/scsi/nsp32.h                        |   9 +
 drivers/scsi/pcmcia/aha152x_stub.c          |  10 +-
 drivers/scsi/pcmcia/nsp_cs.c                | 252 +++++++++--------
 drivers/scsi/pcmcia/nsp_cs.h                |   8 +-
 drivers/scsi/pcmcia/nsp_debug.c             |   2 +-
 drivers/scsi/pcmcia/qlogic_stub.c           |  10 +-
 drivers/scsi/pcmcia/sym53c500_cs.c          |  53 ++--
 drivers/scsi/ppa.c                          |  81 +++---
 drivers/scsi/qedf/qedf.h                    |  11 +-
 drivers/scsi/qedf/qedf_io.c                 |  16 +-
 drivers/scsi/qedf/qedf_main.c               |   3 +-
 drivers/scsi/qedi/qedi_fw.c                 |   2 +-
 drivers/scsi/qedi/qedi_iscsi.c              |   1 +
 drivers/scsi/qla1280.c                      |  15 +-
 drivers/scsi/qla1280.h                      |   3 +-
 drivers/scsi/qla2xxx/qla_def.h              |   2 -
 drivers/scsi/qla2xxx/qla_os.c               |  13 +-
 drivers/scsi/qla4xxx/ql4_def.h              |  13 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  13 +-
 drivers/scsi/qlogicfas.c                    |   6 +-
 drivers/scsi/qlogicfas408.c                 |   6 +-
 drivers/scsi/scsi.h                         |  46 ----
 drivers/scsi/sg.c                           |   8 +-
 drivers/scsi/sgiwd93.c                      |  24 +-
 drivers/scsi/smartpqi/smartpqi_init.c       |  14 +-
 drivers/scsi/sun3_scsi.c                    |   5 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |   5 +-
 drivers/scsi/wd33c93.c                      | 119 ++++----
 drivers/scsi/wd33c93.h                      |  10 +
 drivers/scsi/wd719x.c                       |  12 +-
 drivers/scsi/wd719x.h                       |   1 +
 drivers/scsi/zalon.c                        |   1 +
 drivers/usb/image/microtek.c                |   8 +-
 drivers/usb/storage/debug.c                 |   1 -
 drivers/usb/storage/uas.c                   |  41 ++-
 include/scsi/libfc.h                        |  11 +
 include/scsi/libiscsi.h                     |  12 +
 include/scsi/scsi_cmnd.h                    |  14 +-
 113 files changed, 1501 insertions(+), 1047 deletions(-)
 rename drivers/scsi/arm/{scsi.h => arm_scsi.h} (75%)
 delete mode 100644 drivers/scsi/scsi.h

