Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF51C3B1A4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 16:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F00E246A1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698006;
	bh=BAiSBRFdJMN3ZHL/w78o+PZyV1AC1701XX/Z2jnkgC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vHsR2Tkod57RwST5eTxneLOvsmNKi4Axa9fVgv7gnloeoHnVOPX4Ae03FhYjqqZ6P
	 d8Xd1ck0CQcYE5leNWJVLHVTNRXa7u7tlZEKmqhckooiB6CGAh79KdwyZj+kxlq6BK
	 9JaiMOZva2yVwIJDyHHzm9WzrcWD8juEe2+MjnVQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406108AbgBNQZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406105AbgBNQZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B352A247C7;
        Fri, 14 Feb 2020 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697527;
        bh=BAiSBRFdJMN3ZHL/w78o+PZyV1AC1701XX/Z2jnkgC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0cOuoKt9lDB9xnxgalnqKdlCAcMVDclk/l+QuNu0EnN97591qkdpTXj1c3Dh+3pr
         t/xe+GamU0SS24ZSLyVdgtkXAaIdIk1sW94WOm2rtk7cS7487RvBqDcpXh7rPQpYhC
         5MOBOnSFejiLy3MtFyUROajMQ6rphdZWRjHFf/O8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.4 050/100] scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
Date:   Fri, 14 Feb 2020 11:23:34 -0500
Message-Id: <20200214162425.21071-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 4dbc96ad65c45cdd4e895ed7ae4c151b780790c5 ]

Clang warns:

../drivers/scsi/aic7xxx/aic7xxx_core.c:2317:5: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
                        if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
                        ^
../drivers/scsi/aic7xxx/aic7xxx_core.c:2310:4: note: previous statement
is here
                        if (syncrate == &ahc_syncrates[maxsync])
                        ^
1 warning generated.

This warning occurs because there is a space amongst the tabs on this
line. Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

This has been a problem since the beginning of git history hence no fixes
tag.

Link: https://github.com/ClangBuiltLinux/linux/issues/817
Link: https://lore.kernel.org/r/20191218014220.52746-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 64ab9eaec428c..def3208dd2905 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2321,7 +2321,7 @@ ahc_find_syncrate(struct ahc_softc *ahc, u_int *period,
 			 * At some speeds, we only support
 			 * ST transfers.
 			 */
-		 	if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
+			if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
 				*ppr_options &= ~MSG_EXT_PPR_DT_REQ;
 			break;
 		}
-- 
2.20.1

