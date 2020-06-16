Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C811C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 15:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00969208B3
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 15:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgFPPcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:32:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:38708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbgFPPcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 11:32:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A1151AFB8;
        Tue, 16 Jun 2020 15:32:09 +0000 (UTC)
From:   mwilck@suse.com
To:     Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] scsi: smartpqi: check sdev in pqi_scsi_find_entry
Date:   Tue, 16 Jun 2020 17:31:45 +0200
Message-Id: <20200616153145.16949-2-mwilck@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616153145.16949-1-mwilck@suse.com>
References: <20200616153145.16949-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

If a scsi device has been destroyed e.g. using the sysfs "delete"
attribute, subsequent host rescans won't re-discover it. This
patch makes it work at least via the smartqpi-specific "rescan"
sysfs attribute.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 54a72f465f85..87089b67ff74 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1612,7 +1612,8 @@ static enum pqi_find_result pqi_scsi_find_entry(struct pqi_ctrl_info *ctrl_info,
 			device->scsi3addr)) {
 			*matching_device = device;
 			if (pqi_device_equal(device_to_find, device)) {
-				if (device_to_find->volume_offline)
+				if (device_to_find->volume_offline ||
+				    !pqi_get_scsi_device(device))
 					return DEVICE_CHANGED;
 				return DEVICE_SAME;
 			}
-- 
2.26.2

