Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73FEC77B78
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 19:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjDRTCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjDRTCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 15:02:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C967ABBA8
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t66-20020a254645000000b00b74680a7904so27420100yba.15
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844516; x=1684436516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpvX6zUZ3jJSuVnzz4zMHHsJJxYIrejED2Kgcd4VmHE=;
        b=lrLE+nDGD3TZMrxvhsLtTXo+MNZ85rg5PEI9Nq6nxIGe6cjQJsYwtEVVtXsZvhPACp
         I+clHOcIZHU3sn0gZwgImhOcecFYUu2CF3TDngh8xKkpf839M9bc5GGFLd72Bhb0TvMc
         qz+OBU8XG1j8DkyljpLzjQh8qHIm8UpTufz0UUz7eEjof9zws82ra68q99kqYl8kMP/r
         uII2BDiN1wlpPZzd5POZ6XwzrbF1n3XYQZza6YnLSHtFX95okvT1Wpo07CrT5DzU0Fos
         QxTT/dNYmSHv1mQVBqX32MQ0+ebXb5Hq04VriTzYf+nyGMgXHDF15TEk2wKSiWl7Pi1J
         hUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844516; x=1684436516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpvX6zUZ3jJSuVnzz4zMHHsJJxYIrejED2Kgcd4VmHE=;
        b=QHnsTrPmyvCZBDj3iUr7L7BHCDCESa2eUarbVjkoEtkK1UA9jydW1tndN0waVGa48r
         EPRrQqYRjhCZtUBQVHIu+u57jP+zCWf0IF22IrXO75gHy5XUPoNFeGcpRkohCw8GEVlQ
         qYP8KMI4vwQElQQ7fqcbb45n4bsx2vTmMiptwfRR0UCwx7MTGTrHJs3jP41T+ZvVNTzL
         P2o1dTyDgkX/mMzSkhA7NuGATDNQPKVHFjvbx6rI4OsXXv6JYGqTN0UKLc0lehXMJjIc
         5Tw5XmdmiQAdK0huarTeAT0hwVUDQsKk6NxT/RVvXYoDpobh/nc//pEgxZbJa1MLfcfB
         Dmbg==
X-Gm-Message-State: AAQBX9cLvz0TqaOsznG8qksGgjnt/WmyZiLJv9aqAaTjTP9sn6FX8uxU
        +As5dHoOr3b7KwZL9E1IgkIY49NjQ2w9dg==
X-Google-Smtp-Source: AKy350bXiQoDmPFoIvILcrY2f0FNpLfWJ8niTeLDqT0R6Tk4Kel0fOd1zG2mwdLPANkMv7K8WZNnBU3DE4e+1A==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a25:df41:0:b0:b8b:eea7:525e with SMTP id
 w62-20020a25df41000000b00b8beea7525emr12896039ybg.5.1681844516750; Tue, 18
 Apr 2023 12:01:56 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:01:01 +0000
In-Reply-To: <20230418190101.696345-1-pranavpp@google.com>
Mime-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418190101.696345-7-pranavpp@google.com>
Subject: [PATCH 6/6] scsi: pm80xx: Update PHY state after hard reset
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changyuan Lyu <changyuanl@google.com>,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changyuan Lyu <changyuanl@google.com>

Update phy_attached, phy_state, and port_state to correct values
after a hard rest. Without this patch, after a successful hard reset,
phy_attached is still 0, as a result, any following hard reset will
cause a PHY START to be issued first.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 85908068b8d7..39a12ee94a72 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3417,6 +3417,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u8 port_id = (u8)(lr_status_evt_portid & 0x000000FF);
 	u8 phy_id =
 		(u8)((phyid_npip_portstate & 0xFF0000) >> 16);
+	u8 portstate = (u8)(phyid_npip_portstate & 0x0000000F);
 	u16 eventType =
 		(u16)((lr_status_evt_portid & 0x00FFFF00) >> 8);
 	u8 status =
@@ -3449,7 +3450,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_PHY_DOWN:
 		hw_event_phy_down(pm8001_ha, piomb);
-		phy->phy_attached = 0;
 		phy->phy_state = PHY_LINK_DISABLE;
 		break;
 	case HW_EVENT_PORT_INVALID:
@@ -3567,14 +3567,15 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, EVENT,
-			   "HW_EVENT_PORT_RESET_TIMER_TMO phyid:%#x port_id:%#x\n",
-			   phy_id, port_id);
+			   "HW_EVENT_PORT_RESET_TIMER_TMO phyid:%#x port_id:%#x portstate:%#x\n",
+			   phy_id, port_id, portstate);
 		if (!pm8001_ha->phy[phy_id].reset_completion) {
 			pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
 				port_id, phy_id, 0, 0);
 		}
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
+		port->port_state = portstate;
 		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
@@ -3608,14 +3609,17 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_PORT_RESET_COMPLETE:
 		pm8001_dbg(pm8001_ha, EVENT,
-			   "HW_EVENT_PORT_RESET_COMPLETE phyid:%#x port_id:%#x\n",
-			   phy_id, port_id);
+			   "HW_EVENT_PORT_RESET_COMPLETE phyid:%#x port_id:%#x portstate:%#x\n",
+			   phy_id, port_id, portstate);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
 					PORT_RESET_SUCCESS;
 			complete(pm8001_ha->phy[phy_id].reset_completion);
 			pm8001_ha->phy[phy_id].reset_completion = NULL;
 		}
+		phy->phy_attached = 1;
+		phy->phy_state = PHY_STATE_LINK_UP_SPCV;
+		port->port_state = portstate;
 		break;
 	case EVENT_BROADCAST_ASYNCH_EVENT:
 		pm8001_dbg(pm8001_ha, MSG, "EVENT_BROADCAST_ASYNCH_EVENT\n");
-- 
2.40.0.634.g4ca3ef3211-goog

