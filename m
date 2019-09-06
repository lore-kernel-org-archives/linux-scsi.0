Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5105EC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 20:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246C02178F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 20:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394493AbfIFU0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 16:26:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfIFU0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 16:26:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EE083C918;
        Fri,  6 Sep 2019 20:26:25 +0000 (UTC)
Received: from rhel7lobe.redhat.com (ovpn-125-48.rdu2.redhat.com [10.10.125.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF1E2600CC;
        Fri,  6 Sep 2019 20:26:24 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     loberman@redhat.com, QLogic-Storage-Upstream@qlogic.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or TASK_SET_FULL
Date:   Fri,  6 Sep 2019 16:26:19 -0400
Message-Id: <1567801579-18674-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 06 Sep 2019 20:26:25 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The qla2xxx driver had this issue as well when the newer array
firmware returned the retry_delay_timer in the fcp_rsp.
The bnx2fc is not handling the masking of the scope bits either
so the retry_delay_timestamp value lands up being a large value
added to the timer timestamp delaying I/O for up to 27 Minutes.
This patch adds similar code to handle this to the
bnx2fc driver to avoid the huge delay.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9e50e5b..39f4aeb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1928,6 +1928,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct scsi_cmnd *sc_cmd;
 	struct Scsi_Host *host;
+	u16 scope, qualifier = 0;
 
 
 	/* scsi_cmd_cmpl is called with tgt lock held */
@@ -1997,12 +1998,28 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 
 			if (io_req->cdb_status == SAM_STAT_TASK_SET_FULL ||
 			    io_req->cdb_status == SAM_STAT_BUSY) {
+				/* Newer array firmware with BUSY or
+				 * TASK_SET_FULL may return a status that needs
+				 * the scope bits masked.
+				 * Or a huge delay timestamp up to 27 minutes
+				 * can result.
+				*/
+				if (fcp_rsp->retry_delay_timer) {
+					/* Upper 2 bits */
+					scope = fcp_rsp->retry_delay_timer
+						& 0xC000;
+					/* Lower 14 bits */
+					qualifier = fcp_rsp->retry_delay_timer
+						& 0x3FFF;
+				}
+				if (scope > 0 && qualifier > 0 &&
+					qualifier <= 0x3FEF) {
 				/* Set the jiffies + retry_delay_timer * 100ms
 				   for the rport/tgt */
-				tgt->retry_delay_timestamp = jiffies +
-					fcp_rsp->retry_delay_timer * HZ / 10;
+					tgt->retry_delay_timestamp = jiffies +
+						(qualifier * HZ / 10);
+				}
 			}
-
 		}
 		if (io_req->fcp_resid)
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
-- 
1.8.3.1

