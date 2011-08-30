From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [patch] [SCSI] mptfusion: unlock on error in mpt_config()
Date: Tue, 30 Aug 2011 16:18:23 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6042AD54397@inbmail02.lsi.com>
References: <20110827095930.GK3775@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33658 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab1H3Ksc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 06:48:32 -0400
In-Reply-To: <20110827095930.GK3775@shale.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "open list:LSILOGIC MPT FUSI..." <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

The patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>


Regards,
Nagalakshmi


-----Original Message-----
From: Dan Carpenter [mailto:error27@gmail.com] 
Sent: Saturday, August 27, 2011 3:30 PM
To: Moore, Eric; Desai, Kashyap
Cc: Support; DL-MPT Fusion Linux; open list:LSILOGIC MPT FUSI...; kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] mptfusion: unlock on error in mpt_config()

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
