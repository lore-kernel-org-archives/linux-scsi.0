Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C81C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjCVT5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCVT5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:07 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A92D59E7B
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:45 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id w4so12214651plg.9
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCdcj3LpvEBy9di6orhMZ8/sN2tsh1WV92aSckv+nIs=;
        b=QnmqXmMfB42cUpr1ARQtwo9Gv7qo/YwECgbr7gBGGc73vwPXzohQ7YSGo21mKz8tD/
         HtJrTlDlwEb0xi/ml35NQ8GXUIdW76pjQ4FymIB4WH9s2i3nPNLj7PQWquKCwp+G9rgx
         Vkep+z1q+J+AW5b1rfX4K+mbdAU2qvs8tCvgq72vLYNNqqGMtzfT0abYNc4GF+lZWKaW
         BqFIT7+yUKHysrqMp89Dw9WrJZ+aZREhl6PUIjQ5FaB7YJdQ+q2/3q9FdSDD3lLD8m2X
         HIf2zetTktcyY4RNyOKc0/RmPomcwcVJIwjSUXy5HC/HM6Lk2G0kBSpbLYpn6yuQ6+mg
         EA3w==
X-Gm-Message-State: AO0yUKVrHJ64uo6dOgVkoC7gv+WyxR1VaMSZYBEB6RtjanycEfUsIZjQ
        fdq9UMn8Q6MPNwZbclgpRBnNYA9R/c8=
X-Google-Smtp-Source: AK7set8ZiJq+9pWEaU7WNwnn0NUmgfVa1SZ4sHCwQ7z6gNIAn9fJwp5SXnHEYKHQ0aCeH+U1zmFpeg==
X-Received: by 2002:a17:90b:1b41:b0:23f:7666:c8a5 with SMTP id nv1-20020a17090b1b4100b0023f7666c8a5mr4911918pjb.29.1679515004363;
        Wed, 22 Mar 2023 12:56:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 19/80] scsi: aha1542: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:14 -0700
Message-Id: <20230322195515.1267197-20-bvanassche@acm.org>
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
 drivers/scsi/aha1542.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 552ca95157da..9503996c6325 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -737,7 +737,8 @@ static void aha1542_set_bus_times(struct Scsi_Host *sh, int bus_on, int bus_off,
 }
 
 /* return non-zero on detection */
-static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx)
+static struct Scsi_Host *aha1542_hw_init(const struct scsi_host_template *tpnt,
+					 struct device *pdev, int indx)
 {
 	unsigned int base_io = io[indx];
 	struct Scsi_Host *sh;
@@ -1031,7 +1032,7 @@ static int aha1542_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",
