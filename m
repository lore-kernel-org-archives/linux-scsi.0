Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0A6CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 18:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A28AD20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 18:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfKDSSZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 13:18:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:54536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727998AbfKDSSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 13:18:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6284CABD0;
        Mon,  4 Nov 2019 18:18:23 +0000 (UTC)
From:   Thomas Abraham <tabraham@suse.com>
To:     hmadhani@marvell.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, Thomas Abraham <tabraham@suse.com>
Subject: [PATCH] scsi: qla2xxx: avoid crash in qlt_handle_abts_completion() if mcmd == NULL
Date:   Mon,  4 Nov 2019 13:18:03 -0500
Message-Id: <20191104181803.5475-1-tabraham@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qlt_ctio_to_cmd() will return a NULL mcmd if h == QLA_TGT_SKIP_HANDLE. If
the error subcodes don't match the exact codes checked a crash will occur
when calling free_mcmd on the null mcmd

Signed-off-by: Thomas Abraham <tabraham@suse.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a06e56224a55..611ab224662f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5732,7 +5732,8 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 			    vha->vp_idx, entry->compl_status,
 			    entry->error_subcode1,
 			    entry->error_subcode2);
-			ha->tgt.tgt_ops->free_mcmd(mcmd);
+			if (mcmd)
+				ha->tgt.tgt_ops->free_mcmd(mcmd);
 		}
 	} else if (mcmd) {
 		ha->tgt.tgt_ops->free_mcmd(mcmd);
-- 
2.16.4

