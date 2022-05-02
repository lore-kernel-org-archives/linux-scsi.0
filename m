Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE74C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387833AbiEBWFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387762AbiEBWDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7316DEEA
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CB64B1F750;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EADvvjPA5hcw22PXo+e878ItArC+jGlTf0IlI2Jw/4g=;
        b=ghUBn2QVUDWBfhJ36/yFo7ZEpv/+hpp3ParSKsCO5puHIuOLvKf+tas7kPwYvQv5DykccA
        hVS0vyKibh0+xtLrhAnofb3qSgVv8d1doP4bTssBhBZKFOsFL8wM1AbCzvaInwMIaR4ui9
        xqceHS4ubwPe/79sgp9cetkxaKLM4PQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EADvvjPA5hcw22PXo+e878ItArC+jGlTf0IlI2Jw/4g=;
        b=1A2MB8DPkEB+NYnYX3QhweUd/Xn3ZD/Qm51i07+pjTIqTTq9jyZ+8fO4ZKnihhFZKctq1L
        zqschkNcrdHvN5DA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C783C2C15D;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C4AFC5194158; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
Date:   Mon,  2 May 2022 23:59:47 +0200
Message-Id: <20220502215953.5463-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unused now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c  | 2 --
 include/scsi/scsi_cmnd.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d18cc7e510e..98b1e836231f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1613,8 +1613,6 @@ static void scsi_done_internal(struct scsi_cmnd *cmd, bool complete_directly)
 		break;
 	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
 		return scsi_eh_done(cmd);
-	case SUBMITTED_BY_SCSI_RESET_IOCTL:
-		return;
 	}
 
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 1e80e70dfa92..6fb3311bd704 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -62,7 +62,6 @@ struct scsi_pointer {
 enum scsi_cmnd_submitter {
 	SUBMITTED_BY_BLOCK_LAYER = 0,
 	SUBMITTED_BY_SCSI_ERROR_HANDLER = 1,
-	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
 struct scsi_cmnd {
-- 
2.29.2

