Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15E3C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCDAcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCDAcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:09 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5666A1C2
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:08 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso7840389pjr.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wymxuyu9oeqRFS6g9w4tBUT2F+EZK1WiYB207jxr3Bc=;
        b=1nr9yOkUil64SyWmF1Qit2SPfRvFdPNRR5WA2aPd53bTz69vIEJKfznmknF1mch+o2
         O8gp/gDWSYAUDwFZoIc0FGIueWRwfQYgv/lvUdy546srs11VfZDcJg6ZpbGaC+wa0dTp
         nV/FZHQYxXBhMTG0AJjvkN6TVPjyieQ4Q0br4bfG2b7hSXMTQPeTzLeKlbq5ySJ8vNau
         ZBrvTs2RIk5mdQyZe0ZxoimHeda8hZDF7svryt+Dfol6o13WPc8B2+TD5+x4XoNZ4NhY
         xioEmAQ2sDqv56LVbcg53dZr8/Zn1tK6KqIkySXBK/TjdcigfLhL1VhRzUtEypDuQKsl
         YeHg==
X-Gm-Message-State: AO0yUKVeBUEkLPdw3igTqX5yq0hwd66/W+xVsi7bEUjyNTzqehZ83pR+
        I+YeZVppKt5Ik3J4HiFZ88E=
X-Google-Smtp-Source: AK7set89gKIjzYfC/EvcT2Y6EbbtEKLGbk3gnB5AdxGQ0YOoTkk2HgpNehWZqfaoxsvJxSH2q2ttaQ==
X-Received: by 2002:a17:903:230e:b0:19c:c961:ac15 with SMTP id d14-20020a170903230e00b0019cc961ac15mr4213726plh.0.1677889927608;
        Fri, 03 Mar 2023 16:32:07 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 16/81] scsi: aacraid: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:58 -0800
Message-Id: <20230304003103.2572793-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/linit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5ba5c18b77b4..d0c1f024592c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1476,7 +1476,7 @@ static const struct file_operations aac_cfg_fops = {
 	.llseek		= noop_llseek,
 };
 
-static struct scsi_host_template aac_driver_template = {
+static const struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "AAC",
 	.proc_name			= AAC_DRIVERNAME,
