Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBF9C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B296044F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhHQCGs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 22:06:48 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:60003 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbhHQCGr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 22:06:47 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2021 22:06:47 EDT
Received: from chmeee (unknown [10.95.69.61])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 9DC74400C86;
        Mon, 16 Aug 2021 18:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1629165443;
        bh=uS8gMWp1TJBbSp2Dv8uNLBFegHQ9jEJpiRR6A1tjrHo=;
        h=From:To:Cc:Subject:Date:From;
        b=GAjG3xZMUsXF0gAot0zKGFKDpQWenbzbuPJ/5QD8Fy/l0EKeCSYWss4emE+mkKy35
         VGBjSipsX9YYQuAFZ8z5INeWFVhxGN1GWdAWsH3KYanhR4w+y2zwMjqsUspgdvr6go
         eeY9q5NcKeU6Rt+r3g3+Ln6vWIPGmRLMgZjTkXAyrBH05rSKmRbW3jsPtKaOOhBJMh
         HCHdfCwOJXI2C7svmSFGC0k73f6/k+fQKfgXPhkZX2Dwx32mjmCvh8bC/MMFK9ZFku
         +Eo8b+Yc7SQHskTHOwgK8rcJYXenv2x/9DVTco9yADaks2yXBK6wGhQV5NjrR0fTjd
         WKvRSxMqdXatg==
Received: from kevmitch by chmeee with local (Exim 4.94.2)
        (envelope-from <kevmitch@chmeee>)
        id 1mFoLx-002AwD-NX; Mon, 16 Aug 2021 18:57:21 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kevin Mitchell <kevmitch@arista.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lkdtm: move SCSI_DISPATCH_CMD to scsi_queue_rq
Date:   Mon, 16 Aug 2021 18:57:18 -0700
Message-Id: <20210817015719.518648-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When scsi_dispatch_cmd was moved to scsi_lib.c and made static, some
compilers (i.e., at least gcc 8.4.0) decided to compile this
inline. This is a problem for lkdtm.ko, which needs to insert a kprobe
on this function for the SCSI_DISPATCH_CMD crashpoint.

Move this crashpoint one function up the call chain to
scsi_queue_rq. Though this is also a static function, it should never be
inlined because it is assigned as a structure entry. Therefore,
kprobe_register should always be able to find it. Since there is already
precedent for crashpoint names not exactly matching their probed
functions, keep the name of the crashpoint the same for backwards
compatibility.

Fixes: 82042a2cdb55 ("scsi: move scsi_dispatch_cmd to scsi_lib.c")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 drivers/misc/lkdtm/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 9dda87c6b54a..c3db17e90631 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -82,7 +82,7 @@ static struct crashpoint crashpoints[] = {
 	CRASHPOINT("FS_DEVRW",		 "ll_rw_block"),
 	CRASHPOINT("MEM_SWAPOUT",	 "shrink_inactive_list"),
 	CRASHPOINT("TIMERADD",		 "hrtimer_start"),
-	CRASHPOINT("SCSI_DISPATCH_CMD",	 "scsi_dispatch_cmd"),
+	CRASHPOINT("SCSI_DISPATCH_CMD",	 "scsi_queue_rq"),
 	CRASHPOINT("IDE_CORE_CP",	 "generic_ide_ioctl"),
 #endif
 };
-- 
2.32.0

