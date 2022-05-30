Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08479C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 13:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbiE3NsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 09:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239013AbiE3NqM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 09:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0375A308B;
        Mon, 30 May 2022 06:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 423DA60F49;
        Mon, 30 May 2022 13:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C20C341C0;
        Mon, 30 May 2022 13:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917629;
        bh=djSQlG+ixpoetmhf74mZRZXaD88al5b7zrERb5ILAOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYesmVkIwTf72DhluKByVBB893x9uuUfRD9vspv13BG/S8h3dftY39GoJU0DCbOXf
         6d8zPvR4Ey8X8JJl6zT3BQoNrfwk1IR5GDvNILFvkiNW1OkuFRVFLVqFHnynLvzo8B
         zHQYKnmh+SGOlAB8NpBE6ehsUjGHeBOvauc1tjmj7sG7+gfqD02UQBja7dyz6kwYdc
         yedAfKuxoLTgFpeLycs5ypsiSCbi4PdXvs6TDD7Mt/iuh4bc6THwuB24/TbvIlWjXK
         t+ZiQrElFKr1e4oxYFiAGO4pi4bva0CiZgsff5YO1+Ux1dirO+/9umbis97N1kLi0p
         7upo/jnU334IQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 048/135] scsi: megaraid: Fix error check return value of register_chrdev()
Date:   Mon, 30 May 2022 09:30:06 -0400
Message-Id: <20220530133133.1931716-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit c5acd61dbb32b6bda0f3a354108f2b8dcb788985 ]

If major equals 0, register_chrdev() returns an error code when it fails.
This function dynamically allocates a major and returns its number on
success, so we should use "< 0" to check it instead of "!".

Link: https://lore.kernel.org/r/20220418105755.2558828-1-lv.ruyi@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index bf987f3a7f3f..840175f34d1a 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4608,7 +4608,7 @@ static int __init megaraid_init(void)
 	 * major number allocation.
 	 */
 	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
-	if (!major) {
+	if (major < 0) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char device\n");
 	}
-- 
2.35.1

