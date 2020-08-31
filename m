Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87425C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 16:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4822083E
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 16:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgHaQTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:19:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:45858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgHaQTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 12:19:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7D834AC50;
        Mon, 31 Aug 2020 16:19:19 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 0/4] qla2xxx: A couple crash fixes
Date:   Mon, 31 Aug 2020 18:18:50 +0200
Message-Id: <20200831161854.70879-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

changes since v1:

 - added dummy warn function to patch#1
 - added log entry to patch#4

as suggested by Martin



Initial cover letter:

The first crash we observed is due memory corruption in the srb memory
pool. Unforuntatly, I couldn't find the source of the problem but the
workaround by resetting the cleanup callbacks 'fixes' this problem
(patch #1). I think as intermeditate step this should be merged until
the real cause can be identified.

The second crash is due a race condition(?) in the firmware. The sts
entries are not updated in time which leads to this crash pattern
which several customers have reported:

 #0 [c00000ffffd1bb80] scsi_dma_unmap at d00000001e4904d4 [scsi_mod]
 #1 [c00000ffffd1bbe0] qla2x00_sp_compl at d0000000204803cc [qla2xxx]
 #2 [c00000ffffd1bc20] qla24xx_process_response_queue at d0000000204c5810 [qla2xxx]
 #3 [c00000ffffd1bd50] qla24xx_msix_rsp_q at d0000000204c8fd8 [qla2xxx]
 #4 [c00000ffffd1bde0] __handle_irq_event_percpu at c000000000189510
 #5 [c00000ffffd1bea0] handle_irq_event_percpu at c00000000018978c
 #6 [c00000ffffd1bee0] handle_irq_event at c00000000018984c
 #7 [c00000ffffd1bf10] handle_fasteoi_irq at c00000000018efc0
 #8 [c00000ffffd1bf40] generic_handle_irq at c000000000187f10
 #9 [c00000ffffd1bf60] __do_irq at c000000000018784
 #10 [c00000ffffd1bf90] call_do_irq at c00000000002caa4
 #11 [c00000ecca417a00] do_IRQ at c000000000018970
 #12 [c00000ecca417a50] restore_check_irq_replay at c00000000000de98

From analyzing the crash dump it was clear that
qla24xx_mbx_iocb_entry() calls sp->done (qla2x00_sp_compl) which
crashes because the response is not a mailbox entry, it is a status
entry. Patch #4 changes the process logic for mailbox commands so that
the sp is parsed before calling the correct proccess function.

Thanks,
Daniel

Daniel Wagner (4):
  qla2xxx: Warn if done() or free() are called on an already freed srb
  qla2xxx: Simplify return value logic in qla2x00_get_sp_from_handle()
  qla2xxx: Drop unused function argument from
    qla2x00_get_sp_from_handle()
  qla2xxx: Handle incorrect entry_type entries

 drivers/scsi/qla2xxx/qla_gbl.h    |  3 +-
 drivers/scsi/qla2xxx/qla_init.c   | 10 ++++++
 drivers/scsi/qla2xxx/qla_inline.h |  5 +++
 drivers/scsi/qla2xxx/qla_isr.c    | 74 +++++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_mr.c     |  9 ++---
 5 files changed, 62 insertions(+), 39 deletions(-)

-- 
2.16.4

