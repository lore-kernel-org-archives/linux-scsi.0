Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3B0C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F8B206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgF2TLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:11:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:53706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbgF2TL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58D67B0B8;
        Mon, 29 Jun 2020 07:20:56 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 18/22] hpsa: drop refcount field from CommandList
Date:   Mon, 29 Jun 2020 09:20:17 +0200
Message-Id: <20200629072021.9864-19-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200629072021.9864-1-hare@suse.de>
References: <20200629072021.9864-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Field is now unused, so drop it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c     | 12 ++----------
 drivers/scsi/hpsa_cmd.h |  1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6f0ef39471ce..52a313428a01 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5518,8 +5518,8 @@ static void hpsa_cmd_init(struct ctlr_info *h, int index,
 {
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 
-	/* Zero out all of commandlist except the last field, refcount */
-	memset(c, 0, offsetof(struct CommandList, refcount));
+	/* Zero out all of commandlist */
+	memset(c, 0, sizeof(struct CommandList));
 	c->Header.tag = cpu_to_le64((u64) (index << DIRECT_LOOKUP_SHIFT));
 	cmd_dma_handle = h->cmd_pool_dhandle + index * sizeof(*c);
 	c->err_info = h->errinfo_pool + index;
@@ -5541,7 +5541,6 @@ static void hpsa_preinitialize_commands(struct ctlr_info *h)
 		struct CommandList *c = h->cmd_pool + i;
 
 		hpsa_cmd_init(h, i, c);
-		atomic_set(&c->refcount, 0);
 	}
 }
 
@@ -6136,19 +6135,12 @@ static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 		return NULL;
 	}
 
-	atomic_inc(&c->refcount);
-
 	hpsa_cmd_partial_init(h, idx, c);
 	return c;
 }
 
 static void cmd_tagged_free(struct ctlr_info *h, struct CommandList *c)
 {
-	/*
-	 * Release our reference to the block.  We don't need to do anything
-	 * else to free it, because it is accessed by index.
-	 */
-	(void)atomic_dec(&c->refcount);
 	c->scsi_cmd = NULL;
 }
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 7825cbfea4dc..2575a396f1a5 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -449,7 +449,6 @@ struct CommandList {
 
 	int abort_pending;
 	struct hpsa_scsi_dev_t *device;
-	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 
 /* Max S/G elements in I/O accelerator command */
-- 
2.16.4

