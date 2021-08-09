Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A80BC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F99160EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhHIXEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:24 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:44978 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhHIXEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:23 -0400
Received: by mail-pj1-f43.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so2393188pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RCwhVDZsvtKFMZMkJwoXei4eyejnK2BJAnXo3FbRtHg=;
        b=q0nSRxYiCGIkTEX+ZdOCfvV+Ucx/AuhZyHqIKi25fXkoUyyVvr+l/2YDqxHkiATn3x
         0NwaEloTkWkTBXEs2ezZMbosKgucXiv3v+l2jjhK/INEk33BlD/SwIiD8TVVtXgaiBRe
         FO0WeCV4NpzfMPwTJg4bne+jEbmLNygwimjuk4WKMxDrydScW9ilDM8lj8hmWrbvfwQ6
         xiKaPNix4RswPv62A/nDo3cIiJ13WG0tWdbEChRFgX8nwXIJ4IUSwyc732wFyE1VQeT1
         5+zXBctR8iK1lyQATe/CVS/HSUBlkz31DR8EiK7F3UkH34n1DctXrwrJlDKFLbGF9KuU
         FR0Q==
X-Gm-Message-State: AOAM532nqMs9pXsfFk5bJt8bgRYjrhIjwgkO8E3s/3wkXUQ6TETcUcdh
        a22NS4SwyQ7xgg0qr/N8XC8/nK8wKkI=
X-Google-Smtp-Source: ABdhPJyAXJImrOTfOeg3FXU0sLdLZsE2yKOazOCNuI+r8acQHqpnJhmFd/kRI89yZjGIgiOCvPoxSA==
X-Received: by 2002:a17:902:7598:b029:12b:e9ca:dfd5 with SMTP id j24-20020a1709027598b029012be9cadfd5mr22431134pll.12.1628550242135;
        Mon, 09 Aug 2021 16:04:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 00/52] Remove the request pointer from struct scsi_cmnd
Date:   Mon,  9 Aug 2021 16:03:03 -0700
Message-Id: <20210809230355.8186-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
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

Changes compared to v4:
- Replaced the NCR5380 patch.
- Added several more Acked-by tags.

Changes compared to v3:
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
  NCR5380: Use sc_data_direction instead of rq_data_dir()
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
 drivers/infiniband/ulp/srp/ib_srp.c         |  9 +--
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
 drivers/scsi/sun3_scsi.c                    |  5 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  4 +-
 drivers/scsi/ufs/ufshcd.c                   | 11 ++--
 drivers/scsi/ufs/ufshpb.c                   | 19 +++---
 drivers/scsi/virtio_scsi.c                  |  4 +-
 drivers/scsi/xen-scsifront.c                |  2 +-
 drivers/target/loopback/tcm_loop.c          |  4 +-
 drivers/usb/storage/transport.c             |  2 +-
 include/scsi/scsi_cmnd.h                    | 17 +++--
 include/scsi/scsi_device.h                  | 16 +++--
 65 files changed, 273 insertions(+), 275 deletions(-)

