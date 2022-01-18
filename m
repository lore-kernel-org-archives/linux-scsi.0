Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93C3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jan 2022 15:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbiARPW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 10:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiARPW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2022 10:22:29 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B1AC061574
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2022 07:22:28 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id i82so25947382ioa.8
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2022 07:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=hXIeWmjxOK+9ShgeBWJ8rEVKQBcOGCL48jeDuXezmn8=;
        b=Zpvbp76JPx/QLp8J9GgAaAK0UniPcmLhIeeEPYGAiYwa2frSjsP8FYTEV3k0Hx5TbG
         t5nWWA3SSqJChGNJOKbYt6QwXrD+1r7FOkQe2+nm4TtVLzoJLNYNOcWdCoXvCDsomBVZ
         rzLLLISq46qGL9tHtu33KiNbaANW9l/JXZ9qY142JzJPHc6q2KZamGlaE833ZZbaELXi
         g85VP+kC/3FTVtHKAE5zYwd5qiJ2bTPzpJtU62z9NNnnuUrdLVFTXpcSxJxbf5d8bJu3
         5mmPBUfcWCtQvVp2C+mKkPc3vr3LbwF32dktabhx/+4l6dnUThpf6/KJQBUUsgmqsJpN
         XNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hXIeWmjxOK+9ShgeBWJ8rEVKQBcOGCL48jeDuXezmn8=;
        b=dfJJ90WbU+g5LcU/D4C3NTJ/ZQaanIYMF4FeLL5JtBoFB3lG1LJU1xi0tZSdnv6o99
         R90gli0eNpO+/Mt3iZPRiCptfEAIhRLaYKxk9ho2gpbZd1fs2u08JBxrZOV+biqXgpx1
         DpJvtp8bLTU1a6x/2+I22HHAAX6JQ297wXU4m5e6uAAJR6Ezrckv6qgebQE3Up3KZldu
         sYkJxZGtVhFS4N0LzsZh3iiWmDIgxFldDcU/J/HbGIMthJs7SPBHfY53pBtEpFcH6Gpg
         ad5vQJmOKqpvZorLIZ6kDdiwZofO7awqPbTJE9c9Fe0RRN6GL6MUT16JxnB5eQ9oft86
         6x2w==
X-Gm-Message-State: AOAM5312r1OxlGF5QfGgNVhAKOYry4pwJOWor7+xthxL7j2oYKjbGteD
        WlU6iyiEgbnG0VbNdhIrGqnyRrcXif+d2Y3+3qRJOD9QDnk=
X-Google-Smtp-Source: ABdhPJx10uRCxDYuOzPd1VT6LusjnAkTbHhUHqeeOvqoTsYiimU9pmi5jZsQ+ZSoLNiHMU/W5t40KogF4blH5EtrkN8=
X-Received: by 2002:a5e:9315:: with SMTP id k21mr12866258iom.195.1642519348345;
 Tue, 18 Jan 2022 07:22:28 -0800 (PST)
MIME-Version: 1.0
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Tue, 18 Jan 2022 16:22:17 +0100
Message-ID: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
Subject: Samsung t5 / t3 problem with ncq trim
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello

I hope, that this is the correct mailinglist... if not, pls let me know...

So, it seams, that there is a problem with the samsung t5 and t3,
those ssds are just samsung 850 with an usb-c adapter.
I wrote a mail to linux-ide, but Damien Le Moal suggested to me to
write it to the maintainer of uas.c...
My idea was to patch this in the ata_device_blacklist in
libata-core.c, but since this seams not to be the solution, i have no
idea how to do it...
So, it would be nice, if someone how knows what he is doing could have
a look at it.

Sorry for my poor english.

I hope this helps somehow to fix the problem.

Best regards

Sven Hugi
