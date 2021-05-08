Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9B3C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  8 May 2021 16:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BC461260
	for <linux-scsi@archiver.kernel.org>; Sat,  8 May 2021 16:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhEHQMr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 May 2021 12:12:47 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:47560 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhEHQMq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 May 2021 12:12:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id F33B5128018F;
        Sat,  8 May 2021 09:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1620490304;
        bh=lfDNqkmmUk0mztWdw1x9HPyihAABVH2qlsRo0i0jE3s=;
        h=Message-ID:Subject:From:To:Date:From;
        b=RLSShdV1XmEaUD+S3no020RcXLE8eTF1aJrMtr1QDJvwPDNfm4kogbOTDWeEweaNY
         qqCY0k0XgEiAApGoEB96bJbObX6zcvlS+NPWPDljkz5KGEXz5GUcyIXT0+6NhsVN/d
         6puL5JHdVivokzpXooDKXq/PcivxcZRYDBitxdyw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bG-fE-hKwZR5; Sat,  8 May 2021 09:11:44 -0700 (PDT)
Received: from jarvis (unknown [216.116.7.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4CD47128017C;
        Sat,  8 May 2021 09:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1620490304;
        bh=lfDNqkmmUk0mztWdw1x9HPyihAABVH2qlsRo0i0jE3s=;
        h=Message-ID:Subject:From:To:Date:From;
        b=RLSShdV1XmEaUD+S3no020RcXLE8eTF1aJrMtr1QDJvwPDNfm4kogbOTDWeEweaNY
         qqCY0k0XgEiAApGoEB96bJbObX6zcvlS+NPWPDljkz5KGEXz5GUcyIXT0+6NhsVN/d
         6puL5JHdVivokzpXooDKXq/PcivxcZRYDBitxdyw=
Message-ID: <85c07f003e2fd2885cd69af41f64c5c4d66c7860.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.12+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 08 May 2021 09:11:43 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a set of minor fixes in various drivers (qla2xxx, ufs,
scsi_debug, lpfc) one doc fix and a fairly large update to the fnic
driver to remove the open coded iteration functions in favour of the
scsi provided ones.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

And the short changelog is:

Anastasia Kovaleva (1):
      scsi: qla2xxx: Prevent PRLI in target mode

Bikash Hazarika (1):
      scsi: qla2xxx: Add marginal path handling support

Bodo Stroesser (1):
      scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Can Guo (3):
      scsi: ufs: core: Narrow down fast path in system suspend path
      scsi: ufs: core: Cancel rpm_dev_flush_recheck_work during system suspend
      scsi: ufs: core: Do not put UFS power into LPM if link is broken

Douglas Gilbert (1):
      scsi: scsi_debug: Fix cmd_per_lun, set to max_queue

Hannes Reinecke (2):
      scsi: fnic: Use scsi_host_busy_iter() to traverse commands
      scsi: fnic: Kill 'exclude_id' argument to fnic_cleanup_io()

James Smart (3):
      scsi: lpfc: Fix bad memory access during VPD DUMP mailbox command
      scsi: lpfc: Fix DMA virtual address ptr assignment in bsg
      scsi: lpfc: Fix illegal memory access on Abort IOCBs

Keoseong Park (1):
      scsi: ufs: core: Fix a typo in ufs-sysfs.c

Ming Lei (1):
      scsi: blk-mq: Fix build warning when making htmldocs

with the diffstat:

 drivers/scsi/fnic/fnic_scsi.c     | 828 +++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_bsg.c      |   2 +-
 drivers/scsi/lpfc/lpfc_init.c     |  12 +-
 drivers/scsi/lpfc/lpfc_sli.c      |  26 +-
 drivers/scsi/qla2xxx/qla_init.c   |   3 +
 drivers/scsi/qla2xxx/qla_os.c     |   1 +
 drivers/scsi/scsi_debug.c         |  24 +-
 drivers/scsi/ufs/ufs-sysfs.c      |  12 +-
 drivers/scsi/ufs/ufshcd.c         |   7 +-
 drivers/target/target_core_user.c |   4 +-
 include/linux/blk-mq.h            |   8 +-
 11 files changed, 438 insertions(+), 489 deletions(-)

James


