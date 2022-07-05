Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E8BC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiGEGyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiGEGyM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:54:12 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26284959B
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 23:54:11 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-31c8340a6f7so58408087b3.4
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jul 2022 23:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Queo7cdMLBRpaTu5Sc/SmhVPDMVL0zH+Ng8A8pwNRLQ=;
        b=VsGity2DdqDD8LwLxtEJyw86QtfSDZXELPdE4X6pHWq42zwWUJmxrFw5N2IfMG26xd
         qIqzK98T3R4rYXJ7HcesTzkxmTKnXyhrcL1S2oh59kxFIrQhEfGQVfPLsGFUTFlWd1un
         ss/tKq0JP1YQLSzqLN/1agR5bLV+navkqOOwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Queo7cdMLBRpaTu5Sc/SmhVPDMVL0zH+Ng8A8pwNRLQ=;
        b=RxeSPLvQfBbLvYdlJutIgVWxsm7NAxmekLVYJAn30m60Z/q47rzT5XbcMZUA1SQELP
         xdreahARCJHDCOz3u+Fb2udiXKIgkTMcBz12FaxYO3EBM6pAD+I3UIFiMOW9vrKG0CjB
         6epyiIX7DnWJ6FcAlr9j+UhxDuz5g6sP4RqQOLzKmes3WETwUaFLSTLLEnBBHWwGJmTV
         3FEhblFTZpyEXrw0k4GqkWNbWOhY+QK4LSmy13ErkRWinsfPYUX/XPzXkYU6GgC2qQY6
         uIO8zHLSj8FNpE9WP2xvlmG5iOe4ZC5+5OwtMkFrj7firfz5O+6ijMA05M0GYQ8aSs2i
         gXaQ==
X-Gm-Message-State: AJIora+JJ8fyx/h3wAvT6+St6ZQH8KLKtYSIuTkUekmUQiA9biw+vsau
        x0/UW1HGJv5grozsJxxI9tQHxHRJg5+jHmuuhz9UAw==
X-Google-Smtp-Source: AGRyM1uYahqfKP3lgPn/sQ8wD9kpteYhZ+/WekxkCP8fq6Mfa5wNY9A0kgr97SUsb0jkUqgAtR/7KRXQXxlbxysGCJM=
X-Received: by 2002:a81:c8b:0:b0:31c:7d90:ff0d with SMTP id
 133-20020a810c8b000000b0031c7d90ff0dmr19629109ywm.266.1657004050457; Mon, 04
 Jul 2022 23:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220704092721.1.Ib5ebec952d9a59f5c69c89b694777f517d22466d@changeid>
 <fd3bb4b5-0a19-2dc0-c4b5-60f32abce508@acm.org>
In-Reply-To: <fd3bb4b5-0a19-2dc0-c4b5-60f32abce508@acm.org>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Tue, 5 Jul 2022 16:53:59 +1000
Message-ID: <CAONX=-e+4+92aY=g-_Y-8PZmk1ALkrj7BDADKaSDE9fNJfR96A@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Enable WriteBooster capability on ADL
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Bart.
Sent v2 patch with the commit message fixed.
--Daniil

On Mon, Jul 4, 2022 at 1:00 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 7/3/22 16:28, Daniil Lunev wrote:
> > Sets the WrtieBooster capability flag when ADL's UFS controller is used.
>             ^^^^^^^^^^^^
> WriteBooster?
>
> Otherwise this patch looks fine to me.
>
> Thanks,
>
> Bart.
