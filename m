Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB4DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D38E6101A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhIMIvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:51:49 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:34182 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236022AbhIMIvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 04:51:45 -0400
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id ADA627DA5;
        Mon, 13 Sep 2021 01:50:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com ADA627DA5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1631523026;
        bh=buapfx1eymPAhUW14Z0XHqwJRFRPjH5VD9zcu6wh33I=;
        h=From:To:Cc:Subject:Date:From;
        b=G8MJ9VTPSz5kAgAYPMxHRiBR6T5twdPFHylQzP5CvLSak2bpZsepjBqxMt+Ww1/vV
         Fb9nNypcLIHMOikRUaZ07OA8vpb+xtiPEqPZ79KYsP9AlJUy03BFoxYblZF7IXbn+C
         VNXBGv2hYa+KVqj3umnGjlmA1f9CH40G3aSCiCP4=
From:   Muneendra Kumar <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH scsi:fc] Update documentation of sysfs nodes for appid
Date:   Sun, 12 Sep 2021 18:58:53 -0700
Message-Id: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Muneendra <muneendra.kumar@broadcom.com>

Update documentation for sysfs node within
/sys/class/fc/fc_udev_device/

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 Documentation/ABI/testing/sysfs-class-fc | 27 ++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc

diff --git a/Documentation/ABI/testing/sysfs-class-fc b/Documentation/ABI/testing/sysfs-class-fc
new file mode 100644
index 000000000000..3057a6d3b8cf
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-fc
@@ -0,0 +1,27 @@
+What:		/sys/class/fc/fc_udev_device/appid_store
+Date:		Aug 2021
+Contact:	Muneendra Kumar <muneendra.kumar@broadconm.com>
+Description:
+		This interface allows an admin to set an FC application
+		identifier in the blkcg associated with a cgroup id. The
+		identifier is typically a UUID that is associated with
+		an application or logical entity such as a virtual
+		machine or container group. The application or logical
+		entity utilizes a block device via the cgroup id.
+		FC adapter drivers may query the identifier and tag FC
+		traffic based on the identifier. FC host and FC fabric
+		entities can utilize the application id and FC traffic
+		tag to identify traffic sources.
+
+		The interface expects a string "<cgroupid>:<appid>" where:
+		<cgroupid> is inode of the cgroup in hexadecimal
+		<appid> is user provided string upto 128 characters
+		in length.
+
+		If an appid_store is done for a cgroup id that already
+		has an appid set, the new value will override the
+		previous value.
+
+		If an admin wants to remove an FC application identifier
+		from a cgroup, an appid_store should be done with the
+		following string: "<cgroupid>:"
-- 
2.26.2

