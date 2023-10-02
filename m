Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A9EE743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbjJBPnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbjJBPnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D1D8
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 79C061F747;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=l2em2GE0evIiir8yfztiMXaUwpVXctIILEpclWbKYOw=;
        b=LZ0QcrVWInEg9ai6RMKgdPGSWY4aPri4bgs9fD0zP6VIDvMw5XdN6FNgRL+cCIR53ZM5Dl
        nJJN31PIUkwdH/pgQho6JAz6+OZ0tWfZMW4emDoT5Fl28vFUqoVhwvK0of5pR5yIxCsqUS
        uUqxTzsPl1cuscWM38zWpqOwJNc9pwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=l2em2GE0evIiir8yfztiMXaUwpVXctIILEpclWbKYOw=;
        b=Rnisn4DZAc9NQK92tdWKmDEzlD6bLuPnQwBEySk1Ih6hUoZ+pN2st02LPJm3alNLvV31zR
        S/5zclSLwRGXfICg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 541642C142;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 4071C51E7537; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 00/18] scsi: EH rework prep patches, part 1
Date:   Mon,  2 Oct 2023 17:43:10 +0200
Message-Id: <20231002154328.43718-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

(taking up an old thread:)
here's the first batch of patches for my EH rework.
It modifies the reset callbacks for SCSI drivers
such that the final conversion to drop the 'struct scsi_cmnd'
argument and use the entity in question (host, bus, target, device)
as the argument to the SCSI EH callbacks becomes possible.
The first part covers drivers which just requires minor tweaks.

As usual, comments and reviews are welcome.

Changes to v4:
- Rebase to latest linus tree

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

Hannes Reinecke (18):
  mptfc: simplify mptfc_block_error_handler()
  mptfusion: correct definitions for mptscsih_dev_reset()
  mptfc: open-code mptfc_block_error_handler() for bus reset
  qedf: use fc rport as argument for qedf_initiate_tmf()
  bnx2fc: Do not rely on a scsi command for lun or target reset
  aic7xxx: make BUILD_SCSIID() a function
  aic7xxx: do not reference scsi command when resetting device
  aic79xx: make BUILD_SCSIID() a function
  aic79xx: do not reference scsi command when resetting device
  ibmvfc: open-code reset loop for target reset
  megaraid: pass in NULL scb for host reset
  ips: Do not try to abort command from host reset
  sym53c8xx_2: split off bus reset from host reset
  sym53c8xx_2: rework reset handling
  qla1280: separate out host reset function from qla1280_error_action()
  pmcraid: Select device in pmcraid_eh_bus_reset_handler()
  pmcraid: select device in pmcraid_eh_target_reset_handler()
  mpi3mr: split off bus_reset function from host_reset

 drivers/message/fusion/mptfc.c      |  94 +++++++++-----
 drivers/message/fusion/mptscsih.c   |  55 +++++++-
 drivers/message/fusion/mptscsih.h   |   1 +
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  32 +++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 127 ++++++++++---------
 drivers/scsi/bnx2fc/bnx2fc.h        |   1 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c    |  14 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c     |  94 +++++++-------
 drivers/scsi/ibmvscsi/ibmvfc.c      |  42 ++++---
 drivers/scsi/ips.c                  |  18 ---
 drivers/scsi/megaraid.c             |  42 +++----
 drivers/scsi/mpi3mr/mpi3mr_os.c     |  57 ++++++---
 drivers/scsi/pmcraid.c              |  60 +++++++--
 drivers/scsi/qedf/qedf.h            |   5 +-
 drivers/scsi/qedf/qedf_io.c         |  75 +++--------
 drivers/scsi/qedf/qedf_main.c       |  19 +--
 drivers/scsi/qla1280.c              |  42 ++++---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 189 ++++++++++++++++++----------
 18 files changed, 572 insertions(+), 395 deletions(-)

-- 
2.35.3

