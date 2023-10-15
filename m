Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B23CDB47E
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Oct 2023 19:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjJOTJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Oct 2023 15:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjJOTJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Oct 2023 15:09:20 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302ABA9
        for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2023 12:09:19 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-d84c24a810dso4497046276.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2023 12:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697396958; x=1698001758; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5Ca6w8zcAJyVhhG2bD8gOs8AkSxC/TrDpXuOb1kSNMo=;
        b=Kf4dUOmN2K46LomuJRNC7hFXvYYwI6kFfRGJ4LXpHEBFDAm87Ws+lq+mhN136YnSZs
         +gnUrUEDy0VMl9bOmHwY5yU+ThHdg7giE44dYj+y9gHzkCAkEZUgOMkAWbhdaFFkt5NE
         KJ17r6Kq91A/5olBzx9R4uUZBbzyO2YANrnR7YYtpWKb0VIvh38UsMo0ElppauwVywqs
         MLYIdJRwpa4Q2y+joR7TF8qS1yrP5PfKj6lhQs1Bggpw5+uNAMjIi5q9PssZAu+pMgB3
         WppOKP8d8nxxivSxrZ5UXBrZoiUb/9rBuQlGF/zFMF/fLqoYkm7CaY510/Or2ARPwT2K
         G1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697396958; x=1698001758;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Ca6w8zcAJyVhhG2bD8gOs8AkSxC/TrDpXuOb1kSNMo=;
        b=auQLGGlzmG6OZgIBkqZgpNwm1Z1jg3KK0laHykU+k6Hzb1zcr8sZdxACBuyo+d63w+
         vBtx77rx7339W5EJ0rn2YA6ZGihUG7TlT31/KYG057QZu9Qt1k8ygLshBIj9Sdl7KMYf
         xcm3uriPEilwG5sgX4CUaAA4PwpS9S01jyzZiXojAn/zCKZE/foh1qqwfoh3kQ6jU/dM
         y/ABZ//D8/8CL+9mbDrtcb3aG6d+vpzs/eDcVOeu1HLcLeW/O1+JF4odawJ5OWVwq/ZS
         jZ7VjBy5l/9qSSYhzPvBysuwdnVC38OIkyVdVLp0AOwAawQIHdEKXFfrmu7Nh3FwTVNM
         2x/Q==
X-Gm-Message-State: AOJu0YzLH/lgFzIofOlUptduohPJwYsDmNNw/Q/V0FkLwlX3CF4lZTh6
        3YKExDuVT/gn00oy5kV/mVm84xzCW09UDxdF1r0V2Loc3fo=
X-Google-Smtp-Source: AGHT+IEd83n2zBvIyqcYsrLvaTOAsP5FAvAw2eTdlZGSJVsi71AZUPRkCF0SY546ECW2kTZ71pK53fXmBH3eVVX2HxI=
X-Received: by 2002:a25:19c2:0:b0:d9b:ea48:e5c8 with SMTP id
 185-20020a2519c2000000b00d9bea48e5c8mr326186ybz.59.1697396958243; Sun, 15 Oct
 2023 12:09:18 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Barkas <nickosbarkas@gmail.com>
Date:   Sun, 15 Oct 2023 22:09:07 +0300
Message-ID: <CADg+sAHmMLYAndZ9CaDDHsyGCJd1ZXyJ7SnWZMOfEtM7tqWdtQ@mail.gmail.com>
Subject: Re: PMC(Adaptec) 7805H(7H series) HBA compatibility problem with many
 Seagate HDDs
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,
there have been a lot of patches on pm80xx lately and I decided to
test again with kernel 6.1.57.
Unfortunately the issue remains.

I have uploaded a dmesg excerpt with debug logging that shows what
happens when I run a random i/o test with 128k block reads with 32
threads for 1 minute here:
https://drive.google.com/file/d/1OFpcaZmjkhUzU3b8UYd7mVDBhJzmVnhg/view?usp=drive_link

The system becomes super slow for almost 4 minutes and a lot of i/o
errors occur.
The seagate disks and the controller work fine except when put together.

Regards,
Nick
