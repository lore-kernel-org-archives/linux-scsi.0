Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39D5C76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 23:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjDKXJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDKXJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 19:09:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1391C1FD2
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 16:09:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e199-20020a2550d0000000b00b8db8a4530dso12574194ybb.5
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 16:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681254569; x=1683846569;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vOZGDB1tEns0ICitKu53mE4nvsxHCRDQzBuBh0aiQXo=;
        b=lgZi8uglWKHWhlXre4/ek2jQLOH6P1XWQav0/oTO33kn6oS/pGGIErN4evvKuwF0Vd
         Hr1TwkJDwSytn+K0vjw44D9QWqzU1QsWosxJXsWRy06T3WWUhm90RUJL0Fdn6D07Z8hQ
         1F5FTm7ycHRinDKxnMKO6SaaXE2OrXtRgSZKTQV4gxphwvJoHMqqf8+nAKv0IJQ3UaIG
         FLPoCUSCT4Y03iYtS237wvRS1kv3Z9w2BG8jiiPFop/H3VSr73ElY+MNbVIDflvxweby
         JKt7hpqChemH9QHLcVFo8EV5hEufC+Z2cUVQ4bMAezsoomraxAm++s22xFy9mZfZ8v7+
         XF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681254569; x=1683846569;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vOZGDB1tEns0ICitKu53mE4nvsxHCRDQzBuBh0aiQXo=;
        b=sS/DEF4UuZu+HC0DfzzAtB3LZLcqMHwaSzvaQZM8zHDTWsq2vUqThsSuH34fQ6fDpl
         TuRNqYmEwrkvMjvID/5qwc04HiJAw40/0OCGSrGcfNkyceFhGyPlWxbNjCt6ykKTYcbT
         2yCDzsQwgqZ82lrQKlEuHVHhGNY+/hmBU6eo6jtZjyS1mZCMqMIlnDg3rROd3d7iGeBu
         bDqISIhgzaT/dg7nzmpKPh1AbrUDCYsEVi4nl5iQIT3ViUreB5IZI0X522R/R43dGRJT
         ir8EVWfJYZP8TYDd3MaBHcNJDTfjLsn/zf65S9822AsqquwaiC5BqcLBVc36dCedT2dd
         ufxQ==
X-Gm-Message-State: AAQBX9cPMJ9xq/QE4Y/+twrslNi497MxdrpnR3+bQW2+cvuQVCRLpGAt
        Om4pACt1aoNU0nuXyTv0+T5JcA2y92a/iA==
X-Google-Smtp-Source: AKy350YIK1EZL1Y0TVSqyu3cdqYhqXtb6pb5aYRyZU8d6A+nXo20/b2ezoiZVi5EQq4vABuq7+bkN6hQ3uUEvw==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a25:6c41:0:b0:b75:3fd4:1b31 with SMTP id
 h62-20020a256c41000000b00b753fd41b31mr384659ybc.1.1681254569324; Tue, 11 Apr
 2023 16:09:29 -0700 (PDT)
Date:   Tue, 11 Apr 2023 23:06:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230411230650.1760757-1-pranavpp@google.com>
Subject: [PATCH] scsi: pm80xx: Log device registration
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

Log combination of phy_id and device_id in device registration
response.

Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index ec1a9ab61814..73cd25f30ca5 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3362,8 +3362,9 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dev = ccb->device;
 	status = le32_to_cpu(registerRespPayload->status);
 	device_id = le32_to_cpu(registerRespPayload->device_id);
-	pm8001_dbg(pm8001_ha, MSG, " register device is status = %d\n",
-		   status);
+	pm8001_dbg(pm8001_ha, INIT,
+		   "register device status %d phy_id 0x%x device_id %d\n",
+		   status, pm8001_dev->attached_phy, device_id);
 	switch (status) {
 	case DEVREG_SUCCESS:
 		pm8001_dbg(pm8001_ha, MSG, "DEVREG_SUCCESS\n");
@@ -4278,7 +4279,7 @@ int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(1);
 	payload.device_id = cpu_to_le32(device_id);
-	pm8001_dbg(pm8001_ha, MSG, "unregister device device_id = %d\n",
+	pm8001_dbg(pm8001_ha, INIT, "unregister device device_id %d\n",
 		   device_id);
 
 	return pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
-- 
2.40.0.577.gac1e443424-goog

