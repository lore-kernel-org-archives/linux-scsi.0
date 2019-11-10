Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6CCC43331
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB5F22583
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573354372;
	bh=RN5s4WwjmeKO7kh5V7ierCiAzxj8M84zs8kaJC64wO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=P1eOA0l+IaiSCXI2VvC+EgoEfjXZRxprbfgt0zyDxQJtZvmP31MoXHjg5n+TKiGbx
	 d9JuWIvL06LljJUEwBtXIRZ7Os4UmoG5QYO1QHTtLuQnRaT/hwjPUkuQO++Gro6LZV
	 2+nvuggE73ZRyAu02YeXceDvetE2gPLxrO0nblB8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfKJCwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfKJCvf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D3F522594;
        Sun, 10 Nov 2019 02:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354294;
        bh=RN5s4WwjmeKO7kh5V7ierCiAzxj8M84zs8kaJC64wO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7Ml2J5kKlYaUNioANv+Ppg7Vv7P2db63OAI2otb69MGRzYP12vM42j9/XxwGNNvH
         G9lUZkyIEOAQ6vhs7URLjWCkMIiLYvVlB+Gca9boVppsN8vYAF4Dc7w3VFIAhlxcXS
         sZjNpkV0WDNLvEPFqGdakAKFCWc+HGu6BiuWZsQ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Yan <yanaijie@huawei.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 33/40] scsi: libsas: always unregister the old device if going to discover new
Date:   Sat,  9 Nov 2019 21:50:25 -0500
Message-Id: <20191110025032.827-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 32c850bf587f993b2620b91e5af8a64a7813f504 ]

If we went into sas_rediscover_dev() the attached_sas_addr was already insured
not to be zero. So it's unnecessary to check if the attached_sas_addr is zero.

And although if the sas address is not changed, we always have to unregister
the old device when we are going to register a new one. We cannot just leave
the device there and bring up the new.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 400eee9d77832..d44f18f773c0f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2049,14 +2049,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 		return res;
 	}
 
-	/* delete the old link */
-	if (SAS_ADDR(phy->attached_sas_addr) &&
-	    SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
-		SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
-			    SAS_ADDR(dev->sas_addr), phy_id,
-			    SAS_ADDR(phy->attached_sas_addr));
-		sas_unregister_devs_sas_addr(dev, phy_id, last);
-	}
+	/* we always have to delete the old device when we went here */
+	SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
+		    SAS_ADDR(dev->sas_addr), phy_id,
+		    SAS_ADDR(phy->attached_sas_addr));
+	sas_unregister_devs_sas_addr(dev, phy_id, last);
 
 	return sas_discover_new(dev, phy_id);
 }
-- 
2.20.1

