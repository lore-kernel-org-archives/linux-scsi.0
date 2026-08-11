Received: from outbound.st.icloud.com (st-2001c-snip4-11.eps.apple.com [57.103.76.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F18453A2F
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465382; cv=none; b=ngKEdJFVRZtG7Wv61qJT0Ha9ZcqaZgCSUuDKu5KnyYimiOnEqo30zswPSGPZfXkouSIXgtB8eNvkdtG6waaMZldqUcgCROJB42vqgcaq0cwppWjAW0m0nTaQRdmkQC36V2GqcgJdvD94+vO6qJW6mbhG5LeEiNR0D5Y7lBROsb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465382; c=relaxed/simple;
	bh=cDvzLlzFZYdah33bWCiHUL1zftZsV10gayUQkkOysic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks3OL3YD/lIDeQ+whnOg20CZMxVs2WAIjoq6+/oD/AWwknSuGOwtN4va478plopfI+J0DGDPV0G2GHAgmkHY96a8OMvnPWGLuGsEYATC7o3mp1ztcODmfkDdynv8pbACt1qZOQw77dbto4G8iVdHGF09kRjdIhRKtVymYxFhzIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=XqGtdR2I; arc=none smtp.client-ip=57.103.76.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="XqGtdR2I"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPS id ED5FC180039A;
	Tue, 11 Aug 2026 16:22:56 +0000 (UTC)
X-ICL-RepId: 019ff1a2-5a83-772a-aff9-8ae9e4fd2327
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCEkFXwVZAV4NSQJdAlkfQxQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786465379; x=1789057379; bh=05b0w/YtTgz36UUatu5KxFxKywEL0tdYAlUL3Cd6rng=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=XqGtdR2In79NUjjsjcmdUNjnuORCriKTvE+Yj4jSk1M8/DchS04UT8KVj7AUPVdt9Fzr46dXxypLwe/9bJ3HIuZzgS6FHpD+0mDwiPynQ5NmLtLveBlBe5Hkyk1jdm1STjGKCJrDug0wfOm6d6SckPQsXOl1ZksPBfsQfy9N6uVEFJgxffGVSHLE9kw4jW8a+c+oVV4MozIM5ybSnPO0oy47cSR51QJFnWktt4OI+Gg8Enm8Srh1qmJt2rz8R9BSunodK2Pma7Zg223DIOqoARdJxnSJRuefKvQkq6qZU80FY/qQdawwW0MMGpjxcq+qVNjbtE+hEp9mxZy6x7jyIQ==
Received: from machine (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPSA id 1B1A4180009C;
	Tue, 11 Aug 2026 16:22:56 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v2 2/3] scsi: libsas: Handle errors in sas_set_ex_phy()
Date: Tue, 11 Aug 2026 11:22:22 -0500
Message-ID: <20260811162223.411052-3-eshaan2031@icloud.com>
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
X-Authority-Info-Out: v=2.4 cv=a8Q9NESF c=1 sm=1 tr=0 ts=6a7b4c61
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=PaGFxrA-4Pw6slCmviwA:9
X-Proofpoint-ORIG-GUID: DXmDAf3rjoyH0vRbwwdnaWNECtvh10RW
X-Proofpoint-GUID: DXmDAf3rjoyH0vRbwwdnaWNECtvh10RW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDEzNyBTYWx0ZWRfXw+sirHsPuQPP
 F14DHFc/AVXewcJeJmlkDr1nK7zeZY6w2lrSEzoFrUIqF77XbN2K3j8hXNJlh2wtbjVOTxh3a+T
 Br37rQA7Po8rUeAESb6r/kug7BJNZp0is9tfdfBMI9ySskcSUP3VZ/iFZtpiqf7Jmyl+VpWxtvc
 Vg468L9Xti89poZueRkjZ5TNHeghfz1vYoHz+1XpZLYo3hv+rxjFR76Bo10LqE46cV7rQuIechY
 qo9tICVQqyegbyowE9zO//vAyuar6Uo9Ecpv1PHZxcUTc6w1o+ZUcX0SH515tEQym6IWZi7j8/5
 phPBDoZ/6Edrv6+pSXEtb32WJuG7YzRtnxmYqSRLWTjRUAGT1bIJ5Z91XDYqgw=

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

