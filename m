Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86C6C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9547A22268
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgJSMR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:17:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49258 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgJSMR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 08:17:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC6B1AE2E;
        Mon, 19 Oct 2020 12:17:57 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] bfa: update printk() usage
Date:   Mon, 19 Oct 2020 14:17:52 +0200
Message-Id: <20201019121756.74644-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

sparked off by a recent discussion here is a patchset
to update the printk() usage in bfa.
All 'legacy' printk() calls are moved to structured logging
(ie dev_printk() and friends), and the code is restructured
to move the debugging code over to that, too.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  bfa: Remove legacy printk() usage
  bfa: drop unused 'bfad' and 'pcidev' arguments
  bfa: remove bfa_pcidev_s
  bfa: move bfa_sm_fault() to dev_err()

 drivers/scsi/bfa/bfa.h          |  8 +---
 drivers/scsi/bfa/bfa_core.c     | 51 +++++++++++--------------
 drivers/scsi/bfa/bfa_cs.h       |  2 +-
 drivers/scsi/bfa/bfa_fcpim.c    |  8 ++--
 drivers/scsi/bfa/bfa_ioc.c      | 68 +++++++++++++++++-----------------
 drivers/scsi/bfa/bfa_ioc.h      | 23 +++---------
 drivers/scsi/bfa/bfa_ioc_ct.c   |  8 ++--
 drivers/scsi/bfa/bfa_modules.h  | 28 +++++---------
 drivers/scsi/bfa/bfa_svc.c      | 31 ++++++----------
 drivers/scsi/bfa/bfad.c         | 82 +++++++++++++++++------------------------
 drivers/scsi/bfa/bfad_bsg.c     | 12 ++----
 drivers/scsi/bfa/bfad_debugfs.c | 32 ++++++----------
 drivers/scsi/bfa/bfad_drv.h     |  4 +-
 drivers/scsi/bfa/bfad_im.c      | 14 +++----
 14 files changed, 150 insertions(+), 221 deletions(-)

-- 
2.16.4

