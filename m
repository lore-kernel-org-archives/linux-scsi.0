Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E6CCA9ED4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFAB20717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="owqziVk6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387440AbfKEA5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:41 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:36028 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbfKEA5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:41 -0500
Received: by mail-wr1-f52.google.com with SMTP id w18so19306276wrt.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qqles78biMtDTvw3ZZsxhMt1WAgRxcSEo7VOFsJ5sho=;
        b=owqziVk6NiRA+yqWB8n1xdYH7SoUfi4RT3sau+bGpInmqG/n6ajJKXH3GcfE+0PfgZ
         /j8HNZVfevThe4VkC7hGu7dzThZVa/BgJLuzwUhMWf/gOcV3WtIBINKQd2++eq6Kuvbb
         kmKf1McfCb0pZTWgNgb6Es3JIaflPIhld/btOw1aMPnIkMBCR6PzWkZG/ds85vVjhk0a
         EM/6uApwJzGVp6cC4nv0x4id56BzjWgPYdSMYW62DE5C2C2sXsl2Z25Q1IQ5zwWJzgUS
         JE5IgwBs+Juws0c9MA2b9GIeqPnpLu6exh1wj9fb8wBhRcgCFlyHqSkp0jYf+gMM0n1p
         i/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qqles78biMtDTvw3ZZsxhMt1WAgRxcSEo7VOFsJ5sho=;
        b=DAQydKkJ4ziHDxm65BQ9z1phapPvMKqG1WtcbwHWELsYo2NXEStGPe6qHWLAOW0bp7
         NI2iU77gfqA5/VWOw6gPpYxSXR9IdLTSQo/9Mczh9mzPfqvmn6rdsGflIzNH/dv1jUIj
         HYzgM2nv/poxi/SubwRywHISV4yHr4Cyf5fDtR/kjBl4HClen5mZ3T/c6Vk1ndJjrox3
         XNUs0Spp9GOskXuVhVk1T9KSyabUsmcRDv4oSsve5DuY0PdRUEdd2DxI4bg9CYdFFsOc
         KtXqOl1v1fIIeKp6Lj54yLjjbfWzDi7hti4b+EHLc/nwAsJ+kgyYvk+BNplzTg2pmgaS
         aj2Q==
X-Gm-Message-State: APjAAAW48ikxPgI48TMrKE6i9kCe2RiOJKOeCymviTw6Qck+UthfmnqA
        jt7K3hXHA18IE8+ALYhjk0aFtCPw0vo=
X-Google-Smtp-Source: APXvYqyONZ1oMR78df7/qKS7+VsJ1a0T5XTEQBxNlEi2UaaTeUxwX63oc6r3HW4k8EN3eaMoBac3PQ==
X-Received: by 2002:adf:9e92:: with SMTP id a18mr24990342wrf.34.1572915459185;
        Mon, 04 Nov 2019 16:57:39 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:38 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/11] lpfc: Update lpfc version to 12.6.0.1
Date:   Mon,  4 Nov 2019 16:57:08 -0800
Message-Id: <20191105005708.7399-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.6.0.1

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index ed1b10b0161e..1532390770f5 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.6.0.0"
+#define LPFC_DRIVER_VERSION "12.6.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.7

