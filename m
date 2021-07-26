Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DB5C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D4160F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhGZTjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 15:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbhGZTjD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 15:39:03 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508D6C061760
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:31 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id bp16-20020a05621407f0b02902cec39ab618so9216662qvb.5
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Dtq28Xg8/uLolUu+qWIKeO61eazTXjlrFQKAF/MncPI=;
        b=hz0ZRwZXl5oZHOaXjrQRjl2HnZZcPnSKBtMsJXpFVgVs49kEYZDETQnbXjsHMkKaD2
         0q70L1uD6/YSbaMbT94Kh3w5QcOGxS9iZEVgPRXs4T4KIytYvYwytkGvJCPv44cKed+A
         Jx2e3lGmgKXaVLkoHV/ye5c8QTgzzRl/QnKkoqe36ST0qM2ptLulRN7hL9BTXm0aNSOo
         sHl5nu+5DiX6Wrr4Jx9Lhyul/5A3lbF+7T7PSan7G/xURtsRYcoh4yP9g+zHzFEqKzPM
         m/19zx8izWOJXhRgChVehgR+Czxi7wG6owsMcpZbaH9PhB3AM1+VAV8t1r3Szvve8Dmg
         Iy5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Dtq28Xg8/uLolUu+qWIKeO61eazTXjlrFQKAF/MncPI=;
        b=D3jjGVRO7R9ukuoz8JulZVriObjMYWIgfv2rh45OfX4pvqXHqP6SG0Jwa64HRlz1vK
         /E+dYhFdKiU4wZt9W/eIah/cFRJ70EXchZbNHMi00BDYA0Ex5XXr21QtRWU66+olJ1QY
         dQqrqLnbY6EShJDrNdBPhCU53PDXdVoQvEEVZ9kUM09H89F9uqE5AUwpQA+M6fnpD3ks
         i9o2zsFYCSdXCvRluwI9/fBh/yKD2fuAbnQiVuTC7yLG70b5Nag0Qkw5K4WzlyaA8MRt
         uUsWPOJfIuHpmP/q5caMEkjs2X+fs+iCosFj26MmWdgZ6MktUUCeVZOPO6lOkYYnaC8o
         S/4A==
X-Gm-Message-State: AOAM531LvVd8/5fRJOA2jY6koi8ENfGiaHYO4udxfK36ak23XAzTzdvv
        Wh9LpIraFZhqu7YLk9oFfcxvELDA
X-Google-Smtp-Source: ABdhPJyWjm8hvRlnL19m07zY5k1mL8W4fLKVX43wTTv/q2nEIW5TXdtGEIi490bOn5d3qy09VnkgMF6pBw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ccf7:db54:b9d7:814f])
 (user=morbo job=sendgmr) by 2002:a05:6214:1747:: with SMTP id
 dc7mr15897755qvb.27.1627330770376; Mon, 26 Jul 2021 13:19:30 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:19:22 -0700
In-Reply-To: <20210726201924.3202278-1-morbo@google.com>
Message-Id: <20210726201924.3202278-2-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com> <20210726201924.3202278-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 1/3] base: mark 'no_warn' as unused
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following build warning:

  drivers/base/module.c:36:6: error: variable 'no_warn' set but not used [-Werror,-Wunused-but-set-variable]
        int no_warn;

This variable is used to remove another warning, but causes a warning
itself. Mark it as 'unused' to avoid that.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/base/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/module.c b/drivers/base/module.c
index 46ad4d636731..10494336d601 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -33,7 +33,7 @@ static void module_create_drivers_dir(struct module_kobject *mk)
 void module_add_driver(struct module *mod, struct device_driver *drv)
 {
 	char *driver_name;
-	int no_warn;
+	int __maybe_unused no_warn;
 	struct module_kobject *mk = NULL;
 
 	if (!drv)
-- 
2.32.0.432.gabb21c7263-goog

