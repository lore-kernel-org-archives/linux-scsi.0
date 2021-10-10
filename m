Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E30C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 07:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4488160F46
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 07:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhJJHWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 03:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhJJHWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Oct 2021 03:22:05 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07741C061762
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 00:20:07 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k26so11981959pfi.5
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wt8NCphr5LPTSGm5kELuO+yCdiTjLhoziCfmEiQX52A=;
        b=hzOrD2V4QbMAGtGEfzDIWxHhW6RpCH8bdL5VjrY9tNQKZlKEW6hmDMrE+zskaa55F9
         KsTu8O9zE3HmXcsD3uW/Epeq9uMr1q779pA7PPYU2HtDXxmnYnSr8XLA6ZkpzPLb5T3i
         ltSlFzKZiMXrS4d0cYoL4wHrkmM8HGt3UxFwvtaNoSHifa1ipRc3nIUG3o7pvG3TSU4I
         /Q2l/bUiQPTg0RZ7W5MSDdsFkZ6VdHyoyzSFX9+lipqpvGxJGX8ivH6cRW5ecKVK5TVg
         NRaRc6Pjip69Ff832qrwKZBqosKB1A/3HpLOf7pCzO9zEycpkZhRIBiDsSPE7FQ1wwHD
         Q3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wt8NCphr5LPTSGm5kELuO+yCdiTjLhoziCfmEiQX52A=;
        b=JLeLo5ntF6Sln4cAmTp6buVKV/jw/VcVBxWU0B1l5HmAEyVQl0rYy+5/LrbiY4ryUS
         KGJRldCN0L3/H+BPDT38pKRfo7C9ahcPlp5K2vDtKs7zZ+RHwB52JN2dWOWibHgyTZHy
         bvIMuNRZ3hg50WF23qVordyFmBd2by1AbEuyXTNJUwH5uK04Y+p7du6C993FcOJl8kXd
         T8arhN2xYPW7ym/woEh3BcqBiXipubPxEAgbvndn/W7cK42saMtrSt2hu+PHPU0cyh/E
         //wqOlt2qONHlI6fzUjLD5UFQ6CQNO9Qua0jijMy6942qeQS7eU9n2CTwTeXhXMxNl7U
         9sUQ==
X-Gm-Message-State: AOAM531ilyS5J7LNNxfTVJyHQ80E0vlkXjRNpxAQwjs1hUrRiXL6enIW
        TY9I74Ecmvlzrr9z6R8SMIu+HA==
X-Google-Smtp-Source: ABdhPJzlDvOIRIK4C4y08W5qslrO/yoNoK/k2ICLFh7pgKexkQcQP/tdQHlXaRyCbyHEPAGyDu8gmQ==
X-Received: by 2002:a62:84d5:0:b0:44d:7cf:e6dc with SMTP id k204-20020a6284d5000000b0044d07cfe6dcmr3375469pfd.12.1633850405728;
        Sun, 10 Oct 2021 00:20:05 -0700 (PDT)
Received: from 64-217.. ([103.97.201.33])
        by smtp.gmail.com with ESMTPSA id w13sm2384251pfc.10.2021.10.10.00.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 00:20:05 -0700 (PDT)
From:   Li Feng <fengli@smartx.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com (open list:ISCSI),
        linux-scsi@vger.kernel.org (open list:ISCSI),
        linux-kernel@vger.kernel.org (open list)
Cc:     Li Feng <fengli@smartx.com>
Subject: [PATCH] iscsi_tcp: fix the NULL pointer dereference
Date:   Sun, 10 Oct 2021 15:19:47 +0800
Message-Id: <20211010071947.2002025-1-fengli@smartx.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsi_sw_tcp_conn_set_param should check the pointer before using it.

I got this ops when starting my os:
[   27.158355] sd 27:0:0:1: [sdco] Mode Sense: 83 00 00 08
[   27.158377] scsi 27:0:0:3: Direct-Access     ZBS      VOLUME           0000 PQ: 0 ANSI: 5
[   27.167665]  connection39:0: detected conn error (1020)
[   27.174681] BUG: kernel NULL pointer dereference, address: 0000000000000020
[   27.174706] #PF: supervisor read access in kernel mode
[   27.174719] #PF: error_code(0x0000) - not-present page
[   27.174731] PGD 0 P4D 0
[   27.174739] Oops: 0000 [#1] SMP NOPTI
[   27.174749] CPU: 8 PID: 1044 Comm: iscsid Not tainted 5.11.12-300.fc34.x86_64 #1
[   27.174767] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 12/12/2018
[   27.174790] RIP: 0010:iscsi_sw_tcp_conn_set_param+0x6a/0x80 [iscsi_tcp]
[   27.174807] Code: 85 d2 74 23 48 89 83 e0 00 00 00 31 c0 5b 5d c3 e8 bb 21 fb ff 31 c0 5b 5d c3 48 89 ef 5b 48 89 d6 5d e9 99 62 ff ff 48 8b 03 <48> 8b 40 20 48 8b 80 a0 00 00 00 eb cd 66 0f 1f 84 00 00 00 00 00
[   27.174847] RSP: 0018:ffffba8a46103b90 EFLAGS: 00010246
[   27.174860] RAX: 0000000000000000 RBX: ffff98cbf22766b8 RCX: ffffffffc096d6b9
[   27.174877] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff98cbdbcb6049
[   27.174893] RBP: ffff98cbf2276348 R08: 00000000000000ff R09: 000000000000000a
[   27.174909] R10: 000000000000000a R11: f000000000000000 R12: ffff98cbdbcb6010
[   27.174925] R13: ffff98cbdbcb6048 R14: ffff98cbf2279800 R15: 0000000000000414
[   27.174941] FS:  00007fa88bab7cc0(0000) GS:ffff98d1e0000000(0000) knlGS:0000000000000000
[   27.175188] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.175441] CR2: 0000000000000020 CR3: 000000022522c000 CR4: 00000000003506e0
[   27.175734] Call Trace:
[   27.176003]  iscsi_if_rx+0xdda/0x1adc [scsi_transport_iscsi]
[   27.176291]  ? __kmalloc_node_track_caller+0xec/0x280
[   27.176585]  ? netlink_sendmsg+0x30c/0x440
[   27.176880]  netlink_unicast+0x1d3/0x2a0
[   27.177191]  netlink_sendmsg+0x22a/0x440
[   27.177494]  sock_sendmsg+0x5e/0x60
[   27.177799]  ____sys_sendmsg+0x22c/0x270
[   27.178107]  ? import_iovec+0x17/0x20
[   27.178422]  ? sendmsg_copy_msghdr+0x59/0x90
[   27.178747]  ? _copy_from_user+0x3c/0x80
[   27.179072]  ___sys_sendmsg+0x81/0xc0
[   27.179402]  ? ___sys_recvmsg+0x86/0xe0
[   27.179736]  ? handle_mm_fault+0x113f/0x1970
[   27.180076]  ? enqueue_hrtimer+0x32/0x70
[   27.180422]  __sys_sendmsg+0x49/0x80
[   27.180778]  do_syscall_64+0x33/0x40
[   27.181132]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/iscsi_tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1bc37593c88f..2ec1405d272d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -724,6 +724,8 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
+		if (!tcp_sw_conn || !tcp_sw_conn->sock)
+			return -ENOTCONN;
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		break;
-- 
2.31.1

