Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24925C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 04:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020E361422
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 04:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhEMEem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 00:34:42 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43745 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhEMEek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 00:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620880411; x=1652416411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WTUm+yT12ndFwlr63y1ls78Z0YyYAYvyInTtNQrd1DU=;
  b=TXxVxfb9MO2TkH7pZ1sP5hA7g8iRrBSL8DqwZ+E56aDBtjf5Rm2m0mOf
   2L2mk+cIXtNv5P9x9ZDz+ehmGH0+qTvVsL1hHiIQK8ugQFzNvqbDufODu
   iBds8zUA3C03aTA9Z8zTq8GnpEZtN2dBo5tZXvBGiVpEhGOMpFLQeWVYa
   mCDTeA8p2ik0ONeIyG+dk/kfXWUMnRiKKX/KMdPMXkxZwAWb8zvFJy4Sy
   XdMXiMEElMS08WQ+DrBbI6aI+LdO7y3ITCb1O/j2+YY6gQUghA8CIyvv/
   7OLI6Y/dP972XTHdXfvBL/mZ75j4b0vnLYlFMku2qcHnJJos+mhRB5ypf
   g==;
IronPort-SDR: YmkF6tlV9kwGmMVXJqn3Zyw3QDKeD1BQixlsoBByZcDKdBebWk7DcmEm3lGRqhsfJlodgFzPCj
 ZaZE33dlr2G4UckfjrHKboyx1HtnNzkEnbkpICLJCn/aES5GvmZsCjRxwLOVZeMs+ZKouhj/Eg
 snZkxkKcbEItqvfEeQCyosgceKJ/N7bZjQaik3o7gi1mgmogx9u8Kx6AVCRwM+W/Jaz9lZuTX1
 hrRqJFO0c57VBbmEHM+XIe0Qf+M9RMpJf5SiH2hxpL7fnzCNqow43TXbMSolj9jYz8edb5eddR
 TLk=
X-IronPort-AV: E=Sophos;i="5.82,296,1613404800"; 
   d="scan'208";a="167314106"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2021 12:33:31 +0800
IronPort-SDR: ZI7LkzYOdrbEhqWI3sYLl+UObjMVEVsnvv0PBx4fHa2uCuW7zlXtIlB5KvjBFeNJOo/WmgKfXO
 gHMITgmAfVsU+QQI5him1iDHJhDVvyZmBmycj+wefGXQl3krKO+DAk0ump2NY6Quz10+m3jBNB
 gUewW4uimtWbwBSMy0U1OSnf4TaMTK9TpITld0vkGXBRP15pQAQAVPksgD2gDncjURvwG0c8w8
 b6DIh4SyzWLgZIAVM6vHRBiznodBYgwR8aGq/ePuywCAvJ1LVwQjPFRcAdI74I53+9FwufHlQU
 ViXHEfiNsn4cewvC7fDNWMLC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 21:12:03 -0700
IronPort-SDR: 8vScAqri36vGBYNMPUCmXY+xczDXPFwx+mAOVTi1Q7Nom2FWagcFYoKHmgbq7LDQ6jRno2+uUW
 UoFggA6vs2/qbk68x0Y/2xi/kORV7gJqjVvBT+bUUWDFaPqFigi3zOgtmlzpsRQ7hPHuMMJQRD
 enY6+fu5NdpWEl8yawRtOhXnvFBUNDq9pftgyUwhwW8AmrIHQPvzZ0eoQlUpYkhSueDkpivrhy
 eu+A883bCoDsAtHp7sE1Rf6kt2Q49yVMJgzb+JTs2itJ+Cc0hX3yIOH7mp1jFgphITKHqcZuSe
 tZU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 May 2021 21:33:30 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: target: tcmu: Fix xarray RCU warning
Date:   Thu, 13 May 2021 13:33:29 +0900
Message-Id: <20210513043329.1571849-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N *
PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
These calls triggered the WARNING "suspicious RCU usage" at tcmu device
set up [1]. In the call stack of xas_next(), xas_load() was called.
According to its comment, this function requires "the xa_lock or the RCU
lock".

To avoid the warning, guard xas_next() calls with the RCU lock, adding
rcu_read_lock() and rcu_read_unlock().

[1]

[ 1899.867091] =============================
[ 1899.871199] WARNING: suspicious RCU usage
[ 1899.875310] 5.13.0-rc1+ #41 Not tainted
[ 1899.879222] -----------------------------
[ 1899.883299] include/linux/xarray.h:1182 suspicious rcu_dereference_check() usage!
[ 1899.890940] other info that might help us debug this:
[ 1899.899082] rcu_scheduler_active = 2, debug_locks = 1
[ 1899.905719] 3 locks held by kworker/0:1/1368:
[ 1899.910161]  #0: ffffa1f8c8b98738 ((wq_completion)target_submission){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
[ 1899.920732]  #1: ffffbd7040cd7e78 ((work_completion)(&q->sq.work)){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
[ 1899.931146]  #2: ffffa1f8d1c99768 (&udev->cmdr_lock){+.+.}-{3:3}, at: tcmu_queue_cmd+0xea/0x160 [target_core_user]
[ 1899.941678] stack backtrace:
[ 1899.946093] CPU: 0 PID: 1368 Comm: kworker/0:1 Not tainted 5.13.0-rc1+ #41
[ 1899.953070] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
[ 1899.962459] Workqueue: target_submission target_queued_submit_work [target_core_mod]
[ 1899.970337] Call Trace:
[ 1899.972839]  dump_stack+0x6d/0x89
[ 1899.976222]  xas_descend+0x10e/0x120
[ 1899.979875]  xas_load+0x39/0x50
[ 1899.983077]  tcmu_get_empty_blocks+0x115/0x1c0 [target_core_user]
[ 1899.989318]  queue_cmd_ring+0x1da/0x630 [target_core_user]
[ 1899.994897]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 1899.999695]  ? trace_kmalloc+0xa6/0xd0
[ 1900.003501]  ? __kmalloc+0x205/0x380
[ 1900.007167]  tcmu_queue_cmd+0x12f/0x160 [target_core_user]
[ 1900.012746]  __target_execute_cmd+0x23/0xa0 [target_core_mod]
[ 1900.018589]  transport_generic_new_cmd+0x1f3/0x370 [target_core_mod]
[ 1900.025046]  transport_handle_cdb_direct+0x34/0x50 [target_core_mod]
[ 1900.031517]  target_queued_submit_work+0x43/0xe0 [target_core_mod]
[ 1900.037837]  process_one_work+0x268/0x580
[ 1900.041952]  ? process_one_work+0x580/0x580
[ 1900.046195]  worker_thread+0x55/0x3b0
[ 1900.049921]  ? process_one_work+0x580/0x580
[ 1900.054192]  kthread+0x143/0x160
[ 1900.057499]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 1900.062661]  ret_from_fork+0x1f/0x30

Fixes: f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N * PAGE_SIZE")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/target/target_core_user.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 198d25ae482a..8be0f40ffa2b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -516,8 +516,10 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 	dpi = dbi * udev->data_pages_per_blk;
 	/* Count the number of already allocated pages */
 	xas_set(&xas, dpi);
+	rcu_read_lock();
 	for (cnt = 0; xas_next(&xas) && cnt < page_cnt;)
 		cnt++;
+	rcu_read_unlock();
 
 	for (i = cnt; i < page_cnt; i++) {
 		/* try to get new page from the mm */
@@ -727,6 +729,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 			page_cnt = udev->data_pages_per_blk;
 
 		xas_set(&xas, dbi * udev->data_pages_per_blk);
+		rcu_read_lock();
 		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
 			page = xas_next(&xas);
 
@@ -763,6 +766,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 			if (direction == TCMU_SG_TO_DATA_AREA)
 				flush_dcache_page(page);
 		}
+		rcu_read_unlock();
 	}
 }
 
-- 
2.30.2

