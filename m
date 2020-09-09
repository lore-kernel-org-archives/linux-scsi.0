Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7753C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 17:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0C921919
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 17:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="hYSSqw3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgIIRJF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbgIIRJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 13:09:00 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63306C061755
        for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2020 10:09:00 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x123so2713341pfc.7
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2020 10:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=9VybDLOR5JDoDcYcg+nUMm+MiFVaKetYFnrN0jpQFMg=;
        b=hYSSqw3Fi+VTsFETVEKe5DNYTZwrfWwK3SaAxRXKFYY1KEEVGgcA18ztCaEuUc6sCI
         5wOXDziF3CDTrK/YaW2YRxEigZ/yJC3enVcE0Dw2ZwSlzwZQdQ98OC6hp9Bueudr/zk9
         zMsliwsiZALKbdAP0QoqO/JGJFD07D+PwfKbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=9VybDLOR5JDoDcYcg+nUMm+MiFVaKetYFnrN0jpQFMg=;
        b=uahXV04riUYVwEMhHler0kc+ib0xU9BtlmLOMcMh8IEaCsyzAvx8ygVvSE9oyOPojg
         NOsWVA3wgByby+OuwbZVnTB+/mvpsXbQh+zVGEx+wamaCwq1txxpsd3ecTkGLvwFqY1I
         XMpP4CTT0yPoaRSK2lK+B8H0Y2cwDx7p0arnfnOiWkENH96KzE8SVwT/QvqCf546SgW7
         3SYxL1sTcZRxqN8eY5joRB/NWAYxiGAMfzQOZnnZfFlvRvbHCqYGF6Cr+35wuPf11U4h
         8LEXrU33Z82bcVS4CjOXJDXyrnNL2wD2/7MNs99ZSpRnzHIlhMzy2TSnnp/YaGjU8a/5
         BbRQ==
X-Gm-Message-State: AOAM530TF9Kn6mX+xpGKbG8A6ZbqQwwrTJPfbzNU2sdRNkWzAJ/y2ze5
        nHa5DvgBhAxj6y+gTTZFeJPk6UJVlYLFGZgaPwtCuFAGjP82xW0FwiQGtTj+KvveGwAfb6Z5yYu
        sl1etZSizgViqaSWcljQe3OzELzyd3pASTMWjV1HUHmwpumvLMUcdwH/DLFCN3JI/AUnqtYQpLn
        h1GdU=
X-Google-Smtp-Source: ABdhPJy9pSADJStUcpB0DRuUkNT+Xkn16Wg6aqC9MdlCiRlfWR5ORIxo8Tq3V8hSz0nymbaewKgljg==
X-Received: by 2002:aa7:9817:0:b029:13e:d13d:a139 with SMTP id e23-20020aa798170000b029013ed13da139mr1599537pfl.33.1599671337360;
        Wed, 09 Sep 2020 10:08:57 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id u10sm3249818pfn.122.2020.09.09.10.08.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2020 10:08:56 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.26\))
Subject: fix for kernel BUG at drivers/scsi/device_handler/scsi_dh_alua.c:662!
Message-Id: <FF501332-F768-46E2-9CB4-CAD103952509@purestorage.com>
Date:   Wed, 9 Sep 2020 10:08:55 -0700
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3654.0.3.2.26)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello all,

It looks like I sent this email to the wrong mailing list according to =
RedHat so I am sending it here:

>=46rom my earlier post:

https://www.redhat.com/archives/dm-devel/2020-September/msg00083.html


Would it be better to move the unsetting the address of sdev to NULL =
lower? This would protect
against the crash we see when the alua_rtpg function tries to access the =
sdev address
that has been set to NULL in alua_bus_detach by another thread.

--- a/linux-5.4.17/drivers/scsi/device_handler/scsi_dh_alua.c	=
2020-07-29 22:48:30.000000000 -0600
+++ b/linux-5.4.17/drivers/scsi/device_handler/scsi_dh_alua.c	=
2020-09-07 13:38:23.771575702 -0600
@@ -1146,15 +1146,15 @@
=20
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
 		kref_put(&pg->kref, release_port_group);
 	}
+	rcu_assign_pointer(h->pg, NULL);
+	h->sdev =3D NULL;
+	spin_unlock(&h->pg_lock);
 	sdev->handler_data =3D NULL;
 	kfree(h);
 }

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



