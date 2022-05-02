Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC60C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387723AbiEBVmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbiEBVmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3651BE0A4
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D86A8210EE;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=m/Cq3nIBa98B3jy0w0csw/55FKJhXtBZaLfHx9X5gCs=;
        b=a7rpR9N7ped7nZElbwphKl2NKXEM3hxhtktJtzIabHnygtNSkdyEPYOFWSvm95eb5UlfiQ
        ultMyuS8HCaypW8m6mdpvLAWuP/c3nqLK6dgFQP9mRRQx/YQCiQnASRCza2uFiuYF5/hXi
        d/mxyRnpCqQogO+7Wu7ja8XH8EPTTp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=m/Cq3nIBa98B3jy0w0csw/55FKJhXtBZaLfHx9X5gCs=;
        b=MUnLIbimwOi8ra6H0Plfh1hlbhAtwWRQDdBNQIYynuwuJtb+wBObYaQj/kA0hs2m9GZEGz
        5b3ehypRi3pDwuAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CFE262C142;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B8EB551940F4; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/24] scsi: EH rework prep patches, part 1
Date:   Mon,  2 May 2022 23:37:56 +0200
Message-Id: <20220502213820.3187-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

here's the first batch of patches for my EH rework.
It modifies the host reset callback for SCSI drivers
such that the final conversion to have 'struct Scsi_host'
as argument becomes possible.

As usual, comments and reviews are welcome.

Hannes Reinecke (24):
  csiostor: use fc_block_rport()
  fc_fcp: use fc_block_rport()
  zfcp: open-code fc_block_scsi_eh() for host reset
  mptfc: simplify mpt_fc_block_error_handler()
  mptfusion: correct definitions for mptscsih_dev_reset()
  mptfc: open-code mptfc_block_error_handler() for bus reset
  qedf: use fc rport as argument for qedf_initiate_tmf()
  bnx2fc: Do not rely on a scsi command for lun or target reset
  ibmvfc: open-code reset loop for target reset
  ibmvfc: use fc_block_rport()
  fnic: use dedicated device reset command
  fnic: use fc_block_rport() correctly
  aic7xxx: make BUILD_SCSIID() a function
  aic79xx: make BUILD_SCSIID() a function
  aic7xxx: do not reference scsi command when resetting device
  aic79xx: do not reference scsi command when resetting device
  snic: reserve tag for TMF
  snic: use dedicated device reset command
  snic: Use scsi_host_busy_iter() to traverse commands
  sym53c8xx_2: split off bus reset from host reset
  ips: Do not try to abort command from host reset
  qla1280: separate out host reset function from qla1280_error_action()
  megaraid: pass in NULL scb for host reset
  mpi3mr: split off bus_reset function from host_reset

 drivers/message/fusion/mptfc.c      |  94 +++++++---
 drivers/message/fusion/mptscsih.c   |  55 +++++-
 drivers/message/fusion/mptscsih.h   |   1 +
 drivers/s390/scsi/zfcp_scsi.c       |  29 ++-
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  35 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 119 ++++++------
 drivers/scsi/bnx2fc/bnx2fc.h        |   1 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c    |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c     |  94 +++++-----
 drivers/scsi/csiostor/csio_scsi.c   |   2 +-
 drivers/scsi/fnic/fnic_scsi.c       | 138 +++++---------
 drivers/scsi/ibmvscsi/ibmvfc.c      |  48 ++---
 drivers/scsi/ips.c                  |  18 --
 drivers/scsi/libfc/fc_fcp.c         |   2 +-
 drivers/scsi/megaraid.c             |  42 ++---
 drivers/scsi/mpi3mr/mpi3mr_os.c     |  57 +++---
 drivers/scsi/qedf/qedf.h            |   5 +-
 drivers/scsi/qedf/qedf_io.c         |  75 +++-----
 drivers/scsi/qedf/qedf_main.c       |  19 +-
 drivers/scsi/qla1280.c              |  40 +++--
 drivers/scsi/snic/snic.h            |   3 +-
 drivers/scsi/snic/snic_main.c       |   3 +
 drivers/scsi/snic/snic_scsi.c       | 270 +++++++++++++---------------
 drivers/scsi/sym53c8xx_2/sym_glue.c | 107 ++++++-----
 24 files changed, 665 insertions(+), 606 deletions(-)

-- 
2.29.2

