Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48220C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCDAc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCDAct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:49 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A86A1F9
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:45 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id h8so4511041plf.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvVVQ+ktXujbe64yu0zbTHHU9T+PctoEBb3huhrnTek=;
        b=dDeYY5ZI+886av7VdASKSVT7oHnnRO/52EVSTv0lyDSmpVPUCqNQXkQTOXLdd499mI
         d3p1Ojzprvv2+TWh4Xw5q+fdHK/+nC7hwwn0k2P2gF5g6wv/JZg89P7P4WtqKu45waxR
         CO0JkHM+UCs7jmCyxq/dhyGaCEVk/b1NXj/nXyByt1AK8OouWgD96F0XXPrJqwgG11fP
         hM1AN+uFDyel8N2fqi0nGtrZExNihYz69URdZt4Le3bip8KZPCpfhja7JHZVebadV0Y8
         FydXr9GeZFrjvaTz/Dpyqhw8qWjKqZXKn9Xd2FB9q2H4wePFKcPrRAvL67+ZkD0wqPsy
         /vqQ==
X-Gm-Message-State: AO0yUKXQkUiECPcTZBnsXpzRESH5+C1Q6kCSyF7gC/vGnlGJBQqUoZsq
        sfzU474075v1ARLGhXyugGI=
X-Google-Smtp-Source: AK7set9HkDbq5P0v10BfqfylRDmuQqezzWmk8hmDVZvw6u+IljM8PKOLN28/dWC+ZGKg09dQkgvLAg==
X-Received: by 2002:a17:902:f7c7:b0:19c:da68:337b with SMTP id h7-20020a170902f7c700b0019cda68337bmr2883888plw.16.1677889965214;
        Fri, 03 Mar 2023 16:32:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 30/81] scsi: dc395x: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:12 -0800
Message-Id: <20230304003103.2572793-31-bvanassche@acm.org>
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
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 670a836a6ba1..c8e86f8a631e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4541,7 +4541,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 }
 
 
-static struct scsi_host_template dc395x_driver_template = {
+static const struct scsi_host_template dc395x_driver_template = {
 	.module                 = THIS_MODULE,
 	.proc_name              = DC395X_NAME,
 	.show_info              = dc395x_show_info,
