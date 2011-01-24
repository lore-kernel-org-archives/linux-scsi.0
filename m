From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Reaquire hba_lock + se_port_lock during se_clear_dev_ports continue
Date: Mon, 24 Jan 2011 12:37:25 -0800
Message-ID: <1295901446-17089-3-git-send-email-nab@linux-iscsi.org>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.205]:24317 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750712Ab1AXUhS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 15:37:18 -0500
In-Reply-To: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

This patch reaquires hba->device_lock and dev->se_port_lock in
se_clear_dev_ports() if lun->lun_se_dev is NULL and we need
to continue in dev->dev_sep_list.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 95dfe3a..02b835f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -796,6 +796,8 @@ void se_clear_dev_ports(struct se_device *dev)
 		spin_lock(&lun->lun_sep_lock);
 		if (lun->lun_se_dev == NULL) {
 			spin_unlock(&lun->lun_sep_lock);
+			spin_lock(&hba->device_lock);
+			spin_lock(&dev->se_port_lock);
 			continue;
 		}
 		spin_unlock(&lun->lun_sep_lock);
-- 
1.5.6.5

