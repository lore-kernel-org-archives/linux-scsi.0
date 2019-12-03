Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1E9C432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 06:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2D612073F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 06:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U9np6V2j";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Vw2lnnHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfLCG6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 01:58:41 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:33938
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727337AbfLCG6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 01:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575356320;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=WY+EofIbsJ0ATyBUY39PBUF9SD8Hg6K0NfdwhCSeY68=;
        b=U9np6V2j3j2/rhzPirWafSVsRxLjxu4xlrUfB0RRV6Y3aUsTTgePVSCxd6XtG9Gm
        d0D4cY7kurDRvalGbjKBe9HPkrzQnS/4Gz4+I5R+1efN8do7Dx3scApodCVTPW7mJ6C
        Yx3yHRuZoKhTOtdWOaNp6h5qeZFHvw96Q4r/0Bqk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575356320;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=WY+EofIbsJ0ATyBUY39PBUF9SD8Hg6K0NfdwhCSeY68=;
        b=Vw2lnnHe/3cJm1euDEd9MqLD3tNCdpGXkU4bh+e1zN4k7gvgw+/hUViEbbvlG3qr
        zvw1VbNpfjTs25/7V65vAb0OXtDgbM2ob4lk7RADmHmd0UT31Lwnnf2Is7oAFQzyZV/
        pXBeAKWYykD0XJJ8LbeTeySP5+3EhJq4T45xwJ20=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 428FCC43383
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
Date:   Tue, 3 Dec 2019 06:58:40 +0000
Message-ID: <0101016eca8dc9d7-d24468d3-04d2-4ef3-a906-abe8b8cbcd3d-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.03-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an
unique ID by appending the scsi host number to its device name.

Fixes: df032bf27 (scsi: ufs: Add a bsg endpoint that supports UPIUs)
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index dc2f6d2..d2197a3 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -202,7 +202,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	bsg_dev->parent = get_device(parent);
 	bsg_dev->release = ufs_bsg_node_release;
 
-	dev_set_name(bsg_dev, "ufs-bsg");
+	dev_set_name(bsg_dev, "ufs-bsg%u", shost->host_no);
 
 	ret = device_add(bsg_dev);
 	if (ret)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

