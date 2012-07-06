From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/6] fcoe: Remove redundant 'less than zero' check
Date: Fri, 06 Jul 2012 10:40:20 -0700
Message-ID: <20120706174020.4102.1436.stgit@fritz>
References: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab2GFRkV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:21 -0400
In-Reply-To: <20120706173959.4102.12091.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

strtoul returns an 'unsigned long' so there is no
reason to check if the value is less than zero.

strtoul already checks for the '-' character deep
in its bowels. It will return an error if the user
has provided a negative value and fcoe_str_to_dev_loss
will return that error to its caller.

This patch fixes the following Coverity reported warning:

CID 703581 -  NO_EFFECT Unsigned compared against 0 - This
less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
drivers/scsi/fcoe/fcoe_sysfs.c:105

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2bc1631..5e75168 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -102,7 +102,7 @@ static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
 	int ret;
 
 	ret = kstrtoul(buf, 0, val);
-	if (ret || *val < 0)
+	if (ret)
 		return -EINVAL;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32

