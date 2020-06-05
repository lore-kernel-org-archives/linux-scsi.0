Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459B2C433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF97207ED
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9KgVe3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgFETOx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 15:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbgFETOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 15:14:52 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340ABC08C5C3;
        Fri,  5 Jun 2020 12:14:52 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a25so11284462ejg.5;
        Fri, 05 Jun 2020 12:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VtjTYNoGgr1GHPhLx6n1B3qn1vNiQ0PJclvKumvfGAw=;
        b=J9KgVe3VvLVWkenR+GN+9YnfPlIPop33mi+c7jcu+Iy58wT6FVRPVi2RqLEDKs3zAj
         iRkVreDXQQdrr+60WQLcpo3AWciPQnZnEVwnPUIkvrvCszMXf3PAspdag9vhOCIp0FCv
         4g2BsTZ3uLp7KZwb7/EYvrZ4Cjn11XjDcmrYgKIKoQZvs+o1vEndrADYmpqGdXyW+27i
         2I0KR6dIq3KGP6w37MBLvkBnX68b/hIlRQvJX+u10NtmMf/u01m7r9d5B9QeU1i4YJXP
         a7W8lDSXggoyHBE3sFRDBSGaXCpgZE2fSdg1nFj3C199/ecxI9JU8SvVv+QjeGy/VVay
         ysvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VtjTYNoGgr1GHPhLx6n1B3qn1vNiQ0PJclvKumvfGAw=;
        b=fgf2wI29sNqcSTPTcWGCXZeyHX7EpgNsY6JzgrIwvzF41kwm6XFAYjU0EONcYVjvam
         Fg+K8bEryS7lm9mfLSat/PSOGPZObZoWPlMlC7xUpOlfWcvWqQxqF9PzBzArr6orpLrR
         RGPu1hMKOFxgwR10aZpgrm+XE+uWKqCxb4QqjXDykg651DFoSWFPpEr3UShRwiWX7hKm
         eVgVxNvEjtQ3sxAg/Li9nwxcLDpAlgXAWsvVj8VgByOPQDKjFMLjQM8ZSPDI/ErABSJe
         hgT4/7r20p0mYbTqtdE0WWCQF3zb9ifw8EIOsnJSKrF2aOR10lkdy/h29kosKwxJiWhj
         dHUA==
X-Gm-Message-State: AOAM533min9OhPogK8uAAVPHulNajERGwj5Y6TLzy93kPx3qstdWxn5R
        4D78eeJ4Q8GuVREDdRCcUyY=
X-Google-Smtp-Source: ABdhPJwSfYjuXiSWiRdebYauWtVwgVzcRAQlTw6fvKH2YnxjKnrBTMQi+rDxKpV72BvHMIMDrUSjnw==
X-Received: by 2002:a17:907:429b:: with SMTP id ny19mr2983818ejb.498.1591384490743;
        Fri, 05 Jun 2020 12:14:50 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id ck11sm5123614ejb.41.2020.06.05.12.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 12:14:50 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2 boilerplate
Date:   Fri,  5 Jun 2020 21:14:38 +0200
Message-Id: <20200605191439.19313-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605191439.19313-1-huobean@gmail.com>
References: <20200605191439.19313-1-huobean@gmail.com>
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
index c70845d41449..4df9150769b7 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -1,36 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
index 8f78a8151499..142362d96d86 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
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
index 76f9be71c31b..d9f8032026a1 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -1,36 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
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
index ad4fc829cbb2..e2939382897d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1,40 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
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
index bf97d616e597..672b8787f328 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1,37 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
index c2961d37cc1c..a9345f52605b 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -1,36 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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

