Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EF2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 16:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346643AbiAYQci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:32:38 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:35712 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345866AbiAYQ1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2022 11:27:09 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E423A1F381;
        Tue, 25 Jan 2022 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643128028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=c5PhHKLyvivmkbImU4kGsn4lXvGwy/TZMxliCkBmlLE=;
        b=R9uz++H/3gTh9ZSIzaawkPdNvIdAjGBr+C6gvHDi48wc9nP9oGkbb5cgSBy8a8WXpfLne/
        6Kzl9MqY+K3M7WsXksI4DYayq3ShZ/CosZLfb4YoK/xqpc6uki4HrwV3kV3X48HQQd+8p6
        1wCm+Wp6ZQJYkOmkZ15B13enV18UgLU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97D2613E4B;
        Tue, 25 Jan 2022 16:27:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id d4fvItwk8GF9MgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 25 Jan 2022 16:27:08 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH] scsi: make "access_state" sysfs attribute always visible
Date:   Tue, 25 Jan 2022 17:24:41 +0100
Message-Id: <20220125162441.2226-1-mwilck@suse.com>
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

