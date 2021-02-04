Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D3FC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 16:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E31464F53
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 16:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbhBDQjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 11:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238087AbhBDQbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Feb 2021 11:31:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A6E64F42;
        Thu,  4 Feb 2021 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612456225;
        bh=CzTEpM9u8CI5p3juLfoehGkHvp3K66pt2EkozHWzGDg=;
        h=From:To:Cc:Subject:Date:From;
        b=SGPgNrPK6w9SYhailX+Myofm8zqDZypXNuD/ZTl8DQ60fMj9rLjJ1uHrtFYl0wAiD
         DcamnU0Y2XEhwTAKkT/fAzmU3y+l8/peZ1wMY8pLk2bz0l/T1eA7dqm4DHbteJZK6F
         3DDpqluvT7t4E0XK3nXLaIH1X0SKyKNLBJYo+DsywNdPSZfa2HV7FPmOZAXa+Ifhkd
         j9RKC+pqVollzFmEOUXFctg4+jlqcDEC88l2yq3KLUzmkyc8RIxhj3xw32rF32uKuN
         ErfmDH4yktP1UnzzwSu6/Di+zrW/k3bYDOjC4SxpGHa/yTxWDx4PAlJd2PI0AwCXxs
         DaV2OnBBggOMw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Satish Kharat <satishkh@cisco.com>,
        Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pmcraid: fix 'ioarcb' alignment warning
Date:   Thu,  4 Feb 2021 17:30:14 +0100
Message-Id: <20210204163020.3286210-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building with 'make W=1' enables -Wpacked-not-aligned, and this
warns about pmcraid because of incompatible alignment constraints for
pmcraid_passthrough_ioctl_buffer:

drivers/scsi/pmcraid.h:1044:1: warning: alignment 1 of 'struct pmcraid_passthrough_ioctl_buffer' is less than 32 [-Wpacked-not-aligned]
 1044 | } __attribute__ ((packed));
      | ^
drivers/scsi/pmcraid.h:1041:24: warning: 'ioarcb' offset 16 in 'struct pmcraid_passthrough_ioctl_buffer' isn't aligned to 32 [-Wpacked-not-aligned]
 1041 |  struct pmcraid_ioarcb ioarcb;

The inner structure is documented as having 32 byte alignment here,
but is starts at a 16 byte offset in the outer structure, so it's never
actually aligned, as the outer structure is also marked 'packed'.

Lee Jones point this out as one of the last files that need to be changed
before the warning can be enabled by default.

Change the annotations in a way that avoids the warning but leaves the
layout unchanged, by removing the packing on the inner structure and
adding it to the outer one. The one-byte request_buffer[] array should
have been a flexible array member here, which is how I change it to
avoid extra padding from the alignment attribute.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pmcraid.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 15c962108075..6d36debde18e 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -244,7 +244,7 @@ struct pmcraid_ioarcb {
 	__u8  hrrq_id;
 	__u8  cdb[PMCRAID_MAX_CDB_LEN];
 	struct pmcraid_ioarcb_add_data add_data;
-} __attribute__((packed, aligned(PMCRAID_IOARCB_ALIGNMENT)));
+};
 
 /* well known resource handle values */
 #define PMCRAID_IOA_RES_HANDLE        0xffffffff
@@ -1040,8 +1040,8 @@ struct pmcraid_passthrough_ioctl_buffer {
 	struct pmcraid_ioctl_header ioctl_header;
 	struct pmcraid_ioarcb ioarcb;
 	struct pmcraid_ioasa  ioasa;
-	u8  request_buffer[1];
-} __attribute__ ((packed));
+	u8  request_buffer[];
+} __attribute__ ((packed, aligned(PMCRAID_IOARCB_ALIGNMENT)));
 
 /*
  * keys to differentiate between driver handled IOCTLs and passthrough
-- 
2.29.2

