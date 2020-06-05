Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA69C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 20:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9271420810
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 20:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnk59KQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgFEUF4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 16:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgFEUFz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 16:05:55 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56763C08C5C2;
        Fri,  5 Jun 2020 13:05:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g1so8394219edv.6;
        Fri, 05 Jun 2020 13:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nstJ56S10Mn4mrJ9JyR68t1jQqSqoQheMqXAQ0zBz/A=;
        b=gnk59KQcm56k/Q5k11Pk6d9Ftr70nmkNkPNa67j1NPtlsJwirR5WSue6MvszHaKLtP
         cb3OaB6rvLIdxp/SEAA5uOSeIQQrCwKPPrOnjFv4BPKtkD/SchGji0ri6Vv+KzxgoWHi
         cs9T71KTfB/bi4VasEaYAR9qZIszLFS4hAE6Y6fYS/naMxNZQ36GB6JTv43U0LDqwK/v
         plZsOIEzec5AiL1lmk4kWJ4mAJWQbj91E+b9gbIuK+HpdNIpQMhCfCHgjUeJH9Sm041u
         hg+eQExfdaoUiXa72cB2efnXb7cSqdxzXfeFcvqRlwso0n4hM5Cy8qbeAzZ5hNTwVFDm
         k1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nstJ56S10Mn4mrJ9JyR68t1jQqSqoQheMqXAQ0zBz/A=;
        b=PPUCzC8Pu2NCsX9SPrvgb1+V4xmfTUb4wiIhE+mDt0rVlRTjQlI43+vQ1FyGOmkbFO
         m+k0wxhljgJV4A3BC4Xy30YVR/md+zK++Go4kUeUZ6k05Xo3r94WGGznAs3emjL/2jU4
         rwp8OgGuURMPASv/1V7STLqEuyYlpKeEpnu3pzhqjTwmgFIQDaOBe5+8B/qijoPYSiIJ
         XsGtMyZf0QWZk55UC1EfegYRUs4ODQjJ5+yk0y5aR8qR1oqhCLSx+dV6zmXpGR3vI1xh
         SShRdpz3N4BnAeAisCArE2N5AJlO3N2hF5TzLtj3PL/hFNruvJzftAdEK2eK2Dvut0V6
         +NXg==
X-Gm-Message-State: AOAM530sQje55ENPphYyRQ5XEwOB0inG2QtVhteUOmhW/5nHG2yX8F7z
        nuFO1GXPtLOz/hRetskIwMg=
X-Google-Smtp-Source: ABdhPJxMxLtnt9WdU5POVJH4RRr8ZfDR1pyWMd+zBghz5O+3TLvkrxyiSCDlbFJHgHW5RBG+PvLlHQ==
X-Received: by 2002:aa7:c69a:: with SMTP id n26mr10673786edq.2.1591387551870;
        Fri, 05 Jun 2020 13:05:51 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id b21sm5224430ejz.28.2020.06.05.13.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 13:05:51 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, ebiggers@kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2 boilerplate
Date:   Fri,  5 Jun 2020 22:05:19 +0200
Message-Id: <20200605200520.20831-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605200520.20831-1-huobean@gmail.com>
References: <20200605200520.20831-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add SPDX GPL-2.0 to UFS driver files that specified the GPL
version 2 license, remove the full boilerplate text.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h           | 27 +--------------------------
 drivers/scsi/ufs/ufshcd-pci.c    | 25 +------------------------
 drivers/scsi/ufs/ufshcd-pltfrm.c | 27 +--------------------------
 drivers/scsi/ufs/ufshcd.c        | 30 +-----------------------------
 drivers/scsi/ufs/ufshcd.h        | 27 +--------------------------
 drivers/scsi/ufs/ufshci.h        | 27 +--------------------------
 6 files changed, 6 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index c70845d41449..7df4bdc813d6 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -1,36 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Universal Flash Storage Host controller driver
- *
- * This code is based on drivers/scsi/ufs/ufs.h
  * Copyright (C) 2011-2013 Samsung India Software Operations
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
  *	Vinayak Holikatti <h.vinayak@samsung.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
  */
 
 #ifndef _UFS_H
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 8f78a8151499..f407b13883ac 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Universal Flash Storage Host controller PCI glue driver
  *
@@ -7,30 +8,6 @@
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
  *	Vinayak Holikatti <h.vinayak@samsung.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
  */
 
 #include "ufshcd.h"
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 76f9be71c31b..3db0af66c71c 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -1,36 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Universal Flash Storage Host controller Platform bus based glue driver
- *
- * This code is based on drivers/scsi/ufs/ufshcd-pltfrm.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
  *	Vinayak Holikatti <h.vinayak@samsung.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
  */
 
 #include <linux/platform_device.h>
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ad4fc829cbb2..ec4f55211648 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1,40 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Universal Flash Storage Host controller driver Core
- *
- * This code is based on drivers/scsi/ufs/ufshcd.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
  * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
  *	Vinayak Holikatti <h.vinayak@samsung.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
- *
- * The Linux Foundation chooses to take subject only to the GPLv2
- * license terms, and distributes only under these terms.
  */
 
 #include <linux/async.h>
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bf97d616e597..ef92c4a9e378 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1,37 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Universal Flash Storage Host controller driver
- *
- * This code is based on drivers/scsi/ufs/ufshcd.h
  * Copyright (C) 2011-2013 Samsung India Software Operations
  * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
  *	Vinayak Holikatti <h.vinayak@samsung.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
  */
 
 #ifndef _UFSHCD_H
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c2961d37cc1c..2c1c7a277430 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -1,36 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Universal Flash Storage Host controller driver
- *
- * This code is based on drivers/scsi/ufs/ufshci.h
  * Copyright (C) 2011-2013 Samsung India Software Operations
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
  *	Vinayak Holikatti <h.vinayak@samsung.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * See the COPYING file in the top-level directory or visit
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This program is provided "AS IS" and "WITH ALL FAULTS" and
- * without warranty of any kind. You are solely responsible for
- * determining the appropriateness of using and distributing
- * the program and assume all risks associated with your exercise
- * of rights with respect to the program, including but not limited
- * to infringement of third party rights, the risks and costs of
- * program errors, damage to or loss of data, programs or equipment,
- * and unavailability or interruption of operations. Under no
- * circumstances will the contributor of this Program be liable for
- * any damages of any kind arising from your use or distribution of
- * this program.
  */
 
 #ifndef _UFSHCI_H
-- 
2.17.1

