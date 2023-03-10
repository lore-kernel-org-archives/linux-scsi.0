Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6836DC6FD1E
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 21:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjCJVrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 16:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjCJVrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 16:47:15 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05526119F9A
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 13:45:06 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ay14so25995645edb.11
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 13:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678484682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W5vWZTV9oKc3EJwBR0e/KKmozkU4BeBcYOpS6H8ectc=;
        b=NAQrYZ35Ne2cABlc5MmOqOD/SB3QHkb02yOEWxFPyC3sK189AgHM46qEp5JvPOju2E
         GX8ijQ3SN/66KkGiE6b8t9jzwP73qgLXuVg+3ZrNrDQH9uilrOgYYND8PfuNoVZyzxC7
         rjYwqdHj0dtTbZZcsacR1cvwqYOnbzRJYspOKHK0jaPtutp/CDvHhCGwQLUOmMX3O9Oe
         T/3A9zdLt9D8D6by6aX4z+yXhv9vjNg7Tl2YM2VZRTY5HypDbU2c1Nkd/uI5T86s0GWJ
         t7hfsRhuKJ4yM797kW8nv/tITpUPwAhKEGxm5Gz5kjKmTvhywvUl8kXuUZzbBzjBSCgF
         LiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5vWZTV9oKc3EJwBR0e/KKmozkU4BeBcYOpS6H8ectc=;
        b=JiwJc+rx6oISNE+KLeV13JT+9Em0++iTmTLxEceXlVvAtOO1ElgYlyin9xnOPlVM69
         +SPn0lw6SjIGVYIHUjkUyFAu9v1AG7rCeK9rScAiIdxYjQ12+ATxbbzGnqo9JTG4/0Nb
         eetW0VX0a2XsA6jQP+Kjv1ppI1xn2RVBVm6XGIlu26d/fjC9m4yKGNnRr2ZbWx6krSZw
         atoJ/Ja+L+IwFqQiM2TtPHCkTiVkFmZInZwC8A9n6CD7o04GiOQvX+iOnaVM6sryb289
         IzcSXS6WjBTepFbGXjaMG+zYIiXwS+XGoPHPzz5ItlADv2Ph3Y/CyyR84QaAvj6rhxRS
         Befg==
X-Gm-Message-State: AO0yUKWEQ88YxPCj8xNnZPJMH+M0qyo7nWMkaAX8QeS7hEKrEH07gCQ5
        1ORw74+GA0kk4Ah4dOmT10w9WA==
X-Google-Smtp-Source: AK7set9+Xj7QQpyndl7V7aMO1Dm5cdQzT5Tf0nPQZ+YewNfu8NVyhU1zkK9fNjuymu2DajZjPfDbKQ==
X-Received: by 2002:a17:907:70e:b0:878:955e:b4a4 with SMTP id xb14-20020a170907070e00b00878955eb4a4mr34046804ejb.33.1678484682424;
        Fri, 10 Mar 2023 13:44:42 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090627cb00b008cce6c5da29sm334571ejc.70.2023.03.10.13.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:44:42 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/3] ufs: hisi: drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 22:44:35 +0100
Message-Id: <20230310214435.275127-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310214435.275127-1-krzysztof.kozlowski@linaro.org>
References: <20230310214435.275127-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/ufs/host/ufs-hisi.c:561:34: error: ‘ufs_hisi_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ufs/host/ufs-hisi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 2eed13bc82ca..4c423eba8aa9 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -597,7 +597,7 @@ static struct platform_driver ufs_hisi_pltform = {
 	.driver	= {
 		.name	= "ufshcd-hisi",
 		.pm	= &ufs_hisi_pm_ops,
-		.of_match_table = of_match_ptr(ufs_hisi_of_match),
+		.of_match_table = ufs_hisi_of_match,
 	},
 };
 module_platform_driver(ufs_hisi_pltform);
-- 
2.34.1

