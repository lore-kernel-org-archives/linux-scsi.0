Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946D2C77B7D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 19:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjDRTCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjDRTCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 15:02:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E269023
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n66-20020a254045000000b00b95a177fbe4so1810434yba.18
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844515; x=1684436515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3f1EZFPL8iHspGFGaVTxk55voCz6/hxKfdvRSWrACZU=;
        b=c4zkBfftCqOGxIJfB9cQriVe/8h+ZPNmyfJOdK2vWCZJ2FY2PS3slFzP7qUWVUgOCO
         g3xzNpOdaDKxZJomDgGMM+sMCBb60KlfJqFcJbkbbjEKLCp73oaTNAs/fA0Sh+jE14ic
         9UsZd4nYf3ofU1ZDxyx2Db50ssQGkDhNSFV5wE8CR2/DVlefX7gxOtf33CCWur4DKsas
         2UcWpB8HKiCvO25zIln0pyDD7PoS42ITmu6WpyGPhZspjsXHZXwnDa4cX2ZDedqFbvCu
         UTFstZJwFFTSpROCCEr84N+7iD+LF2BceV20lBkZFUIO534srDc9R5H2tyyF6Iq8y9NL
         0lCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844515; x=1684436515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3f1EZFPL8iHspGFGaVTxk55voCz6/hxKfdvRSWrACZU=;
        b=RVNtL4d69P1HmfSRAJ42XrAZjjoYpb0RgbaJRZXA9ldscsss1un9Xr7UM9eiHPzYbr
         g/YdNuc1Jn8LKxGPy/Q5npo0ela6hu4T2p1gB96tKRxULX8gvVEnZM6+qmouoPRcO6OB
         Zfis2C1QJCHnAElT1sPOSvfCjOHWzLPrl5VAJHZ8w5ihRnesdPdYPCeA6g9Bqs37M27Y
         j9xHqMf/Q2ee9CDRUEB9RUonCy8xvuAHal3X9XIsBIjYFdqMle77BESV0OobQtVIuISl
         ANI+S/F1OotMEvMmb0DBYBV/MHZQQmH8wYfgMI9hDBD8W/u1ew72IPdv9BAGfmdMTikB
         QD5w==
X-Gm-Message-State: AAQBX9e3WiIbaZ5OOF8Eg1fFLUtHBF4Ex+IXeS4ko7V9hzltydfWVYaT
        fb1izjZ+gAT7SYMpnAD3stps9NIDbO5NPQ==
X-Google-Smtp-Source: AKy350YCcbz1nJnmfXHYzGDZ/EdbGZdCqGLDcT2Qn5dSB5nMPvR+vtcQtQKi6ETPcVBjZgM5cUT+vcf8aLN3kQ==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a81:b304:0:b0:54f:b95f:8999 with SMTP id
 r4-20020a81b304000000b0054fb95f8999mr490174ywh.6.1681844515385; Tue, 18 Apr
 2023 12:01:55 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:01:00 +0000
In-Reply-To: <20230418190101.696345-1-pranavpp@google.com>
Mime-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418190101.696345-6-pranavpp@google.com>
Subject: [PATCH 5/6] scsi: pm80xx: Log port state during HW event
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akshat Jain <akshatzen@google.com>,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Akshat Jain <akshatzen@google.com>

Log port state during PHY_DOWN event to understand reasoning for PHY_DOWNs.

Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 43 ++++++++++++++++----------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8571f6222eb8..85908068b8d7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3239,9 +3239,9 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
-	pm8001_dbg(pm8001_ha, DEVIO,
-		   "port id %d, phy id %d link_rate %d portstate 0x%x\n",
-		   port_id, phy_id, link_rate, portstate);
+	pm8001_dbg(pm8001_ha, EVENT,
+		   "HW_EVENT_SATA_PHY_UP phyid:%#x port_id:%#x link_rate:%d portstate:%#x\n",
+		   phy_id, port_id, link_rate, portstate);
 
 	phy->port = port;
 	port->port_id = port_id;
@@ -3291,10 +3291,14 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_attached = 0;
 	switch (portstate) {
 	case PORT_VALID:
+		pm8001_dbg(pm8001_ha, EVENT,
+			"HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstate: PORT_VALID\n",
+			phy_id, port_id);
 		break;
 	case PORT_INVALID:
-		pm8001_dbg(pm8001_ha, MSG, " PortInvalid portID %d\n",
-			   port_id);
+		pm8001_dbg(pm8001_ha, EVENT,
+			"HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstate: PORT_INVALID\n",
+			phy_id, port_id);
 		pm8001_dbg(pm8001_ha, MSG,
 			   " Last phy Down and port invalid\n");
 		if (port_sata) {
@@ -3306,18 +3310,21 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		sas_phy_disconnected(&phy->sas_phy);
 		break;
 	case PORT_IN_RESET:
-		pm8001_dbg(pm8001_ha, MSG, " Port In Reset portID %d\n",
-			   port_id);
+		pm8001_dbg(pm8001_ha, EVENT,
+			"HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstate: PORT_IN_RESET\n",
+			phy_id, port_id);
 		break;
 	case PORT_NOT_ESTABLISHED:
-		pm8001_dbg(pm8001_ha, MSG,
-			   " Phy Down and PORT_NOT_ESTABLISHED\n");
+		pm8001_dbg(pm8001_ha, EVENT,
+			"HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstate: PORT_NOT_ESTABLISHED\n",
+			phy_id, port_id);
 		port->port_attached = 0;
 		break;
 	case PORT_LOSTCOMM:
-		pm8001_dbg(pm8001_ha, MSG, " Phy Down and PORT_LOSTCOMM\n");
-		pm8001_dbg(pm8001_ha, MSG,
-			   " Last phy Down and port invalid\n");
+		pm8001_dbg(pm8001_ha, EVENT,
+			"HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstate: PORT_LOSTCOMM\n",
+			phy_id, port_id);
+		pm8001_dbg(pm8001_ha, MSG, " Last phy Down and port invalid\n");
 		if (port_sata) {
 			port->port_attached = 0;
 			phy->phy_type = 0;
@@ -3328,9 +3335,9 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	default:
 		port->port_attached = 0;
-		pm8001_dbg(pm8001_ha, DEVIO,
-			   " Phy Down and(default) = 0x%x\n",
-			   portstate);
+		pm8001_dbg(pm8001_ha, EVENT,
+			"HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstate:%#x\n",
+			phy_id, port_id, portstate);
 		break;
 
 	}
@@ -3431,9 +3438,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		hw_event_sas_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_SATA_PHY_UP:
-		pm8001_dbg(pm8001_ha, EVENT,
-			   "HW_EVENT_SATA_PHY_UP phyid:%#x port_id:%#x\n",
-			   phy_id, port_id);
 		hw_event_sata_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
@@ -3444,9 +3448,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
-		pm8001_dbg(pm8001_ha, EVENT,
-			   "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x\n",
-			   phy_id, port_id);
 		hw_event_phy_down(pm8001_ha, piomb);
 		phy->phy_attached = 0;
 		phy->phy_state = PHY_LINK_DISABLE;
-- 
2.40.0.634.g4ca3ef3211-goog

