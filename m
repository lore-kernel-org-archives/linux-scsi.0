Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D581C2BB3F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 02:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjKPCDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjKPCDN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 21:03:13 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB06199;
        Wed, 15 Nov 2023 18:03:09 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6be0277c05bso280993b3a.0;
        Wed, 15 Nov 2023 18:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700100188; x=1700704988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Th9lj+aGAw0IRo2uy0RbfTDSdNUMIUbSlSIvNRSZ8To=;
        b=Dr4dCdK8hMJbXhCOB9TkRutY289M4Bu9sZSFwrIIv+mfathQwL8swEsxGaNI1z8Ccy
         ntct32T3mrgVXDP8sqXBYRl5sfQ3j9XjXI5+Q8N8PuvCqDlFlUved01ZcywHWt7WORlw
         h/5q3zqIiXwHvYADe8ICCJAy6Nmp/lTiB+y7dcaxiK/huAWqUCLOz3n8VG1SUquXGc/r
         1hq42864aHFPlrgLAenAvMATWkVmrzimdcKhQlqamuaM3LhQkomNqWDYN8Vba8FLipKa
         Q4bhuuo1omKw4y3WWCRlg6sMsIw217u5ISIId+PjMfRXZ5WFai3SJNtzvrXIfhZq01mQ
         OD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700100188; x=1700704988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Th9lj+aGAw0IRo2uy0RbfTDSdNUMIUbSlSIvNRSZ8To=;
        b=mpYA2EPyTcW6pOPWHNN1X5PEKT8cj2hN8rN4Hv+9M6a24C+PNj+5Xq0QSK/oYuxouf
         J/MgLT0QnNjihp/BqZrZ6JopOaNcnjfVdc5eMIfcbL1IQpr9F5WT+88kOh9ClgGDT1JW
         bOuB3u2PlosgknC93AtHDmJc9kzqT06Y7cgEeWbOvg8q/jDu7VSsfZdpAvCRnLNWQWAL
         ZqQJ0tR4wwQ5x/O5mCjDM1uAHQpupQoZF9dXHA1mXr4IJ23v6B/458otVAqCLNiNuqMi
         VSuJkG3+h2xD3Cwhya/tZe6N9ugzgI1oCM2sCfan1zT6EjRD2MI3XhpzBs5LW9fFv9Jn
         Frxw==
X-Gm-Message-State: AOJu0YxYWuTlFCeF6dION9giEcpI1hriV9jaWBHt4Tz+Zp+SW2Q8LAMM
        KBTuZlWh9Cl3MQfL+z6X1UP2QvK7VC0DrIc=
X-Google-Smtp-Source: AGHT+IEBPLrFnZID1/lRKENL/IKG5994xUr1PV3o5p2zRisF/Gqa54OTbof+SlXP19NYV+iGIjUajg==
X-Received: by 2002:a62:ab0c:0:b0:68e:3772:4e40 with SMTP id p12-20020a62ab0c000000b0068e37724e40mr11743047pff.3.1700100187996;
        Wed, 15 Nov 2023 18:03:07 -0800 (PST)
Received: from localhost.localdomain (111-243-26-65.dynamic-ip.hinet.net. [111.243.26.65])
        by smtp.gmail.com with ESMTPSA id fe8-20020a056a002f0800b006c31b4d5e57sm3417037pfb.184.2023.11.15.18.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:03:07 -0800 (PST)
From:   Stanley Jhu <chu.stanley@gmail.com>
To:     inux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        peter.wang@gmail.com
Cc:     matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        chu.stanley@gmail.com
Subject: [PATCH] scsi: ufs: mediatek: Fix the maintainer for MediaTek UFS hooks
Date:   Thu, 16 Nov 2023 10:02:54 +0800
Message-Id: <20231116020254.10590-1-chu.stanley@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the maintainer for MediaTek UFS hooks since the origianl
email address is not available anymore.

Signed-off-by: Stanley Jhu <chu.stanley@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index be1cbc6c2059..45762cab2991 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22102,7 +22102,7 @@ S:	Maintained
 F:	drivers/ufs/host/ufs-exynos*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER MEDIATEK HOOKS
-M:	Stanley Chu <stanley.chu@mediatek.com>
+M:	Stanley Jhu <chu.stanley@gmail.com>
 L:	linux-scsi@vger.kernel.org
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-- 
2.34.1

