Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734DAC43331
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4860321019
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573354569;
	bh=RN5s4WwjmeKO7kh5V7ierCiAzxj8M84zs8kaJC64wO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UfXP70YJ9O9fZ3j8cJrGdtLlaPJAN4izzh9cAoh0o56OfoPrFYBS2aeRij7btK2lt
	 7oyOytiYr8wwsYb4j8N6uob3Ui+cgAwu34ki/TiapD1XjDbnkmNm2RIDjuJ3faAbsd
	 1Xor3L0FVDYq1SL39ys7EsYC/BaIerQKbp4KJidE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfKJC4H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:56:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbfKJCuD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B9922582;
        Sun, 10 Nov 2019 02:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354202;
        bh=RN5s4WwjmeKO7kh5V7ierCiAzxj8M84zs8kaJC64wO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvENkaTDO+J7FMOonmJeQ0qekLv9pj3VCLKyCebQCYAyvwUDsLz7SfLwcqNW+29NW
         rsjPJv29O1VXUEq/b7vRg5TmpLIvfeMzJxsVSSt2aSpQxcNtrj7qxWGeepYqwoVYc6
         jv7oK82a2bDZ8d4H7IVPqBy4dkAeSEnMFlAWFRGE=
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
Subject: [PATCH AUTOSEL 4.9 45/66] scsi: libsas: always unregister the old device if going to discover new
Date:   Sat,  9 Nov 2019 21:48:24 -0500
Message-Id: <20191110024846.32598-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
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

