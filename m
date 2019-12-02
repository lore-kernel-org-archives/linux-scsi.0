Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E6FC432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 03:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BCCE20716
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 03:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fvj/lJ3Q";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="A1rE1pTK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfLBDX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Dec 2019 22:23:27 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:41402
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727285AbfLBDX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Dec 2019 22:23:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575257006;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=ZNxLvDs36oSS4Z3htMA8E8//iOTysMv+jS6/jUpf1lg=;
        b=fvj/lJ3QB4D0hSQbYxO9bXcCUJYcdb1Qg+OuduP8Q38rlGyB2o5CG++/T/5B1ZHu
        HxC/CUkdFQSgyI00p3tAg7WMl3PKW6GHRhDSgun7wsXU9lV+qHGW4t2MrSyg1HPJZ3C
        7qjmwx9DYGjeTrzCgW061OfJT/gIj6RTN75djcGU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575257006;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=ZNxLvDs36oSS4Z3htMA8E8//iOTysMv+jS6/jUpf1lg=;
        b=A1rE1pTKUjQ8r7ZBL4zApUGzsVspq+0ObIZptIBiAYiT1kWcW4urW5VQ9VuJXgZa
        ZT302fXnSV2A4jrhZ1IYAhuU4D+Ojl6yxkjOvdvPf9hQNi8oIVPgzifz00rMXpuEzNB
        9RWQ/i9serc2BOKCfGfg1KW0ZK9qbPyzu4PwAZPI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 26AAAC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Evan Green <evgreen@chromium.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
Date:   Mon, 2 Dec 2019 03:23:25 +0000
Message-ID: <0101016ec4a25ed1-faa62196-1f0c-48a8-9cba-a433245d0ed0-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.02-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an
unique ID by appending the scsi host number to its device name.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index dc2f6d2..3ef5b78 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -202,7 +202,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	bsg_dev->parent = get_device(parent);
 	bsg_dev->release = ufs_bsg_node_release;
 
-	dev_set_name(bsg_dev, "ufs-bsg");
+	dev_set_name(bsg_dev, "ufs-bsg%d", shost->host_no);
 
 	ret = device_add(bsg_dev);
 	if (ret)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

