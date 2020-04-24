Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A936CC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8811F20736
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="swaQC/Wd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgDXMgI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgDXMgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 08:36:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA3CC09B046
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 05:36:07 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so3822281pjh.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 05:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+9tUT7Sdxjs9d1FtuElo+1LtV4QfTZv6jD05EGpHmGw=;
        b=swaQC/WdzPeqWRdb41ozEYjD1QidtymToEBCKLqH1mBs6RR3A0HyAAvX8udA03D2qS
         YaP5ccB6stYsJEkqqbim5LpcMrRvnmH6HhfxVNkZinFFINvwLUTzaKiZJLleLYITCwCk
         CB2AmcFsFiXoUhSKTPRwK/9H/rW54JHMh5yoZJO8tmLtAq3WfxpZYnyezrkPyEH13NOt
         7Qvz/6YC5wI5CLPfsIcuUcHQBy0XMn4p3V12Xv5K+s4E77bZSzaGbhhKqkcVDIZF0XBY
         knB8r0xEwq7nEmyMy0TkXIYu6LG3GmCEDzqzIxGB4CivoP6HNgMmG6QPhZBONFSk37LL
         hhgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+9tUT7Sdxjs9d1FtuElo+1LtV4QfTZv6jD05EGpHmGw=;
        b=RB/bzGoNYKIExnOBZhh7tOQ8klwEBsrms5euf3H4H3PDkz1phkp7NL35oYFjoyhBu/
         jM2ZmLm7dqrSI6A9H+OdvvoSwP62slPcVyF8hgL3L3rrUfkPgumYgEhxCmmZMdIHAAVg
         lrI1o73iYpCu3UWRwIYI3SwQzn/ztO5biMPcUfGHl8t60pP3dagm3y3Yy1AvfCTXK9ii
         LGCj+0wluDmsxWlGK7+qWWLUoLXWqJ3J/o0bgQsnuVb5L63q/m/V6cAHP5f2P6VImXtu
         tETZ5J8lS5PJhZNyMmGr2vPD0As2djhsWIYRPlX+j+ca2m2uni9RoYKb6BecloFthr43
         PpzQ==
X-Gm-Message-State: AGi0PuaCrkeKB7npw9HjS2xTWhwFLvSaghX2s3bVZ8fds3Z0mjAHbARa
        FO5ZWiXqN5gErfNE4fq4DJslBA==
X-Google-Smtp-Source: APiQypL1qhUJKzjVLt4qhaft9oUKjShlxAtdFTiuLe7ZXjkd1A/AO90PuPsv0zXh2m1ZU2X8aVtKWQ==
X-Received: by 2002:a17:90a:9504:: with SMTP id t4mr5996468pjo.21.1587731766695;
        Fri, 24 Apr 2020 05:36:06 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id 128sm5510851pfy.5.2020.04.24.05.36.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 05:36:06 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Hou Pu <houpu@bytedance.com>
Subject: [PATCH v3 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Date:   Fri, 24 Apr 2020 08:35:28 -0400
Message-Id: <20200424123528.17627-3-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200424123528.17627-1-houpu@bytedance.com>
References: <20200424123528.17627-1-houpu@bytedance.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit 25cdda95fda7 ("iscsi-target: Fix initial login PDU
asynchronous socket close OOPs") changed the return value of
__iscsi_target_sk_check_close. But the pr_debug is still printing
FALSE when returning TRUE which is a little confusing.

Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 4cfa742e61df..7c36368e617d 100644
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

