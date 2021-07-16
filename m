Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8974C07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 11:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE0D60238
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 11:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhGPLrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 07:47:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:40164 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232106AbhGPLrB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jul 2021 07:47:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="208902309"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="208902309"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 04:44:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="467107146"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.79])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jul 2021 04:44:03 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 1/2] driver core: Prevent warning when removing a device link from unregistered consumer
Date:   Fri, 16 Jul 2021 14:44:07 +0300
Message-Id: <20210716114408.17320-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716114408.17320-1-adrian.hunter@intel.com>
References: <20210716114408.17320-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sysfs_remove_link() causes a warning if the parent directory does not
exist. That can happen if the device link consumer has not been registered.
So do not attempt sysfs_remove_link() in that case.

Fixes: 287905e68dd29 ("driver core: Expose device link details in sysfs")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org # 5.9+
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
---
 drivers/base/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ea5b85354526..2de8f7d8cf54 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -575,8 +575,10 @@ static void devlink_remove_symlinks(struct device *dev,
 		return;
 	}
 
-	snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
-	sysfs_remove_link(&con->kobj, buf);
+	if (device_is_registered(con)) {
+		snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
+		sysfs_remove_link(&con->kobj, buf);
+	}
 	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
 	sysfs_remove_link(&sup->kobj, buf);
 	kfree(buf);
-- 
2.17.1

