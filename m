From: taco <tacoee@gmail.com>
Subject: [PATCH 1/1]cciss: Fix free issue
Date: Sun, 28 Aug 2011 21:54:30 +0800
Message-ID: <20110828135427.GA10740@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62949 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1H1Nyl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 09:54:41 -0400
Received: by pzk37 with SMTP id 37so6945857pzk.1
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 06:54:40 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We just need to free j not nr_cmds if kmalloc for cmd_sg_list failed.


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..7b729ca 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -321,7 +321,7 @@ static SGDescriptor_struct **cciss_allocate_sg_chain_blocks(
 	}
 	return cmd_sg_list;
 clean:
-	cciss_free_sg_chain_blocks(cmd_sg_list, nr_cmds);
+	cciss_free_sg_chain_blocks(cmd_sg_list, j);
 	return NULL;
 }
 
