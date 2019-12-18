Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B215EC2D0D1
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88FFB21582
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uFAfZExO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLRX6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46714 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfLRX6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so4100145wrl.13
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tBzoLDfsGDQQ26HQ8iwBTSmaqU98MBum7xIMsbjIVjw=;
        b=uFAfZExO+DNXpGSlFmZ/utGMaLN8E1xB2NQsqDZ2eEBgpzx7hIM/GbyueToDJiEcDd
         2RBAz5kuR+TE/fAmQm2MM2iPlL3jK4x8VEpQzOCSLT5num8CUMNTOWGRZ5bgYZg3NAQE
         tWkWrtjoSw+6lNeeKGn8FqtJkel0Y7I2sD5p2CPbjV+/V3iF1mWtgAGpt7BeGJu4waSH
         wXea1OLXKxEdLlmwMYyYjdx30panElUa0TNRtx9+pot/MunZ1IyNo+5ubNrYisUioVxL
         FLNdHL8L7iWU4RpJQNqHzLorT/hHJ7OcDHDLTOehgFRkc+kl6zdBdLmsG/zZ4MHl6iQe
         9oDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tBzoLDfsGDQQ26HQ8iwBTSmaqU98MBum7xIMsbjIVjw=;
        b=bsspZ7yGkjdCRrBx94if4C1UVA4KmGmEYBLzqWKH6BnXyDO+caUu4pDSjRThTQPGMY
         HTfryXrEbph0hwmNVZ1BlEOEtCNXWyKP0/CJ2DABwPTqWGdF1q9ofQKo0KOrVSR0zaDv
         nwKHBxMwKx35qCHcKEaFnVpG0jutCEE0fn0QKk527Bukrc51SNyerO9Lj3FcRMy+yRlM
         cEGNzl15vcwe39ahzZFK6bZUWcp5hiAVAgL1ndynUEZ7cpLjmKQLq8DtuwwJFSFlNE88
         NS9lRulXRwTri3nGh6wR0qOjnZfq5jIK/ZJsF2+CIRtHd8k0fxXo8lD6H/kdn3UXfiuI
         GnUQ==
X-Gm-Message-State: APjAAAXAh2iHouUoF9l2YEu0/rm+BR00+q3AcVOZy57JVAo5xmTOHKfH
        AQBWE8LvX9XcXrSSbP054DTsYAem
X-Google-Smtp-Source: APXvYqzhLWN7kBjH/xpFNJo8AiTA/UshT5Bx54cAvmoRK2pPgZCazIRUnYlQ619km8lD8lJLhPoq/A==
X-Received: by 2002:a5d:6349:: with SMTP id b9mr6038286wrw.346.1576713501403;
        Wed, 18 Dec 2019 15:58:21 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:20 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/10] lpfc: Fix: Rework setting of fdmi symbolic node name registration
Date:   Wed, 18 Dec 2019 15:58:00 -0800
Message-Id: <20191218235808.31922-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch reworks the fdmi symbolic node name data for the following
two issues:
- Correcting extraneous periods following the DV and HN fdmi data fields.
- Avoiding buffer overflow issues when formatting the data.

The fix to the fist issue is to just remove the characters.
The fix to the second issue has all data being staged in temporary
storage before being moved to the real buffer.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 99c9bb249758..1b4dbb28fb41 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1493,33 +1493,35 @@ int
 lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
-	char fwrev[FW_REV_STR_SIZE];
-	int n;
+	char fwrev[FW_REV_STR_SIZE] = {0};
+	char tmp[MAXHOSTNAMELEN] = {0};
 
-	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
+	memset(symbol, 0, size);
 
-	n = scnprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
-	if (size < n)
-		return n;
+	scnprintf(tmp, sizeof(tmp), "Emulex %s", vport->phba->ModelName);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
-	n += scnprintf(symbol + n, size - n, " FV%s", fwrev);
-	if (size < n)
-		return n;
+	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
+	scnprintf(tmp, sizeof(tmp), " FV%s", fwrev);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
-	n += scnprintf(symbol + n, size - n, " DV%s.",
-		      lpfc_release_version);
-	if (size < n)
-		return n;
+	scnprintf(tmp, sizeof(tmp), " DV%s", lpfc_release_version);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
-	n += scnprintf(symbol + n, size - n, " HN:%s.",
-		      init_utsname()->nodename);
-	if (size < n)
-		return n;
+	scnprintf(tmp, sizeof(tmp), " HN:%s", init_utsname()->nodename);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
 	/* Note :- OS name is "Linux" */
-	n += scnprintf(symbol + n, size - n, " OS:%s",
-		      init_utsname()->sysname);
-	return n;
+	scnprintf(tmp, sizeof(tmp), " OS:%s", init_utsname()->sysname);
+	strlcat(symbol, tmp, size);
+
+buffer_done:
+	return strnlen(symbol, size);
+
 }
 
 static uint32_t
-- 
2.13.7

