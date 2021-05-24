Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1E4C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 186D761166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhEXDKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:32 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:33463 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhEXDKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:31 -0400
Received: by mail-pj1-f50.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so713824pjr.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xozRdG1f/S25Pk07wWWPSAUJz2iEBIbG5Mx1ESpqf1U=;
        b=lYynfx2AXgS22Y7Rx/W0RSMvaQBi6ydWizhN8QDxgMaErKKe919nzisNoYnY7gikIP
         JdDkhrDGpAV4ut03s61yZEcVvipR9FWEK0x7vkvu8wCNuE9LF2EJ3rum1vkAui6aNwAH
         ChUgfjsZwnx/HVUdAl0mMwvC7Jv9cQYMwV56T/LdzM4W6Ympsk8AzIbh1JBdtjo+ACLf
         rFdMlf1m3AEdfMIkcDYetSX4wyMHjRxb7W3ejokKApLBIiqMXWB4JJ2L/cbU2YGYcY7X
         cn1JuGIvU9xsekRDWu5eYH1kprix9zMu9Ziie8rwzznWSRaX4DCRXosCc3urLRbmcCMl
         ROrA==
X-Gm-Message-State: AOAM533AL2oj+/x8e2+vpN2fLDj1KHMLnLQpR53LSo6agqAqabkr9sHm
        mYUyJgsfXfgrKyDA96fhqKQ=
X-Google-Smtp-Source: ABdhPJyzl38f9MRJBpzR747FpuVN66feBlO4JyO7LnqGNwKouB9o7onDg6mBZHCQ3kUfA+8rZjw44A==
X-Received: by 2002:a17:902:d4c6:b029:ef:80f3:c543 with SMTP id o6-20020a170902d4c6b02900ef80f3c543mr23473710plg.85.1621825742917;
        Sun, 23 May 2021 20:09:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/51] Remove the request pointer from struct scsi_cmnd
Date:   Sun, 23 May 2021 20:08:05 -0700
Message-Id: <20210524030856.2824-1-bvanassche@acm.org>
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

Changes compared to v2:
- Added a patch for the aha1542 driver since a recent change introduced a
  scsi_cmnd.request dereference in that driver.
- In patch 2, renamed a local variable in a macro from 'rq' into '__rq'.  
- Added several more Acked-by tags.

Changes compared to v1:
- Renamed blk_req() into scsi_cmd_to_rq().
- Added several Acked-by tags.

Bart Van Assche (51):
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
 drivers/scsi/aha1542.c                      |  6 +-
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
 63 files changed, 259 insertions(+), 261 deletions(-)

