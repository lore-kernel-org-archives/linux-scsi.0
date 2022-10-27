Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19136ECAAA1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 15:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiJ0PKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 11:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiJ0PJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 11:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE15918F242;
        Thu, 27 Oct 2022 08:09:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7441162396;
        Thu, 27 Oct 2022 15:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5404C433D6;
        Thu, 27 Oct 2022 15:09:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oo4Ve-00Bvfa-0M;
        Thu, 27 Oct 2022 11:09:30 -0400
Message-ID: <20221027150929.939073415@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 27 Oct 2022 11:05:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [RFC][PATCH v2 25/31] timers: scsi: Use del_timer_shutdown() before freeing timer
References: <20221027150525.753064657@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Before a timer is freed, del_timer_shutdown() must be called.

Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home/

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 00ccc41cef14..01fc6869b99a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -416,7 +416,7 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 				 */
 				if (edif_entry->delete_sa_index !=
 						INVALID_EDIF_SA_INDEX) {
-					del_timer(&edif_entry->timer);
+					del_timer_shutdown(&edif_entry->timer);
 
 					/* build and send the aen */
 					fcport->edif.rx_sa_set = 1;
@@ -2799,7 +2799,7 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 			    "%s: removing edif_entry %p, new sa_index: 0x%x\n",
 			    __func__, edif_entry, pkt->sa_index);
 			qla_edif_list_delete_sa_index(sp->fcport, edif_entry);
-			del_timer(&edif_entry->timer);
+			del_timer_shutdown(&edif_entry->timer);
 
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
 			    "%s: releasing edif_entry %p, new sa_index: 0x%x\n",
-- 
2.35.1
