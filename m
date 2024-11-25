Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C39619066E
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732570428; cv=none; b=j3dWBfpmc/ge/EIQDbHKHzaj9/Vt8VB4W4Ko595I4vpzzwZnH2mxpXQbJt+UXfh4aGk1eHUfM9j0rVSyctY0E5Y95Ketznng5LT1Nfz8ynkHi9VDH88pLhFp+Wlg9Nlq3tP/FyaieGchmOXQgi7CQ9LYA73GzjgMHai+l/qG6fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732570428; c=relaxed/simple;
	bh=FJCgir9r43q+OZ4PRmfOhfkQS0321BpxnD73taY9x34=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=T+u+mvI81RB+QYD6ATXXKzjheYKqm6C0yFXAVbGLqlaCeBAq8kjnXDI74AsAIG98tIE9W5UzprfO9uMyASWNuhQn+BFFuf1sTD52OmY3qzYwcPgcASH1wNYXq4eWd3y+hqF3H6R+qDGyYh7JHzSt5njZcRJ0CYTvDoReWJ0lgf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kHkIbms1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kHkIbms1"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eaf1a11078so5888708a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 13:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732570426; x=1733175226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZFiria96SY7rAB8WC4WhApJxYJyN2EgdsNvBAbWFtYw=;
        b=kHkIbms1Hd+D6iCN+m5SJ5Mwq6mgX9H6wXtmM/TyaWVvgCEJ7VPPcUOJ8VVhhVMZRs
         DrETUa0KFT0L8BEuYjmsHdC6qFRNEY6jaw7P6m48L2ZX9OiO8S602VUKhQwlaD8ljYuW
         Mv7O2L6xN6ncQd1YEwcfCgy8Nq15jNJcX1nW3UI7PH5gNXciAkkmWhMyiPkvdTWC7pa9
         5hYZzAZjWm2m2m2pPrGQv12YRTY2GY9iH9h0HEFR8i2bae4qkay5vOSIrBgxAvwhSvnR
         jRPjgJ0ttbOSsQ9FSuZSiR1t7LCtOgVMxbnK562XKCTSSWCKsgUguQk1gO+VQD7shsjW
         QvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732570426; x=1733175226;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFiria96SY7rAB8WC4WhApJxYJyN2EgdsNvBAbWFtYw=;
        b=bZt5qN6P1/h1mGDl9VQVDW70/wXGr9sLZu3LvInyWFWwKkY6+oF+tpgpI+7kQ55EU+
         d3xU0IK5fJceioOZjLj0UrJbDILWBJ3URrE9y0dnb+68eS0h0iiet1jWRAS0VmWrDNED
         BFJul+1DwLLK0xr/5RaxtuBbF1bFq/MMO4639+Acb75RZiVZk+00PXCz8PtxiU84Muwl
         4Z4z5sM9F9UglO5JnrPioWZmFpwwhwLsZaqyQ/if8OfQg5tmlujH2h6VOSSidSuD7NBB
         YhTiT7HwyY/dHlLXArFs72lksWpKkqfBll4ittZY94JjrA1ToHaGnfXWFw+N+PhIa6T8
         LS/w==
X-Gm-Message-State: AOJu0YxRfDLDBmltb/XLgjiZG0zpgdvH4OQYMhahtBb9iEPNyHYNL7hh
	DgND1HuJWcDOwm5BfohCmmR8ck7w5gcqS6CqxSCutXJFgAa+1opYX3MzsP2XKMioW6oGNn4rUMl
	I+MZO0OJ1vA==
X-Google-Smtp-Source: AGHT+IFdlI9nCN5k8GNzFx1TNh03phoDVbU5lVpUSrRVeah+MwylZgTpu9MbxBT6MZOC4EESjMDv9OzlVWheLg==
X-Received: from pjyf13.prod.google.com ([2002:a17:90a:ec8d:b0:2e5:5ffc:1c36])
 (user=tadamsjr job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e8a:b0:2ea:a9ac:eef4 with SMTP id 98e67ed59e1d1-2eb0e22a6f1mr19324279a91.9.1732570426535;
 Mon, 25 Nov 2024 13:33:46 -0800 (PST)
Date: Mon, 25 Nov 2024 13:33:43 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241125213343.3272478-1-tadamsjr@google.com>
Subject: [PATCH] scsi: pm80xx: Use dynamic tag numbers for phy start and stop
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jolly Shah <jollys@google.com>, Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jolly Shah <jollys@google.com>

Other commands were not aware if tag 0x01 was in use or not which meant
multiple commands could share the same tag number. This changes prevents
tag 0x01 from being used by multiple commands at the same time.

Signed-off-by: Jolly Shah <jollys@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 37 ++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a9869cd8c4c0..57c5970c04d5 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3335,10 +3335,11 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 phy_id =
 		le32_to_cpu(pPayload->phyid) & 0xFF;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
+	u32 tag = le32_to_cpu(pPayload->tag);
 
 	pm8001_dbg(pm8001_ha, INIT,
-		   "phy start resp status:0x%x, phyid:0x%x\n",
-		   status, phy_id);
+		   "phy start resp status:0x%x, phyid:0x%x, tag 0x%x\n",
+		   status, phy_id, tag);
 	if (status == 0)
 		phy->phy_state = PHY_LINK_DOWN;
 
@@ -3347,6 +3348,8 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		complete(phy->enable_completion);
 		phy->enable_completion = NULL;
 	}
+
+	pm8001_tag_free(pm8001_ha, tag);
 	return 0;
 
 }
@@ -3627,8 +3630,10 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 phyid =
 		le32_to_cpu(pPayload->phyid) & 0xFF;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phyid];
-	pm8001_dbg(pm8001_ha, MSG, "phy:0x%x status:0x%x\n",
-		   phyid, status);
+	u32 tag = le32_to_cpu(pPayload->tag);
+
+	pm8001_dbg(pm8001_ha, MSG, "phy:0x%x status:0x%x tag 0x%x\n", phyid,
+		   status, tag);
 	if (status == PHY_STOP_SUCCESS ||
 		status == PHY_STOP_ERR_DEVICE_ATTACHED) {
 		phy->phy_state = PHY_LINK_DISABLE;
@@ -3636,6 +3641,7 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		phy->sas_phy.linkrate = SAS_PHY_DISABLED;
 	}
 
+	pm8001_tag_free(pm8001_ha, tag);
 	return 0;
 }
 
@@ -3654,10 +3660,9 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 	u32 tag = le32_to_cpu(pPayload->tag);
 
 	pm8001_dbg(pm8001_ha, MSG,
-		   "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
-		   status, err_qlfr_pgcd);
+		   "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x tag 0x%x\n",
+		   status, err_qlfr_pgcd, tag);
 	pm8001_tag_free(pm8001_ha, tag);
-
 	return 0;
 }
 
@@ -4631,9 +4636,16 @@ static int
 pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 {
 	struct phy_start_req payload;
-	u32 tag = 0x01;
+	int ret;
+	u32 tag;
 	u32 opcode = OPC_INB_PHYSTART;
 
+	ret = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (ret) {
+		pm8001_dbg(pm8001_ha, FAIL, "Tag allocation failed\n");
+		return ret;
+	}
+
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(tag);
 
@@ -4669,9 +4681,16 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	u8 phy_id)
 {
 	struct phy_stop_req payload;
-	u32 tag = 0x01;
+	int ret;
+	u32 tag;
 	u32 opcode = OPC_INB_PHYSTOP;
 
+	ret = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (ret) {
+		pm8001_dbg(pm8001_ha, FAIL, "Tag allocation failed\n");
+		return ret;
+	}
+
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
-- 
2.47.0.338.g60cca15819-goog

