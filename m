Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9D2C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 11:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E253021D1B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 11:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ypYYMR/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIOLDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 07:03:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgIOLAn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 07:00:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FAwxpO026428;
        Tue, 15 Sep 2020 10:59:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=uc1nnwweUN3M7hTlh7aVus0Xqc+cXvdEzC3DnDY4d+8=;
 b=ypYYMR/PpLIYQ6wuykLm+y+sW3e5NcMmff5wP/JSIgZ696MrgnmG+zkcv4GOduR3g14z
 7GyvTFXUswYjYhVsnawFExLT2Auwy9HKwsG0r7Ks1OXVWG3WRAc3DbSxvUPI/D3CnYHn
 2vIsg6AH5vMmTFGd6kSnVVJQ66Od7P0Rh2NVLQWxnBWRtxL2re7cJtEASNw//PRiXK1d
 SlrXT5Ranu2UFSJRNXVehbKpni0LrmeauyNYyb7q5dgGlRTdrHNQYXgI8LifXeiZlrKB
 vHipPOcKJNXHYx8zqV6JnlQLBJZxqT8UXPV1SIm3wZHYRrSq+oq9mPKy4Y+VS3Rs3DMu 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9m45vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 10:59:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FAxn3u100210;
        Tue, 15 Sep 2020 10:59:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 33hm307h4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 10:59:50 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FAxnbg100079;
        Tue, 15 Sep 2020 10:59:49 GMT
Received: from mybox.in.oracle.com (dhcp-10-76-51-53.vpn.oracle.com [10.76.51.53])
        by userp3020.oracle.com with ESMTP id 33hm307fy6-1;
        Tue, 15 Sep 2020 10:59:33 +0000
From:   Jitendra Khasdev <jitendra.khasdev@oracle.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.com,
        loberman@redhat.com
Cc:     joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, RITIKA.SRIVASTAVA@ORACLE.COM,
        linux-scsi@vger.kernel.org, jitendra.khasdev@oracle.com
Subject: [PATCH] scsi: alua: fix the race between alua_bus_detach and alua_rtpg
Date:   Tue, 15 Sep 2020 16:28:57 +0530
Message-Id: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150096
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is patch to fix the race occurs between bus detach and alua_rtpg.

It fluses the all pending workqueue in bus detach handler, so it can avoid
race between alua_bus_detach and alua_rtpg.

Here is call trace where race got detected.

multipathd call stack:
[exception RIP: native_queued_spin_lock_slowpath+100]
--- <NMI exception stack> ---
native_queued_spin_lock_slowpath at ffffffff89307f54
queued_spin_lock_slowpath at ffffffff89307c18
_raw_spin_lock_irq at ffffffff89bd797b
alua_bus_detach at ffffffff8984dcc8
scsi_dh_release_device at ffffffff8984b6f2
scsi_device_dev_release_usercontext at ffffffff89846edf
execute_in_process_context at ffffffff892c3e60
scsi_device_dev_release at ffffffff8984637c
device_release at ffffffff89800fbc
kobject_cleanup at ffffffff89bb1196
kobject_put at ffffffff89bb12ea
put_device at ffffffff89801283
scsi_device_put at ffffffff89838d5b
scsi_disk_put at ffffffffc051f650 [sd_mod]
sd_release at ffffffffc051f8a2 [sd_mod]
__blkdev_put at ffffffff8952c79e
blkdev_put at ffffffff8952c80c
blkdev_close at ffffffff8952c8b5
__fput at ffffffff894e55e6
____fput at ffffffff894e57ee
task_work_run at ffffffff892c94dc
exit_to_usermode_loop at ffffffff89204b12
do_syscall_64 at ffffffff892044da
entry_SYSCALL_64_after_hwframe at ffffffff89c001b8

kworker:
[exception RIP: alua_rtpg+2003]
account_entity_dequeue at ffffffff892e42c1
alua_rtpg_work at ffffffff8984f097
process_one_work at ffffffff892c4c29
worker_thread at ffffffff892c5a4f
kthread at ffffffff892cb135
ret_from_fork at ffffffff89c00354

Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f32da0c..024a752 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
 
+	sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
+	flush_workqueue(kaluad_wq);
+
 	spin_lock(&h->pg_lock);
 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
 	rcu_assign_pointer(h->pg, NULL);
-- 
1.8.3.1

