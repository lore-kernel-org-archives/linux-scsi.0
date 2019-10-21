Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F87CA9EBA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 530712070B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfJUJxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:53:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:48814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727850AbfJUJxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 05:53:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D57D7BAB9;
        Mon, 21 Oct 2019 09:53:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/24] scsi: Kill obsolete linux-specific status codes
Date:   Mon, 21 Oct 2019 11:53:07 +0200
Message-Id: <20191021095322.137969-10-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191021095322.137969-1-hare@suse.de>
References: <20191021095322.137969-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After several years it's time to finally kill them.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_proto.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c36860111932..660f37ce8721 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -202,25 +202,6 @@ struct scsi_varlen_cdb_hdr {
 #define SAM_STAT_ACA_ACTIVE      0x30
 #define SAM_STAT_TASK_ABORTED    0x40
 
-/*
- *  Status codes. These are deprecated as they are shifted 1 bit right
- *  from those found in the SCSI standards. This causes confusion for
- *  applications that are ported to several OSes. Prefer SAM Status codes
- *  above.
- */
-
-#define GOOD                 0x00
-#define CHECK_CONDITION      0x01
-#define CONDITION_GOOD       0x02
-#define BUSY                 0x04
-#define INTERMEDIATE_GOOD    0x08
-#define INTERMEDIATE_C_GOOD  0x0a
-#define RESERVATION_CONFLICT 0x0c
-#define COMMAND_TERMINATED   0x11
-#define QUEUE_FULL           0x14
-#define ACA_ACTIVE           0x18
-#define TASK_ABORTED         0x20
-
 #define STATUS_MASK          0xfe
 
 /*
-- 
2.16.4

