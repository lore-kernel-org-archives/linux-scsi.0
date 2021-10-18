Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD3DC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 01:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA84C61179
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 01:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbhJRB6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Oct 2021 21:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbhJRB6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Oct 2021 21:58:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10A2C06161C;
        Sun, 17 Oct 2021 18:56:32 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i76so11342069pfe.13;
        Sun, 17 Oct 2021 18:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=/FugdVHFR3AUqAVRaU4hvpNt7FLfAHIXJPLel1NYKBk=;
        b=kdwbrb625O1ndpj8DAnj+IqS61DrhIdtmSVEE/QW+V+pLuLxiiLXP9MuSdApaQD8Hv
         hL2wWkEZ1vDfqPituao3gTUlSxo4U9XWXYNp0p2yF8iJCpnoqMoHjlwDuQ3ajD+sXkuo
         bClLF9DH7O8M9S6wIhEAMI/X5sMhMtOlfwzKAhFK3/WtS7EM5Z++JCxV6By161WqcWao
         NC5XrIa35k/0g8dAqn6N8pFw4iBI2va7S++mx+6DfU0eR8INqpSSWXiuwKSlSUJU3QWA
         8SkSe1cH9fqwNTK6ojbYcs6V0RVIfpyNxQwnJySqSD8JlCjMgov1VExMB3H0hTxvsUrO
         vuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/FugdVHFR3AUqAVRaU4hvpNt7FLfAHIXJPLel1NYKBk=;
        b=HDOsoXYiRPT7TYvRwGNQcasMrnsn6vu6mVzb0MAAsTlvd3ZIohZuu1y8dY68HSMTDF
         WsI93wLvEAjAssO9BBp8BV63YgkSiiiO77gvYA4HgQi9P2NYQr6KufcXbOOXlCorC6d+
         xC6XAmjQFSpKsv+978cgE+S4FGWU5PzITHbqHhahLcGfwixxFXjOlwFSIyGaxI53MtfS
         D7St9/EWDA4hkuqi1xWnqKCOz/wyfBb75UpfRsdxMzfN2MY08Q0C8lZnDmj9bKC513vU
         1NImT9krRlfIZDeJWkNuQHA79O59AEkYS3JVi897MdrybsuOmbi1y/9SJkoaegUw46jS
         hXFw==
X-Gm-Message-State: AOAM5316ZKxyIqyaxScRHWEv/mFi8uTlr1Rnc1q4c/XWl9e4cjmws4Of
        h4V6DCHhY1+UsAU23GDCWwkWR6wK3HtX
X-Google-Smtp-Source: ABdhPJy/mkeqh+I2Fx/XXIrfDOeafYPH2XerbRGFjUcxpG3OGAZebt6ixGhDhikK+qBps11VrbmgFQ==
X-Received: by 2002:a05:6a00:16d4:b0:44c:22c4:eb88 with SMTP id l20-20020a056a0016d400b0044c22c4eb88mr25702743pfc.75.1634522192466;
        Sun, 17 Oct 2021 18:56:32 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id pj12sm11956887pjb.19.2021.10.17.18.56.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Oct 2021 18:56:32 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Date:   Mon, 18 Oct 2021 01:56:21 +0000
Message-Id: <1634522181-31166-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During the process of driver probing, probe function should return < 0
for failure, otherwise kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d2e40aaba734..836fedcea241 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4157,7 +4157,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return 1;
+					return -ENOMEM;
 				}
 				ha->dif_bundle_kallocs++;
 
-- 
2.17.6

