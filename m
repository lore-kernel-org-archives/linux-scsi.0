Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78886C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355970AbhKYPQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35594 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352737AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1FCE421958;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNJ+5EKwl8ip9Irsdt0s9rcAwv+gUoSSmRF9tpHxDjc=;
        b=j2rYBPLPvP2AvVT5h9oOT23bQeWndF9KT+b2jUegt13Q86V+SSFgMnSdOgRjDxEaQg/asH
        vi3AIOm4TrPTaxmiIefNTl7RGO33SytaASVvpUzRRUW2y+BN7eH/11u/CGb1jswnAufp8l
        S0u7+Xx6Eg1/OSst7ziTpIgTEuQ5/7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNJ+5EKwl8ip9Irsdt0s9rcAwv+gUoSSmRF9tpHxDjc=;
        b=8M4Uin3Vs4pNYi3z1UBgZwUiIirOt9qRanzXV6kmPy5/dUb5WY44X2MI4EjqI/DITLo6xg
        YA6bAtByyx7tV1Aw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 13475A3B90;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B139A51919FA; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 07/15] hpsa: drop refcount field from CommandList
Date:   Thu, 25 Nov 2021 16:10:40 +0100
Message-Id: <20211125151048.103910-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Field is now unused, so drop it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c     | 11 ++---------
 drivers/scsi/hpsa_cmd.h | 10 ----------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 23babe177f5d..08cf9f570c1e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5537,8 +5537,8 @@ static void hpsa_cmd_init(struct ctlr_info *h, int index,
 {
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 
-	/* Zero out all of commandlist except the last field, refcount */
-	memset(c, 0, offsetof(struct CommandList, refcount));
+	/* Zero out all of commandlist */
+	memset(c, 0, sizeof(struct CommandList));
 	c->Header.tag = cpu_to_le64((u64) (index << DIRECT_LOOKUP_SHIFT));
 	cmd_dma_handle = h->cmd_pool_dhandle + index * sizeof(*c);
 	c->err_info = h->errinfo_pool + index;
@@ -5560,7 +5560,6 @@ static void hpsa_preinitialize_commands(struct ctlr_info *h)
 		struct CommandList *c = h->cmd_pool + i;
 
 		hpsa_cmd_init(h, i, c);
-		atomic_set(&c->refcount, 0);
 	}
 }
 
@@ -6171,7 +6170,6 @@ static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 		return NULL;
 	}
 
-	atomic_inc(&c->refcount);
 	hpsa_cmd_partial_init(h, idx, c);
 
 	/*
@@ -6185,11 +6183,6 @@ static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 
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
index ba6a3aa8d954..04c92c94cc6c 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -454,18 +454,8 @@ struct CommandList {
 
 	bool retry_pending;
 	struct hpsa_scsi_dev_t *device;
-	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 
-/*
- * Make sure our embedded atomic variable is aligned. Otherwise we break atomic
- * operations on architectures that don't support unaligned atomics like IA64.
- *
- * The assert guards against reintroductin against unwanted __packed to
- * the struct CommandList.
- */
-static_assert(offsetof(struct CommandList, refcount) % __alignof__(atomic_t) == 0);
-
 /* Max S/G elements in I/O accelerator command */
 #define IOACCEL1_MAXSGENTRIES           24
 #define IOACCEL2_MAXSGENTRIES		28
-- 
2.29.2

