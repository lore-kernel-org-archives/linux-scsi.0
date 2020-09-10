Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78FCC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 21:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79407221E7
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 21:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="E2vJlq56"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgIJVWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgIJVWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 17:22:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DF2C061573
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 14:22:06 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x123so5508729pfc.7
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 14:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=7amgYtKA5AHB51jGt6qVc4R+ZemklilWw9+RcNp7k/I=;
        b=E2vJlq56WKILuCLvyIfkVv48J4mznCKv7BjL+pkwZXttswl1TseVd5+k82D8XX/qd/
         dSc7Z6sEB8dv7gn1+Lg1xBZzPEY2cSsqcSe2lhsUoaEmVAODAZhd2LgtrSzbChvdrBxG
         yRggepQgkuz8l2yc8uJSsUd4A9ElSkfrsDg5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=7amgYtKA5AHB51jGt6qVc4R+ZemklilWw9+RcNp7k/I=;
        b=JSN3ILFxdr9mNu1WvG/klsxawBSIYKjIvI8oUtAni3zQSTmDjkP/e0FoxbWdGEPfib
         Q+cYGifdfjyTw8EmE7VA0uOZUJQMAKC0ZVOwyPOzYbfyCYr+nND0//6kmRlyRehYgeW6
         Uz5Wso5tgY745u1CgqyGg4Fe1RpQsyCbATTdjFebmR0GW+2My0QD/lqx1aQLJMaII8v3
         W/cPSinf/Lh5gtSjJ64dchrN8UFYU6gIa6MUpbPoKWkf1I+1Ax5/wSCcPu0rTphumLXa
         zGXxubAkVEIiqxh0sWq1khWOHfXnx1USuU3Vv5NYbjB1lJGF2WPaoWk5HvziEgYRyy0z
         m3mg==
X-Gm-Message-State: AOAM532Jb2MAaqqU+DDIdCWRq6WKP6yJh0bttVIJBUzkFu59sHULnfDt
        sjp804JofrvyM3J44ocOso/iFWSj3GlLXc2PKnYdVFbglqtPbRwZi1xKz36SnJ0UK8nNb5SMGkD
        +cfS0+4Zftkd/e+y8Zx/c5YTHZtibbaWW0AZW49a4cYO3R8wMy2kNW28Ga3Vzlh7tTE5cT0vc5o
        qcMT0=
X-Google-Smtp-Source: ABdhPJwCAPnP6rUSKjA2YrAO1zLeJOJiGqs15R6ZE4WizOC+lz7iZMQ9Hj+WgrCH8SMDJvttmHNS4w==
X-Received: by 2002:a17:902:bccb:b029:d1:9be4:9d22 with SMTP id o11-20020a170902bccbb02900d19be49d22mr385846pls.40.1599772923843;
        Thu, 10 Sep 2020 14:22:03 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id w19sm22676pfq.60.2020.09.10.14.22.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 14:22:03 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.26\))
Subject: [PATCH 1/1] scsi: scsi_dh_alua: remove the list entry before
 assigning the pointer and sdev to NULL
Message-Id: <4064EB40-C84F-42E8-82F7-3940901C09D2@purestorage.com>
Date:   Thu, 10 Sep 2020 14:22:02 -0700
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3654.0.3.2.26)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A race exists where the BUG_ON(!h->sdev) will fire if the detach device =
handler
from one thread runs removing a list entry while another thread is =
trying to
evaluate the target portal group state.

The order of the detach operation is now changed to delete the list =
entry
before modifying the pointer and setting h->sdev to NULL.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
___
diff -Naur a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c =
b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c
--- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c	2020-09-10 =
12:29:03.000000000 -0700
+++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c	2020-09-10 =
12:41:34.000000000 -0700
@@ -1146,16 +1146,18 @@

 	spin_lock(&h->pg_lock);
 	pg =3D rcu_dereference_protected(h->pg, =
lockdep_is_held(&h->pg_lock));
-	rcu_assign_pointer(h->pg, NULL);
-	h->sdev =3D NULL;
-	spin_unlock(&h->pg_lock);
 	if (pg) {
 		spin_lock_irq(&pg->lock);
 		list_del_rcu(&h->node);
 		spin_unlock_irq(&pg->lock);
-		kref_put(&pg->kref, release_port_group);
 	}
+	rcu_assign_pointer(h->pg, NULL);
+	h->sdev =3D NULL;
+	spin_unlock(&h->pg_lock);
 	sdev->handler_data =3D NULL;
+	if (pg) {
+		kref_put(&pg->kref, release_port_group);
+	}
 	kfree(h);
 }=
