Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353AEC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387740AbiEBV6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiEBV5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:57:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C661C62D2
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:54:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 816701F747;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sCuVfVXXlayVYKPLwhhInbaQ8z3IdeBAZyy2VjpfUvE=;
        b=Bk3yL932VLNt5ktdGNSw5zlmNn7FAF3gZk9Ag2oCWyaUyzcDCViIWLbQ5aTumTdVobg5z6
        cj1H4xQy5TQ5nOWsoG0KJczJJsgb4iuCSWaPY7U4SL8SdfYBUEkRY8Uj18UIucK6i2az2P
        xVBZf6Rmnai+u6Ec3xyhBWLrUHpxkMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sCuVfVXXlayVYKPLwhhInbaQ8z3IdeBAZyy2VjpfUvE=;
        b=yJb4izxs+A0P6d0lBHlCp/USF5F3vLCTZ0759e56vYzEoAL2obsZQs8jPLlMiL4qBXOKLT
        5SZTs7T/ZC+SWnCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 76CB92C141;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 69A0E5194126; Mon,  2 May 2022 23:54:20 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/11] scsi: EH rework prep patches, part 2
Date:   Mon,  2 May 2022 23:54:05 +0200
Message-Id: <20220502215416.5351-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

here's the second batch of patches for my EH rework.
It modifies the host reset callback for SCSI drivers
such that the final conversion to have 'struct scsi_target'
resp 'struct scsi_device' as argument for the EH callbacks
becomes possible.

As usual, comments and reviews are welcome.

Hannes Reinecke (11):
  pmcraid: Select device in pmcraid_eh_bus_reset_handler()
  sym53c8xx_2: rework reset handling
  libiscsi: use cls_session as argument for target and session reset
  scsi_transport_iscsi: use session as argument for
    iscsi_block_scsi_eh()
  pmcraid: select first available device for target reset
  bfa: Do not use scsi command to signal TMF status
  aha152x: look for stuck command when resetting device
  a1000u2w: do not rely on the command for inia100_device_reset()
  xen-scsifront: add scsi device as argument to scsifront_do_request()
  fas216: Rework device reset to not rely on SCSI command pointer
  csiostor: use separate TMF command

 drivers/scsi/a100u2w.c              |  43 +++--------
 drivers/scsi/aha152x.c              |  26 ++++---
 drivers/scsi/arm/fas216.c           |  39 +++++-----
 drivers/scsi/be2iscsi/be_main.c     |  10 ++-
 drivers/scsi/bfa/bfad_im.c          | 112 +++++++++++++++-------------
 drivers/scsi/bfa/bfad_im.h          |   2 +
 drivers/scsi/csiostor/csio_hw.h     |   2 +
 drivers/scsi/csiostor/csio_init.c   |   2 +-
 drivers/scsi/csiostor/csio_scsi.c   |  48 +++++++-----
 drivers/scsi/libiscsi.c             |  21 +++---
 drivers/scsi/pmcraid.c              |  60 ++++++++++++---
 drivers/scsi/qla4xxx/ql4_os.c       |  34 +++++----
 drivers/scsi/scsi_transport_iscsi.c |   6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |  82 +++++++++++++-------
 drivers/scsi/xen-scsifront.c        |  31 +++++---
 include/scsi/libiscsi.h             |   2 +-
 include/scsi/scsi_transport_iscsi.h |   2 +-
 17 files changed, 310 insertions(+), 212 deletions(-)

-- 
2.29.2

