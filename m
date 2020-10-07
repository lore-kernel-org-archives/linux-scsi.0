Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A2FC41604
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 14:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3506B21531
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 14:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bixlT/QR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgJGOxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:53:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728677AbgJGOxw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 10:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602082431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdsd8Ng3fG6CochuxToB2XwYhkI5DE+revworc2rIdo=;
        b=bixlT/QRnfwNUE3wqZixzcnucVaosXM2hM4mYkYw+c+HvCNFfAISVLZdpZxa/QkR6vDSxq
        IvREOnQ71OKDg1KE5pdpQ+abs0//VDHujfOqRIgpB6NHtklRIowHT4b7Ga6byt1ziKyrPK
        7XJsMb2YVuFkgn5kaZiVJWQfrlpyp5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-j750TGzTO1KSvOhH6bVcPQ-1; Wed, 07 Oct 2020 10:53:47 -0400
X-MC-Unique: j750TGzTO1KSvOhH6bVcPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08535101FFD6;
        Wed,  7 Oct 2020 14:53:35 +0000 (UTC)
Received: from nangaparbat.redhat.com (unknown [10.35.206.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9080560BEC;
        Wed,  7 Oct 2020 14:53:32 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org, michael.christie@oracle.com
Subject: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Date:   Wed,  7 Oct 2020 16:53:26 +0200
Message-Id: <20201007145326.56850-3-mlombard@redhat.com>
In-Reply-To: <20201007145326.56850-1-mlombard@redhat.com>
References: <20201007145326.56850-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsit_release_commands_from_conn() function does the following
operations:

1) locks the cmd_lock spinlock
2) Scans the list of commands and sets the CMD_T_FABRIC_STOP flag
3) Releases the cmd_lock spinlock
4) Rescans the list again and clears the i_conn_node link of each command

If an abort task timer is fired between 3) and 4), it will find
the CMD_T_FABRIC_STOP flag set and won't call list_del_init();
therefore it may end up calling __iscsit_free_cmd() with a
non-empty i_conn_node list, thus triggering the warning.

Considering that:

- we expect list_del_init() to be executed by
  iscsit_release_commands_from_conn() when the CMD_T_FABRIC_STOP is set.
- iscsit_aborted_task() is the only function that calls __iscsit_free_cmd()
  directly, while all the other functions call iscsit_free_cmd().
- the warning in __iscsit_free_cmd() is a duplicate (the same warning
  can be found in iscsit_free_cmd().

We can fix the bug by simply removing the warning from __iscsit_free_cmd()

kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 21173 at drivers/target/iscsi/iscsi_target_util.c:720 __iscsit_free_cmd+0x26e/0x290 [iscsi_target_mod]
...
kernel: CPU: 1 PID: 21173 Comm: kworker/u8:3 Kdump: loaded Not tainted 3.10.0-1062.4.1.el7.x86_64 #1
kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/17/2015
kernel: Workqueue: tmr-user target_tmr_work [target_core_mod]
kernel: Call Trace:
kernel: [<ffffffff91d78ba4>] dump_stack+0x19/0x1b
kernel: [<ffffffff9169a958>] __warn+0xd8/0x100
kernel: [<ffffffff9169aa9d>] warn_slowpath_null+0x1d/0x20
kernel: [<ffffffffc0a6f69e>] __iscsit_free_cmd+0x26e/0x290 [iscsi_target_mod]
kernel: [<ffffffffc0a70bc4>] iscsit_aborted_task+0x64/0x70 [iscsi_target_mod]
kernel: [<ffffffffc0a7830a>] lio_aborted_task+0x2a/0x30 [iscsi_target_mod]
kernel: [<ffffffffc09fa516>] transport_cmd_finish_abort+0x66/0xb0 [target_core_mod]
kernel: [<ffffffffc09f4d92>] core_tmr_abort_task+0x102/0x180 [target_core_mod]
kernel: [<ffffffffc09f7bb2>] target_tmr_work+0x152/0x170 [target_core_mod]
kernel: [<ffffffff916bd1df>] process_one_work+0x17f/0x440
kernel: [<ffffffff916be2f6>] worker_thread+0x126/0x3c0
kernel: [<ffffffff916be1d0>] ? manage_workers.isra.26+0x2a0/0x2a0
kernel: [<ffffffff916c51b1>] kthread+0xd1/0xe0
kernel: [<ffffffff916c50e0>] ? insert_kthread_work+0x40/0x40
kernel: [<ffffffff91d8bd37>] ret_from_fork_nospec_begin+0x21/0x21
kernel: [<ffffffff916c50e0>] ? insert_kthread_work+0x40/0x40
kernel: ---[ end trace ed2119501826ec7a ]---


Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 3082f5bde9fa..61233755ece0 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -741,8 +741,6 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
 {
 	struct iscsi_conn *conn = cmd->conn;
 
-	WARN_ON(!list_empty(&cmd->i_conn_node));
-
 	if (cmd->data_direction == DMA_TO_DEVICE) {
 		iscsit_stop_dataout_timer(cmd);
 		iscsit_free_r2ts_from_list(cmd);
-- 
2.26.2

