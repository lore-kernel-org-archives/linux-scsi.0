Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BDEC433E3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05313206DA
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598028389;
	bh=xAEgqohY3FdYqYTTjlQYaSeUB4UNZYS7CDwMTrmHEbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1Zns9VUVMPG18Xexj9VqjWDx1uNHDOjeGwN85xiI07KwCuFD/kIpoizv7TwpyW4t5
	 0L6jhINyvGuq5QNe0eE/6obnkBaiqmAw16Fhld/oYWr0cCx/y4g1ab+Pg40TjKO2qX
	 wPR6lFNUtk0nY0l1p8Ucb9XXR/4YqUhdomknzji0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgHUQoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 12:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgHUQUm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83EA522C9F;
        Fri, 21 Aug 2020 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026785;
        bh=xAEgqohY3FdYqYTTjlQYaSeUB4UNZYS7CDwMTrmHEbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1IOW4UDl3/BZLHx/LW0xHuRy4jPBUf4ccUcTrTVyIELHPxQQt8zRSUuTZftzQX3m
         EruUj79ItnxG4mrN2ePGYGb0gfuNDuksTX0Pk5Rq+etODDYgUQRGT8friaG5YBaYvc
         njDsI/pERmIMvW4kd9RhVQq7kNF2YF56OXV8H2eM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        JiangYu <lnsyyj@hotmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/26] scsi: target: tcmu: Fix crash on ARM during cmd completion
Date:   Fri, 21 Aug 2020 12:19:16 -0400
Message-Id: <20200821161938.349246-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161938.349246-1-sashal@kernel.org>
References: <20200821161938.349246-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 5a0c256d96f020e4771f6fd5524b80f89a2d3132 ]

If tcmu_handle_completions() has to process a padding shorter than
sizeof(struct tcmu_cmd_entry), the current call to
tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as length
param is wrong and causes crashes on e.g. ARM, because
tcmu_flush_dcache_range() in this case calls
flush_dcache_page(vmalloc_to_page(start)); with start being an invalid
address above the end of the vmalloc'ed area.

The fix is to use the minimum of remaining ring space and sizeof(struct
tcmu_cmd_entry) as the length param.

The patch was tested on kernel 4.19.118.

See https://bugzilla.kernel.org/show_bug.cgi?id=208045#c10

Link: https://lore.kernel.org/r/20200629093756.8947-1-bstroesser@ts.fujitsu.com
Tested-by: JiangYu <lnsyyj@hotmail.com>
Acked-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1a83456a65a00..693fbb2858404 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -666,7 +666,14 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
 		struct tcmu_cmd *cmd;
 
-		tcmu_flush_dcache_range(entry, sizeof(*entry));
+		/*
+		 * Flush max. up to end of cmd ring since current entry might
+		 * be a padding that is shorter than sizeof(*entry)
+		 */
+		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
+					       udev->cmdr_size);
+		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
+					ring_left : sizeof(*entry));
 
 		if (tcmu_hdr_get_op(entry->hdr.len_op) == TCMU_OP_PAD) {
 			UPDATE_HEAD(udev->cmdr_last_cleaned,
-- 
2.25.1

