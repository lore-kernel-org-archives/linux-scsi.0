Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C405C47247
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 14:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 513292073A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588862128;
	bh=AbF2uNFJWRWl/L5czMYiTGS/1WgEFm5qePayN96IG0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k+9eppis7HSgwcF62k5V6WRq2oigkIB2WKJkGmiWN2HRgWNvheZLGJbPy2a//0/L7
	 XOJ+fG2SQdyymUov0cWkUKhfnuOoMMk+H3bVc6hrrIhojk67+bkNp9HCbP4fNiJ+d9
	 yJFJ15BDvBm1C2rzSspRMsPr3shbxFrwJJ0lOvPQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgEGO2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 10:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbgEGO2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 10:28:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB7820870;
        Thu,  7 May 2020 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861721;
        bh=AbF2uNFJWRWl/L5czMYiTGS/1WgEFm5qePayN96IG0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NPkos4l10kNgO7io05XDPcA/MbZEQHUpao6/yVyNlc6WzLDozpMNutdC6vA1cjf0
         qmc1EesX0YyjV/IGXWAxTK48btIX17XDK8d0vkns7hFdM4KohXErxPAIvL80mf409a
         bIRQUVKM6srWG8fZGJAZ3hH7PRXiUG+k80Q7zzps=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/35] scsi: target/iblock: fix WRITE SAME zeroing
Date:   Thu,  7 May 2020 10:28:02 -0400
Message-Id: <20200507142830.26239-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 1d2ff149b263c9325875726a7804a0c75ef7112e ]

SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
"shall perform the specified write operation to each LBA specified by the
command".  Commit 2237498f0b5c ("target/iblock: Convert WRITE_SAME to
blkdev_issue_zeroout") modified the iblock backend to call
blkdev_issue_zeroout() when handling WRITE SAME requests with UNMAP=0 and a
zero data segment.

The iblock blkdev_issue_zeroout() call incorrectly provides a flags
parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP.  The bool
false parameter reflects the blkdev_issue_zeroout() API prior to commit
ee472d835c26 ("block: add a flags argument to (__)blkdev_issue_zeroout")
which was merged shortly before 2237498f0b5c.

Link: https://lore.kernel.org/r/20200419163109.11689-1-ddiss@suse.de
Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 51ffd5c002dee..1c181d31f4c87 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -432,7 +432,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 				target_to_linux_sector(dev, cmd->t_task_lba),
 				target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd)),
-				GFP_KERNEL, false);
+				GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-- 
2.20.1

