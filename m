Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD00C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 18:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D2121531
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 18:42:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QJt1iKuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436668AbgFSSl6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 14:41:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52110 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732225AbgFSSl6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 14:41:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JIWdFx070739;
        Fri, 19 Jun 2020 18:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=41SJszYT73pPwR3/1I12iphb74gh+cbWYaqqArUgJ2c=;
 b=QJt1iKuzgVYYKvCFAWAf602XaEeVmcJ8kxsHxezNBc3JjdR+VxgQbcmgrw+yjknqrP7f
 tDgZC68lu6QmwJPRweNhJw/tKd8FQZRvYOtHoGDuayBCwH5G4h6okAohjXFpb3Gt1eAe
 XHDWkBDjcp2VGnj0gKRf+VV083NkYq1g9YDCHL44dPdOoSTAr1HVvgFKwmgzprYO1jFT
 L0JM6jLzKjlVa0pMn9x4gMqPRUADp48fCxBWajOhDRC8rW5Z6tJ0tvj2C/aQxVMLdVWp
 91QMwT8t6C5o9tN7pjDUI0dx6W6kPAUy/KVqTT2jYLPpIaT8xlnXkHoxU1iUKYCqTaIC qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31q66087sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 18:41:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JIXrrG074615;
        Fri, 19 Jun 2020 18:41:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31q6635620-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 18:41:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05JIftvS003532;
        Fri, 19 Jun 2020 18:41:55 GMT
Received: from ca-dev-arm29.us.oracle.com (/10.129.136.23)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 11:41:55 -0700
From:   Henry Willard <henry.willard@oracle.com>
To:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: target: tcmu: Call flush_dcache_page() with proper page struct
Date:   Fri, 19 Jun 2020 11:41:45 -0700
Message-Id: <1592592105-11497-1-git-send-email-henry.willard@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1011 mlxlogscore=999 suspectscore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190135
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tcmu_flush_dcache_range() gets called with addresses from both kernel
linear space and vmalloc space, so virt_to_page() or vmalloc_to_page()
have to be used as appropriate to get the proper page struct. On x86_64
flush_dcache_page() is the default noop implementation, so this hasn't
been a problem there.

When tcmu_flush_dcache_range() is called with a vmalloc address on Arm64,
the result is a kernel panic with the following stack trace:

[  448.873342] CPU: 0 PID: 34102 Comm: iscsi_trx Kdump: loaded
Not tainted 5.4.17-2011.3.2.1.el8uek.aarch64 #2
[  448.876144] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[  448.878377] pstate: 80400005 (Nzcv daif +PAN -UAO)
[  448.880182] pc : flush_dcache_page+0x18/0x60
[  448.881888] lr : is_ring_space_avail+0x74/0x390 [target_core_user]
[  448.883969] sp : ffff80001720fa70
[  448.885450] x29: ffff80001720fa70 x28: 0000000000000000
[  448.887348] x27: 0000000000010000 x26: ffff0003c4b88000
[  448.889285] x25: 0000000000010000 x24: ffff800017da0000
[  448.891166] x23: ffffffdfffe00000 x22: 0000000000000078
[  448.893061] x21: 0000800017da0001 x20: 000000000000ffff
[  448.894931] x19: ffffffffffe5f680 x18: 0000000000000000
[  448.896826] x17: 0000000000000000 x16: 0000000000000000
[  448.898704] x15: 0000000000000000 x14: 0000000000000000
[  448.900562] x13: 0000000000000000 x12: 0000000000000000
[  448.902403] x11: ffff0003d188e4d0 x10: 0000000000000030
[  448.904230] x9 : 0000000000000000 x8 : ffff0003d4073f00
[  448.906094] x7 : 00000000000013b0 x6 : 000000000000003f
[  448.907911] x5 : 0000000000000040 x4 : ffff0003d16d6258
[  448.909720] x3 : 0000000000010000 x2 : 0000000000000078
[  448.911664] x1 : ffff0003d16d6228 x0 : ffff800009f43b1c
[  448.913767] Call trace:
[  448.914984]  flush_dcache_page+0x18/0x60
[  448.916518]  is_ring_space_avail+0x74/0x390 [target_core_user]
[  448.918450]  queue_cmd_ring+0x228/0x700 [target_core_user]
[  448.920318]  tcmu_queue_cmd+0xd8/0x14c [target_core_user]
[  448.922192]  __target_execute_cmd+0x30/0x130 [target_core_mod]
[  448.924170]  target_execute_cmd+0x1a4/0x450 [target_core_mod]
[  448.926212]  transport_generic_new_cmd+0x1b8/0x3a0 [target_core_mod]
[  448.928289]  transport_handle_cdb_direct+0x50/0xb0 [target_core_mod]
[  448.930368]  iscsit_execute_cmd+0x2c0/0x360 [iscsi_target_mod]
[  448.932347]  iscsit_sequence_cmd+0xd8/0x1c8 [iscsi_target_mod]
[  448.934313]  iscsit_process_scsi_cmd+0xac/0xf8 [iscsi_target_mod]
[  448.936479]  iscsit_get_rx_pdu+0x450/0xd68 [iscsi_target_mod]
[  448.938423]  iscsi_target_rx_thread+0xc0/0x168 [iscsi_target_mod]
[  448.940387]  kthread+0x110/0x114
[  448.941802]  ret_from_fork+0x10/0x18
[  448.943271] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260)
[  448.945271] SMP: stopping secondary CPUs

Signed-off-by: Henry Willard <henry.willard@oracle.com>
---
 drivers/target/target_core_user.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 560bfec933bc..7557c0630483 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -597,11 +597,19 @@ static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
 {
 	unsigned long offset = offset_in_page(vaddr);
 	void *start = vaddr - offset;
+	struct page *pg;
 
 	size = round_up(size+offset, PAGE_SIZE);
 
 	while (size) {
-		flush_dcache_page(virt_to_page(start));
+		if (virt_addr_valid(start))
+			pg = virt_to_page(start);
+		else if (is_vmalloc_addr(start))
+			pg = vmalloc_to_page(start);
+		else
+			break;
+
+		flush_dcache_page(pg);
 		start += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
-- 
1.8.3.1

