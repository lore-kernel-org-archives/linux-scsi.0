Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC06C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 08:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 175012074D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 08:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CwWEA4/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgGAIw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:52:59 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25129 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgGAIw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 04:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593593578; x=1625129578;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BWlRD9mW6B/kyMQ4Uh2Jzi00nhQZkX9cddioS3LK6nA=;
  b=CwWEA4/ge1jjJlQZ4YaiFbmWu8EqJ8cAh6E9j7pBG0BlaGFZpDU+AaLC
   K0z0XyXwppLH/vEk2XrDbIOD7kn67rAx68oUm61OWrI0Su0XvAZSJO1a2
   BnlZfdkSlAfcf4RH+Fd95pKEEZnyzns1A39Ma6XoS+KZCZ6o7HZ0BKB9i
   h/8fDbyKgvMItkHFVECHiewNnp+puCX2jKeLYgvDO8oNb1I17PjA5PFzk
   Z3fiYrTD0vtjS3+0ZnGFCBBCYAQn014KsVw0UNT4fMXjMcYr2T9qcRNUu
   /gP0gKfwTkupSk8WIfuc/bwVi/icvI4ATQPMPoGh1QcKfptl7jv5jQlrh
   A==;
IronPort-SDR: LnMGTWTYTxHqml+R1kf3Q6rDnb/nzbHSlnHIPipId/CfhNeBEdb4wH8IzDeTXXkrcRyWL1j/8I
 VPAYB8f7Emugu31MTMHPr0dJXmz3xZ1MGawXyMe+f5ZP/2Ch5Um/xcZQdN1ppmqBDJKdq9zMiX
 wMBue+MWLeLBtN1syod2gn5/Ir13rftj/UXDer+cVU/8YcJyI1c/sf4Cpp44mMR6sacZ5V7cPG
 YRTDTvIeBdPDumCGZITTbr5qMw3xjsZNCr6v1HJQNbuCcSU6IbwnJMynp8ISva+IkAQh9dHzTd
 kWs=
X-IronPort-AV: E=Sophos;i="5.75,299,1589212800"; 
   d="scan'208";a="250598122"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2020 16:52:57 +0800
IronPort-SDR: YynCpmqEJCvOlMhcrZXz5elz9wUWckj4uCzpU80JzkrtNL2QuKL+0xGFkNK2EI0p8l0frFYiK2
 qLUzDf4Pr1zYlMngKrPR+iRWCKxEgvD1U=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 01:41:48 -0700
IronPort-SDR: RPLuZBoYBfSTQc3GkpooK1kZ8RbDS4wrkpuDJGSFMWBf4FFk4L4p5SZ/r3jW75fq2n6MVKbuBr
 lhM0Q612ts3A==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Jul 2020 01:52:58 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Date:   Wed,  1 Jul 2020 17:52:54 +0900
Message-Id: <20200701085254.51740-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In BRM_status_show(), if the condition "!ioc->is_warpdrive" tested on
entry to the function is true, a "goto out" is called. This results in
unlocking ioc->pci_access_mutex without this mutex lock being taken.
This generates the following splat:

[ 1148.539883] mpt3sas_cm2: BRM_status_show: BRM attribute is only for warpdrive
[ 1148.547184]
[ 1148.548708] =====================================
[ 1148.553501] WARNING: bad unlock balance detected!
[ 1148.558277] 5.8.0-rc3+ #827 Not tainted
[ 1148.562183] -------------------------------------
[ 1148.566959] cat/5008 is trying to release lock (&ioc->pci_access_mutex) at:
[ 1148.574035] [<ffffffffc070b7a3>] BRM_status_show+0xd3/0x100 [mpt3sas]
[ 1148.580574] but there are no more locks to release!
[ 1148.585524]
[ 1148.585524] other info that might help us debug this:
[ 1148.599624] 3 locks held by cat/5008:
[ 1148.607085]  #0: ffff92aea3e392c0 (&p->lock){+.+.}-{3:3}, at: seq_read+0x34/0x480
[ 1148.618509]  #1: ffff922ef14c4888 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x2a/0xb0
[ 1148.630729]  #2: ffff92aedb5d7310 (kn->active#224){.+.+}-{0:0}, at: kernfs_seq_start+0x32/0xb0
[ 1148.643347]
[ 1148.643347] stack backtrace:
[ 1148.655259] CPU: 73 PID: 5008 Comm: cat Not tainted 5.8.0-rc3+ #827
[ 1148.665309] Hardware name: HGST H4060-S/S2600STB, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[ 1148.678394] Call Trace:
[ 1148.684750]  dump_stack+0x78/0xa0
[ 1148.691802]  lock_release.cold+0x45/0x4a
[ 1148.699451]  __mutex_unlock_slowpath+0x35/0x270
[ 1148.707675]  BRM_status_show+0xd3/0x100 [mpt3sas]
[ 1148.716092]  dev_attr_show+0x19/0x40
[ 1148.723664]  sysfs_kf_seq_show+0x87/0x100
[ 1148.731193]  seq_read+0xbc/0x480
[ 1148.737882]  vfs_read+0xa0/0x160
[ 1148.744514]  ksys_read+0x58/0xd0
[ 1148.751129]  do_syscall_64+0x4c/0xa0
[ 1148.757941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1148.766240] RIP: 0033:0x7f1230566542
[ 1148.772957] Code: Bad RIP value.
[ 1148.779206] RSP: 002b:00007ffeac1bcac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 1148.790063] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f1230566542
[ 1148.800284] RDX: 0000000000020000 RSI: 00007f1223460000 RDI: 0000000000000003
[ 1148.810474] RBP: 00007f1223460000 R08: 00007f122345f010 R09: 0000000000000000
[ 1148.820641] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000000
[ 1148.830728] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000

Fix this by returning immediately instead of jumping to the out label.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e552838565..e94e72de2fc6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3145,7 +3145,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (!ioc->is_warpdrive) {
 		ioc_err(ioc, "%s: BRM attribute is only for warpdrive\n",
 			__func__);
-		goto out;
+		return 0;
 	}
 	/* pci_access_mutex lock acquired by sysfs show path */
 	mutex_lock(&ioc->pci_access_mutex);
-- 
2.26.2

