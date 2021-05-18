Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F26C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D1A5611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351312AbhERRrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:13 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:43928 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351320AbhERRrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:07 -0400
Received: by mail-pg1-f172.google.com with SMTP id k15so7519967pgb.10
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UMCYnVrhY8njikYx66obtRsVTDVDJ+hpIeqxgmK/N90=;
        b=pVg9BWJuSNKjRodgaAtBG6LUUDPjCTvq9l8IVDiZE9DI6mUmJ3G1QreaJh5clDREDb
         DNzyt02N5Z5xgW2M2Ak3Lz3mQxWAR+2kvEshZsZhpU3da2Y4ujmg9vbR+4tXJbp7MetT
         P90jxv18bfKZa9hrxek4yVhfSwq3sgSmf0eXTzrRwFxFLV6OwBXlkZdWitZjlFeJSd1p
         4F1a8flM6VHBBlg3bmUJuJ2EW4MD1CLTj5SdnlarRPVkfoZnmIlnWpbC2odaUrrgftmT
         u+mg3VhWCVbLhpZ3uGToBrrEvSnOLNkcQperisgNIMQHeWO2veaxb68RrjVqKpP6gVkl
         1FLQ==
X-Gm-Message-State: AOAM531qwKGWFml85uBg9gJluliE2kR1qO3Vo0Ykho6UMmtYZOPpRyPY
        zrsEDE/MsmYIy3vmHHlsJMI=
X-Google-Smtp-Source: ABdhPJzsZiaCBSdlPwT9O86drrTtkKKxRf641z6ST4t6bodvU+3sSnL8rTCfKRQ6jDNnWubdXx5A+Q==
X-Received: by 2002:a65:4548:: with SMTP id x8mr6218790pgr.413.1621359948987;
        Tue, 18 May 2021 10:45:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 44/50] sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:44 -0700
Message-Id: <20210518174450.20664-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..04cd28c268f2 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -502,8 +502,8 @@ static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
-	if (np->s.settle_time_valid && cmd->request->timeout) {
-		unsigned long tlimit = jiffies + cmd->request->timeout;
+	if (np->s.settle_time_valid && scsi_cmd_to_rq(cmd)->timeout) {
+		unsigned long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout;
 		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
 		if (time_after(np->s.settle_time, tlimit)) {
 			np->s.settle_time = tlimit;
