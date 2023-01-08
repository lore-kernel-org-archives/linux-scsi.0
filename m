Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300B5C54EBD
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 19:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjAHTOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 14:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjAHTOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 14:14:10 -0500
Received: from msg-2.mailo.com (msg-2.mailo.com [213.182.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9541964D1;
        Sun,  8 Jan 2023 11:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1673205241; bh=3IgVzGcbKlvB9iXK55wFWtWMolgT1lNBS+PC0hqxscw=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=mTWVk3o4hQ4l049eOGat8J9TwAcHF+OEF2WPdZG2gmlSSFeA6hOfJVb4VWyimbCYK
         YbPjal41i6J5nB8p82eJJcxEmJEgb9U0T+GLeXiIEMykkE0PGx/Xij8lMUJPV0s/l+
         T8MxhDisbghNhyYQ4fV7Dfc8++TYU1Y0b25Y2jag=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Sun,  8 Jan 2023 20:14:01 +0100 (CET)
X-EA-Auth: CYo250FgwwXLDinjEhWIxunfu44PrNgg365QQUi/nkLXQDHLIAwfIj1J7A/8XMObPNptZNvzbbsysxgpl5lJTs5HVeZ3w5V9
Date:   Mon, 9 Jan 2023 00:43:56 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: [PATCH] scsi: Replace printk+WARN_ON by WARN macro
Message-ID: <Y7sV9A+lE5uN9AxT@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A combination of printk() followed by WARN_ON() macro can be simplified
using a single WARN(1, ...) macro. Patch change suggested by warn.cocci
Coccinelle semantic patch.

Signed-off-by: Deepak R Varma <drv@mailo.com>
---
 drivers/scsi/initio.c   | 3 +--
 drivers/scsi/scsi_lib.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 375261d67619..fea591d9d292 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2738,8 +2738,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 	host = (struct initio_host *) host_mem;
 	cblk = (struct scsi_ctrl_blk *) cblk_mem;
 	if ((cmnd = cblk->srb) == NULL) {
-		printk(KERN_ERR "i91uSCBPost: SRB pointer is empty\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "i91uSCBPost: SRB pointer is empty\n");
 		initio_release_scb(host, cblk);	/* Release SCB for current channel */
 		return;
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ed1ebcb7443..96c9a561973e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3009,10 +3009,8 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	}
 
 	if (unlikely(i == sg_count)) {
-		printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
-			"elements %d\n",
-		       __func__, sg_len, *offset, sg_count);
-		WARN_ON(1);
+		WARN(1, printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, elements %d\n",
+					__func__, sg_len, *offset, sg_count);
 		return NULL;
 	}
 
-- 
2.34.1



