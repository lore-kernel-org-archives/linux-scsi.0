Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170DCC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 18:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2FA660E08
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 18:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhHZSvy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 14:51:54 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:32848 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231453AbhHZSvy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Aug 2021 14:51:54 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 525D6181424B6
        for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2021 18:43:19 +0000 (UTC)
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 008ED837F27E;
        Thu, 26 Aug 2021 18:43:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 054AB1D42F7;
        Thu, 26 Aug 2021 18:43:16 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Don Brace <don.brace@microchip.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] scsi: smartpqi: Use vsprintf %phNX extension
Date:   Thu, 26 Aug 2021 11:43:04 -0700
Message-Id: <31db4db01d24e5178188f48adc5acba6c8047316.1630003183.git.joe@perches.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1630003183.git.joe@perches.com>
References: <cover.1630003183.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dkghw7fcxo96pwthgsbw3xud47jefwut
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 054AB1D42F7
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18aJ2uDYrib1nqIWyemTIPTjkSl3+EHeeo=
X-HE-Tag: 1630003396-209518
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reduce object size by using the %phNX extension to format a sysfs output
buffer with identical output.

compiled x86-64 defconfig w/ smartpqi and gcc 10.3.0

$ size drivers/scsi/smartpqi/smartpqi_init.o*
   text	   data	    bss	    dec	    hex	filename
  69791	   2205	     48	  72044	  1196c	drivers/scsi/smartpqi/smartpqi_init.o.new
  69950	   2205	     48	  72203	  11a0b	drivers/scsi/smartpqi/smartpqi_init.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca3..eb39490b196cc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6674,13 +6674,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return scnprintf(buffer, PAGE_SIZE,
-		"%02X%02X%02X%02X%02X%02X%02X%02X"
-		"%02X%02X%02X%02X%02X%02X%02X%02X\n",
-		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
-		unique_id[4], unique_id[5], unique_id[6], unique_id[7],
-		unique_id[8], unique_id[9], unique_id[10], unique_id[11],
-		unique_id[12], unique_id[13], unique_id[14], unique_id[15]);
+	return scnprintf(buffer, PAGE_SIZE, "%16phNX\n", unique_id);
 }
 
 static ssize_t pqi_lunid_show(struct device *dev,
-- 
2.30.0

