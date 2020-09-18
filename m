Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08190C43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F5F23977
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600394913;
	bh=0PFevT8Ecj189Ns/LRiQZ0G7i1mRuO/gYaYyhY09J34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VMG1Mp8CjrBBafwFMhB2RCz60zrFlDvLwvb1AsUM5yV1hV/AtnUfr7LJg7QDORF1j
	 9kaGFpBvom/4fQgO+ryX2N7aw8G2nHIt6c8j13EFWAgtC+0/F3/UDaBtpQqJRrsWJw
	 Dodf47xmUd2QqwVWpWbKCUuLj5URegDB7x0NTVRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIRCId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgIRCIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A773E2395A;
        Fri, 18 Sep 2020 02:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394901;
        bh=0PFevT8Ecj189Ns/LRiQZ0G7i1mRuO/gYaYyhY09J34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2LOwuXT7uk8QSmFbGUj/ItixkTr4oca/JWe2T6RWG/T0bI2dMSGSqaDeeUWTSs4/
         yOF/DNc6JmKPaCMAiTup+2DY4TQYi9A7/S/defBYep7UOKEbSTRcWYknvXM9e4cIs2
         mEePzIv3eBVMZN99CtgOfVWvxp3NhvZO7JcVw3+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Satish Kharat <satishkh@cisco.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 015/206] scsi: fnic: fix use after free
Date:   Thu, 17 Sep 2020 22:04:51 -0400
Message-Id: <20200918020802.2065198-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ec990306f77fd4c58c3b27cc3b3c53032d6e6670 ]

The memory chunk io_req is released by mempool_free. Accessing
io_req->start_time will result in a use after free bug. The variable
start_time is a backup of the timestamp. So, use start_time here to
avoid use after free.

Link: https://lore.kernel.org/r/1572881182-37664-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 73ffc16ec0225..b521fc7650cb9 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1034,7 +1034,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 
-	io_duration_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+	io_duration_time = jiffies_to_msecs(jiffies) -
+						jiffies_to_msecs(start_time);
 
 	if(io_duration_time <= 10)
 		atomic64_inc(&fnic_stats->io_stats.io_btw_0_to_10_msec);
-- 
2.25.1

