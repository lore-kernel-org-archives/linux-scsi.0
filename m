From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v3 1/3] ibmvscsi: make parameters max_id and max_channel read-only
Date: Mon,  9 Nov 2015 14:53:50 +0100
Message-ID: <1447077232-5335-2-git-send-email-lvivier@redhat.com>
References: <1447077232-5335-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbbKINx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 08:53:57 -0500
In-Reply-To: <1447077232-5335-1-git-send-email-lvivier@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: hare@suse.de, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com

The value of the parameter is never re-read by the driver,
so a new value is ignored. Let know the user he
can't modify it by removing writable attribute.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6a41c36..3e76490 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -105,9 +105,9 @@ MODULE_AUTHOR("Dave Boutcher");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IBMVSCSI_VERSION);
 
-module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
+module_param_named(max_id, max_id, int, S_IRUGO);
 MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
-module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
+module_param_named(max_channel, max_channel, int, S_IRUGO);
 MODULE_PARM_DESC(max_channel, "Largest channel value");
 module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
-- 
2.1.0

