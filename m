Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB42C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD41822D71
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbhAGEzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:55:25 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:52424 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbhAGEzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:55:25 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id B7D1082D19;
        Wed,  6 Jan 2021 20:53:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B7D1082D19
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609995210;
        bh=vi8G4VsJJPyBBiBiMTFXGf9Xh0z/JZqIAlSHPyz8TX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ay+/FNMcdjowPkHMwsYA1o+OE1FcNTd4/y2AvZg1bFyIXFvRTMHOOyyEskzdcTn/s
         nXF7YziSeOZUgzxUdZuip9jozUrFt92SGQiyZJ/ZRTt25o5Lati5eMMUlmRbBwR5KL
         HzDqhv45NaR7ZnZ4CVXi3ukgjVk/RUXD3e5hzcYA=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v7 16/16] scsi: Made changes in Kconfig to select BLK_CGROUP_FC_APPID
Date:   Thu,  7 Jan 2021 03:30:30 +0530
Message-Id: <1609970430-19084-17-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new config FC_APPID to select BLK_CGROUP_FC_APPID
which Enable support to track FC io Traffic.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v7:
Modified the Kconfig comments

v6:
Modified the Kconfig comments

v5:
No change

v4:
Addressed the error reported by kernel test robot

v3:
New patch
---
 drivers/scsi/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 701b61ec76ee..500f88ce29e3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -235,6 +235,19 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config FC_APPID
+	bool "Enable support to track FC I/O Traffic"
+	depends on BLOCK && BLK_CGROUP
+	depends on SCSI
+	select BLK_CGROUP_FC_APPID
+	default y
+	help
+	  If you say Y here, it enables the support to track
+	  FC I/O traffic over fabric. It enables the Fabric and the
+	  storage targets to identify, monitor, and handle FC traffic
+	  based on VM tags by inserting application specific
+	  identification into the FC frame.
+
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
 	depends on SCSI && NET
-- 
2.26.2

