Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4E1C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 18:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F40076103A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 18:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243261AbhHZStr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 14:49:47 -0400
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:44394 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243338AbhHZStq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Aug 2021 14:49:46 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2021 14:49:46 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 85A8A1829490A;
        Thu, 26 Aug 2021 18:43:15 +0000 (UTC)
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 7064C181468F4;
        Thu, 26 Aug 2021 18:43:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 97FBF1D42F8;
        Thu, 26 Aug 2021 18:43:13 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] scsi: aacraid: Use vsprintf %phNX extension
Date:   Thu, 26 Aug 2021 11:43:02 -0700
Message-Id: <e628558ecaea44a8f1a99dc19213346fb1ee3b18.1630003183.git.joe@perches.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1630003183.git.joe@perches.com>
References: <cover.1630003183.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oyxkoapxkjdpmjcoqxkpq41u6qwjrke1
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 97FBF1D42F8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19m7FpLVB/46wwfXSmzF/vXd2/a2uAtK1Q=
X-HE-Tag: 1630003393-2335
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reduce object size by using the %phNX extension to format a sysfs output
buffer with identical output.

compiled x86-64 defconfig w/ aacraid and gcc 10.3.0

$ size drivers/scsi/aacraid/linit.o*
   text	   data	    bss	    dec	    hex	filename
  18616	   4056	      0	  22672	   5890	drivers/scsi/aacraid/linit.o.new
  18951	   4056	      0	  23007	   59df	drivers/scsi/aacraid/linit.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aacraid/linit.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3168915adaa75..165e6e10f07b9 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -587,12 +587,7 @@ static ssize_t aac_show_unique_id(struct device *dev,
 	if (sdev_channel(sdev) == CONTAINER_CHANNEL)
 		memcpy(sn, aac->fsa_dev[sdev_id(sdev)].identifier, sizeof(sn));
 
-	return snprintf(buf, 16 * 2 + 2,
-		"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n",
-		sn[0], sn[1], sn[2], sn[3],
-		sn[4], sn[5], sn[6], sn[7],
-		sn[8], sn[9], sn[10], sn[11],
-		sn[12], sn[13], sn[14], sn[15]);
+	return snprintf(buf, 16 * 2 + 2, "%16phNX\n", sn);
 }
 
 static struct device_attribute aac_unique_id_attr = {
-- 
2.30.0

