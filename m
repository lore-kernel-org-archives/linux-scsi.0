Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EDEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E390960E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbhJGUcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:32 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:38619 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhJGUc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:27 -0400
Received: by mail-pj1-f46.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so7797905pjc.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9y0QsIwMPGSgzx5MSYES9jzyAyZhlnryYct60FKOcbI=;
        b=ceATtnZ3tsr6WuKFOwbTiJFtXS+B++WkV/ZgNTlDgXTr23HnW4JeZDB+VwhiqDmZB3
         WR+PoaxFNVDpX9rJtYgn6eiGfXgcg6lCo5f+K9CxuwlT5SurzgkRw+Mpt8UwwtWMcpq/
         GNsGjmxCVsr8qzyrEoqrWMHu/SVcJKo9pJq33nZ6hEoMOjQnS+P9Yx3w7Rem+Yw65GyD
         i7orhYTvdAOttp7cgoqcXDoITC4X+NDTbTLSGifPw7zCEbkMwX5KFU+zhnaqQTOWCbhZ
         fSXtmBRrhFTmG5A0nYyqRI11TzVCH4Ti8E5UAMVf6JPbnGFxtnaO0LkUhZIUbP1H66sP
         ER0A==
X-Gm-Message-State: AOAM533PzoqFLeJh5gYHTOZb3DEwnQuVT1CMQwuO6WapifAUGSpWTExa
        CrR6igLpIV8Y37DNJwEF2KGkIMk65LI=
X-Google-Smtp-Source: ABdhPJzpqDHg3OFgASF/snSbnMWVUYf09Uc2qOz7iV240dG+oPtJ12mkY3dN8R46RO0g4l8UcZe3Kg==
X-Received: by 2002:a17:90a:4:: with SMTP id 4mr7017485pja.221.1633638633412;
        Thu, 07 Oct 2021 13:30:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 34/88] fdomain: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:29 -0700
Message-Id: <20211007202923.2174984-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index eda2be534aa7..9159b4057c5d 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -206,7 +206,7 @@ static void fdomain_finish_cmd(struct fdomain *fd)
 {
 	outb(0, fd->base + REG_ICTL);
 	fdomain_make_bus_idle(fd);
-	fd->cur_cmd->scsi_done(fd->cur_cmd);
+	scsi_done(fd->cur_cmd);
 	fd->cur_cmd = NULL;
 }
 
