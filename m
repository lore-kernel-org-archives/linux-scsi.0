Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D00C2D0E5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A4220857
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgC0Qrx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:47:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:41770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbgC0Qrx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 12:47:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92A2AAE2D;
        Fri, 27 Mar 2020 16:47:51 +0000 (UTC)
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
Subject: [PATCH v3 3/5] Revert "scsi: qla2xxx: Fix unbound sleep in fcport delete path."
Date:   Fri, 27 Mar 2020 17:47:09 +0100
Message-Id: <20200327164711.5358-4-mwilck@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327164711.5358-1-mwilck@suse.com>
References: <20200327164711.5358-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This reverts commit c3b6a1d397420a0fdd97af2f06abfb78adc370df.
Aborting the sleep was risky, because after return from
qlt_free_session_done() the driver starts freeing resources,
which is dangerous while we know that there's pending IO.

The previous patch "scsi: qla2xxx: check UNLOADING before posting async
work" avoids sending this IO in the first place, and thus obsoletes
the dangerous timeout.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 622e733..eec1338 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1019,7 +1019,6 @@ void qlt_free_session_done(struct work_struct *work)
 
 	if (logout_started) {
 		bool traced = false;
-		u16 cnt = 0;
 
 		while (!READ_ONCE(sess->logout_completed)) {
 			if (!traced) {
@@ -1029,9 +1028,6 @@ void qlt_free_session_done(struct work_struct *work)
 				traced = true;
 			}
 			msleep(100);
-			cnt++;
-			if (cnt > 200)
-				break;
 		}
 
 		ql_dbg(ql_dbg_disc, vha, 0xf087,
-- 
2.25.1

