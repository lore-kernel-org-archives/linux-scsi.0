Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB55CEB64D8
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 14:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbjFMOpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 10:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbjFMOos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 10:44:48 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AADE53
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 07:44:47 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1a49716e9c5so3526609fac.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 07:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686667486; x=1689259486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YiotN2TYc5ASeDG9/xvddzyFz+t+WcNisridwLRrRig=;
        b=BPZTP5l7acHHn6UZD9Lnbkl+zDHq9l0buNc2VtbTdTlsOnxrNgk2nBvBF+i2OTuMYy
         kRTuLV0Vijo2YREI45kus+KIWlxjxoTpDIJRsBNhagc8TcTX3Q5wAsnAGiciR/QJGv69
         Q3a7gvckTqHNwL4Brd8ulzx9zYUae5cWVjwAbKNSTOPaADI2d8kegx0bcqyJICxlK18d
         wCe6xHoUrywqbhGP+fUXTpPVjJlUWSwKTIfydL50JGPKv6V4vK9vzhzHNIOOvciEv1NQ
         4FGWYgR8plkPBKDNJQ/KJyaVqFQc+oS3AglJJxofb+cT0SEraO5mQGVtAQ/NQgSuedp2
         xx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667486; x=1689259486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YiotN2TYc5ASeDG9/xvddzyFz+t+WcNisridwLRrRig=;
        b=P+DMxEbGW3P6jfB6drOOLgcVdD0W45egKU9x92/Xe/1uEdiOkH0LtLcFQyXbzWWXmw
         dEc5cDUXaCMVSZw3GbczMMzeNrSKGoSodm0vDSh8SsUSGWw0Y9FXfcEPJPVA3uqqi6+p
         HpFz0q4GE9apJEl/gqFWrRll8yNIflAh0iiN8VnFEpkz33wzvtXdTqSkktVO93H8I4aU
         0PW9VqvXMo5DaPnpFH5ptsnVg/+nAXGb0Igh6QYg+ULIEI8ZHkytr1J48sYtP8AAHPTt
         uYVvK7YevZmcP6t3LsuqjGgsArvXOb3YN7DTznaxMIdQHabriS3NTozZnAsXd9gNAej1
         buNQ==
X-Gm-Message-State: AC+VfDwYubhp3gX98vDRqyj/20QzMc68p27YVU8wmLdA3Yjporv54tSO
        r/ssodlg/6Dcvn7R/6AZ4tjx2onXAQc=
X-Google-Smtp-Source: ACHHUZ4knKAdI1INwAzZR66qpqNnhELD0QI8M1RHsJOb+EXMy6K/UGzj5y9GEJl6R1NInoYzF+m/lA==
X-Received: by 2002:a05:6870:9545:b0:17a:c612:ae0d with SMTP id v5-20020a056870954500b0017ac612ae0dmr7882557oal.49.1686667486164;
        Tue, 13 Jun 2023 07:44:46 -0700 (PDT)
Received: from rpearson-X570-AORUS-PRO-WIFI.tx.rr.com (2603-8081-140c-1a00-b626-4062-16bc-09b1.res6.spectrum.com. [2603:8081:140c:1a00:b626:4062:16bc:9b1])
        by smtp.gmail.com with ESMTPSA id e4-20020a9d5604000000b006ab241d8c42sm4856709oti.17.2023.06.13.07.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:44:45 -0700 (PDT)
From:   Bob Pearson <rpearsonhpe@gmail.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        michael.christie@oracle.com
Cc:     Bob Pearson <rpearsonhpe@gmail.com>
Subject: [PATCH] drivers: target: Fix error path in target_setup_session
Date:   Tue, 13 Jun 2023 09:43:00 -0500
Message-Id: <20230613144259.12890-1-rpearsonhpe@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the error exits in target_setup_session, if a branch is taken
to free_sess: transport_free_session may call to target_free_cmd_counter
and then fall through to call target_free_cmd_counter a second time.
This can, and does, sometimes cause seg faults since the data field
in cmd_cnt->refcnt has been freed in the first call. This patch
fixes this problem by simply returning after the call to
transport_free_session. The second call is redundant for those
cases.

Fixes: 4edba7e4a8f3 ("scsi: target: Move cmd counter allocation")
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
---
 drivers/target/target_core_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86adff2a86ed..687adc9e086c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -504,6 +504,8 @@ target_setup_session(struct se_portal_group *tpg,
 
 free_sess:
 	transport_free_session(sess);
+	return ERR_PTR(rc);
+
 free_cnt:
 	target_free_cmd_counter(cmd_cnt);
 	return ERR_PTR(rc);
-- 
2.39.2

