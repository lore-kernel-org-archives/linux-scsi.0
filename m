Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344BAC432C2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 05:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 062092146E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 05:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392121AbfIZFZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 01:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388040AbfIZFZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 01:25:09 -0400
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF53C796E4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2019 05:25:08 +0000 (UTC)
Received: by mail-pl1-f199.google.com with SMTP id j9so778460plk.21
        for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2019 22:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=1fe6UqqBNwxIhubj0sRC3S5FKZ0/ZDDNO4mSuZB59Wk=;
        b=n1WF46NrNcBwEC4zi/vXEoSYkF6qT7hDoUFhPLBjF5sBtNzTV4zO/ZgQS1E9gpf9eA
         KuHJNXf5s7Q9Yiol+GMiw+UrmFwVIXJ5YJ/kwn+DnqgHFG3nX4croV0nJLyzf+Z1uCC2
         pLUxYaTyTQWO7yKmRXAmfQVXMfXjTVp2dZQSjN4qP5ZhYcCF5O4JoOkSwdGXvGUHoumm
         yjZmmA8J0o5N1hTUL+ZrTgEMb0nIqmett7uIOaMElJRTkpuuoKy405xzHZSOAbKqph3P
         uzN+X43gx4mvhIL++TAB/GducYAHshoSRPm4dSM748VMTQ3Ob3VnFaSYjH3uXIy0q9G6
         q5EA==
X-Gm-Message-State: APjAAAWl6bJkJ0o9EGgPWkwi2GTJBISmSa25mStiyc/PdQ1F72gzMiBd
        h0sZilaz+1Fx2nt9jJEQn4Pue6dASivH88YEIW8ina1QkKKySBDj//hxB0h/BReYdvKbpTDZENc
        btidBxer1UuHnAuSpofd+ZQ==
X-Received: by 2002:a65:6802:: with SMTP id l2mr1591185pgt.33.1569475508154;
        Wed, 25 Sep 2019 22:25:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxZhfGBmsssKh0ogKtSVe/ksNJVJjpIgWoL6rEi2w/rMYGU2XFJYM2bNuWvlukSCiKtvvkYAA==
X-Received: by 2002:a65:6802:: with SMTP id l2mr1591156pgt.33.1569475507654;
        Wed, 25 Sep 2019 22:25:07 -0700 (PDT)
Received: from machine1 ([125.16.200.50])
        by smtp.gmail.com with ESMTPSA id t68sm1436660pgt.61.2019.09.25.22.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 22:25:06 -0700 (PDT)
Date:   Thu, 26 Sep 2019 10:55:02 +0530
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
To:     bvanassche@acm.org, loberman@redhat.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: [PATCH v2] scsi: core: Log SCSI command age with errors
Message-ID: <20190926052501.GA8352@machine1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Couple of users had requested to print the SCSI command age along
with command failure errors. This is a small change, but allows
users to get more important information about the command that was
failed, it would help the users in debugging the command failures:

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---

changes v2:
 - Changed the message to print SCSI command age as 'cmd_age'
   and not 'cmd-age' to avoid any confusion.

 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 39b8cc4574b4..0ccb4c95266d 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -432,6 +432,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	const char *mlret_string = scsi_mlreturn_string(disposition);
 	const char *hb_string = scsi_hostbyte_string(cmd->result);
 	const char *db_string = scsi_driverbyte_string(cmd->result);
+	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
@@ -473,10 +474,15 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 
 	if (db_string)
 		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "driverbyte=%s", db_string);
+				 "driverbyte=%s ", db_string);
 	else
 		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "driverbyte=0x%02x", driver_byte(cmd->result));
+				 "driverbyte=0x%02x ",
+				 driver_byte(cmd->result));
+
+	off += scnprintf(logbuf + off, logbuf_len - off,
+			 "cmd_age=%lus", cmd_age);
+
 out_printk:
 	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
