Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5888C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 16:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80CE164E27
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 16:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhB1QxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 11:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhB1QxE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 11:53:04 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF022C06174A;
        Sun, 28 Feb 2021 08:52:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id DEA3E12801EB;
        Sun, 28 Feb 2021 08:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1614531140;
        bh=n9OTMU0Air1mhCD7c3sXEYkbVbDiquxyJfskZV1x03o=;
        h=Message-ID:Subject:From:To:Date:From;
        b=D96GfLxnfAYdUZu2mwv4JjF9jBH4lJuPAoTYMmOkEyuwA8UC2yf9er2U+DMTGgPo3
         yRyyd414k+1K9LJNYPjCW5w9cgK6nFS6SLJV6UYpQwOuwPi6EfOoVYa5TPfBZ+NHNG
         ZWD9yd84ftBOm1fYHR1UXlXHIzhrNX4zImUjHw6c=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1M97B2PiSC0s; Sun, 28 Feb 2021 08:52:20 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8158112801E9;
        Sun, 28 Feb 2021 08:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1614531140;
        bh=n9OTMU0Air1mhCD7c3sXEYkbVbDiquxyJfskZV1x03o=;
        h=Message-ID:Subject:From:To:Date:From;
        b=D96GfLxnfAYdUZu2mwv4JjF9jBH4lJuPAoTYMmOkEyuwA8UC2yf9er2U+DMTGgPo3
         yRyyd414k+1K9LJNYPjCW5w9cgK6nFS6SLJV6UYpQwOuwPi6EfOoVYa5TPfBZ+NHNG
         ZWD9yd84ftBOm1fYHR1UXlXHIzhrNX4zImUjHw6c=
Message-ID: <eadc15d02e4b01ed41de5bf0a8ea2594cfa288a8.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.11+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 28 Feb 2021 08:52:19 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a few driver updates (iscsi, mpt3sas) that were still in the
staging queue when the merge window opened (all committed on or before
8 Feb) and some small bug fixes which came in during the merge window
(all committed on 22 Feb).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc


The short changelog of the bug fixes is:

Aleksandr Miloserdov (2):
      scsi: target: core: Add cmd length set before cmd complete
      scsi: target: core: Prevent underflow for service actions

Avri Altman (1):
      scsi: ufs: Fix a duplicate dev quirk number

Bart Van Assche (1):
      scsi: sd: Fix Opal support

Bhaskar Chowdhury (1):
      scsi: aic79xx: Fix spelling of version

Bodo Stroesser (2):
      scsi: target: tcmu: Move some functions without code change
      scsi: target: tcmu: Fix memory leak caused by wrong uio usage

Chen Lin (1):
      scsi: aic7xxx: Remove unused function pointer typedef ahc_bus_suspend/resume_t

Don Brace (1):
      scsi: hpsa: Correct dev cmds outstanding for retried cmds

Johannes Thumshirn (1):
      scsi: sd: sd_zbc: Don't pass GFP_NOIO to kvcalloc

Randy Dunlap (1):
      scsi: bnx2fc: Fix Kconfig warning & CNIC build errors



The short changelog of the staging updates is:

Arnd Bergmann (1):
      scsi: pmcraid: Fix 'ioarcb' alignment warning

Damien Le Moal (1):
      scsi: sd: Warn if unsupported ZBC device is probed

DooHyun Hwang (1):
      scsi: ufs: Print the counter of each event history

Jiapeng Chong (1):
      scsi: qla2xxx: Simplify if statement

Mike Christie (9):
      scsi: iscsi: Drop session lock in iscsi_session_chkready()
      scsi: qla4xxx: Use iscsi_is_session_online()
      scsi: libiscsi: Reset max/exp cmdsn during recovery
      scsi: iscsi_tcp: Fix shost can_queue initialization
      scsi: libiscsi: Add helper to calculate max SCSI cmds per session
      scsi: libiscsi: Fix iSCSI host workq destruction
      scsi: libiscsi: Fix iscsi_task use after free()
      scsi: libiscsi: Drop taskqueuelock
      scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Sreekanth Reddy (2):
      scsi: mpt3sas: Add support for shared host tagset for CPU hotplug
      scsi: mpt3sas: Fix ReplyPostFree pool allocation

Suganath Prabu S (2):
      scsi: mpt3sas: Update driver version to 37.100.00.00
      scsi: mpt3sas: Additional diagnostic buffer query interface

Yang Li (2):
      scsi: isci: Remove redundant initialization of variable 'status'
      scsi: target: sbp: Remove unneeded semicolon



And the diffstat:

 drivers/scsi/aic7xxx/aic79xx.h              |   2 +-
 drivers/scsi/aic7xxx/aic7xxx.h              |   2 -
 drivers/scsi/bnx2fc/Kconfig                 |   1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |   2 -
 drivers/scsi/hpsa.c                         |  51 +++-
 drivers/scsi/hpsa_cmd.h                     |   2 +-
 drivers/scsi/isci/request.c                 |   8 +-
 drivers/scsi/iscsi_tcp.c                    |   9 +-
 drivers/scsi/libiscsi.c                     | 348 ++++++++++++++++++----------
 drivers/scsi/libiscsi_tcp.c                 |  86 ++++---
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  58 +++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  52 ++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  67 +++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |  22 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  44 +++-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  38 ++-
 drivers/scsi/pmcraid.h                      |   6 +-
 drivers/scsi/qla2xxx/qla_target.c           |   3 +-
 drivers/scsi/qla4xxx/ql4_os.c               |   2 +-
 drivers/scsi/scsi_transport_iscsi.c         |   3 -
 drivers/scsi/sd.c                           |  14 +-
 drivers/scsi/sd_zbc.c                       |   6 +-
 drivers/scsi/ufs/ufshcd.c                   |   6 +-
 drivers/scsi/ufs/ufshcd.h                   |   2 +-
 drivers/target/sbp/sbp_target.c             |   2 +-
 drivers/target/target_core_pr.c             |  15 +-
 drivers/target/target_core_transport.c      |  15 +-
 drivers/target/target_core_user.c           | 189 ++++++++-------
 include/scsi/libiscsi.h                     |   6 +-
 include/target/target_core_backend.h        |   1 +
 30 files changed, 746 insertions(+), 316 deletions(-)

James


