Received: from outbound.st.icloud.com (st-2005c-snip4-4.eps.apple.com [57.103.79.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D5385D7C
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.79.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787109837; cv=none; b=iqGegnVKiOXVvhaClqfi4VE/fU9cc4ot76xDKDA6IbJbK62CuOIBeAzPma8X9Vtim8nAgBvd7kTD0JVdsIQrjXZs1lUKyYN/KfdHojuYujwWuyFVF63s9Y5lANaV/PhftyNdZNPjpQoe0SOzMPt3pDurGprthizfaj5Kln1C7uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787109837; c=relaxed/simple;
	bh=K6lNrpxYxUNj7xS9Sj1i3MPuM0Xjp/K+B2ztxKfSAp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0WVN9FR8WTzuGqijfR1MzFirWpKqjV1ZccQYxxwP2l59POMpvkVT9aGdohtLbj8Ak7jKtdruOgvBEmausR61X2+qeqLkJZgBczmISKaLUJd3xhD7tFvodnnX9dwaFaWLnY9ny7Rhzh2+8QyZFtV7cZC2cpWmf8IMhPDigiljNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=DyVgUVqm; arc=none smtp.client-ip=57.103.79.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="DyVgUVqm"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id 51E231800113;
	Wed, 19 Aug 2026 03:23:52 +0000 (UTC)
X-ICL-RepId: 01a0180b-f648-7428-a77b-43e6f963a562
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKC0MFWgNeC00HQwZdBlBcHA4IRANTEVdKA14GK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUETV8OXh8EF0YZVQRHHl1WQBkZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRAAUkKXQRZAUIIVgdUBFwGRhRLHghEA1MRV0oDXgYrWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1787109834; x=1789701834; bh=CfSIEMIU8fz5D/RW2vvdqxds2IivGvHuZLoHdlr3P20=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=DyVgUVqmztDBYsQHgnGejNDZhHON5zKw2N2IBDA7H+gd4wpfMfUKVdzTu5jLafoCHYSQ2rylagrhjM9+t6DyuYMETpycyG3TisqB/FM5sEvPSKKZHNmhnKHR89pXUVhlahS35ovmfzILcNjs6t11bBb+0o8CUoPaAa1QCpnJ2JfgY4fePLVjpO3YFO+jsyG/gMktNdAG5eL53atQtlnGzHmIsUTTGHEwp17hmtyGz4KJN0vVcADDMCbAwlcBCHICx8pWk6NVLyAMeJafmQH+93HOQt4nfKek0c1CaOsEy9Kbbdhd7h2vqR5pJHV34DOeyf4uL3qHWjMzIYaTQAXnnA==
Received: from machine.resnet.purdue.edu (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id 76680180012E;
	Wed, 19 Aug 2026 03:23:51 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v4 2/3] scsi: libsas: Handle errors in sas_set_ex_phy()
Date: Tue, 18 Aug 2026 23:23:20 -0400
Message-ID: <20260819032321.493746-3-eshaan2031@icloud.com>
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
X-Authority-Info-Out: v=2.4 cv=O9g0fR9W c=1 sm=1 tr=0 ts=6a8521c8
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=PaGFxrA-4Pw6slCmviwA:9
X-Proofpoint-GUID: a2GDwC70-261bgYEUws4W1iv2uJaPQuC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAyMiBTYWx0ZWRfX2cPBB8u8GuRg
 VExuCyUP/maDFd/Aao4iYG6jzCTH/Wuw+e6DCi/5/0NVcTdztQ9BT22/krzNS66l05T8Yb00Rta
 G0a/ClfZtFz7fpLLw1d6ZTo67ZUAT5nM0PedG64spY8xf1RBTJ5LECgIMAv2SSI1Bqbrcd+k4Fu
 Dg6CKZ6MQ46rTHtP4wGQRCEdUAMS7AQzi00U/dKI23t7GFbgF5TjXQ4CbxGOCgRkDUS1c6TnZhM
 Kv61cYwxO8IQP4fbqOAmAYHNHpSWxa6XU14TKlCglPtn9OYXZacBl3p3vUyTRMTiDYJIalIl/fk
 qBlA1YoyKCfjgPsGBVWAiqsue07Wtq8V9j/82d0cNGtBVHzWPa5kzRLwfRcY78=
X-Proofpoint-ORIG-GUID: a2GDwC70-261bgYEUws4W1iv2uJaPQuC
X-JNJ: AAAAAAABElQRruP6sSBOe6BRCwrC8KAlsG4E1qbaXUGtB8AkFdydtMoMQ7LZmS7fUru2eVkoi3h0aWoSDzaTYC7vqsb8ZnJQqb+jGGPc5qfK4638MKMtSS0aDqNCsx15MbscabYvvbS0soXrspAaHjsUInK5hTnlvJEBABuPiAquRbnVNh4Xd4K26qmrqUUsuKYo5kS5r+nmf9OqMHmhWp4LaWmPuND9+PzsTwOfL/2iPjzDx8wQO0ED/5kmy8OFc6MqwtZhjDRziv7qqPhurXi1sESAAWqNoH3JMDeJJwYXjn0rW0tBTCFfpyqyTFoMoF2Ma2XBYFxm5GvYjEb2aHNdpBI/UoAerO+yhBZrLeLtN4dQuDe95mgYsfsPRSMBsz7JwE9BBKbyTj5f+8//riR2LxWF8O1d1Ry8x8k1JYMDDVJhi8Imu9fsDpvn325ptZDF7AGc7/06b4sBx3RsRDYa+J35SkFipywTLj3za/oCW8pf0UXCzmmbfR6AJaD6Wa4nW5Ugao4WYgMlYaR7vKT1i5V3AkJFnsfMRcr5CURVCMUnhAniuN/RNPQh+ZdoMNIa+b7c/SLjk1FgD9rfRReRdoy6K7z8IpHsc2HZckXpggPoFadiuKOOQ5jIVs8jeyao0wcQk5GC4YPBD/8HTrnoDn3A4exSiQZp7ULnjopVIVan7M11mmGC11Qwka6UNacSl5/+70sZfZM4nZTpcLspgeb4lazWRg8Fhw0eAqhJvx+s5WFj4fQ2pvEPJ9J1gGZyqjrnidZViXrlTsRjpg3ZUc8tlRJ7dz5e3dUFRmc+Bg==

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

