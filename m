From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [LIO-Target/ConfigFS]: Add ALUA secondary access state
	attributes for saving/reading metadata
Date: Mon, 31 Aug 2009 01:28:20 -0700
Message-ID: <1251707300.4136.45.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:26001 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752689AbZHaI3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2009 04:29:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Alasdair G Kergon <agk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hello,

This patch adds the following new configfs attributes for each LIO-Target/ConfigFS allocated
Port/LUN in /sys/kernel/config/target/iscsi/$TIQN/tpgt_$TPGT/lun/lun_$LUN_ID/:

*) 'alua_tg_pt_status' Used for setting ALUA secondary access state for Port/LUN
*) 'alua_tg_pt_write_md'  Used for allowing configuration to enable/disable
   the writing of ALUA target port group secondary access state/status to struct file.
   Does not affect ALUA fabric level operation

The reason why only dump state and status is because these are the only ALUA attributes
that can be changed during both in-band via MO SET_TARGET_PORT_GROUPs (explict) and out-of-band
via configfs (implict).

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |   54 ++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 1230b74..81e382f 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -466,9 +466,63 @@ static ssize_t lio_target_port_store_attr_alua_tg_pt_offline(
 
 LIO_PORT_ATTR(alua_tg_pt_offline, S_IRUGO | S_IWUSR);
 
+/*
+ * alua_tg_pt_status
+ */
+static ssize_t lio_target_port_show_attr_alua_tg_pt_status(
+	struct se_lun_s *lun,
+	char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_show_secondary_status(lun, page);
+}
+
+static ssize_t lio_target_port_store_attr_alua_tg_pt_status(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;	
+
+	return core_alua_store_secondary_status(lun, page, count);
+}
+
+LIO_PORT_ATTR(alua_tg_pt_status, S_IRUGO | S_IWUSR);
+
+/*
+ * alua_tg_pt_write_md
+ */
+static ssize_t lio_target_port_show_attr_alua_tg_pt_write_md(
+	struct se_lun_s *lun,
+	char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_show_secondary_write_metadata(lun, page);
+}
+
+static ssize_t lio_target_port_store_attr_alua_tg_pt_write_md(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return core_alua_store_secondary_write_metadata(lun, page, count);
+}
+
+LIO_PORT_ATTR(alua_tg_pt_write_md, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *lio_target_port_attrs[] = {
 	&lio_target_port_alua_tg_pt_gp.attr,
 	&lio_target_port_alua_tg_pt_offline.attr,
+	&lio_target_port_alua_tg_pt_status.attr,
+	&lio_target_port_alua_tg_pt_write_md.attr,
 	NULL,
 };
 
-- 
1.5.4.1




