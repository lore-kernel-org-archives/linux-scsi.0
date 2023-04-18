Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765EAC77B78
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 19:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjDRTCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjDRTBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 15:01:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE1B76A0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24726c47c65so1173052a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844513; x=1684436513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q705pkA7pRJMTNZuDFlVqTXdHPjT6mc0BG+foW8FYi0=;
        b=GqaVpB2zVNhyjotwG0yVhTUD2FgvGT2em4z75cUO2Etv9n/147+YOqB1E8CyE4fiv3
         JEf8JAbdkea0iZPmSHSc15ndLOJ2IkC4Sj6HeYSJdQpMsdA78+IA0GK/IKQA0r9nncfo
         bXcfgRJkYIJuIlbUNqa2N8hn3g3CWMlgBLhbNelz093pW51MxIt4CGWlAhGz2OtZX43h
         TcjF0s+XJQYHIgn75hlKWOQhCzDd3pN5zXhBXhWHoqrc2U9lC+qvgvrQeyD4dAmbJHrE
         LP1INYSdOeVG/U2wmrnEflyUDg8+aZwcaTznM3pehyzxkLgbWsyrxgPH5e78ZwEaBeSA
         hAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844513; x=1684436513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q705pkA7pRJMTNZuDFlVqTXdHPjT6mc0BG+foW8FYi0=;
        b=PzCF0h74KEoUaQFi+cmxe5yEFkI13tMN8fVDuE98WPo7lrrgt077/K3mGdFB8APxPt
         6iMSF/ZmXCAtMM5oVF4Z3+Iw2dyrJL+mRKmBvOWD8H4EXcFzLLxipoGXJrAtwrOP+ls2
         8eItAHgjYmZ9/43sD5n4i/XS8HLGB0wCRmsSOXq/o0REKU2MVO3l2yN0wfWn7V1AKUx3
         JiZo5zhcMcaZAz6BAR6T0coeNtBkRSlTunK2njOFlJ1E6rr+QQrJ1toWTiwBt/mCZtXv
         k4CQpl5UoGvYuXwEP+eUqCjrL3Rt+FveBeSdlNc+VmI5q3vWqeD31QEFiOxV45F3IE4b
         GXQw==
X-Gm-Message-State: AAQBX9fod/MS+vB7zobttTPCtJFb33qTg4w0Bo4wO/rVHzIidA3ksAJM
        w7J/b4uQicf+9V8NizSpxki5h2OVq4W2Vg==
X-Google-Smtp-Source: AKy350ZW8H2ie7PJ0xF/7HLOgOBlt+IodZxdPo3Cfwds2kbkKdjUEWeiqhOD74s3vqCqGAqiKyXioEQv/u4PSQ==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a17:90a:3182:b0:247:11e6:f6ff with SMTP
 id j2-20020a17090a318200b0024711e6f6ffmr260224pjb.3.1681844513734; Tue, 18
 Apr 2023 12:01:53 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:00:59 +0000
In-Reply-To: <20230418190101.696345-1-pranavpp@google.com>
Mime-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418190101.696345-5-pranavpp@google.com>
Subject: [PATCH 4/6] scsi: pm80xx: Log phy_id and port_id in the device
 registration request
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

Print phy_id and port_id sent as part of device registration
request.

Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c5bf65d0ad14..8571f6222eb8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4756,6 +4756,9 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
 
+	pm8001_dbg(pm8001_ha, INIT,
+		   "register device req phy_id 0x%x port_id 0x%x\n", phy_id,
+		   (port->port_id & 0xFF));
 	rc = pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
 			sizeof(payload), 0);
 	if (rc)
-- 
2.40.0.634.g4ca3ef3211-goog

