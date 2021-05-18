Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23F3C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22E0611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbhERRqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:17 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:37407 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351188AbhERRqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:15 -0400
Received: by mail-pl1-f170.google.com with SMTP id i6so681801plt.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I2k4qNPvbATRmJtNVYyAafdh0Ew4Mb8hSmLWLYJqycQ=;
        b=X8ZSflcBdMoi70WCoavbhACTwPFRHUnt63ofrWjgF+8pmBn1qi0QUdvdJn0Y47lzLY
         lT/HoD+P3XbarsYRwIREJOwje/I7FzZacrkVr6P3uI9YrZstnqstUSrGSy3WrKXY8ukG
         XJiamgh24RTFpAuyJtL4pmNKrOG3CfAmbLuijSWPy6YT8ThdLwAr+PJL0C46Ypuwf5eA
         xXks3sMkBuaVUWfp1O5SUracPwbC5fyqBauSL2nG6ir0gk0z97um29hgDsCmfxRzHpvq
         5SecoZlMlO4HZxZg5tT1ZEzT8uN895XFQsIdVExs6IgHYp60FydVV3CGrezKrQJP6l4e
         +K6A==
X-Gm-Message-State: AOAM533No+I1nasMoWGFXrOCSEWP0hcpJGh/mYNNI/Pqbl1+3Sunt4Qy
        EP3rCJatsCRLiTDmgDrOZl4=
X-Google-Smtp-Source: ABdhPJyXCLeqk1a6dA5PPRM4TXXwJi5M8JaCCIrTSw57vOK5hxZapGil4TM19cvzkmaiupFmrq8j+A==
X-Received: by 2002:a17:902:8b86:b029:e5:bef6:56b0 with SMTP id ay6-20020a1709028b86b02900e5bef656b0mr5868208plb.76.1621359896816;
        Tue, 18 May 2021 10:44:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:44:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/50] Remove the request pointer from struct scsi_cmnd
Date:   Tue, 18 May 2021 10:44:00 -0700
Message-Id: <20210518174450.20664-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
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

Changes compared to v1:
- Renamed blk_req() into scsi_cmd_to_rq().
- Added a few Acked-by tags.

Bart Van Assche (50):
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
 drivers/ata/libata-scsi.c                   | 10 ++--
 drivers/ata/pata_falcon.c                   |  4 +-
 drivers/infiniband/ulp/iser/iser_memory.c   |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |  6 +-
 drivers/s390/scsi/zfcp_fsf.c                |  2 +-
 drivers/scsi/53c700.c                       |  2 +-
 drivers/scsi/NCR5380.c                      |  6 +-
 drivers/scsi/aacraid/aachba.c               |  2 +-
 drivers/scsi/aacraid/commsup.c              |  2 +-
 drivers/scsi/advansys.c                     |  4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |  2 +-
 drivers/scsi/csiostor/csio_scsi.c           |  6 +-
 drivers/scsi/cxlflash/main.c                |  2 +-
 drivers/scsi/dpt_i2o.c                      |  4 +-
 drivers/scsi/fnic/fnic_scsi.c               | 49 ++++++++--------
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  2 +-
 drivers/scsi/hpsa.c                         |  6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  2 +-
 drivers/scsi/ips.c                          |  2 +-
 drivers/scsi/libsas/sas_ata.c               |  2 +-
 drivers/scsi/libsas/sas_scsi_host.c         |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c               | 63 ++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_base.c   |  4 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  6 +-
 drivers/scsi/mvumi.c                        |  2 +-
 drivers/scsi/myrb.c                         | 11 ++--
 drivers/scsi/myrs.c                         | 11 ++--
 drivers/scsi/ncr53c8xx.c                    |  4 +-
 drivers/scsi/qedf/qedf_io.c                 |  8 +--
 drivers/scsi/qedi/qedi_fw.c                 |  9 +--
 drivers/scsi/qla1280.c                      |  6 +-
 drivers/scsi/qla2xxx/qla_os.c               |  4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c             |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  4 +-
 drivers/scsi/qlogicpti.c                    |  2 +-
 drivers/scsi/scsi.c                         |  2 +-
 drivers/scsi/scsi_debug.c                   | 13 +++--
 drivers/scsi/scsi_error.c                   | 15 +++--
 drivers/scsi/scsi_lib.c                     | 29 +++++-----
 drivers/scsi/scsi_logging.c                 | 18 +++---
 drivers/scsi/scsi_transport_fc.c            |  2 +-
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 33 +++++------
 drivers/scsi/sd_zbc.c                       | 10 ++--
 drivers/scsi/smartpqi/smartpqi_init.c       |  4 +-
 drivers/scsi/snic/snic_scsi.c               | 10 ++--
 drivers/scsi/sr.c                           | 13 ++---
 drivers/scsi/stex.c                         |  6 +-
 drivers/scsi/sun3_scsi.c                    |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  4 +-
 drivers/scsi/ufs/ufshcd.c                   | 28 ++++-----
 drivers/scsi/virtio_scsi.c                  |  4 +-
 drivers/scsi/xen-scsifront.c                |  2 +-
 drivers/target/loopback/tcm_loop.c          |  4 +-
 drivers/usb/storage/transport.c             |  2 +-
 include/scsi/scsi_cmnd.h                    | 15 +++--
 include/scsi/scsi_device.h                  | 16 +++---
 62 files changed, 255 insertions(+), 259 deletions(-)

