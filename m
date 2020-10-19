Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8324CC43457
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C9DD22283
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhZXJVn3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgJSTT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731123AbgJSTT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 15:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603135197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=/UNHIosp3cVAd663F6tCAJF4cHtF8pw7KZ/KpFqhcKs=;
        b=BhZXJVn3z9usHymloracMKQU2GafI+gt7l0LSXGUjjZDLa9STtJ2L/QKz2FFn62a1gGnbA
        Umx+idm+yoSCIMZEin9puyP//5q2wg9F8mevNsjT8u3WmtILNzqwU3HrvPpaRhecpsjyr5
        tColAHV66S3hOquIEr4fkQAm+hvpC3s=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-_h6TCPJqP5i6XRCn2jXI3Q-1; Mon, 19 Oct 2020 15:19:55 -0400
X-MC-Unique: _h6TCPJqP5i6XRCn2jXI3Q-1
Received: by mail-qv1-f71.google.com with SMTP id es11so583473qvb.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 12:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/UNHIosp3cVAd663F6tCAJF4cHtF8pw7KZ/KpFqhcKs=;
        b=KSsbrrcBm3Ru4raVjFy+jV/mNhZeuDjO680Zi+ry1S4VUk7vQVM+9ZXl6I67dUxMgm
         Etq6tYxqavpNjaoU82epJUUP/gRllB8mLPMIKvReZi251qO/TITLjtka+5sUp+CzYM9V
         JdzrqzvQny3fxEB/RamyCi+JXspZMEdcODV5QUPVVsg7gYnVGwikPTx73IWwRQUGGisX
         MCMfyQn3T1CFozycHY6hxGWWfOwOjp0UOkuLj8sjtL9DhsQT9U6C4bG6ER6au8usKvh4
         sKcOkg3FF/SKL9IH8Gy9itg2dYWDGfueV+lvpkRTzmNjLuAwtaNtv91YPk/q3L3c/lAH
         nu/A==
X-Gm-Message-State: AOAM532bxoYHXwVPWevpa1C95uGpRVMEutcQYV3Cd2IDyhlse8Z6w8An
        q1KKjwKUAbWOh4YOyBxuAxb0c9evXBNhm4R5JfV6O6Fcyr1/7GWBcG+rKUj8Vcxd3KUMmGg2nSo
        M8kJmrZVEQ2LmJ17QfTpiyw==
X-Received: by 2002:a37:6413:: with SMTP id y19mr1105743qkb.139.1603135195089;
        Mon, 19 Oct 2020 12:19:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxD9hU21lIF+UvW612n9VgAUffmmpNI98WIqFKfQDD/JnPE1dbUHJMvrnlN3qtwZcUaGgWnbA==
X-Received: by 2002:a37:6413:: with SMTP id y19mr1105726qkb.139.1603135194792;
        Mon, 19 Oct 2020 12:19:54 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id f4sm352036qtd.35.2020.10.19.12.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 12:19:54 -0700 (PDT)
From:   trix@redhat.com
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] message: fusion: remove unneeded break
Date:   Mon, 19 Oct 2020 12:19:50 -0700
Message-Id: <20201019191950.10244-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a return

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/message/fusion/mptbase.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9903e9660a38..3078fac34e51 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -473,7 +473,6 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 			mpt_free_msg_frame(ioc, mf);
 			mb();
 			return;
-			break;
 		}
 		mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
 		break;
-- 
2.18.1

