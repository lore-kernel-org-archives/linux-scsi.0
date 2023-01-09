Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B668C5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbjAIXXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237836AbjAIXW6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:58 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A7AA476
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so181664pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsYUTZKmVQD83NnPKk/jgZWiXyc8A+S9jJmsa33k7dA=;
        b=QKZvqq9RdE4OP7aEpp9OtXzVeZ2ckHhre9cksbfDuF/0IJpixLZOcF2dvFRqMX26Kw
         X8TVrhwSkJB5IVixzVvLlYtEzd8G2kg2rSNU3XyGV3Do0nUAK+T9SM7UIMHZJchUBwXz
         P11blNCQm0lkv8TLQT/7TAGCkTrtx3k9tq/+vR7r3cG6AjvNOx8WLJsLRcEaYNk0jggu
         x/NQdoMczwcuR+6AV6AxDu1tgLgGfI1EeyMPDEoAOeopULDjKmEUh0QGGliOyXykaa5Q
         xrPXAGitVWcEhQS07tU/eYMgtZToD5tWscektWZAOaW1r4EE0NKKXNrSB2Jg9zwyAnHv
         25Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HsYUTZKmVQD83NnPKk/jgZWiXyc8A+S9jJmsa33k7dA=;
        b=t6NBCRG+s9tcZctIaaJYvhf8pGps01PhVVwb/f0BvKh3BPXoeIWyj8AtmjRa3cSAd4
         hdRj/YlcBka11mgGe90sKj6EHQBevADZimN6m8jlCuafuWR3CyY8K/wOJ+/c1kY7DhjQ
         R1W3HD3h6Vy+DGnL0i3CLCKeUHwOUUxYSEUeCXuE3C6guJ5g4SBWf1BexBjv6VzcNFUm
         qvcFjJS3z7gqe/CR2zpmBkqdBWd8DaN6eX4wpbij1BFqLCwB23aB2IOdsg7YYkdlzB0t
         8FgDPNiboRQQTKf+MFAVZa/xcEW6o6xSI6boGNQ4Rja0eSsSkc998RZvR4ILQC7XTP9S
         PWRg==
X-Gm-Message-State: AFqh2koZ1ZJWqelKj1V8DuLcoOe2Yq1p7/q9HzJRwuYwDZc9o40yeEL3
        4YtGspnrjlukmvuVJ0rhh+rY9qgPkgg=
X-Google-Smtp-Source: AMrXdXtI6qIZUUOnYJyeECfh9VHnaDvLGaSZ58roganh5WXUW5hz0yMAsezHNY+oYAP6DGP+9OdNug==
X-Received: by 2002:a17:903:54d:b0:189:81a2:d616 with SMTP id jo13-20020a170903054d00b0018981a2d616mr64591834plb.16.1673306577264;
        Mon, 09 Jan 2023 15:22:57 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:57 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/12] lpfc: Update lpfc version to 14.2.0.10
Date:   Mon,  9 Jan 2023 15:33:16 -0800
Message-Id: <20230109233317.54737-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.10

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 41a1128f8651..c06d981cf8c9 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.9"
+#define LPFC_DRIVER_VERSION "14.2.0.10"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

