Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFD8C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCITb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCITax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:53 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346FAF146E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:58 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id i3so3111702plg.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2E38+Z4Kj94CPrSnz/WfZRtH1QTTtivsr8lXuwNctz8=;
        b=j44sFl6Hq3xdW8DSHiJ/bBNdyfrp6SgX8V8TBntu/rtx0dQi+3UW8jqssVfyIyU/dj
         K9JoPTFB27iDLt9IvfS680TKWNfrXQpo7zexP0Xa/qwQ5vhbHyu5mK6/F3K0InsFhZ34
         R9X+M0+eQNpjKWXBIo6VJRKQq1EGFTVJ2NCUcTuRHD2Jhhp7pbc/q6qMfKjuRR1QRUNt
         psrWOq0F4W97L3njjyAcPSJnR+4pxq9BnDyxAAeRef56IIr11/4KPv9wf/vgy8pb9ixD
         yTGzVUSpmn6ouBco9vEBkfw+5RhHLBVYn8rn+zI5LRFrh8EvUrOPhQCL8ZZuuGngvUYU
         n7rg==
X-Gm-Message-State: AO0yUKW/Krt240OisY/au9pHNItLIP4ie2KQ9Ww+JjlTe6yOhcCzC0WS
        5JG9D1m9p8DkQQ9H6PkSF+A=
X-Google-Smtp-Source: AK7set+AMfYT9rpzNwJ6iR7x0MOz1+IfcNwYu/K39ZorbdOHnye3O49CsqPmD2fqY07FK4XCKRkIhQ==
X-Received: by 2002:a05:6a20:12d1:b0:cd:fc47:ddbf with SMTP id v17-20020a056a2012d100b000cdfc47ddbfmr25150792pzg.47.1678390197723;
        Thu, 09 Mar 2023 11:29:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 69/82] scsi: qlogicpti: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:01 -0800
Message-Id: <20230309192614.2240602-70-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 8c961ff03fcd..6fa8c78c3116 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1287,7 +1287,7 @@ static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
 	return return_status;
 }
 
-static struct scsi_host_template qpti_template = {
+static const struct scsi_host_template qpti_template = {
 	.module			= THIS_MODULE,
 	.name			= "qlogicpti",
 	.info			= qlogicpti_info,
