From: Tejun Heo <tj@kernel.org>
Subject: [PATCH libata/for-4.2-fixes] libata: disable NCQ autosense
Date: Mon, 3 Aug 2015 11:16:21 -0400
Message-ID: <20150803151621.GF32599@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
 <20150803150428.GE32599@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150803150428.GE32599@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

>From 8c0fa3e7ca99b0d6d96cb2cf194a912f643da7c5 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 3 Aug 2015 11:10:45 -0400

fe7173c206de ("libata: Implement support for sense data reporting")
and subsequent patches enabled NCQ autosense reporting; unfortunately,
this breaks libata EH behavior for devices which support the feature
because it assumes that only ATAPI devices report sense data and that
sense data trumps explicit device error indication.

For now, disable NCQ autosense.

Cc: stable@vger.kernel.org # v4.1+
Fixes: fe7173c206de ("libata: Implement support for sense data reporting")
---
 drivers/ata/libata-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index db5d9f7..32451ac 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2151,6 +2151,13 @@ static void ata_dev_config_sense_reporting(struct ata_device *dev)
 {
 	unsigned int err_mask;
 
+	/*
+	 * FIXME: This makes ATA devices report sense data on failure which
+	 * in turn makes libata EH ignore AC_ERR_DEV leading to incorrect
+	 * error handling behaviors.
+	 */
+	return;
+
 	if (!ata_id_has_sense_reporting(dev->id))
 		return;
 
-- 
2.4.3

