Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFD3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354087AbiBKWdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347225AbiBKWdF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:05 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C761D4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:03 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id u16so12955649pfg.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2/KK3ljlz13CVV8qXKs236ffJpVlUU/PvjGqE48QTM=;
        b=BxyVgH92O2Dj4eKV4YE0vRs0oDiVwwaVIv16ELulTI3MqnAmwXr6jxT7yvg5aW5DTb
         H8cfJk81adEvRA19VNPgGT7BvE+btx5eos277MY1DK5sW6bzrML/oGG8Ow5JwpPKVxsV
         sxAtZIze+TkJUpEtqcGZTwRP2gF3WIbt7NuUTXo55IotQVcjBBBLOr1ExNRA5naSps+A
         /xNKj4qCRggvVBJsMoLQatJ5CyU57COgU1V2EtScCoF99goBIWWFjOcDaaoxmeY9Ab47
         qsuODt0S9vnuKXx2FmnldZbAYKtjjfE5ZQw4IUEoMKDzd+sDNPQ5qcd4Rjims5xNMQ9c
         3UVg==
X-Gm-Message-State: AOAM531pFci1tsL/mISIQNwKeEj4rR1aATqUbSHEncHIhdWZ6HKue0u6
        auJyynqewpHxyKoF+SvgbKQ=
X-Google-Smtp-Source: ABdhPJzjrxkW5qlZFWo6VcI9+9tBW3fvZjgbRyX7KPWwuKyIyq2JXmsApY8X6FWVdt5M09RiaHG79w==
X-Received: by 2002:a63:e207:: with SMTP id q7mr3056896pgh.593.1644618782940;
        Fri, 11 Feb 2022 14:33:02 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 01/48] scsi: ips: Remove an unreachable statement
Date:   Fri, 11 Feb 2022 14:32:00 -0800
Message-Id: <20220211223247.14369-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Whether or not CONFIG_BUG is enabled, BUG() never returns. Hence, code past
a BUG() statement is unreachable. Remove one such unreachable statement.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 498bf04499ce..0db35e97ce8f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -655,7 +655,6 @@ ips_release(struct Scsi_Host *sh)
 		printk(KERN_WARNING
 		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
 		BUG();
-		return (FALSE);
 	}
 
 	ha = IPS_HA(sh);
