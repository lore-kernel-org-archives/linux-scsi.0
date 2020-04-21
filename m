Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991C6C55185
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 20:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86415206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 20:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDUUq7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 16:46:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:41884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgDUUq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 16:46:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0EEE6AE48;
        Tue, 21 Apr 2020 20:46:55 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 0/2] scsi: qla2xxx: fixes for driver unloading
Date:   Tue, 21 Apr 2020 22:46:19 +0200
Message-Id: <20200421204621.19228-1-mwilck@suse.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Hello Martin, Arun, Himanshu, all,

here is v4 of the little series I first submitted on Nov 29, 2019.
I dropped the more controversial part, hoping to get the actual fix
for the issue merged.

Reviews welcome.
Martin

Changes since v3:
 - In patch 2, moved check from qla2x00_post_async_XYZ_work() to
   qla2x00_alloc_work() as suggested by Arun
 - Dropped patch 3-5. With 1 and 2 applied, I haven't been able to reproduce
   shutdown hangs any more.

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

Martin Wilck (2):
  scsi: qla2xxx: set UNLOADING before waiting for session deletion
  scsi: qla2xxx: check UNLOADING before posting async work

 drivers/scsi/qla2xxx/qla_os.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

-- 
2.26.0

