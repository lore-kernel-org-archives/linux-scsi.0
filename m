Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25030C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 15:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB2BC22362
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 15:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cuJva7/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfKSPlI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:41:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33330 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbfKSPlI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 10:41:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574178067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VXha/U7dFW92tD/+5KwRI9V8OS/lwbb4CbzbqxCKjM0=;
        b=cuJva7/etOenES770nzf1QmdTfy70xYBR2bc2/Id9wfWXxgOR68ChbK4tr3HkYTQzwMGRx
        smTqLBeAPanE1Ehz1Xlu/FGhXJUvkyN9HKs2tbCUZa2CWB6AO6feIUa2x/RIScDszBzRhE
        +iYbE4Oq1ahZwmLDXF981XmhsNj8pvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-a5dhx_99Or-ZLvEJjTEt5g-1; Tue, 19 Nov 2019 10:41:03 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17688477;
        Tue, 19 Nov 2019 15:41:02 +0000 (UTC)
Received: from manaslu.redhat.com (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 908C510027A5;
        Tue, 19 Nov 2019 15:41:00 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        dgilbert@interlog.com
Subject: [PATCH] scsi_debug: check if the max_queue parameter is valid
Date:   Tue, 19 Nov 2019 16:40:59 +0100
Message-Id: <20191119154059.9440-1-mlombard@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: a5dhx_99Or-ZLvEJjTEt5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Passing an invalid value to max_queue may cause memory corruption
or kernel freeze.

E.g.

[ 1841.074356] INFO: task rmmod:18774 blocked for more than 120 seconds.
[ 1841.074400]       Not tainted 4.18.0-151.el8.ppc64le #1
[ 1841.074435] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 1841.074486] rmmod           D    0 18774  17507 0x00040080
[ 1841.074549] Call Trace:
[ 1841.074569] [c0000001eae2b380] [c00000018ae47600] 0xc00000018ae47600 (un=
reliable)
[ 1841.074622] [c0000001eae2b550] [c00000000001f9a0] __switch_to+0x2e0/0x4e=
0
[ 1841.074666] [c0000001eae2b5b0] [c000000000d716b4] __schedule+0x2c4/0x8e0
[ 1841.074712] [c0000001eae2b680] [c000000000d71d28] schedule+0x58/0x120
[ 1841.074755] [c0000001eae2b6b0] [c000000000188a44] async_synchronize_cook=
ie_domain+0x174/0x360
[ 1841.074848] [c0000001eae2b780] [d000000002e228b0] sd_remove+0x78/0x120 [=
sd_mod]
[ 1841.074908] [c0000001eae2b7c0] [c0000000008af084] device_release_driver_=
internal+0x2d4/0x3f0
[ 1841.074971] [c0000001eae2b810] [c0000000008ac368] bus_remove_device+0x12=
8/0x270
[ 1841.075025] [c0000001eae2b890] [c0000000008a6828] device_del+0x298/0x590
[ 1841.075074] [c0000001eae2b940] [c00000000091dfe0] __scsi_remove_device+0=
x190/0x1f0
[ 1841.075127] [c0000001eae2b980] [c000000000919bb4] scsi_forget_host+0xa4/=
0xb0
[ 1841.075180] [c0000001eae2b9b0] [c000000000907a8c] scsi_remove_host+0xac/=
0x3a0
[ 1841.075241] [c0000001eae2ba40] [d000000002624d9c] sdebug_driver_remove+0=
x44/0x150 [scsi_debug]
[ 1841.075302] [c0000001eae2bad0] [c0000000008af084] device_release_driver_=
internal+0x2d4/0x3f0
[ 1841.075364] [c0000001eae2bb20] [c0000000008ac368] bus_remove_device+0x12=
8/0x270
[ 1841.075417] [c0000001eae2bba0] [c0000000008a6828] device_del+0x298/0x590
[ 1841.075461] [c0000001eae2bc50] [c0000000008a6b50] device_unregister+0x30=
/0xa0
[ 1841.075515] [c0000001eae2bcc0] [d000000002623a8c] sdebug_remove_adapter+=
0xe4/0x130 [scsi_debug]
[ 1841.075599] [c0000001eae2bd00] [d00000000262eeb8] scsi_debug_exit+0x50/0=
x1348 [scsi_debug]
[ 1841.075652] [c0000001eae2bd60] [c0000000002453f0] sys_delete_module+0x21=
0/0x380
[ 1841.075706] [c0000001eae2be30] [c00000000000b388] system_call+0x5c/0x70

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 44cb054d5e66..c2779012d968 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5268,6 +5268,11 @@ static int __init scsi_debug_init(void)
 =09=09return -EINVAL;
 =09}
=20
+=09if (sdebug_max_queue <=3D 0 || sdebug_max_queue > SDEBUG_CANQUEUE) {
+=09=09pr_err("max_queue must be > 0 and <=3D %d\n", SDEBUG_CANQUEUE);
+=09=09return -EINVAL;
+=09}
+
 =09if (sdebug_guard > 1) {
 =09=09pr_err("guard must be 0 or 1\n");
 =09=09return -EINVAL;
--=20
Maurizio Lombardi

