From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] tcmu: Fix some memory corruption
Date: Wed, 8 Nov 2017 11:43:44 +0300
Message-ID: <20171108084344.hmqtb5k2puzh3sc6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18948 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdKHIoC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 03:44:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

"udev->nl_reply_supported" is an int but on 64 bit arches we are writing
8 bytes of data to it so it corrupts four bytes beyond the end of the
struct.

Fixes: b849b4567549 ("target: Add netlink command reply supported option for each device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3be4c9696d19..07f2d95f7ae7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1724,11 +1724,10 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 				ret = -ENOMEM;
 				break;
 			}
-			ret = kstrtol(arg_p, 0,
-					(long int *) &udev->nl_reply_supported);
+			ret = kstrtoint(arg_p, 0, &udev->nl_reply_supported);
 			kfree(arg_p);
 			if (ret < 0)
-				pr_err("kstrtoul() failed for nl_reply_supported=\n");
+				pr_err("kstrtoint() failed for nl_reply_supported=\n");
 			break;
 		default:
 			break;
