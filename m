Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AB1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiBPVC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:02:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiBPVC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:02:57 -0500
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9B920577A
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:44 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id e17so3180532pfv.5
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j20a23yGOhoeFIMUSMrpxijJswsIRD1ax7eDogQJ4vQ=;
        b=XeBl16DWT1DuCvJFCtB/XrzhWJ52feSYGOPBpsrTzNog0wa7cPVnmZSmKMqIcJYg3W
         MTqFAakm3M3GIXpzTfMRIOqE66SY75kQliGKVIzhtI0wH2I5nOXrwg8odZ1Zsz0Pwmw3
         hIYHxnTiCrk2w4Ew/L8YHVWCvy3d6B7MRdm8SH46oAT79tcwkQSJsoSbZWOA47MGFFyI
         MP8StcPWEL1GRLng2uhzEVgGG0pqvVvBsa7i6d1m3TGRNN5qdofp7xZXzd1789suL2Kp
         2bKj1+QIJEQ+2dbCkGP4ksGTc9sU3LSSQiFGpabiMPjPdrJD7E7Jl7gfyRkfnDk0WSar
         1vhw==
X-Gm-Message-State: AOAM531dUUO9NY5TwLxlAYpD13AeDcgQttmchdwjQI48kIcAdMfdYzcp
        sHwBrveemA9PUk74oT29DgY=
X-Google-Smtp-Source: ABdhPJyrXNgy8CFPt/q7W1DmQ1KAZWzDZrWKkE7LUw+r9oG/hZ9MJ5p/9Uup39+ctEri/63pk4XMDA==
X-Received: by 2002:a63:b403:0:b0:371:4b9a:b2d6 with SMTP id s3-20020a63b403000000b003714b9ab2d6mr3800100pgf.195.1645045363326;
        Wed, 16 Feb 2022 13:02:43 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:02:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/50] Remove the SCSI pointer from struct scsi_cmnd
Date:   Wed, 16 Feb 2022 13:01:43 -0800
Message-Id: <20220216210233.28774-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The size of struct scsi_cmnd matters for embedded devices. One of the
largest members of that structure is the SCSI pointer. That structure is
relevant for SCSI-II drivers but not for modern SCSI drivers. Hence this
patch series that removes the SCSI pointer from struct scsi_cmnd and moves
it into driver-private command data.

Please consider this patch series for kernel v5.18.

Thanks,

Bart.

Changes compared to v3:
- Split the libfc patch into three patches (libfc, bnx2fc, qedf). Removed the
  libfc private command information and also the status information from the
  bnx2fc and qedf private command data.
- Removed the following statement from libfc_host_alloc():
    WARN_ON_ONCE(sht->cmd_size < sizeof(struct libfc_cmd_priv));

Changes compared to v2:
- Split the ips and nsp_cs patches at the start of this series such that there
  is only one change in each patch.
- Changed the return type of ips_release() from 'int' into 'void' since the
  value returned by that function is not used.
- Remove duplicate <scsi/scsi.h> include directives.
- Use struct scsi_pointer directly instead of wrapping it inside another
  structure for drivers that do not use host_scribble as requested by Hannes.
- Updated the error messages that refer to the SCp.ptr member if that member
  is removed by this patch series.
- Removed WARN_ON_ONCE(sht->cmd_size < sizeof(struct iscsi_cmd)) from
  iscsi_host_alloc() and removed struct iscsi_cmd from the qla4xxx private data
  as requested by Mike.
- Changed 'cmd - 1' into a container_of() expression in megaraid.h (Hannes).
- Removed a cast from the mvsas driver (John).
- Modified the comment in include/scsi/scsi_cmnd.h in the last patch (John).

Changes compared to v1:
- Removed BUILD_BUG_ON(sizeof(...) > sizeof(struct scsi_pointer)) statements.
- Added two void casts in front of I/O statements as requested by Johannes.
- Improved source code formatting in the aha152x driver.
- Restored the DID_OK constant in a SCSI result expression.
- Updated Reviewed-by tags.

Bart Van Assche (50):
  scsi: ips: Remove an unreachable statement
  scsi: ips: Change the return type of ips_release() into 'void'
  scsi: ips: Use true and false instead of TRUE and FALSE
  scsi: nsp_cs: Change the return type of two functions into 'void'
  scsi: nsp_cs: Use true and false instead of TRUE and FALSE
  scsi: Remove drivers/scsi/scsi.h
  scsi: NCR5380: Remove the NCR5380_CMD_SIZE macro
  scsi: NCR5380: Introduce the NCR5380_cmd_priv() function
  scsi: NCR5380: Move the SCSI pointer to private command data
  scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
  scsi: arm: Move the SCSI pointer to private command data
  scsi: 53c700: Stop clearing SCSI pointer fields
  scsi: aacraid: Move the SCSI pointer to private command data
  scsi: advansys: Move the SCSI pointer to private command data
  scsi: aha1542: Remove a set-but-not-used array
  scsi: aha152x: Move the SCSI pointer to private command data
  scsi: bfa: Stop using the SCSI pointer
  scsi: csio: Stop using the SCSI pointer
  scsi: dc395x: Stop using the SCSI pointer
  scsi: esp_scsi: Stop using the SCSI pointer
  scsi: fdomain: Move the SCSI pointer to private command data
  scsi: fnic: Fix a tracing statement
  scsi: fnic: Stop using the SCSI pointer
  scsi: hptiop: Stop using the SCSI pointer
  scsi: imm: Move the SCSI pointer to private command data
  scsi: iscsi: Stop using the SCSI pointer
  scsi: initio: Stop using the SCSI pointer
  scsi: libfc: Stop using the SCSI pointer
  scsi: bnx2fc: Stop using the SCSI pointer
  scsi: qedf: Stop using the SCSI pointer
  scsi: mac53c94: Fix a set-but-not-used compiler warning
  scsi: mac53c94: Move the SCSI pointer to private command data
  scsi: megaraid: Stop using the SCSI pointer
  scsi: megasas: Stop using the SCSI pointer
  scsi: mesh: Move the SCSI pointer to private command data
  scsi: mvsas: Fix a set-but-not-used warning
  scsi: mvumi: Stop using the SCSI pointer
  scsi: nsp32: Stop using the SCSI pointer
  scsi: nsp_cs: Move the SCSI pointer to private command data
  scsi: sym53c500_cs: Move the SCSI pointer to private command data
  scsi: ppa: Move the SCSI pointer to private command data
  scsi: qla1280: Move the SCSI pointer to private command data
  scsi: qla2xxx: Stop using the SCSI pointer
  scsi: smartpqi: Stop using the SCSI pointer
  scsi: sym53c8xx_2: Move the SCSI pointer to private command data
  scsi: usb: Stop using the SCSI pointer
  scsi: wd719x: Stop using the SCSI pointer
  scsi: wd33c93: Move the SCSI pointer to private command data
  scsi: zalon: Stop using the SCSI pointer
  scsi: core: Remove struct scsi_pointer from struct scsi_cmnd

 drivers/infiniband/ulp/iser/iscsi_iser.c    |   1 +
 drivers/scsi/53c700.c                       |   2 -
 drivers/scsi/NCR5380.c                      |  97 ++++---
 drivers/scsi/NCR5380.h                      |   6 +-
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
 drivers/scsi/arm/fas216.h                   |   4 +
 drivers/scsi/arm/oak.c                      |   2 +-
 drivers/scsi/arm/powertec.c                 |   8 +-
 drivers/scsi/arm/queue.c                    |   6 +-
 drivers/scsi/atari_scsi.c                   |   9 +-
 drivers/scsi/be2iscsi/be_main.c             |   3 +-
 drivers/scsi/bfa/bfad_im.c                  |  27 +-
 drivers/scsi/bfa/bfad_im.h                  |  16 ++
 drivers/scsi/bnx2fc/bnx2fc.h                |   9 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |   1 +
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  23 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |   1 +
 drivers/scsi/csiostor/csio_scsi.c           |  20 +-
 drivers/scsi/csiostor/csio_scsi.h           |  10 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |   1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |   1 +
 drivers/scsi/dc395x.c                       |   3 -
 drivers/scsi/dmx3191d.c                     |   2 +-
 drivers/scsi/esp_scsi.c                     |   4 +-
 drivers/scsi/esp_scsi.h                     |   3 +-
 drivers/scsi/fcoe/fcoe.c                    |   1 +
 drivers/scsi/fdomain.c                      |  64 +++--
 drivers/scsi/fnic/fnic.h                    |  27 +-
 drivers/scsi/fnic/fnic_main.c               |   1 +
 drivers/scsi/fnic/fnic_scsi.c               | 289 ++++++++++----------
 drivers/scsi/g_NCR5380.c                    |   8 +-
 drivers/scsi/gvp11.c                        |  25 +-
 drivers/scsi/hptiop.c                       |   1 +
 drivers/scsi/hptiop.h                       |   4 +-
 drivers/scsi/imm.c                          |  88 +++---
 drivers/scsi/imm.h                          |   5 +
 drivers/scsi/initio.c                       |  14 +-
 drivers/scsi/initio.h                       |   9 +
 drivers/scsi/ips.c                          |  52 ++--
 drivers/scsi/iscsi_tcp.c                    |   1 +
 drivers/scsi/libfc/fc_fcp.c                 |  26 +-
 drivers/scsi/libiscsi.c                     |  20 +-
 drivers/scsi/mac53c94.c                     |  27 +-
 drivers/scsi/mac53c94.h                     |  11 +
 drivers/scsi/mac_scsi.c                     |   9 +-
 drivers/scsi/megaraid.c                     |  21 +-
 drivers/scsi/megaraid.h                     |  23 +-
 drivers/scsi/megaraid/megaraid_sas.h        |  12 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |   8 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  15 +-
 drivers/scsi/mesh.c                         |  20 +-
 drivers/scsi/mesh.h                         |  11 +
 drivers/scsi/mvme147.c                      |  16 +-
 drivers/scsi/mvsas/mv_init.c                |   6 +-
 drivers/scsi/mvumi.c                        |   9 +-
 drivers/scsi/mvumi.h                        |   9 +
 drivers/scsi/ncr53c8xx.c                    |  22 +-
 drivers/scsi/ncr53c8xx.h                    |   6 +
 drivers/scsi/nsp32.c                        |  20 +-
 drivers/scsi/nsp32.h                        |   9 +
 drivers/scsi/pcmcia/aha152x_stub.c          |   9 +-
 drivers/scsi/pcmcia/nsp_cs.c                | 246 +++++++++--------
 drivers/scsi/pcmcia/nsp_cs.h                |   8 +-
 drivers/scsi/pcmcia/nsp_debug.c             |   2 +-
 drivers/scsi/pcmcia/qlogic_stub.c           |   9 +-
 drivers/scsi/pcmcia/sym53c500_cs.c          |  47 ++--
 drivers/scsi/ppa.c                          |  75 ++---
 drivers/scsi/qedf/qedf.h                    |  10 +-
 drivers/scsi/qedf/qedf_io.c                 |  25 +-
 drivers/scsi/qedf/qedf_main.c               |   3 +-
 drivers/scsi/qedi/qedi_fw.c                 |   4 +-
 drivers/scsi/qedi/qedi_iscsi.c              |   1 +
 drivers/scsi/qla1280.c                      |  21 +-
 drivers/scsi/qla1280.h                      |   3 +-
 drivers/scsi/qla2xxx/qla_def.h              |   2 -
 drivers/scsi/qla2xxx/qla_os.c               |  13 +-
 drivers/scsi/qla4xxx/ql4_def.h              |  16 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  13 +-
 drivers/scsi/qlogicfas.c                    |   6 +-
 drivers/scsi/qlogicfas408.c                 |   6 +-
 drivers/scsi/scsi.h                         |  46 ----
 drivers/scsi/sg.c                           |   8 +-
 drivers/scsi/sgiwd93.c                      |  24 +-
 drivers/scsi/smartpqi/smartpqi_init.c       |  14 +-
 drivers/scsi/sun3_scsi.c                    |   6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |   4 +-
 drivers/scsi/wd33c93.c                      | 119 ++++----
 drivers/scsi/wd33c93.h                      |   4 +
 drivers/scsi/wd719x.c                       |  12 +-
 drivers/scsi/wd719x.h                       |   1 +
 drivers/scsi/zalon.c                        |   1 +
 drivers/usb/image/microtek.c                |   8 +-
 drivers/usb/storage/debug.c                 |   1 -
 drivers/usb/storage/uas.c                   |  43 ++-
 include/scsi/libfc.h                        |   9 +
 include/scsi/libiscsi.h                     |  12 +
 include/scsi/scsi_cmnd.h                    |  14 +-
 113 files changed, 1484 insertions(+), 1073 deletions(-)
 rename drivers/scsi/arm/{scsi.h => arm_scsi.h} (75%)
 delete mode 100644 drivers/scsi/scsi.h

