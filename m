Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3187FC2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F06E321835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Fox42ic3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgACLfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:35:33 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:37155 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgACLfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:35:33 -0500
Received: by mail-pj1-f53.google.com with SMTP id m13so4633870pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DA8phdQw+aUTdgyo5OReorPC3i37Z5tgP6xQbQ3gT60=;
        b=Fox42ic3dlEWjRTCsnyu5IrD/AHlXtd2WyridUz9mWFmt8HFCGSJU8rP0TC/h1869L
         GfBy2JAH2d/G3I3lLuGZcuCvjFeXK0ltEND6HrUNzyGysa4NjvDYbT+IG1d4o3Q2n51E
         H/X/4XCqTzs82mKjkVXmu6zJdZw5ir8tIZYCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DA8phdQw+aUTdgyo5OReorPC3i37Z5tgP6xQbQ3gT60=;
        b=XZjj0mFc8/LtoTqg+6nOHgBMoyu3Ryn2AzSJzKTAJ+83DuJ94gKKe0psQ511Xr2CLN
         O+Qpj0kqBW7OJsqgPdth3K3qGrPM1biXjvyZ9on4BWqNiEXwPxQOTb+uU8tNn+NeYoAv
         1ThTe/UKDEXK/z6sPSAnpavKj4JsSG7oXaljEkdfIJT9pysUU9PHXNLnUQxsXGW5Yq9T
         IpiFalM8B7zjGq4RP/JYLa/5Zp6ijmkhkN+sq95e8K5LsMZroSX6fX/dujTNRK3FLm5K
         P7IgCyxOHJGAJA7BHysc8PfI/X0FsH8fm5r9qBTpiIqOqrxz9a8BOqPDF0ruW3Fc4Das
         CBjA==
X-Gm-Message-State: APjAAAVxx+wpfzxAyEyp0Z0F/LwHM3NF1tfNZEBIx7yfmOabg4hQGxXP
        59R8xa5B6gHnBJHsxS/zD+pixaKLn1amBXYYw6TfvyrZaeC/ZMyQEKJB44ReTpYab7RvWeirydj
        elj2pnRQPlEc6bwk+giG3tq4gwTPcO9PrbKcWLKOrIkcdowPr5Fqp+AQ9CMeVc+x2fEtg4g63SR
        5YyBNH1Q==
X-Google-Smtp-Source: APXvYqzCztgRibcRk/+/YhRM0+V2q6o+pZHdDqAJJiH2NPSzZ7UGyeoKu7yeYKQJtMIYFd/s85hYAw==
X-Received: by 2002:a17:902:4a:: with SMTP id 68mr43682583pla.245.1578051332600;
        Fri, 03 Jan 2020 03:35:32 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.35.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:35:32 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH 11/11] megaraid_sas: Update driver version to 07.713.01.00-rc1
Date:   Fri,  3 Jan 2020 17:02:35 +0530
Message-Id: <1578051155-14716-12-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 25afa81..83d8c4c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -21,8 +21,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.710.50.00-rc1"
-#define MEGASAS_RELDATE				"June 28, 2019"
+#define MEGASAS_VERSION				"07.713.01.00-rc1"
+#define MEGASAS_RELDATE				"Dec 27, 2019"
 
 #define MEGASAS_MSIX_NAME_LEN			32
 
-- 
1.8.3.1

