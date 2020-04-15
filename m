Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7228C2BB85
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C222051A
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="hll2Bosa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635633AbgDOIIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635632AbgDOIIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2020 04:08:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E30C0610D5
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 01:08:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y12so982603pll.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 01:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yYNKGc07OYBmETnhmBnne+7qYMfErRLdStvSK9DZOKU=;
        b=hll2BosaDpQ2YBILUSls0SxNhUPedGmg+z2GUiazXTZEVBjrCKFc349OXg1zamniDP
         6gcyaWW2eKk63cCC6WIPTsJRIagWWhB1grz4erRGUhVTd3ykcTtfLxTZPfJaFlHm0Vo+
         2WoPyQZGd6aGn0nPHJi3UQV9QdqQ5Tht/hFPuQnuEKSx2VNbYAq8VOyrmCbKA74CLWtX
         a3mcOZbTkvC+7ipVyj0rated/TjFY2E9JWUt3879F4zyzek0mniOEivJO2pg/KKyucv8
         T8CG0Fyj8yISf+SPGk+XlKxRxMpOFFZmR81Pl6Avl+7zPNK/CIrfufAH/a9AreMqqfIC
         F2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yYNKGc07OYBmETnhmBnne+7qYMfErRLdStvSK9DZOKU=;
        b=YnKoe7cc+DMPyeeqWBDJ0rPrTFfE+ZfuEfhVqd0jAqeSfcCk7x6g4iU1CxHrsbop0B
         AloOUZOb5bqIOvjhMTu0WGpXF1QETAmhZNeRWiXt5R+Fy3Ekcw+VjFxWMF0cbyNBueSj
         BwBYqia1E/9dcBcpbT/usqZbsovr3MRDXcHNdGW/9gjzKfLpN7Mjmom2uJxUwPUuaYCs
         3MjPIbYcq2Vf2W8Lxe8utjjDTph8sB5UtY3/+aNSSogmEq+KbUbnRjPKSMybtP7Igp4M
         NdZIq7/nCMDltKpZWSA4eRZpml/CgiJWmkiz/lazNYpdDf0PzynBXxMckdcH2a/4un9+
         OETQ==
X-Gm-Message-State: AGi0PuYIDWkbnZRTn85IsI9zmDEKi+Nch9lfFKvYW0e0OkTRD8w8zHkU
        hD6ON2YKcxUdOGCtqhyLo0cq7w==
X-Google-Smtp-Source: APiQypIqWjVIHBTvcz+GZPt0ZG5iTVoEaLnDbeH0s39YM2GseBFUs9fjRg1OoJ0bqqmuQCJZ0bUAyA==
X-Received: by 2002:a17:90a:bf84:: with SMTP id d4mr4908421pjs.82.1586938123963;
        Wed, 15 Apr 2020 01:08:43 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id c10sm10020576pfc.23.2020.04.15.01.08.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 01:08:43 -0700 (PDT)
From:   Pu Hou <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Pu Hou <houpu@bytedance.com>
Subject: [PATCH 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Date:   Wed, 15 Apr 2020 04:08:19 -0400
Message-Id: <20200415080819.27327-3-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200415080819.27327-1-houpu@bytedance.com>
References: <20200415080819.27327-1-houpu@bytedance.com>
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

Signed-off-by: Pu Hou <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 950339655778..56686e880d23 100644
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

