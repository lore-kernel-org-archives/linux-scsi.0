Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC1FC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A075160F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhIRAHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:45 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:34523 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbhIRAHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:41 -0400
Received: by mail-pl1-f170.google.com with SMTP id o8so7245826pll.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okOSEzV0+A8+l9hebYc7xfpaQb9LGG/FcDSWfdCsvKs=;
        b=seFvNh/bFats50Ytj23aZl4jLNDYb7gsEgILrdCmD/s7L85NI/m3nXu28LhBDkioqX
         Van7ZZ0XZZzeiaifRhbZk7CHNLG8p6/Vt2YMu2PHONYCrwrQQrisDXqw6eOPqMpjCpgv
         mjUcV+lNO/DOQ0S0ssJwV561q7sNBrOuaGoqI5n/G3EozKlXCEOChs0T7c0HAnIQZe9a
         lvaZtrrItz3ufIufv2kpnzXKZ3xJd3kpXbQPyvuyo9/r0Yl8r1aHTjoR0e9+FBuNMCc9
         7W/5tLvuAEt4IZoLClOBIOpHQnVy05GmcAZ0WSpGEmdd/V04kNpJMS479hKbOYbDH2d8
         ag6A==
X-Gm-Message-State: AOAM5334Ty2Brk5tf9RU+Q1XzxVHAfNmrTzhz76uBXcD53pA9nH2JRO3
        6Y4mBMXG4y9i/lJfJOhufnA=
X-Google-Smtp-Source: ABdhPJxG++ZvDshISuIgRIdYFz2SsJJ1mkVeOiquv/yfAfufDf19y70Epd9zilbZ09mYACisEy4kvw==
X-Received: by 2002:a17:90a:301:: with SMTP id 1mr15482033pje.65.1631923578606;
        Fri, 17 Sep 2021 17:06:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 03/84] scsi: core: Call scsi_done directly
Date:   Fri, 17 Sep 2021 17:04:46 -0700
Message-Id: <20210918000607.450448-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 2 +-
 include/scsi/scsi_host.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f0cafb..de5f5949a7a9 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -666,7 +666,7 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 	scsi_dma_unmap(scmd);
 	scmd->result = 0;
 	set_host_byte(scmd, status);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	return true;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 75363707b73f..3329dde02a2c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -516,7 +516,7 @@ struct scsi_host_template {
 		unsigned long irq_flags;				\
 		int rc;							\
 		spin_lock_irqsave(shost->host_lock, irq_flags);		\
-		rc = func_name##_lck (cmd, cmd->scsi_done);			\
+		rc = func_name##_lck (cmd, scsi_done);			\
 		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
 		return rc;						\
 	}
