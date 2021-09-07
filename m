Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214ECC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 07:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0064460698
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 07:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhIGHRO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:17:14 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39996 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbhIGHRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 03:17:13 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EF58D1FDC7;
        Tue,  7 Sep 2021 07:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630998966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=icUYa+nNPBGm1qunlm/dRShUBng0bSB7KfRBlesHKfo=;
        b=E7l3PzmHuL5jIByxDdk4Ram1Cj6/RbfvWClAle52ev3Z6fXDF1qVMHZpRjsnhymIVzfatg
        DUdKyBYqZKhybAYJ1fNta6OnQc45yRwlS6xkt+SWN33jGmw0TME9Lg+lVVgKqv23PKPMbI
        jHQl37HmtGsYIsQuAW0uP+3+60xhafY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630998966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=icUYa+nNPBGm1qunlm/dRShUBng0bSB7KfRBlesHKfo=;
        b=M5uTX7RHaEqP06RF3RZvmXfn0NUzc4iZNw5vTymfFqoJF5sswx1W8a04h7SKWgNFlBidJ8
        Uz9VopYH5fk2EaDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E4F65A3B90;
        Tue,  7 Sep 2021 07:16:06 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B37A9518E192; Tue,  7 Sep 2021 09:16:06 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Rajashekhar M A <rajs@netapp.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] I/O errors for ALUA state transitions
Date:   Tue,  7 Sep 2021 09:16:05 +0200
Message-Id: <20210907071605.48968-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Rajashekhar M A <rajs@netapp.com>

When a host is configured with a few LUNs and IO is running,
injecting FC faults repeatedly leads to path recovery problems.
The LUNs have 4 paths each and 3 of them come back active after
say an FC fault which makes two of the paths go down, instead of
all 4. This happens after several iterations of continuous FC faults.

Reason here is that we're returning an I/O error whenever we're
encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 03a2ff547b22..1185083105ae 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -594,10 +594,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		    sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
 			return NEEDS_RETRY;
 		/*
-		 * if the device is in the process of becoming ready, we
-		 * should retry.
+		 * if the device is in the process of becoming ready, or
+		 * transitions between ALUA states, we should retry.
 		 */
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
+		if ((sshdr.asc == 0x04) &&
+		    (sshdr.ascq == 0x01 || sshdr.ascq == 0x0a))
 			return NEEDS_RETRY;
 		/*
 		 * if the device is not started, we need to wake
-- 
2.29.2

