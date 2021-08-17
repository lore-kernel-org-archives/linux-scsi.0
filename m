Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEC6C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 23:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB6E61038
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 23:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhHQX4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236831AbhHQX4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 19:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E3B61026;
        Tue, 17 Aug 2021 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244540;
        bh=1tXm1ZK5eBuqFdwalK+JaYUMeBrtRzBzZQUvOp4atGs=;
        h=From:To:Cc:Subject:Date:From;
        b=Ga+ag2Png9FbqmvQdyueg11z+BncKy0TBP0Leb8uBg2dgVibDy7Jg/lPnht3nM7hq
         reIZHdd97CyKrkrsHTnogsNItJ3/P4L50TnLdtU4xH9A59y+9dN/3sqV4wPl9+H8FU
         xjvWc4wTtbGoV2iuw+KfO9ndBmGA7a+Hrfdcv2NM5g9owwoyeJuluwbz9aH7hRydh/
         hKyh/dPkaZI5B+lm2LX+cPvs9a0kBUB0gNpJ6mLV8FEPm4ixQmM75MDif3Qy1BFVrT
         LSlBOcVRRZ02eh3qW5Ulp/UKCeT5RZNW7epedJTuvJQVdKq9kYZONBHFeOmW3H2rXs
         nVKO+5OXUPd7A==
From:   Nathan Chancellor <nathan@kernel.org>
To:     =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] scsi: st: Add missing break in switch statement in st_ioctl()
Date:   Tue, 17 Aug 2021 16:55:31 -0700
Message-Id: <20210817235531.172995-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang + -Wimplicit-fallthrough warns:

drivers/scsi/st.c:3831:2: warning: unannotated fall-through between
switch labels [-Wimplicit-fallthrough]
        default:
        ^
drivers/scsi/st.c:3831:2: note: insert 'break;' to avoid fall-through
        default:
        ^
        break;
1 warning generated.

Clang's -Wimplicit-fallthrough is a little bit more pedantic than GCC's,
requiring every case block to end in break, return, or fallthrough,
rather than allowing implicit fallthroughs to cases that just contain
break or return. Add a break so that there is no more warning, as has
been done all over the tree already.

Fixes: 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from scsi_ioctl()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 2d1b0594af69..0e36a36ed24d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3828,6 +3828,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	case CDROM_SEND_PACKET:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		break;
 	default:
 		break;
 	}

base-commit: 58dd8f6e1cf8c47e81fbec9f47099772ab75278b
-- 
2.33.0

