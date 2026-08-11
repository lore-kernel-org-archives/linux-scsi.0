Received: from outbound.st.icloud.com (st-2001j-snip4-11.eps.apple.com [57.103.76.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC304570E9
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465383; cv=none; b=njap4za94NCy7bW2mGNv3xTwmE3k6uaaV2VMr70nE2Bzuk2uxFCwhvaR1iDlHZ2qqLOrwAyQbW5oHbsUo8TtSqWbRZIewAFT5h0L401qK1jCedj5QEXCb9NKd8t45oW+0oU7tnNlREvAbxhllaiiOjklFkMPOQpQMWWUIPqkDQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465383; c=relaxed/simple;
	bh=Gm5zOKSEWAhE3mXt3G0dNDJ/PcB4syl2jQ254qbijVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNUQKor27kzNoP99O3sAYsJlknIqzeCo3t3xcux0LUAk5UxA2FZYQSabAmIPDX846Ty/RJyLEcSfziIXutnIldoyhur9h9cGaneInzIKTiGs3p9verc2Ajao0sciN4/X4wNuX1rK/eQX33FDyg9DIsaVy/pDPyFLnjDBKf7Ibr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=gWCuBOkD; arc=none smtp.client-ip=57.103.76.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="gWCuBOkD"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPS id 0F10F1801786;
	Tue, 11 Aug 2026 16:22:58 +0000 (UTC)
X-ICL-RepId: 019ff1a2-62a8-7bf8-b2c1-b680490c13ea
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCEkFXwVZAV4NSQJdAlkfRBQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786465381; x=1789057381; bh=ZFPQIxawaE0fVlWGUO2XI7RNDYyUtq2a9C+Qje6V7+o=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=gWCuBOkDkStokkZeAFJ1+nes182oKjU4NCWZLr8VHxluxh0AoHwYtKhKz+7st9ygVBeONOzoHt/FH53F4lvDnR/B70TdFSlWL/XOqGudlmc5Apol3+crL04efEQZNqJ9Iam77xoMag2H3Xhpj8O2GUx6Ixoz5NkReG4jKYMXuYq2DP47RlbhGJYS3/phGNxq8pIpYlWoJTsTXenWDHkC0MtGd5+3CfFUg2/JNByrF6JBzceBqvK3fAszMnIt4Y1EIDkcgSdcZRc4JznziRjDrSTOT6BKAwEHj9zeX8PbH3hmVxR3I4Id29FlvNEJPTNcslUpb57KzjsQHWoL5avK3A==
Received: from machine (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPSA id 3099C18003A9;
	Tue, 11 Aug 2026 16:22:58 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v2 3/3] scsi: libsas: Handle errors in  sas_ex_discover_expander()
Date: Tue, 11 Aug 2026 11:22:23 -0500
Message-ID: <20260811162223.411052-4-eshaan2031@icloud.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDEzNiBTYWx0ZWRfX/8P4V9u6d7Ri
 Of3wz3XG0wWhzlgccqWW9eOqomcAKj0KQObQjux+do06I3NfEll69EFthrPG24l8jtDKwxIRxOd
 V9FkAQ4uknF8GBht3ScSi0rokd3r2FRkxrngFKiKZDdCbSzO4nNVugPw0HdOem/SE20mt8tNTtI
 fykbDmVSTnVewHZFIczIsBVEVhQ0cb0Oymf00v7iRkrFph8ODS0gqXF/8LLHGWurGOuni/Y4CGH
 OhlmP9+WwdqE8t+CoKUXD87ztAca17NWv9tp/vObsKFlfyZt3YQfprOYs6iP0u3C8W3u++VEiKS
 bSIFjWg9iDeEXiqlmBzeSC4ctjByzxkhx0CtZELBWohKeO4r91f9tqQiK6Yrgc=
X-Proofpoint-GUID: X0ND-97e00y0gjX4U9GofTpwOfV9NM5j
X-Authority-Info-Out: v=2.4 cv=NObYOk6g c=1 sm=1 tr=0 ts=6a7b4c63
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=G5qPdV8fadFp4kCsiFEA:9
X-Proofpoint-ORIG-GUID: X0ND-97e00y0gjX4U9GofTpwOfV9NM5j

The function sas_ex_discover_expander() does not account for the
potential failure of sas_port_alloc() for phy->port. It also calls
BUG_ON in case sas_port_add fails for phy->port. Add a check for
phy->port after sas_port_alloc() where if it is NULL, it cleans up the
child allocated device and returns NULL. Add another check for
sas_port_add() where if it returns an error code it frees phy->port,
sets it to NULL, cleans up the child allocated device, and returns NULL.

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
 drivers/scsi/libsas/sas_expander.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 1aa99e7c7..f9ae655a2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -925,9 +925,18 @@ static struct domain_device *sas_ex_discover_expander(
 		return NULL;
 
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (!phy->port) {
+		sas_put_device(child);
+		return NULL;
+	}
 
+	res = sas_port_add(phy->port);
+	if (res) {
+		sas_port_free(phy->port);
+		phy->port = NULL;
+		sas_put_device(child);
+		return NULL;
+	}
 
 	switch (phy->attached_dev_type) {
 	case SAS_EDGE_EXPANDER_DEVICE:
-- 
2.55.0

