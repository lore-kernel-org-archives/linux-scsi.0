From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] libfcoe: remove and unneeded check
Date: Thu, 7 Jun 2012 11:23:26 +0300
Message-ID: <20120607082326.GB7582@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34783 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab2FGIXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 04:23:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Unsigned values are never less than zero.  We check for an upper bound
later so that's OK too.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2bc1631..6e402f6 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -102,8 +102,8 @@ static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
 	int ret;
 
 	ret = kstrtoul(buf, 0, val);
-	if (ret || *val < 0)
-		return -EINVAL;
+	if (ret)
+		return ret;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32
 	 */
