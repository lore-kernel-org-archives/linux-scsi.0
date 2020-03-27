Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBAAC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D5320857
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgC0Qrx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:47:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:41714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbgC0Qrx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 12:47:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D2294AD94;
        Fri, 27 Mar 2020 16:47:50 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/5] scsi: qla2xxx: fixes for driver unloading
Date:   Fri, 27 Mar 2020 17:47:06 +0100
Message-Id: <20200327164711.5358-1-mwilck@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Hello Martin, Arun, Himanshu, all,

here is v3 of the little series I first submitted on Nov 29, 2019.
It's pretty much a complete rewrite, except for 1/5 which was 3/3 in v2.

Reviews welcome.
Martin

Changes since v2:
 - Removed "scsi: qla2xxx: avoid sending mailbox commands if firmware is
   stopped", because the first hunk is obsoleted by the (new) 1/3, and Arun
   suggested to use a different approach (which is now in 4/3) for the second
   hunk.
 - Removed "scsi: qla2xxx: don't shut down firmware before closing sessions"
   (nak'd by Arun).
 - Former 3/3 is now 1/5
 - Added "scsi: qla2xxx: check UNLOADING before posting async work". This one
   is key for avoiding lags when qla2xxx is unloaded.
 - Added revert of "scsi: qla2xxx: Fix unbound sleep in fcport delete path.",
   as I believe it's now obsolete.
   If we ever encounter unbound sleep there again, we should rather figure
   out the reason than simply abort waiting.
 - Added patch 4 and 5, a new attempt at avoiding mailbox and HW request queue
   access at low level. 4/5 was motivated by Arun's comments on my v2 series.
   5/5 is obviously similar in spirit to 77ddb94a4853 ("scsi: qla2xxx: Only
   allow operational MBX to proceed during RESET."), but I found that the
   rom_cmds list contains commands that would hang when the FW is stopped,
   so I created a new list. Perhaps some day the two can be consolidated.

Changes since v1:
 - Added patch 3 to set the UNLOADING flag before waiting for sessions
   to end (Roman)
 - Use test_and_set_bit() for UNLOADING (Hannes)

Martin Wilck (5):
  scsi: qla2xxx: set UNLOADING before waiting for session deletion
  scsi: qla2xxx: check UNLOADING before posting async work
  Revert "scsi: qla2xxx: Fix unbound sleep in fcport delete path."
  scsi: qla2xxx: avoid sending iocbs when firmware is stopped
  scsi: qla2xxx: only send certain mailbox commands to stopped firmware

 drivers/scsi/qla2xxx/qla_inline.h |  3 ++
 drivers/scsi/qla2xxx/qla_iocb.c   | 23 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c    | 46 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nvme.c   |  3 ++
 drivers/scsi/qla2xxx/qla_os.c     | 35 ++++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.c |  4 ---
 6 files changed, 92 insertions(+), 22 deletions(-)

-- 
2.25.1

