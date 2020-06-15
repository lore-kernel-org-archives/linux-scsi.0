Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18037C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 22:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E399220768
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592261350;
	bh=xBGoroK2H8hqzN5/4X4Uahd06hiNRj+zCe3PMuFRh+M=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=T0+f5oMbvoUNCkDAqWXyiQTLtg60I3Tg1yLlownYULHu9PHcwVzhlfaSnG4VuRbuz
	 I8QUNa995abJhgdGRmwvd9vY93OW+ADDb4qj0b3paE5YiXXs+o61ZryJHsHTj+86BX
	 khIq6yzXHwbAmFbavGO5URZa5u+nE8RS4glaKVkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgFOWtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 18:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFOWtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jun 2020 18:49:10 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BA3D2074D;
        Mon, 15 Jun 2020 22:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592261349;
        bh=xBGoroK2H8hqzN5/4X4Uahd06hiNRj+zCe3PMuFRh+M=;
        h=Date:From:To:Cc:Subject:From;
        b=EdqLMWVVkfWhaDiXk9TWcjR84sGAV5boxxGLbuFkH8aRPLjY+KXkNilVvsF5Jb6Do
         qFdST2NcU9xr2MujM2LUeavJ825gXsq25ndV6yhw2UlpZyir2DucCuwN6TqDstLgcA
         SjOlTrrpFKcVS3AJmItqTWbVRAIVLO0lMRb/OZOQ=
Date:   Mon, 15 Jun 2020 17:54:28 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] scsi: fnic: Replace vmalloc() + memset() with
 vzalloc() and use array_size()
Message-ID: <20200615225428.GA14959@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use vzalloc() instead of the vmalloc() and memset. Also, use array_size()
instead of the open-coded version.

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/fnic/fnic_trace.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 9d52d83161ed..be266d1611bb 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -488,7 +488,7 @@ int fnic_trace_buf_init(void)
 	}
 
 	fnic_trace_entries.page_offset =
-		vmalloc(array_size(fnic_max_trace_entries,
+		vzalloc(array_size(fnic_max_trace_entries,
 				   sizeof(unsigned long)));
 	if (!fnic_trace_entries.page_offset) {
 		printk(KERN_ERR PFX "Failed to allocate memory for"
@@ -500,8 +500,6 @@ int fnic_trace_buf_init(void)
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_entries.page_offset, 0,
-		  (fnic_max_trace_entries * sizeof(unsigned long)));
 	fnic_trace_entries.wr_idx = fnic_trace_entries.rd_idx = 0;
 	fnic_buf_head = fnic_trace_buf_p;
 
@@ -559,10 +557,10 @@ int fnic_fc_trace_init(void)
 	int err = 0;
 	int i;
 
-	fc_trace_max_entries = (fnic_fc_trace_max_pages * PAGE_SIZE)/
+	fc_trace_max_entries = array_size(fnic_fc_trace_max_pages, PAGE_SIZE)/
 				FC_TRC_SIZE_BYTES;
 	fnic_fc_ctlr_trace_buf_p =
-		(unsigned long)vmalloc(array_size(PAGE_SIZE,
+		(unsigned long)vzalloc(array_size(PAGE_SIZE,
 						  fnic_fc_trace_max_pages));
 	if (!fnic_fc_ctlr_trace_buf_p) {
 		pr_err("fnic: Failed to allocate memory for "
@@ -571,12 +569,9 @@ int fnic_fc_trace_init(void)
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
 
-	memset((void *)fnic_fc_ctlr_trace_buf_p, 0,
-			fnic_fc_trace_max_pages * PAGE_SIZE);
-
 	/* Allocate memory for page offset */
 	fc_trace_entries.page_offset =
-		vmalloc(array_size(fc_trace_max_entries,
+		vzalloc(array_size(fc_trace_max_entries,
 				   sizeof(unsigned long)));
 	if (!fc_trace_entries.page_offset) {
 		pr_err("fnic:Failed to allocate memory for page_offset\n");
@@ -588,9 +583,6 @@ int fnic_fc_trace_init(void)
 		err = -ENOMEM;
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
-	memset((void *)fc_trace_entries.page_offset, 0,
-	       (fc_trace_max_entries * sizeof(unsigned long)));
-
 	fc_trace_entries.rd_idx = fc_trace_entries.wr_idx = 0;
 	fc_trace_buf_head = fnic_fc_ctlr_trace_buf_p;
 
-- 
2.27.0

