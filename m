Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DECC33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A36720842
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="U9tHqWYk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAQOf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 09:35:26 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37210 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbgAQOfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 09:35:25 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so26184826ioc.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 06:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AR9xNVW8DzroePFi4I60D2jYDKum8gcIuyxwPgVsKEs=;
        b=U9tHqWYkcxlJofwsMIwtEuUYFlPSZmXzwxq2kRFzDCuBK7yHfnthsi32xJclQZMcop
         p7dzrkrgzkOoA7Vwh+FZYxrkZwAALn9EeXvHJHxr+e1KZ/coby985sUHystunhgVjjez
         Ha37flL4VKoiUlXkOBapxFBoS1ynywQu2c6VME67mdohTBMm0jJQ3E18aFRCa9sUkR4S
         bpqmGdYW47fY6F1FvsyehDCgVruvSDVWXjkWspCSM/GVNGR0fPjfnDtwX5A7AbfwCySc
         HgjI5PqGD0Jklkoyd7s7USVBuH4dtKibxxLYmMvM88S/LLoVAe9xXykFuyg48klRqt0l
         qakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AR9xNVW8DzroePFi4I60D2jYDKum8gcIuyxwPgVsKEs=;
        b=gLAjgWUoJ1RbXMXRxxHkQXpAnaK3V9djbYBY1OqvsR4KGoWwCrKtiEa9HDoNFhkcPh
         R1AgcRYNRwQCmb7hh3SP1GDs9fGQtQjEHhYNLbLBYV40FktDIL8oL1WiAKuTB1n09rXR
         BA4C4XkzrwvDGwz9jiy5TRyc6X5+euE71u/sv72nkR3wObqFFgW83Pxe4zM2vGYvqsRa
         ZOmtHfbDfLCfCXPozKufmR9e7TJQND4nFjyKvSs0WPC2HqNjKkt61u93JnG8gwfqdZpB
         qgwU2gJxQpfAUZDi/SWheREknsH7WzeqQTVDpAJyYVkCV1lUgafQ7ojoIRudb/KPz4OD
         n3Ww==
X-Gm-Message-State: APjAAAVplO7x+CBaLl5AeIhq05z3OvGqcdjOX0zo9LxtQiqz9njH5D4K
        yQRPRDnABfSEJmL9jCCwNEVAAuNJO5EJocOY0GuRqA==
X-Google-Smtp-Source: APXvYqz5Q8wmRiFuPWd3i9g193D7zraE4eF5SicXQEIpcyRCoyghM5sErzVtiT3NIZvliMrklglM6Dj8uRVrJ17oTeU=
X-Received: by 2002:a5e:c606:: with SMTP id f6mr15525105iok.71.1579271725020;
 Fri, 17 Jan 2020 06:35:25 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com> <20200117071923.7445-8-deepak.ukey@microchip.com>
In-Reply-To: <20200117071923.7445-8-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 17 Jan 2020 15:35:14 +0100
Message-ID: <CAMGffEkjgKeR0kt9u1sLSD_ngQy6rr3cbn4zpzFuwGtKfHTJKA@mail.gmail.com>
Subject: Re: [PATCH V2 07/13] pm80xx : IOCTL functionality to get phy status.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  struct pm8001_chip_info {
> @@ -560,6 +563,10 @@ struct pm8001_hba_info {
>         bool                    controller_fatal_error;
>         const struct firmware   *fw_image;
>         struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
> +       spinlock_t              ioctl_lock;
> +       struct mutex            ioctl_mutex;
did you ever initial both lock? why do you need both? I failed to find them.
> +       struct completion       *ioctl_completion;
> +       struct  phy_prof_resp   phy_profile_resp;
>         u32                     reset_in_progress;
>  };
