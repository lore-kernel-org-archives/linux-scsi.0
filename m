Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BBBC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCDAft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjCDAfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:07 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F7AD53C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:30 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id y2so4353205pjg.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8zmmOkwIoIKAWyiwthdityD4hZhxjndZB0ZAklYRAQ=;
        b=Z+ZXjfJJNINrWoTS0ZZS+GF/gv+ZFbPXbybAKkw27aLixCIrNKsF0FZydpJtt12LQ7
         7r5uoV5S66n7Owty/euXhshn9exUAzxPHTsWavH95h0kLXF5PFWyeMaSopV7wZSK6nk5
         +KUez5jz+op4RAlByRBZjEkSvuuA6uiqm8nZAFwywOYT0gx1tP3yMLRH+8P8UP/Wtvjx
         sQWApMBiHLNhSN+qyeTrgaj4qkcJsx5Jx/568wOyu5nNhC7GN5q2kzgKUrEygWIcQEm3
         rR/822OZ/F9Rnj5tkuK/aWywHqgXLxXlJ5hOVFhjYMWpVCyfqos3W2QuDbX7nSwMaHZQ
         aQCw==
X-Gm-Message-State: AO0yUKU2N0c2skPsmRTvRLMlGhxIkbzhbDzlFr0Wssgdly5JjKx/K5Hn
        Cf0aurIl+H12sFv3RFXL+oc=
X-Google-Smtp-Source: AK7set/4AW9tjpTYZY51nvvHey7LXZxoe+f8UBvttmDr3/swm0NLFLzjj+swYLEb7CwIXmCDVySvQQ==
X-Received: by 2002:a17:903:11c3:b0:19c:c9da:a630 with SMTP id q3-20020a17090311c300b0019cc9daa630mr4184602plh.18.1677890069594;
        Fri, 03 Mar 2023 16:34:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:28 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 71/81] scsi: snic: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:53 -0800
Message-Id: <20230304003103.2572793-72-bvanassche@acm.org>
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
 drivers/scsi/snic/snic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 174f7811fe50..cc824dcfe7da 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -100,7 +100,7 @@ snic_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	return sdev->queue_depth;
 }
 
-static struct scsi_host_template snic_host_template = {
+static const struct scsi_host_template snic_host_template = {
 	.module = THIS_MODULE,
 	.name = SNIC_DRV_NAME,
 	.queuecommand = snic_queuecommand,
