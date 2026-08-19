Received: from outbound.st.icloud.com (st-2005k-snip4-10.eps.apple.com [57.103.79.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63AC38B124
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.79.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787109836; cv=none; b=lsDOLQi3Esn71QPlR+/P3xifAwDUWt4ogySFTN4m1ED8MdO/bXa+LWVs1rGV9KJjc37XMs8Sm+d7h6XQd0Gt2rX1pKrcRT06IkBWvjiJZsxncs0kWw1X+Kr0voJde6auBGyE765JqPyB/ZSShsnaSxKjGPZIFga8U8A+pGsSVns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787109836; c=relaxed/simple;
	bh=0fPc6CARPcuAaajWRtt23gGGfR1jiXTnCmvuXPbfhcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0b55KD29gBkk/vl8o8AHb7Ac/pPUZpNBN8VGDbYEY2lYwV+xGMswo1cXOpmvt+lSqgyGA5i5UFlWtw2tRVnxmNKCKGnxkUaM1GIIL6I7f+K+np8/pYNixleiWT0stRN7usaT3HTiJ4FqdMmHHh9fJN6EMit3MVbrAFOLX2NXXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=R0XO/kHZ; arc=none smtp.client-ip=57.103.79.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="R0XO/kHZ"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id C249E1800103;
	Wed, 19 Aug 2026 03:23:50 +0000 (UTC)
X-ICL-RepId: 01a0180b-f03b-72ab-bddc-37aac77c513c
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKC0MFWgNeC00HQwZdBlBcHA4IRANTEVdKA14GK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUETV8OXh8EF0YZVQRHHl1WQBkZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRAAUkKXQRZAUIIVgdUBFwGRhRKHghEA1MRV0oDXgYrWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1787109833; x=1789701833; bh=SKbj1OiC/mTsqe+ug23DPAsn1yxr1ddVH2kyAr8TTnY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=R0XO/kHZ7NKqMwSs8KzgONas5J7/jFZXuxHssFLktv4F4G0mw1eIg2EdtYKsxwenQOV1F7pyMKcxXOXmNAA3RqRu5Zwb5dKGUE45Ef4wo9OyrTWla7GQntsOfVQ1NU8QVZcxx56Ftt3DQdHJ/g1KYWWcQzEB+cmGanmIDLvszHm3iOsKr45TgAWqiFpXYPlg0ZXXYNCzzCH0027qf7RHzAozlLCpmKDcOW7jnhiHndHQzDUwOBpMJPC/Hqi2AP2SRqyT0BHcFGAQU4z3x1VbvIMtOq92QQMij+KJJ8lVMHn8K2Hkyr6rmJGVjFKi6FJjJ5mGuQjWzm8OhvkXxI4Gvg==
Received: from machine.resnet.purdue.edu (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id DC4E318000B7;
	Wed, 19 Aug 2026 03:23:49 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v4 1/3] scsi: libsas: Handle errors in sas_ex_add_parent_port()
Date: Tue, 18 Aug 2026 23:23:19 -0400
Message-ID: <20260819032321.493746-2-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819032321.493746-1-eshaan2031@icloud.com>
References: <20260819032321.493746-1-eshaan2031@icloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LUoCaC8RCF02c614aNZjpjfVsB2Vn3_n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAyMiBTYWx0ZWRfXyBsyL0j60zcN
 ZCe0ZH4OGJjiNoNkfE6GH6k+fpB6vOmGVB16AmjZze1mhUvR/ChapVvKz1kBd6K7KTbHvmv/dul
 JRJPP72vDQqzqdaGGW7Ft/LQ9QOMIstv+iT6TwT2o+LcbiirpV/TM7QkgKcP+Z1Zb6agbckUFWj
 As3CUm8BNvL1NJLKhnJgtzsdWjg+cmrO7YO877JI7Zwln7U2QLM5uFZhq7byaYKB6DmyDN+INmw
 jc7AwTppXpBCF/0F2KaYNFGD8mq8fwdcJzCOhHZhwHkNi4eNsrCF1jo0EQA08LEvNsJHutj5U2O
 qlJgFVWPgoSOlXfS6J7b/ZFfxY7DUC0GEptPhrRt9ty6JJYO4grJhqPCeXjmVU=
X-Proofpoint-ORIG-GUID: LUoCaC8RCF02c614aNZjpjfVsB2Vn3_n
X-Authority-Info-Out: v=2.4 cv=UJDQ3Sfy c=1 sm=1 tr=0 ts=6a8521c7
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=i0Imq2-WVZI-w4_-C1cA:9
X-JNJ: AAAAAAABgH9eI67iUak/uIFN9mN6GFv8uzlJ7GKcRG1g0bUYKsTjFJXxOiZuCch+ZzutzRx3opcJRaw7nEIeLxs2sGIbnjVw1Z2a6Az7mfKCzgnETpYKB349fAQUufAknKDksF0aZMuIJj7fhIxsYJYLZ8s3A9WagO3QEss60mbpJBVhMxOmBTP67uV8wuJlz3uZ5DJjjU+0oO6CPWxLLdvlViNwssUIdbxpKwO8aiNjzxxifs3ZovnPcWhn5UYfjMHQRyGgBi6ZWKZnzAE9K92aToUPZn1w3Cp6pliB0fLiDfBeJxA64OFAqr31+2HkWF0cB8ZU1WmSgENmWfdc5spnWP9cpFT0QorgPjk9xCUiWpidkJnq+AotBzP9wCqF8DUQBpEfzlYkWXEZgPeGR/KUueZnWePD9B/c7rKxL6h+BSgnPcWQpITJDY3PSj/ZIqz7QRKQ5mOYm1BDonWTAkiDHyFf2g9I5jMlXu7D3F/++ZwdM/dx/boM2aFBbGYmOCxBpm+lUWwEqK1hWdxllueHHgSp2y8SHzEIWjQ4pMqRdk79/pvkm3Qpxsaw9bbQr6Uyfb4A/G0eoSROfWXsCRvVbX+CmUPKjRYAvVQyhZ1FZFdj0aEALaGEGHR3W5FBRpTmlGvE7ExQ0GpyhQb91bJnNmDVUNDwgdblvsm+/qD7sP27Jb+4nGDKEZOSPw5S99pHN5TnPTxGKfga9eIwZvSIgM0WUdyKWD+SgzyGRondJrimBGmoIbZ2kiEDPSRqB/Q99SwqRpvop6eH5DUjPX1K6KId5ffBZIHBpsENQJa1

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

