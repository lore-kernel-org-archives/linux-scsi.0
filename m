Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E84CC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA716115B
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242400AbhDWLlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:47220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242283AbhDWLkm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B6849B1F4;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/39] advansys: do not set message byte in SCSI status
Date:   Fri, 23 Apr 2021 13:39:35 +0200
Message-Id: <20210423113944.42672-31-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The host byte in the SCSI status takes precedence during error recovery,
so there is no point in setting the message byte in addition to a host byte
which is not DID_OK.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 77c99fe11c81..28748df36c2f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6773,14 +6773,12 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	case QD_ABORTED_BY_HOST:
 		ASC_DBG(1, "QD_ABORTED_BY_HOST\n");
 		set_status_byte(scp, qdonep->d3.scsi_stat);
-		set_msg_byte(scp, qdonep->d3.scsi_msg);
 		set_host_byte(scp, DID_ABORT);
 		break;
 
 	default:
 		ASC_DBG(1, "done_stat 0x%x\n", qdonep->d3.done_stat);
 		set_status_byte(scp, qdonep->d3.scsi_stat);
-		set_msg_byte(scp, qdonep->d3.scsi_msg);
 		set_host_byte(scp, DID_ERROR);
 		break;
 	}
-- 
2.29.2

