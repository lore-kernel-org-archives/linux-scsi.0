Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B3FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 10:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1082D2081A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 10:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="LLgdBMQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGPKDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgGPKDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 06:03:17 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFD2C061755
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 03:03:16 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k27so4608267pgm.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 03:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wCm6g8PFrAG/ekXZHVoEYGMTgypsF/q64n/9gor/F3E=;
        b=LLgdBMQyAhNYTnpWigaSMpydcREs4d8c4U0eDCKJ8X+mjBnhzN0q2zVyx4YEVb5wtU
         IgmIVL6wRWiwIdQTVmQipxJK2d6SubI6RGxX1IKMCLrNJmjpRELqFfuBd+nKLb6bweSp
         bklBPVC8P0qfmySgq8gSnANR7dEktyMxLFo4khg7CJxU6286saIfTew02ANDUOGyOLqu
         oeevooUJHyVzAGcJmTV8g6uJZ2Qi8A05Yy7wqjjyfPwh2tZApzwk19MRpXcH+LRD7lQH
         /Z6mjraTM/5KRVeh5vSyKAU+2LuwZocpJWjfjz8j1wPNfoF1vGwrU/Xi7Be3pv8Q+cva
         Iunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wCm6g8PFrAG/ekXZHVoEYGMTgypsF/q64n/9gor/F3E=;
        b=nKWgbX3ag4tyhWh9sz/puWhSV8WHTe7kq3/ds8qAylafMmTrEW3Esz2zu3sao9sZDu
         mzVjBAUS7avXxeL8rtW4opcHC9vJQpeLc98uRoyymcK0XIwFjFX8UDQ082ID/modLbq8
         E4HGZp6FDS8s6JSB0yoYR44X9yNf5B/u58xbjr1tJNzya1JhO2MI+/ytbLIiAMe8IIMn
         yWosgFVaAs1RW6wn9WjSdzmD9fs1X3nQ3BtMvmLziSpS7+TScVykGeXOkqA8QciaGL8r
         WCSBjaZbZGohTCC+zeBtMNlCwbJusHQhSDBtFS09OveCxMgcjwLOZyTJ/XPorYPAWMCR
         +4yw==
X-Gm-Message-State: AOAM533CAJBtDhykVJ+iWxBCjpkT9Lt4Gj9Arbs70iYDqQubZDVjc5Lt
        vDdwupjt8oDG/zmAAwCYMriRcfOrf7Y=
X-Google-Smtp-Source: ABdhPJwNrDgUO7VlNAjZ8Fo6AQngwNwXisibH9GXT9GMvN4cprhyzv7vwb7cxiTZ8B256OaU3jnMag==
X-Received: by 2002:a62:8183:: with SMTP id t125mr3019763pfd.210.1594893796570;
        Thu, 16 Jul 2020 03:03:16 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id f29sm4602477pga.59.2020.07.16.03.03.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 03:03:16 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Hou Pu <houpu@bytedance.com>
Subject: [PATCH v4 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Date:   Thu, 16 Jul 2020 06:02:12 -0400
Message-Id: <20200716100212.4237-3-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200716100212.4237-1-houpu@bytedance.com>
References: <20200716100212.4237-1-houpu@bytedance.com>
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
index 10477e44d17b..701c008d6bd5 100644
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

