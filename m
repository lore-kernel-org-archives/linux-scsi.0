Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD21BC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89AB82070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhA0Fhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbhA0EpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:45:16 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E26C061574
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 20:44:34 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w18so388304pfu.9
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 20:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r+K96DRQNy+NCjrBH8FDjJUlajTw0HIRdd1WcRhlN/M=;
        b=UVcjqGGe85X+L0qn+Kk5fz/VjgPr3QmUjWO6zbVnHL7itHBwO37JREM56mvKRJEsoo
         eOKl+RuEW8qGJQdzddv2j9Prlv+U6F2uf2C4efItxoQOnGrQyJR7JK/Ajp9jUP3RfPR/
         KAg2KSPDe6zpIfAdv2mWBQCgk2CnGHo29ZBQ7NWVnF1Ua2++xdgz8UpVVapIHcZwDKhW
         dDvj1ZW40v/j37Lsc15sqSaRzM2pU1V88RruDYAGPsbHSWvuZiAWmG3JfUdODp2cfjXm
         HNRoZWsNBTBTNJOj5JL+c5m5BJIGTHIfDFmzgsivAL+Rmw8jSJ4gwPxsqAhf4qyfaXGJ
         nKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r+K96DRQNy+NCjrBH8FDjJUlajTw0HIRdd1WcRhlN/M=;
        b=RLCUR0TLypYGoq7xG9Xs4lDIwPaBhvi8zvlnVogJYo8QFKoU+l+qvaJlDK8YJ0yOn2
         zNxUXclRQjgb0CBCH5QKwdKcYBz0tcqHrC66fQXlgBe59BAxCw8HLO24E2D4Qz+xr5R5
         vDWT3V5t+1wveen38Evv+MWbSOk6uXq8XjrrFJ5w4QTbIw/D2C/rn/ICy8Braq8QNjzr
         l+m+vv3fhCMznPLfCu6NjDxniBLDoIb7o/Rqm/yEYY66HofPmzTIvKimLyiWUwfDcaKO
         u/HAqSs64cvuGdwoA9r/cB9RGY9RSepyZF6UAfGK6F5QFuA2/13/aQullh4AIHB1x1Gn
         uRwA==
X-Gm-Message-State: AOAM5327R49KQsFYoJMnWhvLPwyy/ABUb/6d5Bp8rFuoGEdL3MmLIDC6
        kv4FxldNHffZ5iyTbM5HSg0a9V/tu5yLERJRXU0=
X-Google-Smtp-Source: ABdhPJy8b8YdzQVbAnNPUcaXtNEKXE8GW00b9jOAcbtjovAq4qyDlHtF0sTCJjX7ok253I/FY7tG1tM59SmrmCJy/gQ=
X-Received: by 2002:aa7:8209:0:b029:19f:3002:513 with SMTP id
 k9-20020aa782090000b029019f30020513mr8770572pfi.49.1611722674109; Tue, 26 Jan
 2021 20:44:34 -0800 (PST)
MIME-Version: 1.0
References: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
 <yq1czxrqai6.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1czxrqai6.fsf@ca-mkp.ca.oracle.com>
From:   Patrick Strateman <patrick.strateman@gmail.com>
Date:   Tue, 26 Jan 2021 23:44:23 -0500
Message-ID: <CA+-=UwYTKhvEDSq3pZgpoH1N-Tf8Smq1cRE+J7t3-A+SCeYaYg@mail.gmail.com>
Subject: Re: [PATCH] st: reject MTIOCTOP mt_count values out of range for the
 SPACE(6) scsi command
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm happy to implement SPACE(16) instead.

I believe the opcode for SPACE(16) is 0x91, but in
include/scsi/scsi_proto.h that value is listed as
SYNCHRONIZE_CACHE_16.

I couldn't figure out which was wrong, so I proposed this to at least
prevent the interface from doing the wrong thing.

On Tue, Jan 26, 2021 at 11:26 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Patrick,
>
> > Values greater than 0x7FFFFF do not fit in the 24 bit big endian two's
> > complement integer for the underlying scsi SPACE(6) command.
>
> I was hoping Kai would chime in.
>
> However, since SPACE(6) has been deprecated for a while, I am not so
> keen on blindly enforcing this in the ioctl interface. I would rather
> see SPACE(16) support added and then have the supplied count value be
> validated based on whether the 6 or 16 byte command is being issued to
> the device.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
