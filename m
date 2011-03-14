From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 12/21] target: Fix bogus return in transport_add_device_to_core_hba failure path
Date: Mon, 14 Mar 2011 04:06:06 -0700
Message-ID: <1300100775-10012-13-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ne1.yahoo.com ([98.138.90.69]:46560 "HELO
	nm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753989Ab1CNLHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:23 -0400
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes a bogus conditional+return check within the failure path
of transport_add_device_to_core_hba().  This breakage was introduced during
the v4 conversion to remove struct se_cmd passthrough ops for INQUIRY /
READ_CAPCITY during struct se_device creation and registration process.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index af56ce2..536de6f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1621,7 +1621,7 @@ struct se_device *transport_add_device_to_core_hba(
 	const char *inquiry_prod,
 	const char *inquiry_rev)
 {
-	int ret = 0, force_pt;
+	int force_pt;
 	struct se_device  *dev;
 
 	dev = kzalloc(sizeof(struct se_device), GFP_KERNEL);
@@ -1738,9 +1738,8 @@ struct se_device *transport_add_device_to_core_hba(
 	}
 	scsi_dump_inquiry(dev);
 
+	return dev;
 out:
-	if (!ret)
-		return dev;
 	kthread_stop(dev->process_thread);
 
 	spin_lock(&hba->device_lock);
-- 
1.7.4.1

