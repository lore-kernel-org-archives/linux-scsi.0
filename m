Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D384C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349532AbhKYPSP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:18:15 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47312 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355938AbhKYPQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:16:15 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 22B7D1FDF2;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g45ASkjvWI2xkcBz9wYpZAONSnwJRel08aEwB+Jp2qQ=;
        b=b2eOC4/+HoNMD0zjxi4yYu0+6LlQW0KOwrEY3XyZWwknCXypThQpdt8nImjEFm86RKqQrb
        AdFiWKgYMnc/nS3w7Ma9gvsWocGh9k9K4eKB2QHGrR/wgzPeNeJqr6+rJJKkmnGcBBsLdo
        SZe7W0tJbjxdDoeNE7LEDKRyLiDT0jI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g45ASkjvWI2xkcBz9wYpZAONSnwJRel08aEwB+Jp2qQ=;
        b=bg/WPHp7JfiKqqLSYoytlq53c0egPTbvGxj5fAmUc7mQqVz/3wcjMDX7criE8NtQ0r1IaA
        JDFp00poS2dj18AA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 18458A3B94;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C7BEE5191A06; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/15] aacraid: store callback in scsi_cmnd.host_scribble
Date:   Thu, 25 Nov 2021 16:10:46 +0100
Message-Id: <20211125151048.103910-14-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Store the container callback in scsi_cmnd.host_scribble to avoid
having to rely on the fake scsi device during container probing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 580d74b2ee14..b21ccf7af43f 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -676,8 +676,8 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
-	callback = (int (*)(struct scsi_cmnd *))(scsicmd->SCp.ptr);
-	scsicmd->SCp.ptr = NULL;
+	callback = (int (*)(struct scsi_cmnd *))(scsicmd->host_scribble);
+	scsicmd->host_scribble = NULL;
 	(*callback)(scsicmd);
 	return;
 }
@@ -758,7 +758,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
 
 		dinfo->count = cpu_to_le32(fibptr->cid);
 		dinfo->type = cpu_to_le32(FT_FILESYS);
-		scsicmd->SCp.ptr = (char *)callback;
+		scsicmd->host_scribble = (char *)callback;
 		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 		status = aac_fib_send(ContainerCommand,
@@ -775,9 +775,9 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
 			return 0;
 
 		if (status < 0) {
-			scsicmd->SCp.ptr = NULL;
 			aac_fib_complete(fibptr);
 			aac_fib_free(fibptr);
+			scsicmd->host_scribble = NULL;
 		}
 	}
 	if (status < 0) {
@@ -798,7 +798,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
  */
 static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
 {
-	scsicmd->device = NULL;
+	scsicmd->host_scribble = NULL;
 	return 0;
 }
 
@@ -827,7 +827,7 @@ int aac_probe_container(struct aac_dev *dev, unsigned int cid)
 	status = _aac_probe_container(scsicmd, cid,
 				      aac_probe_container_callback1);
 	if (status == 0)
-		while (scsicmd->device == scsidev)
+		while (scsicmd->host_scribble != NULL)
 			schedule();
 	kfree(scsidev);
 	kfree(scsicmd);
-- 
2.29.2

