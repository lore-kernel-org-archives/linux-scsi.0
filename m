Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB26AC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 16:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A754208FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 16:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KOHwV0nW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgIKQVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgIKQVK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 12:21:10 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EEDC061573
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 09:21:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 7so6977062pgm.11
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 09:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=V2N3yyGKFkqeOT8pl/d/gwuEP1edsjjDij1TWzHYTuM=;
        b=KOHwV0nWFcmp5odmHQ7xW0wqUgPBCInGFvWzFYx7CbMRTC1pRpNbbzrqPDkaCTyrGI
         aiixHJlPI3ZFxsLKEznc4r2xU2sTtU7UuQ951uWegRmFt4CKRJLmoX0+Mw2MjvlX5FkZ
         lLtxqqaZlYlUcVFlHuNjYxiglBzo5akgxD5+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=V2N3yyGKFkqeOT8pl/d/gwuEP1edsjjDij1TWzHYTuM=;
        b=Zpu+zGe8eGPe+R1CYm609oRYnNvccgvjYAhpSKDQjVpJtaDSrRQ+Ws2twP2kZppWH+
         pxtDYH+8Y9hVVZnN/w2ow4f2ox/BiwsV0hpslUvCnJu2Xvmve9BBYRNvf5tCmorQc25q
         em7sFVEC5jRqB687WekblzZJkflVZGLlmknWyIIdgYmwwyE3l+9l6baXagdjR/fyrahr
         lj/vz4RVnU4gwQFnccIVBqNqnm0LFVQ2av/Ov6kjkASVWSdAgeAKRKQm6qi3cJYm2Ru4
         SQN4CFE5IW18Lhw2wFzrVqgKbKh0ZhJNaOPCg555MMywSFBACgv96jLCldgoi5vI/HQO
         mMqA==
X-Gm-Message-State: AOAM532lzeCQestx6a+Gys57zK+QZBRMz+LhJlwrNiYZlU/s3NVzhRep
        tm9ExTqY5NCzXqHniFLahf1IecxTZlZ+xLv8GfZ2Ipb7Yf8etq619r4eXTRzvxq0SkzCmxLaCG+
        NlMRPsgje3MYzfgdln3N5dSWe90DNFwMIhkDzUrH2Cb7M77ZIwONWOzDf6NUTMyr5TKP/SQSert
        QJlZM=
X-Google-Smtp-Source: ABdhPJxpGgIzwcTqsMmFH20kI9k9I0xWfkHDtc9ZwF4JN4kSLx5q+jbnsEb/Iz97CUXit4MYfBvraA==
X-Received: by 2002:a63:1a21:: with SMTP id a33mr2221344pga.305.1599841268392;
        Fri, 11 Sep 2020 09:21:08 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id 72sm2744671pfx.79.2020.09.11.09.21.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Sep 2020 09:21:07 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.26\))
Subject: [PATCH 1/1] scsi: scsi_dh_alua: do not set h->sdev to NULL before
 removing the list entry
Message-Id: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
Date:   Fri, 11 Sep 2020 09:21:07 -0700
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

Do not set the h->sdev to NULL in the detach device handler. It is freed =
at the
end of the function any way. Also remove the BUG_ON since the condition
that causes them to fire has been removed.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
___
--- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-10 =
12:29:03.000000000 -0700
+++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-11 =
09:14:15.000000000 -0700
@@ -658,8 +658,6 @@
                                        rcu_read_lock();
                                        list_for_each_entry_rcu(h,
                                                &tmp_pg->dh_list, node) =
{
-                                               /* h->sdev should always =
be valid */
-                                               BUG_ON(!h->sdev);
                                                h->sdev->access_state =3D =
desc[0];
                                        }
                                        rcu_read_unlock();
@@ -705,7 +703,6 @@
                        pg->expiry =3D 0;
                        rcu_read_lock();
                        list_for_each_entry_rcu(h, &pg->dh_list, node) {
-                               BUG_ON(!h->sdev);
                                h->sdev->access_state =3D
                                        (pg->state & =
SCSI_ACCESS_STATE_MASK);
                                if (pg->pref)
@@ -1147,7 +1144,6 @@
        spin_lock(&h->pg_lock);
        pg =3D rcu_dereference_protected(h->pg, =
lockdep_is_held(&h->pg_lock));
        rcu_assign_pointer(h->pg, NULL);
-       h->sdev =3D NULL;
        spin_unlock(&h->pg_lock);
        if (pg) {
                spin_lock_irq(&pg->lock);




