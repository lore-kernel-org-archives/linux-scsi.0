From: Gwendal Grignou <gwendal@google.com>
Subject: [PATCH 1/3] Revert "ata: make ata port as parent device of scsi host"
Date: Thu, 27 Sep 2012 12:04:02 -0700
Message-ID: <1348772644-12486-2-git-send-email-gwendal@google.com>
References: <1348772644-12486-1-git-send-email-gwendal@google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58747 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2I0TEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 15:04:16 -0400
Received: by weyx43 with SMTP id x43so107588wey.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 12:04:15 -0700 (PDT)
In-Reply-To: <1348772644-12486-1-git-send-email-gwendal@google.com>
In-Reply-To: <20120920020145.GA23210@mint-spring.sh.intel.com>
References: <20120920020145.GA23210@mint-spring.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com
Cc: Gwendal Grignou <gwendal@google.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

This reverts commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a.

Instead, melt libata transport sysfs object in scsi objects.

Change-Id: I8c709f63ddf7ba97b9e6f449d5c0b8b85e44e818

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e3bda07..be38930 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3609,7 +3609,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_host_blocked = 1;
 
 		rc = scsi_add_host_with_dma(ap->scsi_host,
-						&ap->tdev, ap->host->dev);
+					    host->dev, host->dev);
 		if (rc)
 			goto err_add;
 	}
-- 
1.7.7.3

