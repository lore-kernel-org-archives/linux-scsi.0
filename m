Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE6FC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 784AA206E9
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qt1g91u8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgGFTj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:39:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A78C061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ayRGLYBF5yAp/zMieRJWdNpKwjSm0ZE+TXYIWhuwRb0=; b=qt1g91u8x1jROXTY0OmITX9QQf
        rhAqW7bDFFjSb3L4hm36b+SJNveZgeWIvQy/QFyeMMPd5DErxfOI54a7XcbTfLXzT1LI7q7Oji6bU
        2VRHr8VeJNB3LCZ94E7nI9zlE9vMmvhD8SYEPtuCScBqCD8wZR+4PwEe51YyrBlC/3ooAcsiQL4hK
        +aksNSo+mannlo8XbWLq4XF+QwE3S1/Si7rgflD1uTAMYB4CmXUWrqjFB2icanfYa79p6PRQuUMcV
        NN9W1iNKAmRHzWEsO/73ZFqsJbMc9Tt89K/Sqi2BDPBQm6/GHCiq8pz7AvN8ENaZPF2/y1vtznqRZ
        w/ImEXHg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsWxW-0001oC-QU; Mon, 06 Jul 2020 19:39:24 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 0/3] Rename some scsi host template functions
Date:   Mon,  6 Jul 2020 20:39:17 +0100
Message-Id: <20200706193920.6897-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I wasn't able to think of better names than sdev_destroy() and
sdev_configure(), but sdev_prep() is a better name in just about every
way than slave_alloc().  Mostly this was done with sed, but I fixed up
a few drivers by hand.  I also avoided 'fixing' the various changelog
files in Documentation/.  Should those just be deleted?  I'm not sure
I see the value of keeping that history.

I generated this against
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi for-next
-- let me know if it needs to be against a different tree.

Matthew Wilcox (Oracle) (3):
  scsi: Rename slave_alloc to sdev_prep
  scsi: Rename slave_destroy to sdev_destroy
  scsi: Rename slave_configure to sdev_configure

 Documentation/scsi/scsi_mid_low_api.rst       | 78 +++++++++----------
 drivers/ata/libata-sata.c                     |  6 +-
 drivers/ata/libata-scsi.c                     | 12 +--
 drivers/ata/pata_macio.c                      |  6 +-
 drivers/ata/sata_nv.c                         | 16 ++--
 drivers/firewire/sbp2.c                       |  8 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  4 +-
 drivers/message/fusion/mptfc.c                | 14 ++--
 drivers/message/fusion/mptsas.c               | 14 ++--
 drivers/message/fusion/mptscsih.c             | 10 +--
 drivers/message/fusion/mptscsih.h             |  4 +-
 drivers/message/fusion/mptspi.c               | 18 ++---
 drivers/net/ethernet/mellanox/mlx4/main.c     | 12 +--
 drivers/s390/scsi/zfcp_scsi.c                 | 14 ++--
 drivers/s390/scsi/zfcp_sysfs.c                |  2 +-
 drivers/s390/scsi/zfcp_unit.c                 |  2 +-
 drivers/scsi/3w-9xxx.c                        |  6 +-
 drivers/scsi/3w-sas.c                         |  6 +-
 drivers/scsi/3w-xxxx.c                        |  8 +-
 drivers/scsi/53c700.c                         | 18 ++---
 drivers/scsi/BusLogic.c                       |  6 +-
 drivers/scsi/BusLogic.h                       |  1 -
 drivers/scsi/aacraid/linit.c                  |  6 +-
 drivers/scsi/advansys.c                       | 18 ++---
 drivers/scsi/aha152x.c                        |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c            |  8 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c            |  8 +-
 drivers/scsi/aic94xx/aic94xx_init.c           |  2 +-
 drivers/scsi/bfa/bfad_im.c                    | 26 +++----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |  6 +-
 drivers/scsi/csiostor/csio_scsi.c             | 18 ++---
 drivers/scsi/dc395x.c                         | 12 +--
 drivers/scsi/dpt_i2o.c                        |  4 +-
 drivers/scsi/dpti.h                           |  2 +-
 drivers/scsi/esp_scsi.c                       | 14 ++--
 drivers/scsi/fcoe/fcoe.c                      |  2 +-
 drivers/scsi/fnic/fnic_main.c                 |  4 +-
 drivers/scsi/gdth.c                           |  4 +-
 drivers/scsi/hisi_sas/hisi_sas.h              |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c         |  6 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c        |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c        |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |  2 +-
 drivers/scsi/hpsa.c                           | 18 ++---
 drivers/scsi/hptiop.c                         |  4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                | 12 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  6 +-
 drivers/scsi/imm.c                            |  2 +-
 drivers/scsi/ipr.c                            | 28 +++----
 drivers/scsi/ips.c                            |  6 +-
 drivers/scsi/ips.h                            |  2 +-
 drivers/scsi/isci/init.c                      |  2 +-
 drivers/scsi/iscsi_tcp.c                      |  4 +-
 drivers/scsi/libfc/fc_fcp.c                   |  6 +-
 drivers/scsi/libsas/sas_scsi_host.c           |  6 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 | 24 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c     | 12 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          | 24 +++---
 drivers/scsi/mvsas/mv_init.c                  |  2 +-
 drivers/scsi/mvumi.c                          |  4 +-
 drivers/scsi/myrb.c                           | 20 ++---
 drivers/scsi/myrs.c                           | 12 +--
 drivers/scsi/ncr53c8xx.c                      |  8 +-
 drivers/scsi/pm8001/pm8001_init.c             |  2 +-
 drivers/scsi/pmcraid.c                        | 20 ++---
 drivers/scsi/ppa.c                            |  2 +-
 drivers/scsi/ps3rom.c                         |  4 +-
 drivers/scsi/qedf/qedf_main.c                 |  4 +-
 drivers/scsi/qla1280.c                        |  6 +-
 drivers/scsi/qla2xxx/qla_os.c                 | 12 +--
 drivers/scsi/qla4xxx/ql4_os.c                 |  6 +-
 drivers/scsi/qlogicpti.c                      |  4 +-
 drivers/scsi/scsi_debug.c                     | 18 ++---
 drivers/scsi/scsi_scan.c                      | 20 ++---
 drivers/scsi/scsi_sysfs.c                     |  4 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  4 +-
 drivers/scsi/snic/snic_main.c                 | 12 +--
 drivers/scsi/stex.c                           |  4 +-
 drivers/scsi/storvsc_drv.c                    |  4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           | 14 ++--
 drivers/scsi/ufs/ufshcd.c                     | 18 ++---
 drivers/scsi/virtio_scsi.c                    |  2 +-
 drivers/scsi/xen-scsifront.c                  |  8 +-
 drivers/staging/rts5208/rtsx.c                |  8 +-
 .../staging/unisys/visorhba/visorhba_main.c   | 12 +--
 drivers/usb/image/microtek.c                  |  8 +-
 drivers/usb/storage/scsiglue.c                | 10 +--
 drivers/usb/storage/uas.c                     |  8 +-
 include/linux/libata.h                        | 10 +--
 include/scsi/libfc.h                          |  2 +-
 include/scsi/libsas.h                         |  4 +-
 include/scsi/scsi_device.h                    |  4 +-
 include/scsi/scsi_host.h                      | 20 ++---
 net/dsa/dsa2.c                                |  2 +-
 net/dsa/dsa_priv.h                            |  2 +-
 net/dsa/slave.c                               |  2 +-
 96 files changed, 438 insertions(+), 439 deletions(-)

-- 
2.27.0

