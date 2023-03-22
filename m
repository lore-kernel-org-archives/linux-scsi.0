Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63393C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjCVUCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjCVUBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:15 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707026B95B
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:50 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id l7so2457253pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bKU77JUcmdCiHf19hl22iuzy8frSUKxUFEkHosyM1I=;
        b=iWbEIB9ooZwZgAH+1u+DARHeWBpic4iUS+3lbhji51auVv3c9fkS9VEHcsN2XUQPp/
         DfhF2R2J/nNrVV9c0O+1eGpIz1dEmvZPVXqf7IBs+HwRRGCo5qQ0K9OqbF077O04ifM8
         YSYRTZgDZTyKshipKv5WrohXJB/PDmyORvCT2HlWnSlFYdOrgz/4p+YsxlNVE7sWC3kQ
         HbG2YKaEMM55+BzJayfpNPanno7XP3SYAT7TFt0b74SdHw8HrIpwKmkWKgqYez7E3x+P
         ttzxM9YJLfLRMfXwGcOhZbTPSeSf3oV2BQ0wOSXdh4VHsaIMoOyBI5XOunfwVWwPzp9/
         w+CA==
X-Gm-Message-State: AO0yUKVUVjPUi1JtfNaMDIffr7OgsOR5Ak/EE/ImbpBloH1+r0Ejr4eB
        rUJuXiGyhaOwpfUOCtcv/ow=
X-Google-Smtp-Source: AK7set80T2HHX2i04aAz4NZeD41ADHaoAMNEe/r8xjYrpb67pdBk/661PVkQC+DK7GurETctTytOqA==
X-Received: by 2002:a17:90a:bc85:b0:23f:d7ea:6212 with SMTP id x5-20020a17090abc8500b0023fd7ea6212mr4269644pjr.38.1679515116871;
        Wed, 22 Mar 2023 12:58:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 64/80] scsi: ppa: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:59 -0700
Message-Id: <20230322195515.1267197-65-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ppa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index c6c1bc608224..909c49541984 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -972,7 +972,7 @@ static int ppa_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template ppa_template = {
+static const struct scsi_host_template ppa_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "ppa",
 	.show_info		= ppa_show_info,
