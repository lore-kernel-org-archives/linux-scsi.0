Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82408C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D2663212
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhKQDDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 22:03:15 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47910 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhKQDDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 22:03:14 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8784B1FD29;
        Wed, 17 Nov 2021 03:00:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E98B13BBF;
        Wed, 17 Nov 2021 03:00:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pR+jOTxwlGFefgAAMHmgww
        (envelope-from <dave@stgolabs.net>); Wed, 17 Nov 2021 03:00:12 +0000
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     hare@suse.de, bigeasy@linutronix.de, tglx@linutronix.de,
        linux-scsi@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave@stgolabs.net
Subject: [PATCH -next 0/3] scsi/fcoe: Play nicer with PREEMPT_RT
Date:   Tue, 16 Nov 2021 18:59:53 -0800
Message-Id: <20211117025956.79616-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

The following are the result of trying to get rid of the out-of-tree
equivalent[1].

Patches 1 and 2 remove the actual scheduling while atomic scenarios.

Patch 3 could be considered optional because afaict the stats do not
actually have blocking calls while having preemption disabled. But
from an RT perspective it's still beneficial as the region remains
preemptible.

Compile tested only.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/scsi_fcoe__Make_RT_aware..patch?h=linux-5.15.y-rt-patches

Thanks!

Davidlohr Bueso (3):
  scsi/libfc: Remove get_cpu() semantics in fc_exch_em_alloc()
  scsi/fcoe: Add a local_lock to fcoe_percpu
  scsi/fcoe: Add a local_lock to percpu localport statistics

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 16 ++++++++------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  5 +++--
 drivers/scsi/fcoe/fcoe.c          | 35 +++++++++++++++++++------------
 drivers/scsi/fcoe/fcoe_ctlr.c     | 24 +++++++++++++--------
 drivers/scsi/libfc/fc_exch.c      |  3 +--
 drivers/scsi/libfc/fc_fcp.c       | 31 +++++++++++++++++++--------
 drivers/scsi/qedf/qedf_main.c     |  7 ++++---
 include/scsi/libfc.h              |  7 +++++++
 include/scsi/libfcoe.h            |  2 ++
 9 files changed, 86 insertions(+), 44 deletions(-)

-- 
2.26.2

