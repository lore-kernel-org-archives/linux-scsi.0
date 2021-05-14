Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F6BC43462
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F6A61440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhENVgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:53 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:36457 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhENVgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:47 -0400
Received: by mail-pg1-f170.google.com with SMTP id c21so263742pgg.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5/zbnZ/xYrj1cwD7byXiX9Cnltohh9FdvaA9gHBEJE=;
        b=ExfzdCoJH4OWj93/qpzpeS2c+lZdaGA8nnafHK7FCAUGnn803hWRHnejkpx8lYTKIb
         rDtRDdQxeMMfuj9FGUSNfClEE1EYHWzLwyZnkjDBVgtaLTO3TK4LnSAhlpbwRO47js38
         OiIKHWLor0C+T+bmiCH/yPk8klO71h2CXLjAFbIQAphwhGekTneOOw7vkgDRZu27OF2/
         d9b2u5fzGdKmfZVCFOOyB8K7DWDaacQz81IeAMum4ce+yGpia2R78CY/y+LyRfGEdSf2
         b2thRKW25qXHQZUdP5JcnQmRDEAlabB1Ztwf9IL4H+2j4cQs1qXh4+b52/k39CfijP3t
         vvcA==
X-Gm-Message-State: AOAM533PU/+cOhcAPIr3n/ElJ4uDlQaMFtKloVUIJT+PQ8pQ5wcPptw0
        ICxfczKWV4PdjYNXXjTXiMk=
X-Google-Smtp-Source: ABdhPJz9lk3tdFHotj4MQX9Q/bTnJszfHdntc8S9B5YPSWNOYCzeLAzQYwCKunGoE/gmx3pXoW9f+A==
X-Received: by 2002:a62:30c2:0:b029:289:116c:ec81 with SMTP id w185-20020a6230c20000b0290289116cec81mr48267817pfw.42.1621028134153;
        Fri, 14 May 2021 14:35:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/50] Remove the request pointer from struct scsi_cmnd
Date:   Fri, 14 May 2021 14:33:06 -0700
Message-Id: <20210514213356.5264-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
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

Bart Van Assche (50):
  core: Introduce the blk_req() function
  core: Use blk_req() instead of scsi_cmnd.request
  sd: Use blk_req() instead of scsi_cmnd.request
  sr: Use blk_req() instead of scsi_cmnd.request
  scsi_transport_fc: Use blk_req() instead of scsi_cmnd.request
  scsi_transport_spi: Use blk_req() instead of scsi_cmnd.request
  ata: Use blk_req() instead of scsi_cmnd.request
  rdma/iser: Use blk_req() instead of scsi_cmnd.request
  rdma/srp: Use blk_req() instead of scsi_cmnd.request
  zfcp: Use blk_req() instead of scsi_cmnd.request
  53c700: Use blk_req() instead of scsi_cmnd.request
  NCR5380: Use blk_req() instead of scsi_cmnd.request
  aacraid: Use blk_req() instead of scsi_cmnd.request
  advansys: Use blk_req() instead of scsi_cmnd.request
  bnx2i: Use blk_req() instead of scsi_cmnd.request
  csiostor: Use blk_req() instead of scsi_cmnd.request
  cxlflash: Use blk_req() instead of scsi_cmnd.request
  dpt_i2o: Use blk_req() instead of scsi_cmnd.request
  fnic: Use blk_req() instead of scsi_cmnd.request
  hisi_sas: Use blk_req() instead of scsi_cmnd.request
  hpsa: Use blk_req() instead of scsi_cmnd.request
  ibmvfc: Use blk_req() instead of scsi_cmnd.request
  ibmvscsi: Use blk_req() instead of scsi_cmnd.request
  ips: Use blk_req() instead of scsi_cmnd.request
  libsas: Use blk_req() instead of scsi_cmnd.request
  lpfc: Use blk_req() instead of scsi_cmnd.request
  megaraid: Use blk_req() instead of scsi_cmnd.request
  mpt3sas: Use blk_req() instead of scsi_cmnd.request
  mvumi: Use blk_req() instead of scsi_cmnd.request
  myrb: Use blk_req() instead of scsi_cmnd.request
  myrs: Use blk_req() instead of scsi_cmnd.request
  ncr53c8xx: Use blk_req() instead of scsi_cmnd.request
  qedf: Use blk_req() instead of scsi_cmnd.request
  qedi: Use blk_req() instead of scsi_cmnd.request
  qla1280: Use blk_req() instead of scsi_cmnd.request
  qla2xxx: Use blk_req() instead of scsi_cmnd.request
  qla4xxx: Use blk_req() instead of scsi_cmnd.request
  qlogicpti: Use blk_req() instead of scsi_cmnd.request
  scsi_debug: Use blk_req() instead of scsi_cmnd.request
  smartpqi: Use blk_req() instead of scsi_cmnd.request
  snic: Use blk_req() instead of scsi_cmnd.request
  stex: Use blk_req() instead of scsi_cmnd.request
  sun3_scsi: Use blk_req() instead of scsi_cmnd.request
  sym53c8xx: Use blk_req() instead of scsi_cmnd.request
  ufs: Use blk_req() instead of scsi_cmnd.request
  virtio_scsi: Use blk_req() instead of scsi_cmnd.request
  xen-scsifront: Use blk_req() instead of scsi_cmnd.request
  tcm_loop: Use blk_req() instead of scsi_cmnd.request
  usb-storage: Use blk_req() instead of scsi_cmnd.request
  core: Remove the request member from struct scsi_cmnd

 drivers/ata/libata-eh.c                     |  5 +-
 drivers/ata/libata-scsi.c                   | 10 ++--
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
 drivers/scsi/fnic/fnic_scsi.c               | 40 ++++++-------
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
 drivers/scsi/myrb.c                         | 10 ++--
 drivers/scsi/myrs.c                         | 10 ++--
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
 drivers/scsi/scsi_lib.c                     | 27 +++++----
 drivers/scsi/scsi_logging.c                 | 18 +++---
 drivers/scsi/scsi_transport_fc.c            |  2 +-
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 32 +++++------
 drivers/scsi/sd_zbc.c                       | 10 ++--
 drivers/scsi/smartpqi/smartpqi_init.c       |  4 +-
 drivers/scsi/snic/snic_scsi.c               | 10 ++--
 drivers/scsi/sr.c                           | 10 ++--
 drivers/scsi/stex.c                         |  6 +-
 drivers/scsi/sun3_scsi.c                    |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  4 +-
 drivers/scsi/ufs/ufshcd.c                   | 22 +++----
 drivers/scsi/virtio_scsi.c                  |  4 +-
 drivers/scsi/xen-scsifront.c                |  2 +-
 drivers/target/loopback/tcm_loop.c          |  4 +-
 drivers/usb/storage/transport.c             |  2 +-
 include/scsi/scsi_cmnd.h                    | 13 +++--
 include/scsi/scsi_device.h                  | 16 +++---
 61 files changed, 239 insertions(+), 246 deletions(-)

