Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53428C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhLTLjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:39:09 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29266 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhLTLjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:39:08 -0500
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHczn1tgkzbjQq;
        Mon, 20 Dec 2021 19:38:45 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:39:07 +0800
Received: from [10.174.179.176] (10.174.179.176) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:39:06 +0800
To:     <lduncan@suse.com>, <cleech@redhat.com>,
        <linux-scsi@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>
From:   lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH] libiscsi: fix UAF when iscsi_conn_get_param and
 iscsi_conn_teardown concurrent
Message-ID: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
Date:   Mon, 20 Dec 2021 19:39:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

|- iscsi_if_destroy_conn            |-dev_attr_show
 |-iscsi_conn_teardown
  |-spin_lock_bh                     |-iscsi_sw_tcp_conn_get_param

  |-kfree(conn->persistent_address)   |-iscsi_conn_get_param
  |-kfree(conn->local_ipaddr)
                                       ==>|-read persistent_address
                                       ==>|-read local_ipaddr
  |-spin_unlock_bh

when iscsi_conn_teardown and iscsi_conn_get_param happen in parallel,
may trigger UAF issues.

Signed-off-by: Lixiaokeng<lixiaokeng@huawei.com>
Signed-off-by: Linfeilong<linfeilong@huawei.com>
Reported-by: Lu Tixiong<lutianxiong@huawei.com>
---
 drivers/scsi/libiscsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 284b939fb1ea..059dae8909ee 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3100,6 +3100,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
+	char *tmp_persistent_address = conn->persistent_address;
+	char *tmp_local_ipaddr = conn->local_ipaddr;

 	del_timer_sync(&conn->transport_timer);

@@ -3121,8 +3123,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
-	kfree(conn->persistent_address);
-	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
@@ -3134,6 +3134,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	mutex_unlock(&session->eh_mutex);

 	iscsi_destroy_conn(cls_conn);
+	kfree(tmp_persistent_address);
+	kfree(tmp_local_ipaddr);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_teardown);

-- 
