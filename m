Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA859C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 09:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEEF860EB2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhITJ6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 05:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhITJ57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 05:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78ABD60F9D;
        Mon, 20 Sep 2021 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632131793;
        bh=/JPK7Aa+16V2XfmQjabOyz7J9/sDWLciDQDg3Rabzw8=;
        h=From:To:Cc:Subject:Date:From;
        b=qd1DbWTkZetXA19rFyBSAErgu9uP23Hz56h5qq07iAYfhxzhWsEN8yd/CUQNjzQV1
         LQ/b3j+FVIDDVb6YeiKJNyFWvGxrV7TlQ9ClmuhHmjckK/DF2R4zoGAMUtel2WkQxs
         AyDmsEkMIdQXmXpGsHiNmfBqeeGEwx60yBLqKNWsAdAojANXCdN5tnY+Fpvu7I/Opj
         u6nUc6pxl3yBHnJZ62lVFWmgtMxVwNhl5QCEaTIabj4IT3sUyLUh12T8DgFW2QP9eU
         aHcH3b/YxPjyD5UNqcB3gOvFTvfb+KN5ZYHZHJFE0W0ifuQ4A1arbFUFRhYqUyjjRh
         NzVYa/wMtwwvg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Justin Tee <justin.tee@broadcom.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix gcc -Wstringop-overread warning, again
Date:   Mon, 20 Sep 2021 11:56:22 +0200
Message-Id: <20210920095628.1191676-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

I fixed a stringop-overread warning earlier this year, now a
second copy of the original code was added and the warning came
back:

drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_cmf_info_show':
drivers/scsi/lpfc/lpfc_attr.c:289:25: error: 'strnlen' specified bound 4095 exceeds source size 24 [-Werror=stringop-overread]
  289 |                         strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1),
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it the same way as the other copy.

Fixes: ada48ba70f6b ("scsi: lpfc: Fix gcc -Wstringop-overread warning")
Fixes: 74a7baa2a3ee ("scsi: lpfc: Add cmf_info sysfs entry")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b35bf70a8c0d..ca0433e28ac3 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -285,11 +285,8 @@ lpfc_cmf_info_show(struct device *dev, struct device_attribute *attr,
 				"6312 Catching potential buffer "
 				"overflow > PAGE_SIZE = %lu bytes\n",
 				PAGE_SIZE);
-		strscpy(buf + PAGE_SIZE - 1 -
-			strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1),
-			LPFC_INFO_MORE_STR,
-			strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1)
-			+ 1);
+		strscpy(buf + PAGE_SIZE - 1 - sizeof(LPFC_INFO_MORE_STR),
+			LPFC_INFO_MORE_STR, sizeof(LPFC_INFO_MORE_STR) + 1);
 	}
 	return len;
 }
-- 
2.29.2

