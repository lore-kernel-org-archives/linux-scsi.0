Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8215DC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267E12225E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDukm1bp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgKPHuh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgKPHug (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 02:50:36 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2527C0613CF;
        Sun, 15 Nov 2020 23:50:36 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 81so4092325pgf.0;
        Sun, 15 Nov 2020 23:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fXZ0Y2LRL/rfunqIOF6yRFDaxDl0MTFKNEqvS2WDbvo=;
        b=rDukm1bpLxDGwB7pdXYCH/9tvNIIqF6PVBO3sgQqkkxkQVM565qCzrOrw/IMepl64G
         hw0CZqr6EcBMqY2k0ZLcNmQvy8A631Bl0RjSLt/IJlK6V9lgiHl8py5zb72BUSK/Dpnx
         RIXYkHYcYnXp9NbRRpLJjigu0DQKxCMCdjSWsgwic7I/g+xCn6Y0RaOny/0k9prB3a+/
         uyZlrBE+/aTKlzKe6an2QPMgnDqFKXJX8E1RuDh9pHmYDFlXHt/w26IF0d7swZoBxMPn
         NVKNkJO/+a4znFr7MG9Se0Y5LoChlC6dQLxhaJegOrsmo96zQdQDYPrGAtJCAshM50XL
         qONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fXZ0Y2LRL/rfunqIOF6yRFDaxDl0MTFKNEqvS2WDbvo=;
        b=EDxuQZyyFeLMdY/odIWr5OVfThd6sB9khKKrwB0Bw9tLAUR3YOezkNuq5yC3xp9d8z
         CaRRt7tOo2PkYSa3Tr7BIlPMRUjXt1ct0dd9g78rUkzHnOuIUEgGqBZ6tbppJhDLXE04
         bbi+O+wwoBy+uMwTxMaPkHg8zteWi9t7w+v7j/XTTO6tT7BpMxybd4lIkDt7nmwcKF7c
         UadfMXdrZBmXQfu5mWOkOXLY8kvXi7pj5uNeHdAhdetaI8F+03dcPnH/duJCgKG1DH7b
         ZR6E+3iThYVJGm3SKgYMNy3fnue85aJaE4tq5Jn7W6DWLS6jACqPIUXpraC/AB7aXy2p
         FcMg==
X-Gm-Message-State: AOAM531ZLEoqW0W9tCH3UbuhEIkqge+3b0OMHaC9bTCD71w9Plkez6gh
        K+3huKnQP2ayeUBggyc2hNU=
X-Google-Smtp-Source: ABdhPJxPTsGJegQuO+20ZnGMCEFbzINma/k321tyJ86ou7b/ghg2lt8r7o8GvLqmt3m8/swoN/+DxA==
X-Received: by 2002:a17:90a:8543:: with SMTP id a3mr14947266pjw.13.1605513036454;
        Sun, 15 Nov 2020 23:50:36 -0800 (PST)
Received: from localhost.localdomain ([8.210.202.142])
        by smtp.gmail.com with ESMTPSA id d10sm16776574pjj.38.2020.11.15.23.50.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Nov 2020 23:50:36 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] scsi: pmcraid: replace atomic_add_return()
Date:   Mon, 16 Nov 2020 15:50:16 +0800
Message-Id: <1605513016-7357-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

atomic_inc_return() looks better

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 drivers/scsi/pmcraid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index cbe5fab..3e5b70c 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3381,7 +3381,7 @@ static int pmcraid_queuecommand_lck(
 	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
 	 * hrrq_id assigned here in queuecommand
 	 */
-	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
+	ioarcb->hrrq_id = atomic_inc_return(&pinstance->last_message_id) %
 			  pinstance->num_hrrq;
 	cmd->cmd_done = pmcraid_io_done;
 
@@ -3684,7 +3684,7 @@ static long pmcraid_ioctl_passthrough(
 	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
 	 * hrrq_id assigned here in queuecommand
 	 */
-	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
+	ioarcb->hrrq_id = atomic_inc_return(&pinstance->last_message_id) %
 			  pinstance->num_hrrq;
 
 	if (request_size) {
-- 
1.9.1

