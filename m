From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [Target_Core_Mod]: Add alua mutex initialization in
	core_alloc_port()
Date: Mon, 31 Aug 2009 01:27:33 -0700
Message-ID: <1251707253.4136.42.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752799AbZHaI36@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Alasdair G Kergon <agk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch updates core_alloc_port() to call mutex_init() for the
mutex protecting the ALUA secondary access state/status metadata.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a088960..a3572ed 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -611,6 +611,7 @@ se_port_t *core_alloc_port(se_device_t *dev)
 	INIT_LIST_HEAD(&port->sep_list);
 	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 	spin_lock_init(&port->sep_alua_lock);
+	mutex_init(&port->sep_tg_pt_md_mutex);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
-- 
1.5.4.1
