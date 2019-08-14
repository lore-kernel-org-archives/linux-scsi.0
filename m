Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA86AC41514
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABFB20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TS1hSags"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbfHNX5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38639 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbfHNX5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id e11so422890pga.5
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Dyvt2ksicsoiNb6kw0TlKNPmNElwcg+Ik4NHfYMpN4=;
        b=TS1hSagsGm68+EyWMv4Xaf5V8T1gHpGnwt3EmKiZRqMKAtkJgcUte+z5OFxCok3C49
         XQHvIk9t58zq5tQnJ0rd+FA/3/3W+hOA2BnoWhz60u//5XiNFYBgkNEc/pQvae+69hfF
         nST2njsU92mXJjW8LCbW1V9yWnUprGz54bw/Yov8ry6UKHwWq7WxTMER6IjbzXCnYbEd
         9ZRDUFRgvCs2FGH4kavfoiiohleEX0/xV6nd7oPa1bHV05cAXj0tPLEM7VjQISqptLn5
         xs78PCPBQp+ImMFeNAONT+ldS3vWyPLpWoT+82WA4dpTAljkRy+gjLAM5URD0Q99GFqN
         2nUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Dyvt2ksicsoiNb6kw0TlKNPmNElwcg+Ik4NHfYMpN4=;
        b=sSgoSOZpMoQ9qeShWhqqbySatDT1osQbqet8RY9+AYcZBhwZdFLIe5UeLt3/yGvtr5
         w8tfqMEQj1ElIoaALKIj7AEyMlLpR3sWArbQWc4VVuxRGJ30wyy/g7vdHLGgne5tnZO4
         D/LqSXi6uIyJ+dLi/ifdN5QekjH9s3TZRHnWcCvBkQugCvJ7R54OS/M1dWURN/XvaFPD
         FYE7FBiDwX2E6uwuteqZHpK8/rgzNu3MMySQMTmz0G7VSu6l1AlUV96mlZ+Sbm1Hyh9N
         YbdH02qrHLbhdjskDYUHZbMzsBJSXvtsDXDdhbeD6rPI647cCP7SyOgJkDsD+9zs2VtZ
         o7kg==
X-Gm-Message-State: APjAAAWJPHEo5HqH0gRRzJdu+GLHvhxRQHhsAUF06SLHlAYuzHQR9G9h
        v7dIHosTlSctzrTgnnLFDPofFjEN
X-Google-Smtp-Source: APXvYqwlETJ8aIg0e1Hyd3QVdQ3PJT9/qFSn5anz1Vs97fl2yzCXMpQr28US43UETkNrjSjHBELVuQ==
X-Received: by 2002:a17:90a:3465:: with SMTP id o92mr439134pjb.20.1565827053884;
        Wed, 14 Aug 2019 16:57:33 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/42] lpfc: Fix null ptr oops updating lpfc_devloss_tmo via sysfs attribute
Date:   Wed, 14 Aug 2019 16:56:45 -0700
Message-Id: <20190814235712.4487-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an admin updates lpfc's devloss_tmo sysfs attribute, the kernel
will oops.

Coding of a loop allowed a new value (rport) to be set/checked for null
followed by an older value (remoteport) checked for null to allow
progress where the new value, even though null, will be referenced.

Rework the logic to validate and prevent any reference to the null ptr.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 8d8c495b5b60..33c8bae49821 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3682,8 +3682,8 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 		if (rport)
 			remoteport = rport->remoteport;
 		spin_unlock(&vport->phba->hbalock);
-		if (remoteport)
-			nvme_fc_set_remoteport_devloss(rport->remoteport,
+		if (rport && remoteport)
+			nvme_fc_set_remoteport_devloss(remoteport,
 						       vport->cfg_devloss_tmo);
 #endif
 	}
-- 
2.13.7

