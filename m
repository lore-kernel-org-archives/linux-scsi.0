Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEA9C4361A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E364764F6B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCQJNm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhCQJNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:00 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786AFC061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 12so1009672wmf.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kpxpj9RY3Tz1buvtlliu/SfUSZOzhZdJwGgmrjmjL4c=;
        b=ENZefxfvp2SbLaisye3tgbpbWWpQrCXHaTbdFnQ7jF7oVLFWuLPED510b4pzbTPx6T
         qJ5UbDkPqrEpjwDmL0+UAsVELrgLAvENpJPTWWlfYh2eQlxjTRuPukX5GWJKNpEghVUT
         W4Q1LEGGpAYTMeQkwi1t1LW6I/GWJB5BSOfowD1op7cj4/CdhHZTn1iAR+CMfkBYyT6s
         GbNmu/FnHvKkj+bOPh3PZKlJ2/C7BtTB5lvFL0si86sLj3r33gFpxhMQAAL+DuV/6OsL
         6EYXH8JojSR2IBU8VJro4y67zxHzg5ab2q9OSE56Z8HtpjPSKA4x/mhmRZ8zpOeY7Ly1
         befw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kpxpj9RY3Tz1buvtlliu/SfUSZOzhZdJwGgmrjmjL4c=;
        b=ebDrsNotUsqPIjjGZKxOD2lEbrY6yqyO3MO/O35zE6inR8Zop6yw661LOdFwCgs4uS
         BsnDNCtJCSmvr5TCM5kL3yixHHIs+DaL3LKcG4TstrmQzCBs8cuSMjU5XbXMWZ4pS8IG
         t15pmPub2PNjUgIk92O8ir9rriKrRLPDwHu2DCBJh0fPfYgMAyaWBH/NJSc8DWRe1TTG
         5L0gqVNTXS5rkpaHYuEZwnYljpwVItbAnZJzWOulvXLyS/NT+mW8psab5We3JBvYzpAa
         Mhb5PyTTZunh+HBi2heNSFToqqIAnECcsx+2omKR/Wis2g/gterAsSxgRW4kEtECRNHL
         6r0g==
X-Gm-Message-State: AOAM533klSZODwzfRrSDmI3hqOokL6TPRpZv4l7Ejk/jHLzjnZ0XMlDm
        EH7OSR/rpvGRrH6Lu1iFfFkANA==
X-Google-Smtp-Source: ABdhPJzZkiEitRE+GZC9nr/Ly46A/COTSQRSLSiOZArjHnJgIdgU28VIcHakoCp3CXIHDbEsxPBJCg==
X-Received: by 2002:a7b:c3cd:: with SMTP id t13mr2675160wmj.109.1615972371169;
        Wed, 17 Mar 2021 02:12:51 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:50 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: [PATCH 11/36] scsi: a100u2w: Fix some misnaming and formatting issues
Date:   Wed, 17 Mar 2021 09:12:05 +0000
Message-Id: <20210317091230.2912389-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/a100u2w.c:278: warning: expecting prototype for orc_exec_sb(). Prototype was for orc_exec_scb() instead
 drivers/scsi/a100u2w.c:596: warning: Function parameter or member 'target' not described in 'orc_device_reset'
 drivers/scsi/a100u2w.c:739: warning: Function parameter or member 'host' not described in 'orchid_abort_scb'
 drivers/scsi/a100u2w.c:739: warning: Function parameter or member 'scb' not described in 'orchid_abort_scb'
 drivers/scsi/a100u2w.c:915: warning: expecting prototype for inia100_queue(). Prototype was for inia100_queue_lck() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/a100u2w.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index c99224a128f82..c9ed210d77b39 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -269,7 +269,7 @@ static u8 orc_nv_read(struct orc_host * host, u8 address, u8 *ptr)
 }
 
 /**
- *	orc_exec_sb		-	Queue an SCB with the HA
+ *	orc_exec_scb		-	Queue an SCB with the HA
  *	@host: host adapter the SCB belongs to
  *	@scb: SCB to queue for execution
  */
@@ -586,7 +586,7 @@ static int orc_reset_scsi_bus(struct orc_host * host)
  *	orc_device_reset	-	device reset handler
  *	@host: host to reset
  *	@cmd: command causing the reset
- *	@target; target device
+ *	@target: target device
  *
  *	Reset registers, reset a hanging bus and kill active and disconnected
  *	commands for target w/o soft reset
@@ -727,7 +727,7 @@ static void orc_release_scb(struct orc_host *host, struct orc_scb *scb)
 	spin_unlock_irqrestore(&(host->allocation_lock), flags);
 }
 
-/**
+/*
  *	orchid_abort_scb	-	abort a command
  *
  *	Abort a queued command that has been passed to the firmware layer
@@ -902,7 +902,7 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 }
 
 /**
- *	inia100_queue		-	queue command with host
+ *	inia100_queue_lck		-	queue command with host
  *	@cmd: Command block
  *	@done: Completion function
  *
-- 
2.27.0

