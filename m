Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0378AC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 29 May 2022 15:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiE2PjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 May 2022 11:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiE2PjM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2022 11:39:12 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47AF62CF4;
        Sun, 29 May 2022 08:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838737;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=b9EOAZEtMeMOw4CE+ljgRiq8Y/E5wl6YtfwQ/Y/g9fY=;
        b=K9iFG7haZUnGl1ACKH9GvvKesKECfbzX0cWBpwodvG6BRLJaHls0JImr3+HAEmHm
        +uXvCiCjRePe+nObZGZ1d8VfQOOPYWwOdhdmUaZpfa4neNxZWqzjfP1RRtS6NR27ONk
        ReifQ7gUfj5xi9TRzz/Qulfxi6GMfkwK0JwzVfaI=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838735065952.2650944013579; Sun, 29 May 2022 23:38:55 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-2-cgxu519@mykernel.net>
Subject: [PATCH 1/6] netlink: fix missing destruction of rhash table in error case
Date:   Sun, 29 May 2022 23:34:51 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220529153456.4183738-1-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix missing destruction(when '(--i) =3D=3D 0') for error case in
netlink_proto_init().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0cd91f813a3b..bd0b090a378b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2887,7 +2887,7 @@ static int __init netlink_proto_init(void)
 =09for (i =3D 0; i < MAX_LINKS; i++) {
 =09=09if (rhashtable_init(&nl_table[i].hash,
 =09=09=09=09    &netlink_rhashtable_params) < 0) {
-=09=09=09while (--i > 0)
+=09=09=09while (--i >=3D 0)
 =09=09=09=09rhashtable_destroy(&nl_table[i].hash);
 =09=09=09kfree(nl_table);
 =09=09=09goto panic;
--=20
2.27.0


