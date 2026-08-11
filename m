Received: from outbound.st.icloud.com (st-2001b-snip4-11.eps.apple.com [57.103.76.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81A044C670
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465376; cv=none; b=HxNJn3C2wEamUe9OlwkpT0NKTqahs68vMiEQKc/inAXUiYYS74smf7ZBHXMU741bjPKU2yusRBV7VnrpgwmnFrwVuT3Fvyuk5wKffXu8zn8QPQVPRwJ2T6eerrXHEx/0Ms9cavP9k7JlD5dUldhvsx+Jyif0Md/Y6cEMCOmF4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465376; c=relaxed/simple;
	bh=0fPc6CARPcuAaajWRtt23gGGfR1jiXTnCmvuXPbfhcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz2LiyfFg+iskCiK8alX4+fOEM6UmNfogvOAwhrD2Wuj+5+NyVzRLU70a+6J87eo/aVL3k1SnbHcCOAn1cBlKmM9Gsja3cwukFEP9jv+Ykl72qp3BACh3ixc1D8AzQsrkURY9fEueBOVMAcbd8HoLHECoa2CT1YvPeB54E7e/Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=0DTKdtAM; arc=none smtp.client-ip=57.103.76.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="0DTKdtAM"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPS id E6C101801785;
	Tue, 11 Aug 2026 16:22:50 +0000 (UTC)
X-ICL-RepId: 019ff1a2-432e-730e-a388-a7b91807ae58
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCEkFXwVZAV4NSQJdAlkfQhQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786465373; x=1789057373; bh=SKbj1OiC/mTsqe+ug23DPAsn1yxr1ddVH2kyAr8TTnY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=0DTKdtAMXgxk4D/MXnE8RJ0/+h1Q5YIHjQgg/HiMTFB1d3aEBVFnhOkHDAWM1cw8tifbsFUtvm6jfsAHroyAfjl/UBGB7bv/1ydzNjsYPZtI7Na3FclQqOLAwp+sZdQxXQSG2BfWzccqbkiRT7z4kiU2wLyKvsJDmXG+o/GH1bLapCwrxpsBp1vlIDUGfl0n0aCCMdjzPULF1xu9xAMswEs1R++nlfBWEwBibSRyrH2nTvebK86XYDy/eX4ufWw53HDly5sQOebPUU9fjv/C3QfXY7OJ5xSsBmvygfNRtekPoHyyHLzo+RCIyCNN0CfY+3U/d3EmvwneGAhXONIIug==
Received: from machine (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPSA id 762AF1801784;
	Tue, 11 Aug 2026 16:22:50 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v2 1/3] scsi: libsas: Handle errors in sas_ex_add_parent_port()
Date: Tue, 11 Aug 2026 11:22:21 -0500
Message-ID: <20260811162223.411052-2-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811162223.411052-1-eshaan2031@icloud.com>
References: <20260811162223.411052-1-eshaan2031@icloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: EGe0L9IzSpxheSGvoowNgJeIKGi6R7SE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDEzNiBTYWx0ZWRfX1qHgB0wdOXto
 p22MGpcjUIQOLP9g1TFraCv09t/MoVKilGoG05NB3/L2FPAev6FmUoXDvf8YBEQfIk3WUIwW4n4
 qzYQJXtLWELjKE+R+cllVsQ6UuZotWkDjAev+JO0BiIKRlvk2ETrU5uIl/hBut6c/I2djTA/bGU
 lmw3D83l9RISML9ot1Az2k+AaaxRwGmEKw//to+6IXzx605CNTJwObMScPyL8UoqxzdrWUyS5om
 nrOVzWAI+eL9ZnHb1buMAi7efLNMip9VTyOhyZhyNaXEHe7zd6IEDt3H4HEPdfH5QS6IQXpipIP
 +XiIXIkFxnyrpx3ZwpAl8fvrR6MmHIEztgktzOTkFEKXV2/VjWzSojdL77jH0g=
X-Authority-Info-Out: v=2.4 cv=e5sLiKp/ c=1 sm=1 tr=0 ts=6a7b4c5b
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=i0Imq2-WVZI-w4_-C1cA:9
X-Proofpoint-ORIG-GUID: EGe0L9IzSpxheSGvoowNgJeIKGi6R7SE

The function sas_ex_add_parent_port() uses BUG_ON() if sas_port_alloc()
or sas_port_add() fails. Change sas_ex_add_parent_port() to return error
codes to the caller and free the sas_port_alloc() allocation. Also
change sas_ex_discover_dev() to handle errors returned by
sas_ex_add_parent_port().

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
 drivers/scsi/libsas/sas_expander.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f471ab464..f1a1417b0 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -33,19 +33,29 @@ static void sas_port_add_ex_phy(struct sas_port *port, struct ex_phy *ex_phy)
 	ex_phy->phy_state = PHY_DEVICE_DISCOVERED;
 }
 
-static void sas_ex_add_parent_port(struct domain_device *dev, int phy_id)
+static int sas_ex_add_parent_port(struct domain_device *dev, int phy_id)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *ex_phy = &ex->ex_phy[phy_id];
+	int error;
 
 	if (!ex->parent_port) {
 		ex->parent_port = sas_port_alloc(&dev->rphy->dev, phy_id);
-		/* FIXME: error handling */
-		BUG_ON(!ex->parent_port);
-		BUG_ON(sas_port_add(ex->parent_port));
+		if (!ex->parent_port)
+			return -ENOMEM;
+
+		error = sas_port_add(ex->parent_port);
+		if (error) {
+			sas_port_free(ex->parent_port);
+			ex->parent_port = NULL;
+			return error;
+		}
+
 		sas_port_mark_backlink(ex->parent_port);
 	}
 	sas_port_add_ex_phy(ex->parent_port, ex_phy);
+
+	return 0;
 }
 
 /* ---------- SMP task management ---------- */
@@ -981,12 +991,14 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 	}
 
 	/* Parent and domain coherency */
-	if (!dev->parent && sas_phy_match_port_addr(dev->port, ex_phy)) {
-		sas_ex_add_parent_port(dev, phy_id);
-		return 0;
-	}
+	if (!dev->parent && sas_phy_match_port_addr(dev->port, ex_phy))
+		return sas_ex_add_parent_port(dev, phy_id);
+
 	if (dev->parent && sas_phy_match_dev_addr(dev->parent, ex_phy)) {
-		sas_ex_add_parent_port(dev, phy_id);
+		res = sas_ex_add_parent_port(dev, phy_id);
+		if (res)
+			return res;
+
 		if (ex_phy->routing_attr == TABLE_ROUTING)
 			sas_configure_phy(dev, phy_id, dev->port->sas_addr, 1);
 		return 0;
-- 
2.55.0

