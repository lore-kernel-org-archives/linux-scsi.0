Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F32CC2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707AA20863
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="dJU/2POp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgABMD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 07:03:56 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33000 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgABMD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 07:03:56 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so38060814ioh.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2020 04:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JS5FQQWC+NK8XR6GAAeE1BL2YKEN9XefX5WxgUHZfs=;
        b=dJU/2POpnhjmXo0qk3NvUiRAeK82EiO0W9mPnzwsBIe+ANHOKBtwj8T0Q5dg8B2PKb
         YBG26Z24uT8bmDqtT1botDIE3zDnKLkLsvzktd8Qfpi/iT69URpXblRHcQgXxUMyr9ze
         2hQs3Ac8zP8E9o7MM0THCd0Cvxwo5yWBQ6Ks3gKJukYFOsomFTtwBohyPt3gWeVXaepv
         TSB7jf0RrP7yTQG88WM0HM2o6wbbbbTjwJg4Szm9ViHXwX3LAhMoLDY/O8drtco7pHKu
         1gLo/gRFODeH5wUU9EGqX0p9LAFMYvVLeLDOwt9GLltTo1IsLpwjuX+cYzx8+KIbOK/L
         eNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JS5FQQWC+NK8XR6GAAeE1BL2YKEN9XefX5WxgUHZfs=;
        b=ZQlqdnKW5HMBG8nGl+h8/8gzo/JvFyb/MgOxXazxBXsyDXz+rAzfFcGpiia8h/79QR
         1b7liNe0wyvbWdBLQA+T3zoNbyxVqD8jv4JxtAPExibDLdUgazTxFzPaAX+CF1tLhBx9
         UzuPXXfsym36Iv8D0ii25ObXBbv/GWZY6Ddv/V0v/KTGA9faX9XrsohF2m5X26LnULqy
         qgW+qKESb3MfuoGzOXIBDJS44h5Dm9UvZi1Qir3B55796XdVlQAbb+gdPbZMKYRzK42/
         JgAbOTR3bcTeHzYb/IiwWnXKA/vNogv78t3ToV8AkWBIWyMH9NdYlZVzduIg9vqWWoaM
         2xBQ==
X-Gm-Message-State: APjAAAVRDzC3XZYpgFy96q0y4sXlftcX1k6/Zy/i9SzxVl4s1Q+bK/4U
        wUe3GJMVicWOORqjbEO86WXHLAMlLboJQ3F2BWRakQ==
X-Google-Smtp-Source: APXvYqzKw2e+snUSQz/E71WH6g13VoDhEGYbPKU6ubpknubuHxNmeRWl4LyClwo/b84iJ+DEa4RsckpNkfxmLl6cY/k=
X-Received: by 2002:a5e:c606:: with SMTP id f6mr14765576iok.71.1577966635275;
 Thu, 02 Jan 2020 04:03:55 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-6-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-6-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 2 Jan 2020 13:03:44 +0100
Message-ID: <CAMGffEk57rUWr_5bdHFfg05+Ptpt5yBu9RkopR26x-sH=urESg@mail.gmail.com>
Subject: Re: [PATCH 05/12] pm80xx : Support for char device.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the support to register char device for pm80xx module and
> also added the ioctl functionality to get driver info.

Please describe why do you need a char device, also the use case for
this get driver info functionality.

>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>
