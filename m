Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ED7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbiECUKx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiECUKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9522656D
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F39D91F38D;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sz6a773qEQ/B8X1/2T5zLokhjVOg2Impr7RklbXsMJo=;
        b=HiU9cbYePSR0patfV1MxSdZYnj/aEUjDoItWlUzjrMghBiChpI/mHxf68Ox/c7N17DuDA7
        yyIts+IEFtJWLZo6nyy7ZqD47QSb6mCHiRsxUhfzLyv0w7tvDRnOObi72vKgmn36SNJAr0
        ulw/S3/1aoZPkNHoVbRk6UJ7eSEg6Qg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sz6a773qEQ/B8X1/2T5zLokhjVOg2Impr7RklbXsMJo=;
        b=tDcQSW8gDsUvRjU3ZDgkiGJ9uGPbHGGGJcYW8aBFX3Lqj68Znbh792R62RYznPicj/XsYd
        tHCDWxyBh4+cg+Aw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D39302C142;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D7EED51941C6; Tue,  3 May 2022 22:07:14 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/24] scsi: EH rework prep patches, part 1
Date:   Tue,  3 May 2022 22:06:40 +0200
Message-Id: <20220503200704.88003-1-hare@suse.de>
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

Changes to the initial version:
- Include reviews from Christoph
- Fixup build robot issues

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
 drivers/s390/scsi/zfcp_scsi.c       |  21 ++-
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  32 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 121 +++++++------
 drivers/scsi/bnx2fc/bnx2fc.h        |   1 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c    |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c     |  94 +++++-----
 drivers/scsi/csiostor/csio_scsi.c   |   2 +-
 drivers/scsi/fnic/fnic_scsi.c       | 139 +++++---------
 drivers/scsi/ibmvscsi/ibmvfc.c      |  48 ++---
 drivers/scsi/ips.c                  |  18 --
 drivers/scsi/libfc/fc_fcp.c         |   2 +-
 drivers/scsi/megaraid.c             |  42 ++---
 drivers/scsi/mpi3mr/mpi3mr_os.c     |  57 +++---
 drivers/scsi/qedf/qedf.h            |   5 +-
 drivers/scsi/qedf/qedf_io.c         |  75 +++-----
 drivers/scsi/qedf/qedf_main.c       |  19 +-
 drivers/scsi/qla1280.c              |  42 ++---
 drivers/scsi/snic/snic.h            |   3 +-
 drivers/scsi/snic/snic_main.c       |   3 +
 drivers/scsi/snic/snic_scsi.c       | 270 +++++++++++++---------------
 drivers/scsi/sym53c8xx_2/sym_glue.c | 107 ++++++-----
 24 files changed, 658 insertions(+), 607 deletions(-)

-- 
2.29.2

