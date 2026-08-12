Received: from outbound.qs.icloud.com (qs-2005i-snip4-3.eps.apple.com [57.103.86.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28802316199
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 19:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786564116; cv=none; b=MbvHzYqQfMSLwAaWMfHFli46+xCE++0JrPykgdRcCfutkDETQWbUOAavaNQ4oHcZJ7fwbi3kMO2/Du23fIWZoT6hrlRPLQh3/mCDEgX6TOUF+8NhZaLMjLMBwoO6jdCPWtqket5V2j48ny++RCybWVtVuCvq6v3r+fZN6KhEPYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786564116; c=relaxed/simple;
	bh=K6lNrpxYxUNj7xS9Sj1i3MPuM0Xjp/K+B2ztxKfSAp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiXDXYjeEYO0k8CKJMs3mXwHD6AYN+phR5tt9Ft+DERTCCvLz8jsrXIUaEPR6LCYZsFeoubw9bS9DZPnzkP5E6GzrDJlREEf5Bq9M1YPVBey8lqU+pek1Yp+qUHKpH1MGMt4UTa/yKbAw+S6MceBSJWyf+Nr1ORF5jEwDFN5h6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=LkikD7LN; arc=none smtp.client-ip=57.103.86.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="LkikD7LN"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPS id B12851800161;
	Wed, 12 Aug 2026 19:48:30 +0000 (UTC)
X-ICL-RepId: 019ff784-e906-724d-85f9-9cb21c620025
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBC0kKWQ9bCl4MTwVYD10fQxQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786564114; x=1789156114; bh=CfSIEMIU8fz5D/RW2vvdqxds2IivGvHuZLoHdlr3P20=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=LkikD7LNFbwKmX63q5B/7MxcsyZXZb01t38DDfO7hiAWaTQuMdsglY9WxSDdsZ7TXCfxHOCGLlHXomKYgmqQIRZCgW28/gEcFdvAL5JcH2Zh+0tP4IhUkp0WbfBxHqJZBPpDY/aeKKmNKjyEzjICjug8IH/8MKnVi6SIkq1KqJa5cLNX5kFbfD9l8vK7SMtsYWn9EceVDGWuIcFevhMoDHGQtt7I02gd6X0VsF53QCyKDFGExTH0lyfgLyjSV1kDBOvk4rNGWqz6q7PIpAIREyZHKWvrNUBAxfHqG1/+e5FfpjwegzJx6ZYnKcoRzNcPC5ZBvLIhnw2NccFae7wa8Q==
Received: from machine (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPSA id 429EF180030D;
	Wed, 12 Aug 2026 19:48:29 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v3 2/3] scsi: libsas: Handle errors in sas_set_ex_phy()
Date: Wed, 12 Aug 2026 14:48:07 -0500
Message-ID: <20260812194808.576586-3-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812194808.576586-1-eshaan2031@icloud.com>
References: <20260812194808.576586-1-eshaan2031@icloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=UchciaSN c=1 sm=1 tr=0 ts=6a7cce10
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=PaGFxrA-4Pw6slCmviwA:9
X-Proofpoint-GUID: iv_fbHm6iEXMP9r0FPN5I__5ISfdHJkC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE1OSBTYWx0ZWRfX10KnWZJJK9Kt
 ZoOfe9sma4RHGOM2qoLMoRsDcJWUEqCWtpgoOUx2hkb3fuSl7p4jthzqaHl0jTeMdRyhooNCkc2
 jUE5HI4xnr3HxqG4z/OUzHPWkVPUymEFxbAC9Qp7RWL31r0Mf3lBUnD3TH0pkNbIrgNXHaTTdyg
 FLuEjiy7g5lc0fwbRFRiTYk0b9c14PhdrlpgnKyahG92WuvbAvrZzmdVueh5dNLgxLoDyGbe1Jf
 SAmQwOhScCmlSN5ddR04Mvekzr6/SGvZkWVweWZbRUIPmtSz+CglAZYO6jKFKWEGd6Yhnhb3wgP
 A+ph8YjVydp4p9+i/wQ+Is4A0Zzcw1rtswxSXNO79Xj3kY6a4Z+RuMa+wFhjqk=
X-Proofpoint-ORIG-GUID: iv_fbHm6iEXMP9r0FPN5I__5ISfdHJkC
X-JNJ: AAAAAAAB+uhKp+6Z6LcU0ZmNdQjHFBqQ/v2fFDG4bJFdzTLso0aR4L+9em5Ou0midrn1AmqlXsZKyae72nZO2JQRVQ7W+YsUYz2a00oO1YknwUtqfuFBYYNHzx8KHac3yi41P32WnIB5ccppu/doIEY4F/gCBAalzwnMAapJORAyW69p3JW08eBnl+7wc+M4zkD+EEUj7z9kwhTwvlUMGZumFZYsadRVNebnAxO65g2QkQc6WIO81L8RUNOL9JF2HBZO4FaFpsgLHAgrakIPs6CueIZ7oAZ21JVaQhYlSxv5qlJ8O2UKC/vATpeb7Lq67dqjiRX75DFx6rvPE0BhVVp91OfCnXdCSz1dW/BgcvwDuGcLMcgp3BtZD8cgPYks2ghkm3uoYz1sGF/x3pDvlwDo8EeKMWC2JsMCUCDkfEKhoW95/h0TJ3VSMADDviTUBRzyLWxazx9Wo3mNouKwXazJZa/0b1RtE40CYX2PmgAhMoOdNB41OT+Kav7CZbjIvgf4QMsoIoR2mJdFxRWDO2O1N5zuCmEwgrJXnTl7+nrcGLQB1XpLhcJUCHP4YdJTDqsoavMTGu33r6QXMGvoQFvPDT6+75/BP9hRyA0ty3QlTaEJefhClTBe7CC+7+Nr4Thg7tfV2tXdSdzT/b3vFDmFNghQbC6fwlG/LqjT/GzYvoH7I9iVTUhHOySgcnkjQagHDEycTc3oMHPG276TgidEG2fUp3PnvJhM87YNejyDQ2oIbfKtRRAjlO2tmisTqE8QYTTfo3nGytEfSQ0E2alRCuNcYxuxvVgXtBYTwV1M5ijV+TmgPcOKrDc=

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
index f1a1417b0..ab6afbad3 100644
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
+			return -EBUSY;
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

