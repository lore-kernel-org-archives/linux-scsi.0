Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D85C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 14:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiA0OOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 09:14:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:37020 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiA0OOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 09:14:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 778FF1F3A9;
        Thu, 27 Jan 2022 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643292849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tWcwS6ED/mkktDY/ojoagNo8BtKt7JYQJADnHylBU+s=;
        b=V4BnBxjjcYfbadAi40py9ZPm+V11ElIB1CgkXOFsYWVoSLSDjZUx6R3+tplOlM0r1w38no
        SieBpy5WjXC3mDRl8Vxdp2Ma+q1Pfy9A3OXYYcTQRsJf0a3evUVUMMR1BMkhxE2iacmV/r
        BuPp/uwS5pSW2Es+SJCj47z7fbPwt3w=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 322FB13BE5;
        Thu, 27 Jan 2022 14:14:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id p4inCbGo8mEMOQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 27 Jan 2022 14:14:09 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: make "access_state" sysfs attribute always visible
Date:   Thu, 27 Jan 2022 15:13:51 +0100
Message-Id: <20220127141351.30706-1-mwilck@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

If a SCSI device handler module is loaded after some SCSI devices
have already been probed (e.g. via request_module() by dm-multipath),
the "access_state" and "preferred_path" sysfs attributes remain invisible for
these devices, although the handler is attached and live. The reason is
that the visibility is only checked when the sysfs attribute group is
first created. This results in an inconsistent user experience depending
on the load order of SCSI low-level drivers vs. device handler modules.

This patch changes user space API: attempting to read the "access_state"
or "preferred_path" attributes will now result in -EINVAL rather than
-ENODEV for devices that have no device handler, and tests for the existence
of these attributes will have a different result.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_sysfs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f1e0c131b77c..226a50944c00 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1228,14 +1228,6 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	    !sdev->host->hostt->change_queue_depth)
 		return 0;
 
-#ifdef CONFIG_SCSI_DH
-	if (attr == &dev_attr_access_state.attr &&
-	    !sdev->handler)
-		return 0;
-	if (attr == &dev_attr_preferred_path.attr &&
-	    !sdev->handler)
-		return 0;
-#endif
 	return attr->mode;
 }
 
-- 
2.34.1

