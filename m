Received: from out30-73.freemail.mail.aliyun.com (out30-73.freemail.mail.aliyun.com [115.124.30.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929633C19C;
	Fri,  5 Dec 2025 08:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764921803; cv=none; b=odFir6ZvYsH9p2GX841A32rG5pdgC9V5Opo5ilvuMLDjrHn03ekLz9Cc2Ol9k2C94ai8yG7sf8aMOgiheDwwLbo0Z4U3ffJPpYlF0nWij0h7KCqhbRu8gv0jUeUkh/B9rFBDjjQSJC1IEyw+0M2n63dlv71Xo5IHLRLE0vX4PtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764921803; c=relaxed/simple;
	bh=8gjgWNsS9zZkeuIWGkw2PhPTE31rXSEKuw2fVxqY4AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bCJgyCu85FG2l2jVy6EZCdV0LBDZ4QK54KNrFAXl8hAq6foSGlgD45YZ8miC/tkyl4FWzScFegT/XMG0JCtHLPsIXkSxgOzaNLz5tV30ea0cMCdNx79C8XmGLdjKOQ4mrxQ2d9ZW+4oyjDG/EkcxykUjGD5GNSiFgFGWYPnm+5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=uCCoWNz4; arc=none smtp.client-ip=115.124.30.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="uCCoWNz4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1764921778; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=7BmwsBF1WmWYsoWEbb4GCyqrxff6DcB09pSzjzXqBVY=;
	b=uCCoWNz4w9m1O99DorDJ1vWUzNybAfnIGdGz/0p1KpnjRYXdi8+34LY6NdiYgr++1j1CvXtnrY/hzIK/n2CV5oesO5PaVRlYRxQr+6rDKipCNP6hgH1hS8fsxDF+p0nf6FjTcWSmZKKlgQh3TTykJsbASnDZpbKXZJWk69R2Ql8=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0Wu7HA-r_1764921776 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 16:02:57 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: john.g.garry@oracle.com,
	yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	wdhh6@aliyun.com
Cc: dlemoal@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libsas: Add error handling in the sas_register_phys()
Date: Fri,  5 Dec 2025 16:02:51 +0800
Message-ID: <20251205080252.1020028-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an error is triggered in the loop process, we need to roll back
the resources that have already been requested.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/libsas/sas_phy.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index 635835c28ecd..455118c7e889 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -116,6 +116,7 @@ static void sas_phye_shutdown(struct work_struct *work)
 int sas_register_phys(struct sas_ha_struct *sas_ha)
 {
 	int i;
+	int ret = 0;
 
 	/* Now register the phys. */
 	for (i = 0; i < sas_ha->num_phys; i++) {
@@ -132,8 +133,10 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->frame_rcvd_size = 0;
 
 		phy->phy = sas_phy_alloc(&sas_ha->shost->shost_gendev, i);
-		if (!phy->phy)
-			return -ENOMEM;
+		if (!phy->phy) {
+			ret = -ENOMEM;
+			goto fail;
+		}
 
 		phy->phy->identify.initiator_port_protocols =
 			phy->iproto;
@@ -146,10 +149,22 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
 		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 
-		sas_phy_add(phy->phy);
+		ret = sas_phy_add(phy->phy);
+		if (ret) {
+			sas_phy_free(phy->phy);
+			goto fail;
+		}
 	}
 
 	return 0;
+fail:
+	for (i--; i >= 0; i--) {
+		struct asd_sas_phy *phy = sas_ha->sas_phy[i];
+
+		sas_phy_delete(phy->phy);
+		sas_phy_free(phy);
+	}
+	return ret;
 }
 
 const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {
-- 
2.43.7

