Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668D1C54FCB
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 23:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388DD206A5
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 23:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/wFog8o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDZXzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 19:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgDZXzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Apr 2020 19:55:09 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE78FC061A0F
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 16:55:08 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id w20so15732909ljj.0
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 16:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=yBSlXpMW1v0ROzEeWCcYRtRQ1QAXB6itNoOD7a6l7cc=;
        b=S/wFog8oRgRFbCTFLjVMUqh9mMnXNKbI19gbs+HVmv48ayatIe7d5G0Iz6XupVF1M3
         qBVFF5y4w4ieLXYgwHcnbvZPcUfcQebOzcN9akqWdgUPFtJgVKgZwyKujkIwN6r1qwYA
         3Ueise1guErmroAl69Pz6hEtt0b3Ivr2PFOm3YPv7Dq4edJgLJu+VdZtHaJUrVIlFjPg
         vDv8S47TBXLqYQaDR13wOQokmSsY3/uioP3nQCARso4RBL//NwITQU4yaB7IqBgLZoC2
         xfvnj7kYgEbhPSEBQ+X/M2EBYr+P+f5PBA772f6wQUiNpCoTzoLAL1JqWCw570HQJhQF
         XR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yBSlXpMW1v0ROzEeWCcYRtRQ1QAXB6itNoOD7a6l7cc=;
        b=qZyJ7kl0QycqmDMdrjiqKr3pkcxUeu++QxINMCWtmQOnycrpyFsg72WEC4chxZQ/JB
         oGHYsiOhxPLgQNV/JIWxRPzspUBcSQl8OyZ3YkE6zf7pBHJldmn43tJ+eCWPbWuHsZon
         Q+CwA+qJgLvEkGnjQ1oX5275a8iudL6xWnNow/tsmopbsEoz6HnqRYePcuBGzqcRUviF
         HnldsGsVPsXe6wM/jgKY8tULVqje6V0bNceZmr4o/ZiEzOgsbhytwo7l0dLOGTIWAS27
         yW0Zh42OnfG40G9SyihTMDrA5xdf/Ba3pouMTlOUBl63OwIjILI5Fg8OHRucS6GErm3U
         2yGQ==
X-Gm-Message-State: AGi0PuaoQe6qe+G9lAXDC2vfcrY6EyRQ4h8JPYryWmfg5v1D7JJKJhUu
        qEB1D2AxQTWD63umofa8QqL5vGUlOboVN7ixQCDVO7IjMm8=
X-Google-Smtp-Source: APiQypKVvCDueqz65yClheLdFvHKdJyVPSSQtTZPwjERoPigVaCYa/TYXwEGxh+ebi+IcNMdIyf6nyUGxIDVX2Jt7Lw=
X-Received: by 2002:a2e:87d9:: with SMTP id v25mr12307100ljj.241.1587945305461;
 Sun, 26 Apr 2020 16:55:05 -0700 (PDT)
MIME-Version: 1.0
From:   Aijaz Baig <aijazbaig1@gmail.com>
Date:   Mon, 27 Apr 2020 05:24:54 +0530
Message-ID: <CAHB2L+cDZCMAwQhVxU99Dwa7Fj90Wwn7qZ9e=78MCqQdwrEjGQ@mail.gmail.com>
Subject: Venturing into HBA driver development
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm a mid level developer with acceptable knowledge of OS internals
and some driver development but up until now, I've worked mostly on
the networking side of things

most searches online are leading me to open solaris which seems to be
the only guide available online for writing HBA drivers

Is there anything else (Besides reading the source), like a guide or
something, that I can read to help me get up to speed with it.

Do I really need to know SAN to become acceptably good. How much SCSI
(and other protocol(s)) knowledge is needed?

Keen to hear suggestions
