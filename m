Received: from outbound.qs.icloud.com (qs-2003b-snip4-8.eps.apple.com [57.103.86.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD527404E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786564111; cv=none; b=MCGMp89C2OSH3f0qhMfCJmG0QKhC7ynpwiy4v5f0jAgWDj0NdgNWfxmuR/kO8JBZFLMiB4z2wl73Nr/ohl/rHkOa23L/aJvHs9uljwPqux+F71PPuHUXkTSfF482oE05fnxUwbiAk3ALrM/TDMdf9646bljVkimNVgfoqPy2kVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786564111; c=relaxed/simple;
	bh=0fPc6CARPcuAaajWRtt23gGGfR1jiXTnCmvuXPbfhcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa6FCGhdOzlvVHBJg+HYl7QJlRaDf5CFesc8ipXmubTQIcEqfRFv+dCkhoOvFPMb7yU+UlVUKzsRWVAYLnAL/bEZj8IQJpZq3pFjRZUk4m/sbOOVHHNCu+79FKRgqNydmox2fXQa1bjkMCp+UZcifdyM2inkE0ozyREwyfs8uxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=IpqBEEGi; arc=none smtp.client-ip=57.103.86.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="IpqBEEGi"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPS id B863C1800322;
	Wed, 12 Aug 2026 19:48:27 +0000 (UTC)
X-ICL-RepId: 019ff784-dd93-7b19-866a-e06e2f141893
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBC0kKWQ9bCl4MTwVYD10fQhQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786564109; x=1789156109; bh=SKbj1OiC/mTsqe+ug23DPAsn1yxr1ddVH2kyAr8TTnY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=IpqBEEGiDS/DmH6EugjuiNiRGu+dvWXMTdlSodGLCrH98j7N44PbblqWgArXVvDvszbYxubaxFAYISDMFcgrD9npYviFcfCIVlwAa+6RovYsw/nSe6o4red2tKNVMgHBf43Iz7JbGe0DYjsvwbfjgoC8HJFAz6eyQnWdfMvHVAgYHc43/iKR+lhLv6fq4RBav8SLERWYE+4DrLd1BAo2CuiM6RNFYeJ4bJUuKDTBdIeevwEcrhzmR74PeturTh+1c+uRAqYtLN0cTIhBGAOe1ZIyy/Q4VAj7526dIhWK1W/mRszItAGdgpvsADtEMrBSMC3/txYzeTIvpq15seg/JQ==
Received: from machine (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPSA id A84F01800174;
	Wed, 12 Aug 2026 19:48:26 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v3 1/3] scsi: libsas: Handle errors in sas_ex_add_parent_port()
Date: Wed, 12 Aug 2026 14:48:06 -0500
Message-ID: <20260812194808.576586-2-eshaan2031@icloud.com>
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
X-Proofpoint-GUID: AoEA-HEhYXUbMdftH-8QKUBfMrv4DvWo
X-Proofpoint-ORIG-GUID: AoEA-HEhYXUbMdftH-8QKUBfMrv4DvWo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE1OSBTYWx0ZWRfX9SwKqogHlkKy
 PW8BazC8DgSkOLToIoZOT15f+y1xIZL952zMRazqMvBVZIalzfilkJ2tz93AVYoRY+qzV7AM3G3
 4zpM7a/BfxbejVt33jiF2PC8KtRjw856BhuEAuwlOapZWPHueEwaZCeOBZLug1p4HssEclZYkRN
 6E+tAQTPfciIGlWgsIkIR/MtigcgeohWBKke3areKsCrD1rNlnvioNAOB5Imf0GD17boyhh8ihQ
 OysWgJHKE0wBLqZYrtJbRCYM8YLoqYPch1Wo8Qba8cPwY8DOsRkSJkFO4/K6+Mdj/4N3eFRDsSr
 3zgQGwZs+Z2cjj/F6qQH9LYoJsls9veS4jegX4/b/ApyJeQ/n4BvvHjhYKmbgw=
X-Authority-Info-Out: v=2.4 cv=DqBbOW/+ c=1 sm=1 tr=0 ts=6a7cce0c
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=i0Imq2-WVZI-w4_-C1cA:9
X-JNJ: AAAAAAABlDIIYURcikXnCHpb8V1hZ4Q0f3WhAnutbLi/fCp8T16cLiJ1vZlw4QHVIhH54azwSS0JHH9Y0R4PRDGDHAN0wLm5o+0t6zcKvnwiwppud42fIoK0bGZggLkjAUsJSCIEW9KaVciP3WoD3IFFtxvYIdmFIp4S3XC/RjuJXsZyxaPfgEul/Y5LgbjlquGX9sAGx7eJb9+DdzYX7JWOalV51S7Bd8YvwuoQHb3wlqyLr6DahsNuTToZATnTqPIDB4QGysz4z7svbRwWATOTpBhe4RSVJWfL35WuxfQgOL0YjcJqVdJCofCNwExoCsNmLPiIlwj39F8Ql5AyeCNNjgHOtzYnfNEHqQwsbOBudWdUM8i+JLLGBYlQRclP00UMrScEg1TmqgwdoybATgHzrdRo/vmNZ5RHcx0ed9bnSHVXG/t7Egh9iLvpftvNeG4DzZtjsUT0jkNzimNzsi+vgQ5t+86JdIzEXYf4q7DgXaTd7Q/LWdhFKfRPVvyYcwfOJs0mqghdq+Nltj5TPt0FzuEq/B7lct+u3X+YTNTGZ2Rvj6CJeA1mNqgqhbBbQ5gGiiWkRAC6Ft31xTtVJ0kDUogS53OQRzSb/OabFTH4TYae+sAjbL9CNWYmpEcgTDcrMOzsgvZ+gYJBZv2kOUyqlm2EguKitqOlyQaNkHa1ZNF/z624UPQKdZ5hMvmu+wMpFY9+yOVAMufBOenoaGLo+gkg5dAA2yf2pRM0Xq1sVFE4WdorBf9w5klYMX4X17QvD1F1u/396mVJQY3gyTnIIpp5ud9QZ/gUTPW9

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

