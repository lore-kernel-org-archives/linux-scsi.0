Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1574AC49EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD6E61C5B
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhF1Jy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 05:54:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35644 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhF1Jy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 05:54:58 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 92D1F2024F;
        Mon, 28 Jun 2021 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624873952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72vzEdeI67TNBamj/NSvbzifW0vrJrVIQXgQ2w7uS3M=;
        b=c3WKa82UAaIa2O2alAIqgwZBi/MngjTyjF1vZXBh5r5DTz/4wO+0makcWsoR+vqt0UdDry
        rt+zAShB0oMqH1u7DkpdskRATTL7/oY2p2ffWRJa0Ko5urJ3f53wXxr/upd7RSVd1XicC+
        pGvuwnVNdoVggsJeO60sGI+U4K4BZ2I=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 0667311906;
        Mon, 28 Jun 2021 09:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624873952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72vzEdeI67TNBamj/NSvbzifW0vrJrVIQXgQ2w7uS3M=;
        b=c3WKa82UAaIa2O2alAIqgwZBi/MngjTyjF1vZXBh5r5DTz/4wO+0makcWsoR+vqt0UdDry
        rt+zAShB0oMqH1u7DkpdskRATTL7/oY2p2ffWRJa0Ko5urJ3f53wXxr/upd7RSVd1XicC+
        pGvuwnVNdoVggsJeO60sGI+U4K4BZ2I=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id iLV3O9+b2WAqagAALh3uQQ
        (envelope-from <mwilck@suse.com>); Mon, 28 Jun 2021 09:52:31 +0000
From:   mwilck@suse.com
To:     Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>
Cc:     Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 1/3] scsi: scsi_ioctl: export __scsi_result_to_blk_status()
Date:   Mon, 28 Jun 2021 11:52:08 +0200
Message-Id: <20210628095210.26249-2-mwilck@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210628095210.26249-1-mwilck@suse.com>
References: <20210628095210.26249-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This makes it possible to use scsi_result_to_blk_status() from
code that shouldn't depend on scsi_mod (e.g. device mapper).

scsi_ioctl.c is selected by CONFIG_BLK_SCSI_REQUEST, which is automatically
selected by CONFIG_SCSI.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 block/scsi_ioctl.c      | 47 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c | 24 +--------------------
 include/linux/blkdev.h  |  1 +
 3 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index fa6df11b8bdd..19b63b64ecbc 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -882,6 +882,53 @@ void scsi_req_init(struct scsi_request *req)
 }
 EXPORT_SYMBOL(scsi_req_init);
 
+/* See set_host_byte() in include/scsi/scsi_cmnd.h */
+static void __set_host_byte(int *result, char status)
+{
+	*result = (*result & 0xff00ffff) | (status << 16);
+}
+
+/**
+ * __scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
+ * @cmd:	SCSI command
+ * @cmd_result: pointer to scsi cmnd result code to be possibly changed
+ *
+ * Translate a SCSI result code into a blk_status_t value. May reset the host
+ * byte of @cmd_result.
+ */
+blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result)
+{
+	switch (host_byte(result)) {
+	case DID_OK:
+		/*
+		 * Also check the other bytes than the status byte in result
+		 * to handle the case when a SCSI LLD sets result to
+		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
+		 */
+		if (scsi_status_is_good(result))
+			return BLK_STS_OK;
+		return BLK_STS_IOERR;
+	case DID_TRANSPORT_FAILFAST:
+	case DID_TRANSPORT_MARGINAL:
+		return BLK_STS_TRANSPORT;
+	case DID_TARGET_FAILURE:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_TARGET;
+	case DID_NEXUS_FAILURE:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_NEXUS;
+	case DID_ALLOC_FAILURE:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_NOSPC;
+	case DID_MEDIUM_ERROR:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_MEDIUM;
+	default:
+		return BLK_STS_IOERR;
+	}
+}
+EXPORT_SYMBOL(__scsi_result_to_blk_status);
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b994baf87c2..2c0eca3693af 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -589,29 +589,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
  */
 static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 {
-	switch (host_byte(result)) {
-	case DID_OK:
-		if (scsi_status_is_good(result))
-			return BLK_STS_OK;
-		return BLK_STS_IOERR;
-	case DID_TRANSPORT_FAILFAST:
-	case DID_TRANSPORT_MARGINAL:
-		return BLK_STS_TRANSPORT;
-	case DID_TARGET_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_TARGET;
-	case DID_NEXUS_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NEXUS;
-	case DID_ALLOC_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NOSPC;
-	case DID_MEDIUM_ERROR:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_MEDIUM;
-	default:
-		return BLK_STS_IOERR;
-	}
+	return __scsi_result_to_blk_status(&cmd->result, result);
 }
 
 /* Helper for scsi_io_completion() when "reprep" action required. */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1255823b2bc0..48497a77428d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2021,4 +2021,5 @@ int fsync_bdev(struct block_device *bdev);
 int freeze_bdev(struct block_device *bdev);
 int thaw_bdev(struct block_device *bdev);
 
+blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result);
 #endif /* _LINUX_BLKDEV_H */
-- 
2.32.0

