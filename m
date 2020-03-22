Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2186DC4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF9420736
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qmj2j/WC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCVSN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:28 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33750 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgCVSN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:28 -0400
Received: by mail-pl1-f174.google.com with SMTP id g18so4892761plq.0
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MKNpqwXPnZjbvT23Ks0JWvpzrv1CDKNpSRKwVFjt/zM=;
        b=qmj2j/WCHxIZpY1vhidBvo2CM8QxXcu1HElOSTfZDIdShCIaLCusB5BR5FMVh90Iiq
         d59E/w1VkK0PmvJSP2m2aLU+/or0yGHGZ6ZrFZPPBQQFWQeTFjYYLTHtudkyTMyyMwok
         E/6CMsQzmFCkxCLTMu4g+qd6NQrTgXrnxho050CIx0NxD6bo07kxB6p5SE9HwgRjSQzm
         IsO3KfmiNPbhGlhkqqXH3BC7ubu10STGMcukcMdApsYxbOyT4fav97EGRquZun4ejjXl
         Yu4MCtOVpyqOxWzUqvxH2s2a22ZAXXPUsJUqnkWClv3upn6tMBxLdr//HQGYLnNjKHXJ
         ECrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MKNpqwXPnZjbvT23Ks0JWvpzrv1CDKNpSRKwVFjt/zM=;
        b=d9z3rGRdsjNxmoxyItb+qmDldwjOAtUqDCFtvU9ffS40BFJ+Qs0QimIDY8ix9Ln230
         /H6VPUKn+v5Fkkz+IwUtVD1dB/PSdRUcH7a54sne1dljbBD6r9r4oyik6YRA5UGqjo0m
         4y1nLjnPjBFCc4sfsLc17MX3dJTsn6hQQLsBJ5ks8PMFwZknXyxBAsTBMfL6D/xmI6Rz
         dvECq3C6UysekIVP/D8cggwWRY4S1JWboGmgjorwcYtJ/knw2CeLRXFkMVz8l0D73bnA
         cOFKgomvem2fkbs7Gg/XpLEeCbWDpBehDhmGPLTN4pXqOA+Nl6brN8adPDjTZHScSUZa
         Qdxg==
X-Gm-Message-State: ANhLgQ22C93EBwae3ixupj+ZWRDMBhOB2S1mMBAQCok65eaGZXB5krHw
        2J2Z+EH/IuzHF9wlEYvga36mo0X6
X-Google-Smtp-Source: ADFU+vsYjaXJ2+m/0ofiZ/UXhvo/J5YrJiSnMVXefF7w71jmuOpEDcqD8RyRU9xeLWcGNsdjWRESTg==
X-Received: by 2002:a17:902:b187:: with SMTP id s7mr18791230plr.84.1584900806775;
        Sun, 22 Mar 2020 11:13:26 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/12] lpfc: Update lpfc version to 12.8.0.0
Date:   Sun, 22 Mar 2020 11:13:04 -0700
Message-Id: <20200322181304.37655-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.0

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c4ab006e6ecc..ca40c47cfbe0 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.6.0.4"
+#define LPFC_DRIVER_VERSION "12.8.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.16.4

