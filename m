Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C5FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094D06103B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344504AbhIXX2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:28:17 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:39770 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhIXX2R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 19:28:17 -0400
Received: by mail-pl1-f172.google.com with SMTP id c4so7565668pls.6
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 16:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RI/KN2Bj43TtVkF8a8pHbEf9wAYih72DhkW08K0PiA8=;
        b=AlLha1s4ozbpiXWzyOfN4X6l+izz5Kp3dtL4VGILceeaLE3zLug8AkKTW1CcSPI+89
         AsVaqlq7YFMaII3fIhUDRsJZ2h1zvMAYS2b3F9V43zQUf+W2JYa3qaaX8hBoOH6YD9En
         qsX6cnzL6VM+3hntWJ2Jc+zUjyyM1c2EHyGSVwpQ+zrHq+Q0/r5Bqxpb1kuYEZUt+x2E
         DGFA7dgXCoIHOuZtjljpUaZxw9PC0CvDa5W5B6OwJfFmYo0NHnN1ErPIHBbhoxl3QOGr
         8vmkECbERCLRV6cvpyzYR5VGwD3wBy3rmzWcwmVdRlEWWO4Q77JHqiIRtwcm+Q9YdQeE
         XrHA==
X-Gm-Message-State: AOAM532nCDYXipTn/Blfqoy3wZ0XEUbzT+roQ1vcrnerK1iDGqTTV/l/
        DkePOuFOzq44SKW0Zg8dHb/R6qFgba4=
X-Google-Smtp-Source: ABdhPJwN2dYAfotXKif9pvqs9DZ1D7UW4+GeaCwMOeJjqQ8015f4UCgzbpoE+VdVXL/p9SlrSwqs0Q==
X-Received: by 2002:a17:90b:1d01:: with SMTP id on1mr5108479pjb.21.1632526003175;
        Fri, 24 Sep 2021 16:26:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ee5b:ba55:22d5:49c9])
        by smtp.gmail.com with ESMTPSA id b142sm10200043pfb.17.2021.09.24.16.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:26:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Register SCSI sysfs attributes earlier
Date:   Fri, 24 Sep 2021 16:26:33 -0700
Message-Id: <20210924232635.1637763-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

For certain user space software, e.g. udev, it is important that sysfs
attributes are registered before the KOBJ_ADD uevent is emitted. Hence
this patch series that removes the device_create_file() and
sysfs_create_groups() calls from the SCSI core. Please consider this
patch series for kernel v5.16.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: Register SCSI host sysfs attributes earlier
  scsi: Register SCSI device sysfs attributes earlier

 drivers/ata/ahci.h                        |   4 +-
 drivers/ata/ata_piix.c                    |   4 +-
 drivers/ata/libahci.c                     |  30 +--
 drivers/ata/libata-sata.c                 |   8 +-
 drivers/ata/libata-scsi.c                 |   4 +-
 drivers/firewire/sbp2.c                   |   4 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  44 ++--
 drivers/message/fusion/mptscsih.c         |  26 +-
 drivers/message/fusion/mptscsih.h         |   2 +-
 drivers/s390/scsi/zfcp_ext.h              |   4 +-
 drivers/s390/scsi/zfcp_sysfs.c            |  34 +--
 drivers/scsi/3w-9xxx.c                    |   4 +-
 drivers/scsi/3w-sas.c                     |   4 +-
 drivers/scsi/3w-xxxx.c                    |   4 +-
 drivers/scsi/aacraid/linit.c              |  30 +--
 drivers/scsi/arcmsr/arcmsr.h              |   2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c         |  24 +-
 drivers/scsi/be2iscsi/be_main.c           |  17 +-
 drivers/scsi/bfa/bfad_attr.c              |  52 ++--
 drivers/scsi/bfa/bfad_im.h                |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |   4 +-
 drivers/scsi/bnx2i/bnx2i.h                |   2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |   6 +-
 drivers/scsi/csiostor/csio_scsi.c         |  16 +-
 drivers/scsi/cxlflash/main.c              |  32 +--
 drivers/scsi/fnic/fnic.h                  |   2 +-
 drivers/scsi/fnic/fnic_attrs.c            |   8 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  10 +-
 drivers/scsi/hosts.c                      |  10 +-
 drivers/scsi/hpsa.c                       |  36 +--
 drivers/scsi/hptiop.c                     |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |  18 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  18 +-
 drivers/scsi/ipr.c                        |  30 +--
 drivers/scsi/isci/init.c                  |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c             | 296 +++++++++++-----------
 drivers/scsi/lpfc/lpfc_crtn.h             |   4 +-
 drivers/scsi/megaraid/megaraid_mbox.c     |   8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  20 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h       |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c        |  66 ++---
 drivers/scsi/mvsas/mv_init.c              |   8 +-
 drivers/scsi/myrb.c                       |  20 +-
 drivers/scsi/myrs.c                       |  32 +--
 drivers/scsi/ncr53c8xx.c                  |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c        |   4 +-
 drivers/scsi/pm8001/pm8001_ctl.c          |  56 ++--
 drivers/scsi/pm8001/pm8001_sas.h          |   2 +-
 drivers/scsi/pmcraid.c                    |   8 +-
 drivers/scsi/qedf/qedf.h                  |   2 +-
 drivers/scsi/qedf/qedf_attr.c             |   6 +-
 drivers/scsi/qedi/qedi_gbl.h              |   2 +-
 drivers/scsi/qedi/qedi_sysfs.c            |   6 +-
 drivers/scsi/qla2xxx/qla_attr.c           |  98 +++----
 drivers/scsi/qla2xxx/qla_gbl.h            |   3 +-
 drivers/scsi/qla4xxx/ql4_attr.c           |  32 +--
 drivers/scsi/qla4xxx/ql4_glbl.h           |   2 +-
 drivers/scsi/scsi_priv.h                  |   2 +-
 drivers/scsi/scsi_sysfs.c                 |  60 ++---
 drivers/scsi/smartpqi/smartpqi_init.c     |  38 +--
 drivers/scsi/snic/snic.h                  |   2 +-
 drivers/scsi/snic/snic_attrs.c            |  10 +-
 drivers/usb/storage/scsiglue.c            |   4 +-
 include/linux/libata.h                    |   4 +-
 include/scsi/scsi_device.h                |   2 +
 include/scsi/scsi_host.h                  |   6 +-
 68 files changed, 660 insertions(+), 666 deletions(-)

