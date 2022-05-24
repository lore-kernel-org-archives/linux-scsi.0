Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D69C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiEXGQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiEXGQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ABEDFA6
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9B67E21A4D;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=R6xQEbxYjb5ZKwCMUCZgHiDBDxJ+Q3h+QDcw9SLpwnE=;
        b=GixUDN0MYrdaKFJXKhJRA0F+Cp0x3dD0c/oVJ2yxOoPRmj6yy0M6RkqVEldmznBZxSB23Q
        1W5wARhgq3232fFKoiNiu0BJpczYjbKkl4g2potRz+SP24eJorEwuhT+sivXLWX6vMgPfg
        QccdFQD/j+hRi8DyMeWimsaOTaqYbCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=R6xQEbxYjb5ZKwCMUCZgHiDBDxJ+Q3h+QDcw9SLpwnE=;
        b=oGf+k4DmNpPtng2LVXwPigQmUTiKDW3mQeYDLtrCbZdLrqMW8jTIE8HW6M1J/+GN1G4uJs
        mBmkghqONxhUkaBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9352B2C141;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 863AD5194638; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 00/16] scsi: EH rework prep patches, part 1
Date:   Tue, 24 May 2022 08:15:46 +0200
Message-Id: <20220524061602.86760-1-hare@suse.de>
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

Changes to v3:
- Move fnic and snic patches to the next patchset
- Include reviews from Ewan Milne

Changes to v2:
- Include reviews from John Garry
- move mpi3mr, zfcp, sym53c8xx_2, and qla1280 patches to the
  next patchset

Changes to the initial version:
- Include reviews from Christoph
- Fixup build robot issues

Hannes Reinecke (16):
  csiostor: use fc_block_rport()
  fc_fcp: use fc_block_rport()
  mptfc: simplify mpt_fc_block_error_handler()
  mptfusion: correct definitions for mptscsih_dev_reset()
  mptfc: open-code mptfc_block_error_handler() for bus reset
  qedf: use fc rport as argument for qedf_initiate_tmf()
  bnx2fc: Do not rely on a scsi command for lun or target reset
  ibmvfc: open-code reset loop for target reset
  ibmvfc: use fc_block_rport()
  fnic: use fc_block_rport() correctly
  aic7xxx: make BUILD_SCSIID() a function
  aic79xx: make BUILD_SCSIID() a function
  aic7xxx: do not reference scsi command when resetting device
  aic79xx: do not reference scsi command when resetting device
  ips: Do not try to abort command from host reset
  megaraid: pass in NULL scb for host reset

 drivers/message/fusion/mptfc.c     |  96 +++++++++++++++-------
 drivers/message/fusion/mptsas.c    |   2 +-
 drivers/message/fusion/mptscsih.c  |  55 ++++++++++++-
 drivers/message/fusion/mptscsih.h  |   1 +
 drivers/message/fusion/mptspi.c    |   2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c |  32 +++++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 127 ++++++++++++++++-------------
 drivers/scsi/bnx2fc/bnx2fc.h       |   1 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   |  14 ++--
 drivers/scsi/bnx2fc/bnx2fc_io.c    |  94 ++++++++++-----------
 drivers/scsi/csiostor/csio_scsi.c  |   2 +-
 drivers/scsi/fnic/fnic_scsi.c      |   7 +-
 drivers/scsi/ibmvscsi/ibmvfc.c     |  47 ++++++-----
 drivers/scsi/ips.c                 |  18 ----
 drivers/scsi/libfc/fc_fcp.c        |   2 +-
 drivers/scsi/megaraid.c            |  42 ++++------
 drivers/scsi/qedf/qedf.h           |   3 +-
 drivers/scsi/qedf/qedf_io.c        |  69 +++++-----------
 drivers/scsi/qedf/qedf_main.c      |  19 +++--
 19 files changed, 352 insertions(+), 281 deletions(-)

-- 
2.29.2

