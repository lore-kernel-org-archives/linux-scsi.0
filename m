Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91BFE784BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbjJBPtj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbjJBPtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F311FD9
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AFF0C2185F;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KXsDW4bHzz48+4x7pZWIdVLveXvjFzWFCS2CRNPPqBw=;
        b=n6Q06WewQrfzKKLVB18lItckeeRN1qM+IprBoyJSreTFVqlcA//tAZBamkDCzmnhjJZWnl
        LCmMUtwx4NXSs7oQNmBz7+4wTJCGivC9Ris5tQ4k35eM1YRnIVNnbd7HV/xe4IeGBIfi55
        0o45iU0mOM7qQ6WtnLB9ufNXpTLbWOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KXsDW4bHzz48+4x7pZWIdVLveXvjFzWFCS2CRNPPqBw=;
        b=NYE5ghuTuu5mH+l2GwiUkGnvDUtxFYoqJGaV56TIwmnQpL0Mbs740UvkYpKpy200kLVQA6
        Mura2PgliJ6sCvBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8E5F62C142;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9E4AD51E755D; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv500/15] scsi: EH rework prep patches, part 2
Date:   Mon,  2 Oct 2023 17:49:12 +0200
Message-Id: <20231002154927.68643-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

(taking up an old thread:)
here's the second batch of patches for my EH rework.
It modifies the reset callbacks for SCSI drivers
such that the final conversion to drop the 'struct scsi_cmnd'
argument and use the entity in question (host, bus, target, device)
as the argument to the SCSI EH callbacks becomes possible.
The second part covers drivers which require a bit more love.
In particular the fnic, snic, and csiostor drivers require a tag to
send TMFs. So to handle that I've modified the patches to call
scsi_alloc_request() with the NOWAIT flag; that will return a scsi
command with a valid tag. It might fail (eg when the tagset is full),
but in these cases it might be better to fall back to host_reset anyway.

As usual, comments and reviews are welcome.

Changes to v4:
- rework snic to use a dedicated tag for host reset
- rework snic to allocate TMFs on the fly
- rework fnic to allocate TMFs on the fly
- rework csiostor to allocat TMFs on the fly
- drop fc_block_rport() from zfcp host_reset
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

Hannes Reinecke (15):
  zfcp: do not wait for rports to become unblocked after host reset
  bfa: Do not use scsi command to signal TMF status
  aha152x: look for stuck command when resetting device
  a1000u2w: do not rely on the command for inia100_device_reset()
  fas216: Rework device reset to not rely on SCSI command pointer
  xen-scsifront: add scsi device as argument to scsifront_do_request()
  xen-scsifront: rework scsifront_action_handler()
  libiscsi: use cls_session as argument for target and session reset
  scsi_transport_iscsi: use session as argument for
    iscsi_block_scsi_eh()
  snic: reserve tag for TMF
  snic: allocate device reset command
  snic: Use scsi_host_busy_iter() to traverse commands
  fnic: allocate device reset command on the fly
  fnic: use fc_block_rport() correctly
  csiostor: use separate TMF command

 drivers/s390/scsi/zfcp_scsi.c       |   4 -
 drivers/scsi/a100u2w.c              |  43 +---
 drivers/scsi/aha152x.c              |  26 ++-
 drivers/scsi/arm/fas216.c           |  39 ++--
 drivers/scsi/be2iscsi/be_main.c     |  10 +-
 drivers/scsi/bfa/bfad_im.c          | 112 +++++-----
 drivers/scsi/bfa/bfad_im.h          |   2 +
 drivers/scsi/csiostor/csio_scsi.c   |  72 ++++---
 drivers/scsi/fnic/fnic.h            |   1 -
 drivers/scsi/fnic/fnic_scsi.c       | 115 +++++-----
 drivers/scsi/libiscsi.c             |  21 +-
 drivers/scsi/qla4xxx/ql4_os.c       |  34 +--
 drivers/scsi/scsi_transport_iscsi.c |   6 +-
 drivers/scsi/snic/snic.h            |   2 +-
 drivers/scsi/snic/snic_main.c       |   5 +-
 drivers/scsi/snic/snic_scsi.c       | 319 ++++++++++++----------------
 drivers/scsi/xen-scsifront.c        |  49 +++--
 include/scsi/libiscsi.h             |   2 +-
 include/scsi/scsi_transport_iscsi.h |   2 +-
 19 files changed, 414 insertions(+), 450 deletions(-)

-- 
2.35.3

