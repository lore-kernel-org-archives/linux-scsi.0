Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727F0C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568506113B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242445AbhHETSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:18:55 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:50949 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242602AbhHETSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:18:54 -0400
Received: by mail-pj1-f54.google.com with SMTP id l19so11376055pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hibJHfs5ETE7VDF3VtyKAdZsBoM5+E/EDpKZeRH6Whc=;
        b=PJTYe+G7KzhX84NyJwbP+diS7iLiAWCyiLK0+Met4BHrVx/YJskB83UpUz1q3g71uI
         4FIfAlAWyoNg5itVrVQaeky3Kh5CVkQFYCtTBs2q/3JpoNpO9cddYsqx4gpejfXwP32+
         qDDDr2Q1EjTc4fLViG7I5e7hLNpzfVySvh84/l2/RZgJidu7d2dwhevBUVXXwMca3z5U
         FQgoMADqqhN+HMTsGwymxfGwfhQxpWU2uERSWbt1PbRZunjPprcF7spFpQnKqR+v8WO7
         mzokl/ToRAmOjmvfxtnJ3CLMclEXSjoeGyrnl2u5JSf/QCF4GJNpyefyF6dBQz19Va6I
         AZcA==
X-Gm-Message-State: AOAM533DCUg8ZaExojh2fSM5aouCC/skSpqhaLVyycSrgsgMGnau4274
        wP8BDw3lsXtscFFikY3bJDz/5cEqTXtGJq7x
X-Google-Smtp-Source: ABdhPJyDr7JGfQ9RxiCfOBJfq/Qno8MyORcrMKzKX6l4UyJH1sbA3FK+m5k+Ykb52LBL+plDr86/FA==
X-Received: by 2002:a62:8407:0:b029:39a:59dc:a237 with SMTP id k7-20020a6284070000b029039a59dca237mr6769104pfd.30.1628191118855;
        Thu, 05 Aug 2021 12:18:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/52] Remove the request pointer from struct scsi_cmnd
Date:   Thu,  5 Aug 2021 12:17:36 -0700
Message-Id: <20210805191828.3559897-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series implements the following two changes for all SCSI drivers:
- Use blk_mq_rq_from_pdu() instead of the request member of struct scsi_cmnd
  since adding an offset to a pointer is faster than pointer indirection.
- Remove the request pointer from struct scsi_cmnd.

Please consider this patch series for kernel v5.14.

Thanks,

Bart.

Changes compared to v2:
- Added several more Acked-by tags.
- Rebased this patch series.

Changes compared to v2:
- Added a patch for the aha1542 driver since a recent change introduced a
  scsi_cmnd.request dereference in that driver.
- In patch 2, renamed a local variable in a macro from 'rq' into '__rq'.  
- Added several more Acked-by tags.

Changes compared to v1:
- Renamed blk_req() into scsi_cmd_to_rq().
- Added several Acked-by tags.

Bart Van Assche (52):
  core: Introduce the scsi_cmd_to_rq() function
  core: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  sd: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  ata: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  NCR5380: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  aacraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  aha1542: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  fnic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  ips: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  mpi3mr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  qla1280: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
  core: Remove the request member from struct scsi_cmnd

 drivers/ata/libata-eh.c                     |  5 +-
 drivers/ata/libata-scsi.c                   | 10 +--
 drivers/ata/pata_falcon.c                   |  4 +-
 drivers/infiniband/ulp/iser/iser_memory.c   |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |  6 +-
 drivers/s390/scsi/zfcp_fsf.c                |  2 +-
 drivers/scsi/53c700.c                       |  2 +-
 drivers/scsi/NCR5380.c                      |  6 +-
 drivers/scsi/aacraid/aachba.c               |  2 +-
 drivers/scsi/aacraid/commsup.c              |  2 +-
 drivers/scsi/advansys.c                     |  4 +-
 drivers/scsi/aha1542.c                      |  6 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |  2 +-
 drivers/scsi/csiostor/csio_scsi.c           |  6 +-
 drivers/scsi/cxlflash/main.c                |  2 +-
 drivers/scsi/dpt_i2o.c                      |  4 +-
 drivers/scsi/fnic/fnic_scsi.c               | 51 ++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  2 +-
 drivers/scsi/hpsa.c                         |  6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  2 +-
 drivers/scsi/ips.c                          |  2 +-
 drivers/scsi/libsas/sas_ata.c               |  2 +-
 drivers/scsi/libsas/sas_scsi_host.c         |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c               | 71 ++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_base.c   |  4 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 +--
 drivers/scsi/mpi3mr/mpi3mr_os.c             |  8 +--
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  6 +-
 drivers/scsi/mvumi.c                        |  2 +-
 drivers/scsi/myrb.c                         | 11 ++--
 drivers/scsi/myrs.c                         | 11 ++--
 drivers/scsi/ncr53c8xx.c                    |  4 +-
 drivers/scsi/qedf/qedf_io.c                 |  8 +--
 drivers/scsi/qedi/qedi_fw.c                 |  9 +--
 drivers/scsi/qla1280.c                      |  5 +-
 drivers/scsi/qla2xxx/qla_os.c               |  4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c             |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  4 +-
 drivers/scsi/qlogicpti.c                    |  2 +-
 drivers/scsi/scsi.c                         |  2 +-
 drivers/scsi/scsi_debug.c                   | 13 ++--
 drivers/scsi/scsi_error.c                   | 16 ++---
 drivers/scsi/scsi_lib.c                     | 29 +++++----
 drivers/scsi/scsi_logging.c                 | 18 +++---
 drivers/scsi/scsi_transport_fc.c            |  2 +-
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 33 +++++-----
 drivers/scsi/sd_zbc.c                       | 10 +--
 drivers/scsi/smartpqi/smartpqi_init.c       |  4 +-
 drivers/scsi/snic/snic_scsi.c               | 10 +--
 drivers/scsi/sr.c                           | 13 ++--
 drivers/scsi/stex.c                         |  6 +-
 drivers/scsi/sun3_scsi.c                    |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  4 +-
 drivers/scsi/ufs/ufshcd.c                   | 11 ++--
 drivers/scsi/ufs/ufshpb.c                   | 19 +++---
 drivers/scsi/virtio_scsi.c                  |  4 +-
 drivers/scsi/xen-scsifront.c                |  2 +-
 drivers/target/loopback/tcm_loop.c          |  4 +-
 drivers/usb/storage/transport.c             |  2 +-
 include/scsi/scsi_cmnd.h                    | 17 +++--
 include/scsi/scsi_device.h                  | 16 +++--
 65 files changed, 269 insertions(+), 273 deletions(-)

