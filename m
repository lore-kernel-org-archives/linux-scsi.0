From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] target: Allow non-supporting backends to set pi_prot_type to 0
Date: Tue, 15 Apr 2014 14:13:12 -0700
Message-ID: <1397596392-32552-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaDOVNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2014 17:13:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, frirajder@gmail.com

Userspace tools assume if a value is read from configfs, it is valid
and will not cause an error if the same value is written back. The only
valid value for pi_prot_type for backends not supporting DIF is 0, so allow
this particular value to be set without returning an error.

Reported-by: Krzysztof Chojnowski <frirajder@gmail.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 65001e1..382b66b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -936,6 +936,10 @@ int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
 		return 0;
 	}
 	if (!dev->transport->init_prot || !dev->transport->free_prot) {
+		/* 0 is only allowed value for non-supporting backends */
+		if (flag == 0)
+			return 0;
+
 		pr_err("DIF protection not supported by backend: %s\n",
 		       dev->transport->name);
 		return -ENOSYS;
-- 
1.9.0

