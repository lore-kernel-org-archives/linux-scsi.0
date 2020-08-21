Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E704DC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B848622BED
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598026862;
	bh=HLpcYm022fsWDy3FXUhFyjTS+Kk9jiUppDpx58YYbJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1rl7qdCktr5kc6OWQNyj7sjUCrzXubF0faOK8RXQCcWkCWZO7/KIXAEculwWVgTp1
	 pNm8VdgLUqrT6V6XltsADeWmOpB0gW+Y8ZIpUieap7KpgMfh+8gcXe10P99YFrExuC
	 5l6uMuMo0+IighesJX1Uc6/OK9UhSr9csXK1DceA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgHUQU4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 12:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbgHUQUd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA0022CF6;
        Fri, 21 Aug 2020 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026775;
        bh=HLpcYm022fsWDy3FXUhFyjTS+Kk9jiUppDpx58YYbJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFVX1FmcTe0yT4u3PIYEMiU0vuwGXARhfkxYdb+Uov483qEDQ8BlSlTt/br4HIASy
         1iAiL1bpeKjQgG7jCTJfHHupP6SrQ0tQgIiQCOUqDKtJ7OfB60yNm6fs8IeTbfzylA
         +vSow3aqp3MnI9HrSrq6rpIf9pR8E1X2xVo3ybn4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Shyam Sundar <ssundar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 29/30] scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()
Date:   Fri, 21 Aug 2020 12:18:56 -0400
Message-Id: <20200821161857.348955-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161857.348955-1-sashal@kernel.org>
References: <20200821161857.348955-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit e95b4789ff4380733006836d28e554dc296b2298 ]

In fcoe_sysfs_fcf_del(), we first deleted the fcf from the list and then
freed it if ctlr_dev was not NULL. This was causing a memory leak.

Free the fcf even if ctlr_dev is NULL.

Link: https://lore.kernel.org/r/20200729081824.30996-3-jhasan@marvell.com
Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Santosh Vernekar <svernekar@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index d95ba1a07ba3b..eaab59afd90c7 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -267,9 +267,9 @@ static void fcoe_sysfs_fcf_del(struct fcoe_fcf *new)
 		WARN_ON(!fcf_dev);
 		new->fcf_dev = NULL;
 		fcoe_fcf_device_delete(fcf_dev);
-		kfree(new);
 		mutex_unlock(&cdev->lock);
 	}
+	kfree(new);
 }
 
 /**
-- 
2.25.1

