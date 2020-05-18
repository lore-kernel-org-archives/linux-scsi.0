Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFD9C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 01:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A539207BB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 01:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgERBC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 May 2020 21:02:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbgERBC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2020 21:02:29 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-4JzaRyvBOUKOHEemSFbP9g-1; Sun, 17 May 2020 21:02:25 -0400
X-MC-Unique: 4JzaRyvBOUKOHEemSFbP9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29B68474;
        Mon, 18 May 2020 01:02:24 +0000 (UTC)
Received: from ldigby.remote.csb (vpn2-54-25.bne.redhat.com [10.64.54.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 907A1398;
        Mon, 18 May 2020 01:02:22 +0000 (UTC)
From:   Lance Digby <lance.digby@gmail.com>
To:     mchristi@redhat.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 target] target: Add initiatorname to NON_EXISTENT_LUN error
Date:   Mon, 18 May 2020 11:02:16 +1000
Message-Id: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The NON_EXISTENT_LUN error can be written without an error condition
on the initiator responsible. Adding the initiatorname to this message
will reduce the effort required to fix this when many initiators are
supported by a target.

This version ensures the initiator name is also printed on the same
message in transport_lookup_tmr_lun for consistency.

Signed-off-by: Lance Digby <lance.digby@gmail.com>
---
 drivers/target/target_core_device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_co=
re_device.c
index 4cee113..15064a5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -100,9 +100,10 @@
 =09=09 */
 =09=09if (unpacked_lun !=3D 0) {
 =09=09=09pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-=09=09=09=09" Access for 0x%08llx\n",
+=09=09=09=09" Access for 0x%08llx from %s\n",
 =09=09=09=09se_cmd->se_tfo->fabric_name,
-=09=09=09=09unpacked_lun);
+=09=09=09=09unpacked_lun,
+=09=09=09=09nacl->initiatorname);
 =09=09=09return TCM_NON_EXISTENT_LUN;
 =09=09}
=20
@@ -174,9 +175,10 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u6=
4 unpacked_lun)
=20
 =09if (!se_lun) {
 =09=09pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-=09=09=09" Access for 0x%08llx\n",
+=09=09=09" Access for 0x%08llx for %s\n",
 =09=09=09se_cmd->se_tfo->fabric_name,
-=09=09=09unpacked_lun);
+=09=09=09unpacked_lun,
+=09=09=09nacl->initiatorname);
 =09=09return -ENODEV;
 =09}
 =09se_cmd->se_dev =3D rcu_dereference_raw(se_lun->lun_se_dev);
--=20
1.8.3.1

