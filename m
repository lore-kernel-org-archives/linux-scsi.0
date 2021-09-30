Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E58C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE3661875
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348642AbhI3H1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348599AbhI3H1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 03:27:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ED5C06161C
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 00:25:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c73-20020a1c9a4c000000b0030d040bb895so3561551wme.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 00:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=axQ9/7AE/6RppMRqdSYGBJ1oRY51A/w1xHged9roXos=;
        b=aO90SRMgOf8TnvgUY1IrklItoDQ/cmxQcxzjeanJAX4eIRGHNyTtW9G9UAU66umCGC
         Bo3/0zm2Dq/MlZ8gvxLyatoiqmQYPDsX2CSoil/FGVH0s/+lfZohnZG34/d9oMKOS2bM
         0jKpTcn418v1OgWKXsD5vFuoYKC8lRwnUGkINSAqIFfDlxM7pApdn3vGMMu8dE0P4Mfl
         wgqBkZqlENkTFR+5hA7lCFytN9ox2ddHLbUZSA+DOSqJeQIC7JZ3oDa0feTtT4q8xFPk
         E3qY7fG85AsY/5t8mLeGAlGb1TE8N0V39FxA2dFB8zPruM10y5vSR1Kka2e1ARpaiHyz
         Z1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=axQ9/7AE/6RppMRqdSYGBJ1oRY51A/w1xHged9roXos=;
        b=JcwwuQvThByfiONdqT7jBgBhx4TzMIuvvTuGiGGqYZGy0PvzTAI390Wzu+d7CsjO+k
         FxIyrpF5km7tXvBugMUjFzuwxguEq2VDQzo5JxjRfGCXLSfk6SLXF3d2il0+zueRGc09
         V9bOoQG5F8YsPqg5jyx/r7ZfUVmvqnMQtZ/RwraL8NLygTk9efozyhGONejVBNWkRZbk
         l2EHvU1kD4BhacEFCjn5eiyKQhTSF9LsJHCKyLYeAav2aN6BvtV64d8lz5H/8Zf5cwZf
         tiPD0P0tbT/5+xHQE2qsVRuyI/RwAXYHpB+y+Ij0+NmKDRA8FTdqKNhH5JVCq96vE8iw
         X76A==
X-Gm-Message-State: AOAM531wj2u0fyYe2jnkqegQhDE0YlSXlb1GWBO2nhuMzcJgD5uRvNJV
        F/U/2fHn23ad6qBhiFnE7eDFJWx3CqQTPg==
X-Google-Smtp-Source: ABdhPJyrxuFGHUVwbD3DBdUQ7IBL/L4//XIn+nE1eH0+v/qrc3uRSkSijRZ50G20HRboWpGhl9cV8g==
X-Received: by 2002:a1c:2357:: with SMTP id j84mr14318205wmj.1.1632986739925;
        Thu, 30 Sep 2021 00:25:39 -0700 (PDT)
Received: from p200300e94717cf3f837b83e464a227b5.dip0.t-ipconnect.de (p200300e94717cf3f837b83e464a227b5.dip0.t-ipconnect.de. [2003:e9:4717:cf3f:837b:83e4:64a2:27b5])
        by smtp.googlemail.com with ESMTPSA id d24sm1986538wmb.35.2021.09.30.00.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 00:25:39 -0700 (PDT)
Message-ID: <44a3eccd2210d752ecb83195f001530f0c4e29b2.camel@gmail.com>
Subject: Re: [PATCH v2 00/84] Call scsi_done() directly
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 30 Sep 2021 09:25:38 +0200
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart,

On Wed, 2021-09-29 at 15:04 -0700, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series increases IOPS by 5% on my test setup in a single-
> threaded
> test with queue depth 1 on top of the scsi_debug driver.

Here you mentioned queue depth 1. Does this mean SW queue depth?

Kind regards,
Bean

> Please consider this
> patch series for kernel v5.16.
> 
> Thanks,
> 
> Bart.
> 
> Changes compared to v1:
> - Inserted the SUBMITTED_BY_ prefix in front of the enumeration
> constants
>   introduced in patch 1.
> - Reworked the fas216 patch such that the scsi_done pointer is
> preserved.
> - Moved some SCSI core changes from the start of this series to the
> end to
>   improve bisectability of this series.
> - Added explicit initialization of the new "submitter" member
> variable instead
>   of relying on implicit initialization.
> - Added Reviewed-by/Acked-by tags.
> 
> Bart Van Assche (84):
>   scsi: core: Use a member variable to track the SCSI command
> submitter
>   scsi: core: Rename scsi_mq_done() into scsi_done() and export it
>   ata: Call scsi_done() directly
>   firewire: sbp2: Call scsi_done() directly
>   ib_srp: Call scsi_done() directly
>   message: fusion: Call scsi_done() directly
>   zfcp_scsi: Call scsi_done() directly
>   3w-9xxx: Call scsi_done() directly
>   3w-sas: Call scsi_done() directly
>   3w-xxxx: Call scsi_done() directly
>   53c700: Call scsi_done() directly
>   BusLogic: Call scsi_done() directly
>   NCR5380: Call scsi_done() directly
>   a100u2w: Call scsi_done() directly
>   aacraid: Introduce aac_scsi_done()
>   aacraid: Call scsi_done() directly
>   acornscsi: Call scsi_done() directly
>   advansys: Call scsi_done() directly
>   aha152x: Call scsi_done() directly
>   aha1542: Call scsi_done() directly
>   aic7xxx: Call scsi_done() directly
>   arcmsr: Call scsi_done() directly
>   atp870u: Call scsi_done() directly
>   bfa: Call scsi_done() directly
>   bnx2fc: Call scsi_done() directly
>   csiostor: Call scsi_done() directly
>   cxlflash: Call scsi_done() directly
>   dc395x: Call scsi_done() directly
>   dpt_i2o: Call scsi_done() directly
>   esas2r: Call scsi_done() directly
>   esp_scsi: Call scsi_done() directly
>   fas216: Introduce struct fas216_cmd_priv
>   fas216: Stop using scsi_cmnd.scsi_done
>   fdomain: Call scsi_done() directly
>   fnic: Call scsi_done() directly
>   hpsa: Call scsi_done() directly
>   hptiop: Call scsi_done() directly
>   ibmvscsi: Call scsi_done() directly
>   imm: Call scsi_done() directly
>   initio: Call scsi_done() directly
>   ipr: Call scsi_done() directly
>   ips: Call scsi_done() directly
>   libfc: Call scsi_done() directly
>   libiscsi: Call scsi_done() directly
>   libsas: Call scsi_done() directly
>   lpfc: Call scsi_done() directly
>   mac53c94: Call scsi_done() directly
>   megaraid: Call scsi_done() directly
>   megaraid: Call scsi_done() directly
>   mesh: Call scsi_done() directly
>   mpi3mr: Call scsi_done() directly
>   mpt3sas: Call scsi_done() directly
>   mvumi: Call scsi_done() directly
>   myrb: Call scsi_done() directly
>   myrs: Call scsi_done() directly
>   ncr53c8xx: Call scsi_done() directly
>   nsp32: Call scsi_done() directly
>   pcmcia: Call scsi_done() directly
>   pmcraid: Call scsi_done() directly
>   ppa: Call scsi_done() directly
>   ps3rom: Call scsi_done() directly
>   qedf: Call scsi_done() directly
>   qla1280: Call scsi_done() directly
>   qla2xxx: Call scsi_done() directly
>   qla4xxx: Call scsi_done() directly
>   qlogicfas408: Call scsi_done() directly
>   qlogicpti: Call scsi_done() directly
>   scsi_debug: Call scsi_done() directly
>   smartpqi: Call scsi_done() directly
>   snic: Call scsi_done() directly
>   stex: Call scsi_done() directly
>   storvsc_drv: Call scsi_done() directly
>   sym53c8xx_2: Call scsi_done() directly
>   ufs: Call scsi_done() directly
>   virtio_scsi: Call scsi_done() directly
>   vmw_pvscsi: Call scsi_done() directly
>   wd33c93: Call scsi_done() directly
>   wd719x: Call scsi_done() directly
>   xen-scsifront: Call scsi_done() directly
>   staging: rts5208: Call scsi_done() directly
>   staging: unisys: visorhba: Call scsi_done() directly
>   target/tcm_loop: Call scsi_done() directly
>   usb: Call scsi_done() directly
>   scsi: core: Call scsi_done directly
> 
>  drivers/ata/libata-sata.c                     |   2 +-
>  drivers/ata/libata-scsi.c                     |  14 +--
>  drivers/firewire/sbp2.c                       |   2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c           |   8 +-
>  drivers/message/fusion/mptfc.c                |   6 +-
>  drivers/message/fusion/mptsas.c               |   2 +-
>  drivers/message/fusion/mptscsih.c             |  10 +-
>  drivers/message/fusion/mptspi.c               |   4 +-
>  drivers/s390/scsi/zfcp_fsf.c                  |   2 +-
>  drivers/s390/scsi/zfcp_scsi.c                 |   4 +-
>  drivers/scsi/3w-9xxx.c                        |   7 +-
>  drivers/scsi/3w-sas.c                         |   7 +-
>  drivers/scsi/3w-xxxx.c                        |  13 +-
>  drivers/scsi/53c700.c                         |   5 +-
>  drivers/scsi/BusLogic.c                       |   9 +-
>  drivers/scsi/NCR5380.c                        |  12 +-
>  drivers/scsi/a100u2w.c                        |   3 +-
>  drivers/scsi/aacraid/aachba.c                 |  53 ++++----
>  drivers/scsi/advansys.c                       |   3 +-
>  drivers/scsi/aha152x.c                        |  27 ++--
>  drivers/scsi/aha1542.c                        |  10 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.c            |   3 +-
>  drivers/scsi/aic7xxx/aic7xxx_osm.c            |   3 +-
>  drivers/scsi/arcmsr/arcmsr_hba.c              |  17 ++-
>  drivers/scsi/arm/acornscsi.c                  |   6 +-
>  drivers/scsi/arm/arxescsi.c                   |   1 +
>  drivers/scsi/arm/cumana_2.c                   |   1 +
>  drivers/scsi/arm/eesox.c                      |   1 +
>  drivers/scsi/arm/fas216.c                     |   8 +-
>  drivers/scsi/arm/fas216.h                     |  10 ++
>  drivers/scsi/arm/powertec.c                   |   2 +-
>  drivers/scsi/atp870u.c                        |  13 +-
>  drivers/scsi/bfa/bfad_im.c                    |   8 +-
>  drivers/scsi/bnx2fc/bnx2fc_io.c               |   8 +-
>  drivers/scsi/csiostor/csio_scsi.c             |   8 +-
>  drivers/scsi/cxlflash/main.c                  |   6 +-
>  drivers/scsi/dc395x.c                         |   8 +-
>  drivers/scsi/dpt_i2o.c                        |  11 +-
>  drivers/scsi/esas2r/esas2r_main.c             |   8 +-
>  drivers/scsi/esp_scsi.c                       |  10 +-
>  drivers/scsi/fdomain.c                        |   2 +-
>  drivers/scsi/fnic/fnic_scsi.c                 | 119 ++++++++------
> ----
>  drivers/scsi/hosts.c                          |   2 +-
>  drivers/scsi/hpsa.c                           |  12 +-
>  drivers/scsi/hptiop.c                         |   7 +-
>  drivers/scsi/ibmvscsi/ibmvfc.c                |   8 +-
>  drivers/scsi/imm.c                            |   3 +-
>  drivers/scsi/initio.c                         |   4 +-
>  drivers/scsi/ipr.c                            |  10 +-
>  drivers/scsi/ips.c                            |  28 ++---
>  drivers/scsi/libfc/fc_fcp.c                   |   6 +-
>  drivers/scsi/libiscsi.c                       |   4 +-
>  drivers/scsi/libsas/sas_scsi_host.c           |   4 +-
>  drivers/scsi/lpfc/lpfc_scsi.c                 |   8 +-
>  drivers/scsi/mac53c94.c                       |   3 +-
>  drivers/scsi/megaraid.c                       |  21 ++--
>  drivers/scsi/megaraid/megaraid_mbox.c         |   9 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c     |  16 +--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c   |   6 +-
>  drivers/scsi/mesh.c                           |  16 +--
>  drivers/scsi/mpi3mr/mpi3mr_os.c               |  26 ++--
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  18 +--
>  drivers/scsi/mvumi.c                          |   4 +-
>  drivers/scsi/myrb.c                           |  32 ++---
>  drivers/scsi/myrs.c                           |  10 +-
>  drivers/scsi/ncr53c8xx.c                      |   3 +-
>  drivers/scsi/nsp32.c                          |   3 +-
>  drivers/scsi/pcmcia/nsp_cs.c                  |   4 +-
>  drivers/scsi/pcmcia/sym53c500_cs.c            |   3 +-
>  drivers/scsi/pmcraid.c                        |  11 +-
>  drivers/scsi/ppa.c                            |   3 +-
>  drivers/scsi/ps3rom.c                         |   5 +-
>  drivers/scsi/qedf/qedf_io.c                   |  19 +--
>  drivers/scsi/qla1280.c                        |   5 +-
>  drivers/scsi/qla2xxx/qla_os.c                 |   8 +-
>  drivers/scsi/qla4xxx/ql4_os.c                 |   4 +-
>  drivers/scsi/qlogicfas408.c                   |   3 +-
>  drivers/scsi/qlogicpti.c                      |   4 +-
>  drivers/scsi/scsi_debug.c                     |   8 +-
>  drivers/scsi/scsi_error.c                     |  18 ++-
>  drivers/scsi/scsi_lib.c                       |  16 ++-
>  drivers/scsi/scsi_priv.h                      |   1 +
>  drivers/scsi/smartpqi/smartpqi_init.c         |   2 +-
>  drivers/scsi/snic/snic_scsi.c                 |  33 +++--
>  drivers/scsi/stex.c                           |   6 +-
>  drivers/scsi/storvsc_drv.c                    |   4 +-
>  drivers/scsi/sym53c8xx_2/sym_glue.c           |   3 +-
>  drivers/scsi/ufs/ufshcd.c                     |   6 +-
>  drivers/scsi/virtio_scsi.c                    |   7 +-
>  drivers/scsi/vmw_pvscsi.c                     |   7 +-
>  drivers/scsi/wd33c93.c                        |  14 +--
>  drivers/scsi/wd719x.c                         |   4 +-
>  drivers/scsi/xen-scsifront.c                  |   4 +-
>  drivers/staging/rts5208/rtsx.c                |   5 +-
>  .../staging/unisys/visorhba/visorhba_main.c   |  14 +--
>  drivers/target/loopback/tcm_loop.c            |   4 +-
>  drivers/usb/storage/scsiglue.c                |   1 -
>  drivers/usb/storage/uas.c                     |  10 +-
>  drivers/usb/storage/usb.c                     |   4 +-
>  include/scsi/scsi_cmnd.h                      |  13 +-
>  include/scsi/scsi_host.h                      |   2 +-
>  101 files changed, 452 insertions(+), 522 deletions(-)
> 

