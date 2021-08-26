Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4784C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 18:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB87C6103A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 18:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhHZSwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 14:52:24 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:57374 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231453AbhHZSwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Aug 2021 14:52:24 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 8139D812368C
        for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2021 18:43:17 +0000 (UTC)
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 47CFF182CED2A;
        Thu, 26 Aug 2021 18:43:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 412B91D42F9;
        Thu, 26 Aug 2021 18:43:15 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] scsi: hpsa: Use vsprintf %phNX extension
Date:   Thu, 26 Aug 2021 11:43:03 -0700
Message-Id: <adef530c3e1f5acbbdc89cefcc21bb82e3b7bfbf.1630003183.git.joe@perches.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1630003183.git.joe@perches.com>
References: <cover.1630003183.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1dp4t7h5ed5sruzop8r3hbifn7ysaibg
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 412B91D42F9
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/HRp/Bw4bZ2IiTshRMV6FJJeAVTLa57dw=
X-HE-Tag: 1630003395-496730
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reduce object size by using the %phNX extension to format a sysfs output
buffer with identical output.

compiled x86-64 defconfig w/ hpsa and gcc 10.3.0

$ size drivers/scsi/hpsa.o*
   text	   data	    bss	    dec	    hex	filename
  84041	   2181	     20	  86242	  150e2	drivers/scsi/hpsa.o.new
  84226	   2181	     20	  86427	  1519b	drivers/scsi/hpsa.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/hpsa.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a2..c56871e8ce1b7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -743,13 +743,7 @@ static ssize_t unique_id_show(struct device *dev,
 	}
 	memcpy(sn, hdev->device_id, sizeof(sn));
 	spin_unlock_irqrestore(&h->lock, flags);
-	return snprintf(buf, 16 * 2 + 2,
-			"%02X%02X%02X%02X%02X%02X%02X%02X"
-			"%02X%02X%02X%02X%02X%02X%02X%02X\n",
-			sn[0], sn[1], sn[2], sn[3],
-			sn[4], sn[5], sn[6], sn[7],
-			sn[8], sn[9], sn[10], sn[11],
-			sn[12], sn[13], sn[14], sn[15]);
+	return snprintf(buf, 16 * 2 + 2, "%16phNX\n", sn);
 }
 
 static ssize_t sas_address_show(struct device *dev,
-- 
2.30.0

