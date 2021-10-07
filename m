Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A153C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FF760F23
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhJGUdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:37 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42794 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242391AbhJGUdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:24 -0400
Received: by mail-pg1-f177.google.com with SMTP id 66so907085pgc.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebG8Zj8/jup/7EtMIvvugZMwxuQdc8xv6Kv59v69CJQ=;
        b=YR6H2HmVPMh9Ec8ZAdjZ9x4eGWQyQjdp3OdUZM4dxPPcL23NcxcJrIP8kLjOY5W3GA
         /p/SHMKwnAIbOw/JJw4G5ca691/B+224V1/6SHEDCgLq+xiIN59jp+EPA+s1HVTItKzW
         E8fmrcKIvqCd8Iy2EnOBy6f7v8/CVNy5TyxwRhaW6ahkOh0XKwts+EG/Ddw5DHdxlvkh
         qhc/FRWXV5CxHEm+le2jr9Z61yQrKWmapYKJNOL1x3kEigyS5lIZXJVSV82EcyBQ9oOa
         2mcXT9VE+0je4NbZete/tY5VZH2XUxKDEjM7Nt+0N3EK1hooeXcVa21HGiyjcs8pfuIo
         Ei0A==
X-Gm-Message-State: AOAM533b76DGTeNOGBZAdZX8T8aDNVd9f+F0zfg0aNEeAchlMhEZ313p
        9u0Z/Bk34w0TXIesV2t1/DM=
X-Google-Smtp-Source: ABdhPJxFZlOVsvEPFVVNR6rga/aI0aMClu2+zpIt/EyYzA3ZQ6l6KGvV1rTnYgJUs7bcXKtML/MAbg==
X-Received: by 2002:a63:1d23:: with SMTP id d35mr1320573pgd.357.1633638690063;
        Thu, 07 Oct 2021 13:31:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 70/88] smartpqi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:05 -0700
Message-Id: <20211007202923.2174984-71-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b966ce3b4385..54c12b149fda 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -195,7 +195,7 @@ static char *pqi_raid_level_to_string(u8 raid_level)
 static inline void pqi_scsi_done(struct scsi_cmnd *scmd)
 {
 	pqi_prep_for_scsi_done(scmd);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 }
 
 static inline void pqi_disable_write_same(struct scsi_device *sdev)
