Received: from outbound.st.icloud.com (st-2001g-snip4-11.eps.apple.com [57.103.76.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0A6344040
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 21:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786396202; cv=none; b=KmJQCBQ3g6SpR1PNYvNzG/UH8TaoB2Afxkz1PWj+eWPSKqo0P7URLz+/Hf4kA9B+dRyadWGPjCgv8oTJS103/JvEdlLmC8UYUNYOzcwE508sgOcD0o1jLrPtp5yu4xvIfliZ55LGR/1cWAbFV92YUjPzNGYB8XyPaIhFsF7eV3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786396202; c=relaxed/simple;
	bh=0fPc6CARPcuAaajWRtt23gGGfR1jiXTnCmvuXPbfhcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LTxZraP7L70hSp4+Fjz/yKs9yIRueW/Xhv3hsTzKYxSBHL8lwzwYTtOEIJBctgzuRcd29Bg0eRBYQBEI6rAXi2PAhelTRj+J748Wuqc3U1eMAZP9YLhsee+UkO0bKxNjAAliJnnzHCpjlUH+Fky3Rq/fXHx42lDzBtejhjwwZvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=tWBZ3PkD; arc=none smtp.client-ip=57.103.76.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="tWBZ3PkD"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 53F661800097;
	Mon, 10 Aug 2026 21:09:58 +0000 (UTC)
X-ICL-RepId: 019fed82-c5a5-7213-8d94-85dabc6e7e6a
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCUoCXQ5fAF4ITQNbBlwfQRQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786396199; x=1788988199; bh=SKbj1OiC/mTsqe+ug23DPAsn1yxr1ddVH2kyAr8TTnY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=tWBZ3PkDt0+2FuNGc8TNms/H25Wyu5rItj3Nkfb2ruSwtDq6RZ0KQHviMqnAB3pm9P9ukV1i/g39JuKvcM8yBy7FlNY95OLY4o3YOFM5alv02JJnK7TpmjsPh1nC6AygLmJyqyxdArIAhtHHWcuPhTYBZuCM8wo0bdWw8tlP6+APsRBNOqYyniLi8PEljj9UsXVJFzqNCp6YMGXwwIbnWWmXTSbyi/zUy6v/KdUr2AUGaZr07MP5/9qRwn/wij11plQUyctiFDNgQtupsLSVmqpl7kHGtBDkFYPlO9GyWl9o5T1xgK67PSuHlBDPEIIiTe6u5RXJ89Us+KR6XWE3Aw==
Received: from machine (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 822F71800122;
	Mon, 10 Aug 2026 21:09:57 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH] scsi: libsas: Handle errors in sas_ex_add_parent_port()
Date: Mon, 10 Aug 2026 16:09:42 -0500
Message-ID: <20260810210942.150617-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: DXJPRex64nYFv8MdqjPmkGRvguJrcJdq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDE3OSBTYWx0ZWRfX/NftYgaphkyX
 qfIkLip+BHWdKj2lyfVKkL2pDn1/Up4SaDIHftwOAt9GSlaT9/aUgIMQiy7VUwirmqS3xAZNFcQ
 aLp3cRKmfnStJTWZsTF6GTfyIA8mYR6RM+6gVe8q2UbUdb3yXGHL1NXGEt5wlypp4MxvGMKDYGg
 Ex+cTO73sHyjvqV3zA/0Ta3la5GfFLHm8/ppm3I0iYQj7CAF2aCHdvqultArPoJjJ7+52y76L2P
 3Mgj039M715V+R4hsexpj64jbZxvIrZ1qx7zvb//QZtzo2TKwD4KGGJe4VxixZJCd1p5KDygnyF
 /PPAWnGTuQX6Jf/j6DCuB26jNOfjB1MAgDs9P0YKU90SUydCXVQNUnQuoP9Mnw=
X-Proofpoint-GUID: DXJPRex64nYFv8MdqjPmkGRvguJrcJdq
X-Authority-Info-Out: v=2.4 cv=bNIb4f+Z c=1 sm=1 tr=0 ts=6a7a3e27
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=i0Imq2-WVZI-w4_-C1cA:9

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

