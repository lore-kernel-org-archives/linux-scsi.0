From: Tomer Barletz <barletz@gmail.com>
Subject: [PATCH] scsi/be2iscsi: Fix logical-not-parentheses compilation warning
Date: Tue,  4 Aug 2015 11:25:43 -0700
Message-ID: <1438712743-5821-1-git-send-email-barletz@gmail.com>
References: <mqdy4hrts7e.fsf@c203.arch.suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34105 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbbHDS0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:26:03 -0400
In-Reply-To: <mqdy4hrts7e.fsf@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomer Barletz <barletz@gmail.com>

This fixes the following warning seen with GCC v5.1:
warning: logical not is only applied to the left hand side of
comparison [-Wlogical-not-parentheses].

Signed-off-by: Tomer Barletz <barletz@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..cf1908e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
 {
 	WARN_ON(!virtual_address);
 	WARN_ON(!physical_address);
-	WARN_ON(!length > 0);
+	WARN_ON(length == 0);
 	WARN_ON(!sgl);
 
 	sgl->va = virtual_address;
-- 
2.4.3

