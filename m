Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48382C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 11:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353019AbiELLM6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 07:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352988AbiELLMw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 07:12:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEA0527EC
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 04:12:47 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 259F41F929;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652353966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xskkfIu2XuD9l9y1pxHVLKuxXH0Kjcc9k0RB/tbLR8o=;
        b=H8Zpg4gtZAfwTFN2ZrN4vgksuCyyhe3ZEeXHkMKbakL9oz19Bv18BmphdATYQF+jvjwKiz
        3t/MwpYTbgT5JylInuoTHg4MoAjoFWhj8pEzU826WYzYVDabMeZFy3NlCThnVXjJ943j75
        06U/k2pEOLnzXLlYg7LZaM6UVymrcGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652353966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xskkfIu2XuD9l9y1pxHVLKuxXH0Kjcc9k0RB/tbLR8o=;
        b=l/xfKXNfToAU3eOdlBdrXinq1LD5Huu9EKTC/xuvfKFPWiFIGh+BdmxqEPtpKBfc6xOiqn
        V/uF3yy5v6CQVBCA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1B4762C143;
        Thu, 12 May 2022 11:12:45 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id DE82F51943D8; Thu, 12 May 2022 13:12:45 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/20] scsi: EH rework prep patches, part 1
Date:   Thu, 12 May 2022 13:12:16 +0200
Message-Id: <20220512111236.109851-1-hare@suse.de>
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

Changes to v2:
- Include reviews from John Garry
- move mpi3mr, zfcp, sym53c8xx_2, and qla1280 patches to the
  next patchset

Changes to the initial version:
- Include reviews from Christoph
- Fixup build robot issues

Hannes Reinecke (20):
  csiostor: use fc_block_rport()
  fc_fcp: use fc_block_rport()
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
  ips: Do not try to abort command from host reset
  megaraid: pass in NULL scb for host reset

 drivers/message/fusion/mptfc.c     |  94 +++++++---
 drivers/message/fusion/mptscsih.c  |  55 +++++-
 drivers/message/fusion/mptscsih.h  |   1 +
 drivers/scsi/aic7xxx/aic79xx_osm.c |  32 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 127 ++++++++------
 drivers/scsi/bnx2fc/bnx2fc.h       |   1 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c    |  94 +++++-----
 drivers/scsi/csiostor/csio_scsi.c  |   2 +-
 drivers/scsi/fnic/fnic_main.c      |   9 +
 drivers/scsi/fnic/fnic_scsi.c      | 139 +++++----------
 drivers/scsi/ibmvscsi/ibmvfc.c     |  48 ++---
 drivers/scsi/ips.c                 |  18 --
 drivers/scsi/libfc/fc_fcp.c        |   2 +-
 drivers/scsi/megaraid.c            |  42 ++---
 drivers/scsi/qedf/qedf.h           |   5 +-
 drivers/scsi/qedf/qedf_io.c        |  75 +++-----
 drivers/scsi/qedf/qedf_main.c      |  19 +-
 drivers/scsi/snic/snic.h           |   2 +-
 drivers/scsi/snic/snic_main.c      |   8 +
 drivers/scsi/snic/snic_scsi.c      | 271 ++++++++++++++---------------
 21 files changed, 535 insertions(+), 523 deletions(-)

-- 
2.29.2

