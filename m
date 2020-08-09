Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA27C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 22:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C41B206C3
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 22:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPDzhuDR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHIWMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 18:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgHIWMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 18:12:10 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5CBC061756;
        Sun,  9 Aug 2020 15:12:09 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id 77so6067750ilc.5;
        Sun, 09 Aug 2020 15:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AvS+7tcJ0luMeV/+/W9Zg4dLmU8DE2mswXm9rvs/puw=;
        b=bPDzhuDRNATpcyga4HNTi0dfLxnNQABh/P+JFjBFSIOdDMBkln5HygQaf20NcNhsH9
         2g419KBQZzNESaeg1/io5lBP/Zq1GatosAaavFp5KCKzkPb2T8D/dkBMRzS8zBR5ztLj
         bfochdCHk1AB4vEhP7RxMMpMwLhiSUaR0EI2nSBCKuo8ixk+STepYlJccyWStq6dZFcw
         Xf5vLJhq0x5tyxyhEhuVRgPJKdyhYh4ZZVbgfJwUKSEMGHzMReam6vshT6oVvWhjMeSJ
         7FSsEgLBEHc1ACGZSw414lYdDOeW0eGODBjpTHXgPxVcwhBmhdBiiXIhKncLXTdcKWmR
         qVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AvS+7tcJ0luMeV/+/W9Zg4dLmU8DE2mswXm9rvs/puw=;
        b=gS2XzhRYZDhIoO9uWTsCWxobEIXJtcoPf0/UGSLKglpiJw+y+WJI4ztmVayW6Tq/do
         TJ3LCoBlWcE5rsT8sYKkiKxtjBjdvBeehBQv3pdZNyszqn0lWZsQjLQX+Xq9Qn6ayR6m
         ITws5R4A9eo8Jl16Xi2JHZlNvkfypowsqz4SELNQVS7e5oW6gw0pYENCrnJRAIjTQg58
         xpchePMkZbA6yweAmrhcBOCcoDyZu5W1VlBFc4ZGXjopwhNmBavqfi2orBXVUcm08cqV
         +Yxk6SjY44dYwDnDD2ztvV/ZL/10ZCrD/k6s9WjA3gdu23SnsPfiweVXJQ1XqpiLW0bu
         zifQ==
X-Gm-Message-State: AOAM533e72ObUxv7fWYNTJSyOw0AI5Dc3UmYlIPBRUaG71sfRK8vKj/T
        dWbAJzrVXoj+Zm7kwAsXQao=
X-Google-Smtp-Source: ABdhPJzXLGJoXaIC1nVF3xLJ/PVV/F0lSPYp8QI+5xZ66wuqAxFYNd8FqKfrq5TjULQ1HJOLubY0rw==
X-Received: by 2002:a92:c904:: with SMTP id t4mr15286161ilp.257.1597011129011;
        Sun, 09 Aug 2020 15:12:09 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id s85sm11070853ilk.77.2020.08.09.15.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2020 15:12:08 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] scsi: qla2xxx: fix memory leak if qlt_add_target fails
Date:   Sun,  9 Aug 2020 17:11:53 -0500
Message-Id: <20200809221154.12798-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the implementation of qla2x00_probe_one() the allocated and
initialized ha is leaked if it fails to add target via qlt_add_target().
Go to error handling path if qlt_add_target() fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e92fad99338c..81a58ae54909 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3457,7 +3457,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    base_vha->host_no,
 	    ha->isp_ops->fw_version_str(base_vha, fw_str, sizeof(fw_str)));
 
-	qlt_add_target(ha, base_vha);
+	ret = qlt_add_target(ha, base_vha);
+	if (ret)
+		goto probe_failed;
 
 	clear_bit(PFLG_DRIVER_PROBING, &base_vha->pci_flags);
 
-- 
2.17.1

