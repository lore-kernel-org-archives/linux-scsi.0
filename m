Return-Path: <SRS0=Nr3K=4D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD04BC2BA83
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Feb 2020 08:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A177E2083B
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Feb 2020 08:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rhoz7O0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgBOI6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Feb 2020 03:58:21 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42611 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgBOI6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Feb 2020 03:58:21 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so6209464pfz.9
        for <linux-scsi@vger.kernel.org>; Sat, 15 Feb 2020 00:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=A87v22gjG4q/4Ilo9HDjwf1XNrfE8BtiBiFiwn1YvQs=;
        b=rhoz7O0aYKNvmkeGMk6B24VXCTtIgnkHInsuW9PpbQwwhR0VNUR/wSxxYYtun+/F8/
         RjPmPeXlMVSBGktmWn2dMC708+syqi5rv3fN1MgNToMaCHco4aEcJ8r+5cRWERrpFiz3
         muwVOL8mAPJy/qYtJQSm/VWfFf+kpY7w7k4ysYiztiQfIQUdvuurr09CBbJTJMpm6EZX
         CChvsb+wSaF/AwCbJyoncJkRjGL3LvI5LHPV8LRyVRrJFfQBGnrE0edBvb37EXPF3r93
         op+tF+sbGb7MZGr3f9gPSPCcupYFZ15B5W6Vz2bTXl9Juca92X+QpRtRYj6oJIDUIXEJ
         AJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A87v22gjG4q/4Ilo9HDjwf1XNrfE8BtiBiFiwn1YvQs=;
        b=DkhA+XNycKMwOESOox4ZuirUf+pMBnNyrNCWGwSWKaRzFV/1y1qHDV5nCNHS6wlKkQ
         LBEn4Pc8nU8lEMHynNDP+pR2yQ6pmb6MmvbzQfUxwk+eCGSxDPBMyG3hbrW618qngM9Z
         rDMmDgOMXa3AfTfdFXrSzCMHgDHrYdnDozXEtt2h3+GlUoiRXGwRB9KzAAApHlECG3DT
         ndBOPmhhaz0W3F/65VJmCCyS6g5iB+uNN0+1t1LtOm92ljiwCeQgB8J2equE6j4octgx
         GGZ/dBIGPvBztSw3Bi1DMPEtLji2+G7mSJXcf3d7/oalLObWbuW27TV9vDL4pmAF7gDy
         fjUA==
X-Gm-Message-State: APjAAAU3YVFiZIfPd3J6hJnmBbK4bGO+RRHWb03DqAVFuBJqVDX5ah7/
        GkRBQsJ+LDeYN0Zvg6TiHzA=
X-Google-Smtp-Source: APXvYqyfESZYz66a2+oj9RSyLZ03WeOiJVhC+euFBy9tMvCGf0fikbLXKejqkKbGR8L+7DCj7GH94g==
X-Received: by 2002:aa7:9908:: with SMTP id z8mr7049188pff.68.1581757100330;
        Sat, 15 Feb 2020 00:58:20 -0800 (PST)
Received: from localhost ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id d4sm9050914pjg.19.2020.02.15.00.58.19
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 15 Feb 2020 00:58:19 -0800 (PST)
From:   qiwuchen55@gmail.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, chenqiwu <chenqiwu@xiaomi.com>
Subject: [PATCH] scsi: core: fix a typo of coding format
Date:   Sat, 15 Feb 2020 16:58:15 +0800
Message-Id: <1581757095-11518-1-git-send-email-qiwuchen55@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chenqiwu <chenqiwu@xiaomi.com>

Fix a typo of coding format.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41..a89cfaf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1563,7 +1563,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	}
 
 	return rtn;
- done:
+done:
 	cmd->scsi_done(cmd);
 	return 0;
 }
-- 
1.9.1

