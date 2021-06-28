Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CC3C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEF761448
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhF1JzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 05:55:03 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35666 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbhF1Jy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 05:54:59 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4049720250;
        Mon, 28 Jun 2021 09:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624873953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QWZWzQI5muMZzs/zBUCoXOExibFys9EajgyvUx8J0Y=;
        b=BIB2YK0Gh5XWnkRckMtd6fx3YJfB2BFnDtNYE+YzCUf/HSR/egDGntiQOJd1Xw5oHuUodX
        v48KaODsEoo6NiXSwz8Lk1fcSGiRkpVePNFHBiII1LTzXMMwG7pceUePKwdAQdfjBGjytO
        sHZzH4qpOYXtdgodShFReB5NfH2660I=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9CEE911906;
        Mon, 28 Jun 2021 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624873953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QWZWzQI5muMZzs/zBUCoXOExibFys9EajgyvUx8J0Y=;
        b=BIB2YK0Gh5XWnkRckMtd6fx3YJfB2BFnDtNYE+YzCUf/HSR/egDGntiQOJd1Xw5oHuUodX
        v48KaODsEoo6NiXSwz8Lk1fcSGiRkpVePNFHBiII1LTzXMMwG7pceUePKwdAQdfjBGjytO
        sHZzH4qpOYXtdgodShFReB5NfH2660I=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id GAeyJOCb2WAqagAALh3uQQ
        (envelope-from <mwilck@suse.com>); Mon, 28 Jun 2021 09:52:32 +0000
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
Subject: [PATCH v4 2/3] scsi: scsi_ioctl: add sg_io_to_blk_status()
Date:   Mon, 28 Jun 2021 11:52:09 +0200
Message-Id: <20210628095210.26249-3-mwilck@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210628095210.26249-1-mwilck@suse.com>
References: <20210628095210.26249-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This helper converts the SCSI result in a sg_io_hdr struct to a blk_status_t.
It will be used in the SG_IO code path for dm-multipath. Putting it into
scsi_ioctl.c avoids open-coding SCSI specific code in the dm layer.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 block/scsi_ioctl.c     | 20 ++++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 19b63b64ecbc..f226cac02e88 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -929,6 +929,26 @@ blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result)
 }
 EXPORT_SYMBOL(__scsi_result_to_blk_status);
 
+blk_status_t sg_io_to_blk_status(struct sg_io_hdr *hdr)
+{
+	int result;
+	blk_status_t sts;
+
+	if (!hdr->info & SG_INFO_CHECK)
+		return BLK_STS_OK;
+
+	result = hdr->status |
+		(hdr->msg_status << 8) |
+		(hdr->host_status << 16) |
+		(hdr->driver_status << 24);
+
+	sts = __scsi_result_to_blk_status(&result, result);
+	hdr->host_status = host_byte(result);
+
+	return sts;
+}
+EXPORT_SYMBOL(sg_io_to_blk_status);
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 48497a77428d..5da03edf125c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2022,4 +2022,5 @@ int freeze_bdev(struct block_device *bdev);
 int thaw_bdev(struct block_device *bdev);
 
 blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result);
+blk_status_t sg_io_to_blk_status(struct sg_io_hdr *hdr);
 #endif /* _LINUX_BLKDEV_H */
-- 
2.32.0

