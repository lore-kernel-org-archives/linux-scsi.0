From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] mptfusion: unlock on error in mpt_config()
Date: Sat, 27 Aug 2011 12:59:30 +0300
Message-ID: <20110827095930.GK3775@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1H0KBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Aug 2011 06:01:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, kashyap.desai@lsi.com
Cc: "supporter:LSILOGIC MPT FUSI..." <support@lsi.com>, "open list:LSILOGIC MPT FUSI..." <DL-MPTFusionLinux@lsi.com>, "open list:LSILOGIC MPT FUSI..." <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

We introduced a new return here and forgot to unlock the mutex.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e9c6a60..e72320e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6482,6 +6482,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 				printk(MYIOC_s_INFO_FMT "%s: host reset in"
 					" progress mpt_config timed out.!!\n",
 					__func__, ioc->name);
+				mutex_unlock(&ioc->mptbase_cmds.mutex);
 				return -EFAULT;
 			}
 			spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
