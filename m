Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50399C07E95
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 10:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3294A613DA
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 10:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhGJKlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Jul 2021 06:41:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:34009 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhGJKlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 10 Jul 2021 06:41:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="209638437"
X-IronPort-AV: E=Sophos;i="5.84,229,1620716400"; 
   d="scan'208";a="209638437"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2021 03:38:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,229,1620716400"; 
   d="scan'208";a="429090442"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.79])
  by orsmga002.jf.intel.com with ESMTP; 10 Jul 2021 03:38:14 -0700
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
Subject: [PATCH V3 2/3] driver core: Add ability to delete device links of unregistered devices
Date:   Sat, 10 Jul 2021 13:38:18 +0300
Message-Id: <20210710103819.12532-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210710103819.12532-1-adrian.hunter@intel.com>
References: <20210710103819.12532-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Managed device links are deleted by device_del(). However it is possible to
add a device link to a consumer before device_add(), and then discover an
error prevents the device from being used. In that case normally references
to the device would be dropped and the device would be deleted. However the
device link holds a reference to the device, so the device link and device
remain indefinitely (unless the supplier is deleted).

Amend device link removal to accept removal of a link with an
unregistered consumer device.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Fixes: b294ff3e34490 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/base/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2de8f7d8cf54..983e895d4ced 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -887,6 +887,8 @@ static void device_link_put_kref(struct device_link *link)
 {
 	if (link->flags & DL_FLAG_STATELESS)
 		kref_put(&link->kref, __device_link_del);
+	else if (!device_is_registered(link->consumer))
+		__device_link_del(&link->kref);
 	else
 		WARN(1, "Unable to drop a managed device link reference\n");
 }
-- 
2.17.1

