Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64C4C5518A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 03:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B64502075A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 03:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="YBfsf5zr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgDXD7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 23:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725922AbgDXD7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 23:59:25 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C60DC09B046
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 20:59:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x15so4171396pfa.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 20:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gSwadPZDs7z0NR+Wq1n49zqNXXT9ZEwk3RHF436fbNg=;
        b=YBfsf5zrinXBhhxkJe2FBGyeiG8aGdMfpXPDcTabiAV/Ub7VR+7D1YB1FdmDi2YZEn
         rE8Mb1FXa0TraFnXU/+I/Z1thtdkvsRWKAPLxQTHMiPFy02QAYwDRF1XfqTXR8XZB9DT
         OfyMgGqhKH8AfT4/HKNPEkoYQVz5gw4uvFi+hYjQWV8ijLyrc8KnO0OmwURjUcpCEuJD
         DIlciQz3olugUYTeC8SNv+c+i30txNXAb+hJQp3ldNaRdb4eu2jt4LAJpiYIzvpYMEbE
         jKjWKIP8f6lnUzr7+kQ1Nv2PT1rMxdhblg5KUQ4NVGq/Ii7ve0NmgC3aWFyDYTU6bX1/
         mUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gSwadPZDs7z0NR+Wq1n49zqNXXT9ZEwk3RHF436fbNg=;
        b=WDOfcMxrgwM3biYOSqtr6chBVSxk5mm7RMuJJsU64VNjdsB4OdwaP174Ugh7AfWZbl
         MYEb/CytSIDRJfYrOytqImYlYECQWyhGBvadfoOXhgkIO15BiY59hdK6dFKRVdgnQprG
         e+MlIB8oewzK/AELzf4xFYyZBJM1zs7+eEGygLzXNgy+5781M9wPO22iiOVRVTqLxqbP
         Ve4vWW/hzdlVQrGsJhTMF6Xz/Zj4JIjtoECQqK/pUhOxFFxBpiolOfal7ptuUFzlzRnE
         V3P/p+wAYd2RskpKADQ2PG2IYfUaywOzs5ltnXhfQJhlbR9+DSyGk4tCYOh9HAfYuqCS
         eJiA==
X-Gm-Message-State: AGi0PuZ+LPhvH84FexCJFGfJCKmbKMjhIXzssl3RSBNJB8gjSlp0Ilky
        /sbl8rRxAcgGuwfqffkXJrTtdQ==
X-Google-Smtp-Source: APiQypLrJpchRobxsJ+BHIFRvWHlvV/6Fp//6VzqyU3IlzGfRY9j/OKW8hU4O136v/0opyBsGZBeTQ==
X-Received: by 2002:aa7:843a:: with SMTP id q26mr7007116pfn.240.1587700764827;
        Thu, 23 Apr 2020 20:59:24 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id h14sm3624577pjc.46.2020.04.23.20.59.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 20:59:24 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Hou Pu <houpu@bytedance.com>
Subject: [PATCH v2 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Date:   Thu, 23 Apr 2020 23:58:43 -0400
Message-Id: <20200424035843.5914-3-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200424035843.5914-1-houpu@bytedance.com>
References: <20200424035843.5914-1-houpu@bytedance.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Following commit changed the return value of __iscsi_target_sk_check_close.
But the pr_debug is still printing FALSE when returing TRUE which is a little
confusing.

commit 25cdda95fda78d22d44157da15aa7ea34be3c804
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed May 24 21:47:09 2017 -0700

    iscsi-target: Fix initial login PDU asynchronous socket close OOPs

Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 5292b6c51b4e..2fee1946fb7a 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -481,7 +481,7 @@ static bool __iscsi_target_sk_check_close(struct sock *sk)
 {
 	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
 		pr_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
-			"returning FALSE\n");
+			"returning TRUE\n");
 		return true;
 	}
 	return false;
-- 
2.11.0

