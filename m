Received: from outbound.qs.icloud.com (qs-2005l-snip4-11.eps.apple.com [57.103.86.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F2346A18
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786399275; cv=none; b=O9PsYGNGSGAtxnUh75na2bpyqHxvGL1dVTia/ifFH6CPw8EmHPdm4U/FGj+KA/GeIu8qwQRP4+z7D428gKkWSvcJyrGvBAlQtjLizY9BuDDOqAHNJoZdI2plAZtKjaRLfE4hdNBvKvKKbZ6skb/HbPlkAVb+mpGOaKZ/sZsuAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786399275; c=relaxed/simple;
	bh=cDvzLlzFZYdah33bWCiHUL1zftZsV10gayUQkkOysic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DLR84HNjDCa7KySOV3rqMkuunnb5mrcyud1bmasPZVw7j6MRhY7qzzvZqFtjmQOPs1AMufWmu4B2rBZn1QB+S08TE+UuX4g4WUq/a9qZXOzgaHVs8a2kk7WG4Le1N7RjLOFTBZnIAkUuxsKRv71fuV63JbFHdnv6dC/sSAiFs2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=PVhc2gzg; arc=none smtp.client-ip=57.103.86.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="PVhc2gzg"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-7 (Postfix) with ESMTPS id 5A3CB180063B;
	Mon, 10 Aug 2026 22:01:06 +0000 (UTC)
X-ICL-RepId: 019fedb1-9617-7a53-86c3-e8685e0e1e11
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCUoBXQdfCl4LSgBbAV4fQRQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786399273; x=1788991273; bh=05b0w/YtTgz36UUatu5KxFxKywEL0tdYAlUL3Cd6rng=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=PVhc2gzgOCgGreEJyGZkk4fUDgjxgt2IJrbtGm/S4bQ6tAJMv5RCaOAEKiXlajBldHCmtthB/xf2WyCI0cr7bICdr1RdQEdArqtQ6+Ik5nHVlhLy4WjIhw+B00a99u+VcW2kwQTYVOWqS7FZ/82R2qp8VDu9hfula1zCVV16jwTqkhoBbvgW/nbfmJejY+woCRZlA0ltGBTUv/or2CIkSoK95NG46aQzwM6vZY4GCA9JrWqpz8xZ/CwuelN4y80O1Cw6b+k8M7u+8FHkDN7hH1eHYau/2LhuoXikHvFppZvcHQof8AlUDWpOBMWWNUmcub2ORQtf6d/nCVcpAy/UaA==
Received: from machine (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-7 (Postfix) with ESMTPSA id 185DF18002B5;
	Mon, 10 Aug 2026 22:01:01 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH] scsi: libsas: Handle errors in sas_set_ex_phy()
Date: Mon, 10 Aug 2026 17:00:48 -0500
Message-ID: <20260810220048.223665-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDE4NiBTYWx0ZWRfX4aRXiv9xK1lF
 ORt7YqqzHYGyDik8+iQsw6v2TO7wfmI7kbzCSdq1v0lrMlgJxFsWoZXz378ZJASEAS8PDnuJqwa
 ANXA2SrIVGEbRvkvuUH0eswrIziF+ifHzy2Dro5bOEpUda82yUekCtX3WmrMHUvAYboeI0OE/ZS
 uyeqk38TlYCczhHOXX3Rm+G97YsvboeZ1UfO0+m4CKK7+hhxRG29/Kp1NDtkF1zVRAaoHeRLDtF
 hnbbv/mhxPQ1Jeuo0PNoIM+5CqK5Fl5AaYFNPZYXOJp0Qh2S5Ch7P+BKN02Lp6moAn1pzhj6yxC
 4kJ/ujh+pgpD8nfktWDmYxKrb7jaOIXdy4qpyQ5mXgiCbVSMHiVqabiRuZ2YiI=
X-Authority-Info-Out: v=2.4 cv=aLv9aL9m c=1 sm=1 tr=0 ts=6a7a4a26
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=PaGFxrA-4Pw6slCmviwA:9
X-Proofpoint-GUID: Xxn41MBvxBFKIeEZlyjQCrKWzyIy11fi
X-Proofpoint-ORIG-GUID: Xxn41MBvxBFKIeEZlyjQCrKWzyIy11fi

The function sas_set_ex_phy() uses BUG_ON() if sas_phy_alloc() fails.
Change it to return -ENOMEM error code if that happens. Change all the
other returns in sas_set_ex_phy() to return 0 to preserve current
functionality, or to return an error. Change all uses of sas_set_ex_phy
to handle the returned error codes.

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
 drivers/scsi/libsas/sas_expander.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f1a1417b0..1aa99e7c7 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -207,7 +207,7 @@ static enum sas_device_type to_dev_type(struct discover_resp *dr)
 		return dr->attached_dev_type;
 }
 
-static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
+static int sas_set_ex_phy(struct domain_device *dev, int phy_id,
 			   struct smp_disc_resp *disc_resp)
 {
 	enum sas_device_type dev_type;
@@ -220,14 +220,15 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	struct sas_rphy *rphy = dev->rphy;
 	bool new_phy = !phy->phy;
 	char *type;
+	int error;
 
 	if (new_phy) {
 		if (WARN_ON_ONCE(test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)))
-			return;
+			return 0;
 		phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
 
-		/* FIXME: error_handling */
-		BUG_ON(!phy->phy);
+		if (!phy->phy)
+			return -ENOMEM;
 	}
 
 	switch (disc_resp->result) {
@@ -296,11 +297,14 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	phy->phy->enabled = (phy->linkrate != SAS_PHY_DISABLED);
 
  skip:
-	if (new_phy)
-		if (sas_phy_add(phy->phy)) {
+	if (new_phy) {
+		error = sas_phy_add(phy->phy);
+		if (error) {
 			sas_phy_free(phy->phy);
-			return;
+			phy->phy = NULL;
+			return error;
 		}
+	}
 
  out:
 	switch (phy->attached_dev_type) {
@@ -339,7 +343,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	    SAS_ADDR(phy->attached_sas_addr) != SAS_ADDR(sas_addr))
 		/* pass */;
 	else
-		return;
+		return 0;
 
 	/* if the attached device type changed and ata_eh is active,
 	 * make sure we run revalidation when eh completes (see:
@@ -353,6 +357,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 		 SAS_ADDR(dev->sas_addr), phy->phy_id,
 		 sas_route_char(dev, phy), phy->linkrate,
 		 SAS_ADDR(phy->attached_sas_addr), type);
+
+	return 0;
 }
 
 /* check if we have an existing attached ata device on this expander phy */
@@ -397,8 +403,8 @@ static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 		pr_notice("Found loopback topology, just ignore it!\n");
 		return 0;
 	}
-	sas_set_ex_phy(dev, single, disc_resp);
-	return 0;
+
+	return sas_set_ex_phy(dev, single, disc_resp);
 }
 
 int sas_ex_phy_discover(struct domain_device *dev, int single)
@@ -2021,7 +2027,7 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 		 * the PHY info, like negotiated linkrate.
 		 */
 		if (res == 0)
-			sas_set_ex_phy(dev, phy_id, disc_resp);
+			res = sas_set_ex_phy(dev, phy_id, disc_resp);
 		goto out_free_resp;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
-- 
2.55.0

