Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE38C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DA86113D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbhHSJLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:11:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36676 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbhHSJLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:11:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 83208200B2;
        Thu, 19 Aug 2021 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mypCkcN03B6JdHrT6lxH/iNV6wSnQ4DHefYz3yCgc/I=;
        b=Ec3ExpIHcxyD6SLUhBC0rdQSjuaChgflfONv7OjnEsegoEyiJYt2avSB8fogIuw3Hxtecd
        otCF8hVwRBDlvl+J4JIA3lyBb6CgOHhLvKb7Zhgqyfg1sKONeE1ood4nM3CQ9SN9U63RNG
        rI6/Jti3zx5BqCO3iiAMNuf7Gw7tEuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364223;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mypCkcN03B6JdHrT6lxH/iNV6wSnQ4DHefYz3yCgc/I=;
        b=xoghmLb0BCqIingFfLCpeItQ4Ba+vnCpqxpAAWeo2OEFLudVvkYwSLME1nFxHfVqNjAnEa
        /6FFh4gTDOiUWxDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id BC72FA3BA1;
        Thu, 19 Aug 2021 09:10:13 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 75E37518D284; Thu, 19 Aug 2021 11:10:23 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] mptfc: iterate over all rports during bus reset
Date:   Thu, 19 Aug 2021 11:10:17 +0200
Message-Id: <20210819091017.94142-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091017.94142-1-hare@suse.de>
References: <20210819091017.94142-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When issuing a bus reset we need to call fc_block_rport() on all
ports, otherwise we might be executing the bus reset call prematurely.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptfc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 3962951c1e9a..952dc85bba08 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -227,14 +227,18 @@ mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_device	*sdev = SCpnt->device;
 	struct Scsi_Host	*shost = sdev->host;
-	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
 	MPT_SCSI_HOST		*hd = shost_priv(shost);
 	MPT_ADAPTER 		*ioc = hd->ioc;
+	struct mptfc_rport_info	*ri;
 	int rval;
 
-	rval = fc_block_rport(rport);
-	if (rval)
-		return rval;
+	list_for_each_entry(ri, &ioc->fc_rports, list) {
+		rval = fc_block_rport(ri->rport);
+		if (rval)
+			return rval;
+		if (ioc->active == 0)
+			return FAILED;
+	}
 	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 		"%s.%d: %d:%llu, executing recovery.\n",
 		ioc->name, __func__, ioc->sh->host_no,
-- 
2.29.2

