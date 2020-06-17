Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E33C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDEF02073E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFQIf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:35:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbgFQIfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 04:35:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89269AE0E;
        Wed, 17 Jun 2020 08:35:57 +0000 (UTC)
From:   mwilck@suse.com
To:     Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        shane.seymour@hpe.com, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/3] scsi: smartpqi: check sdev in pqi_scsi_find_entry
Date:   Wed, 17 Jun 2020 10:35:13 +0200
Message-Id: <20200617083514.19174-3-mwilck@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617083514.19174-1-mwilck@suse.com>
References: <20200617083514.19174-1-mwilck@suse.com>
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

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
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

