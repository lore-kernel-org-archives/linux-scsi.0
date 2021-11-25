Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2172C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355982AbhKYPQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:21 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47110 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353986AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1C9201FD40;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vG1NsW9Ym2IChL7Z2Nlxo8rK9NdubQtAdZTF8Jc0FeU=;
        b=AMA9WyPWYvkD+hKCcIy0DdVT6El9MqS2LT0nta+cwKn7+kQqdUXh0JT3Rm6Eryt9ILwww9
        KIZ8qmI3ST7NH7qQIVfFHZ8KwN64uupVPlLSOGc80J2R/UlsmsZvOCr+ZJ239DCMK7CoHT
        PutgYzyXf9el0o9mNncw/ZXQCz2DC1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vG1NsW9Ym2IChL7Z2Nlxo8rK9NdubQtAdZTF8Jc0FeU=;
        b=GkKzHA+MjSQTWDzz0SS8FoxOg1vetQFKno0nyfA02I/UD2XaVLOD58OlVbwV+yVxqwBcZG
        t08Jg1ZKu36igoCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 14744A3B91;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B8D0251919FE; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/15] aacraid: don't bother with setting SCp.Status
Date:   Thu, 25 Nov 2021 16:10:42 +0100
Message-Id: <20211125151048.103910-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCp.Status is only ever evaluated to set the return code of
aac_probe_container(), and all callers only check for negative
values here. The callbacks set it to the value of aac_mount.count,
which is an unsigned int; as such it should never become negative
here, and so we only need to return an error from aac_probe_container()
if we can't send the initial fib. But once that's done we can return
'0' and don't need to set SCp.Status at all.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 5b309a8beab8..289c4968a92e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -641,7 +641,6 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 	if (!aac_valid_context(scsicmd, fibptr))
 		return;
 
-	scsicmd->SCp.Status = 0;
 	fsa_dev_ptr = fibptr->dev->fsa_dev;
 	if (fsa_dev_ptr) {
 		struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
@@ -679,7 +678,6 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 		}
 		if ((fsa_dev_ptr->valid & 1) == 0)
 			fsa_dev_ptr->valid = 0;
-		scsicmd->SCp.Status = le32_to_cpu(dresp->count);
 	}
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
@@ -831,11 +829,11 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 	scsidev->id = cid;
 	scsidev->host = dev->scsi_host_ptr;
 
-	if (_aac_probe_container(scsicmd, aac_probe_container_callback1) == 0)
+	status = _aac_probe_container(scsicmd, aac_probe_container_callback1);
+	if (status == 0)
 		while (scsicmd->device == scsidev)
 			schedule();
 	kfree(scsidev);
-	status = scsicmd->SCp.Status;
 	kfree(scsicmd);
 	return status;
 }
-- 
2.29.2

