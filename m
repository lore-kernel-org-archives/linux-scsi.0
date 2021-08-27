Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E7CC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 14:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E0D60F44
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 14:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245205AbhH0OLY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 10:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhH0OLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 10:11:23 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46E2C0613CF
        for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2021 07:10:34 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id t4so7247601qkb.9
        for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2021 07:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rrJMTcBJng7lg5+SYeFOOrr3iU5VlkOZnQpM2Ssl+hQ=;
        b=oVatR1qDsx2892HhBb+8XxxPXjxCNF6FBamsG+Z1leyWQpucAiUcA8mC7J2HpqNAgw
         MqUQnzTht9L8TKigieacD8a1mjenTQb02uvQ/FDnuFrwdono+sStwj3XPNT0XBP5PZus
         OEb2uGxrkjUW89z/R41/YeTS+HFCwrGK2Qhi4KGJ5XLRbk4ZQ3GJmi3gdoqCkJC0uVvU
         mg3sfjGENmHU14Y6wdWHBFyJI+vGsLYwX8xrkkC7OoD1q/vCrup1Ycj/n2nebl+EaTIX
         sjGTeLIDagyx4d6SOSfavzNTgCH6HQjWpOHnmuLIRbfbbNgjuS/S7oBF+R06e2Iv/QYi
         qoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rrJMTcBJng7lg5+SYeFOOrr3iU5VlkOZnQpM2Ssl+hQ=;
        b=F9YIjqUFy87FJ3SSHp+T0FxIdLKEaE4ziqkiYmiUpGHQ1xwxx3H+O+Qzg9fUs63d04
         QsyhXSKIaI852GPorD64mJHmEghVr1SqsiC3q0mr+pVqiteUSieiKUSoJ3iSDzTsb9qp
         IMfa8h8Mk2wk6Z/sAImAn1WaIRYs3FdK/uBNqZQWtamfCBGdHYTV9z81ozlgO2EYG0RJ
         qc+ydzKQ0CHrKWbtScWNBoWw6JA/k46bNOLJ0hWlwzjo7R+Flk1Z6abUa/TEiXU+P9Nx
         5BBwZhSVHbVBgyi0H94lSuCpCIERJzMU3ePdyPARUNyjxeVQEKGai9k+IYxOrLC/6DsF
         JW9w==
X-Gm-Message-State: AOAM530RmzB9TeY1S6uHyqD/ksNg045LMppr/laanaVX7mK4S6ptBBGq
        cYNYesSSuV0xpoQla43V+W5wLNticxIXog==
X-Google-Smtp-Source: ABdhPJx8uZ6KLSWLiaVTzdcF+CbRkbzecbW/I0NEw5CCcQQmsWp9AEHqNOuk2nEze21vyoYUbNF4iA==
X-Received: by 2002:a02:6a55:: with SMTP id m21mr8501409jaf.74.1630073423420;
        Fri, 27 Aug 2021 07:10:23 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g11sm3457252iom.46.2021.08.27.07.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 07:10:23 -0700 (PDT)
To:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: Wanted: CDROM maintainer
Message-ID: <22d59432-1b8e-0125-96e9-51b041fe3536@kernel.dk>
Date:   Fri, 27 Aug 2021 08:10:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Back in 1998, if I recall correctly, Erik Andersen posted on lkml that
he was looking for someone to take over development and maintainership
of the cdrom drivers. I responded to that, and ended up maintaining and
continuing the development of that part of the kernel. Outside of
working on that part of the stack, it eventually led to diving further
down the rabbit hole and into the general block IO stack. In many ways,
it kick started by career in kernel development.

These days I've got a lot on my plate, and areas like cdrom have been
neglected as a result. This obviously isn't an area of hot development
these days, but even so it still needs someone that cares for the code
and is available to review and merge patches in a timely fashion. I
haven't been able to do so for quite a while.

In the spirit of passing on the baton, I think we're way overdue for
some new blood in this area. With the recent removal of the old parallel
IDE code, the old atapi cdrom driver is gone. Hence there are really two
parts to this these days:

1) drivers/scsi/sr.c - the SCSI cdrom driver. My suggestion would be to
   fold this in with general SCSI maintainership, as that's really where
   that belongs.

2) drivers/cdrom/cdrom.c - the uniform cdrom layer. This is really the
   meat of it. sr is a consumer, and so is the paride cdrom driver and
   the sega dreamcast cdrom driver.

If you have any interest and experience with cdrom/dvd and mmc/atapi, I
would love to hear from you. Let's find a new good home for this code.

-- 
Jens Axboe

