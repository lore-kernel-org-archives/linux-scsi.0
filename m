Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E726DC33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 23:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF767206E5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 23:57:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpvdQUd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgAMX5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 18:57:19 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:36732 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgAMX5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 18:57:19 -0500
Received: by mail-qk1-f176.google.com with SMTP id a203so10522223qkc.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2020 15:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LN7qLh71H+QbcGbIetP9xZTs++TQtaYIEV0MJGB09to=;
        b=IpvdQUd8yJNqRYFQrJU2jlw/Vl+QDTHO3VL2XQObKThzQoUqzRIp7TAKfucGBCSDP/
         OSR8GyFBOJTbrNVmXHxI9+SoKVg3b24F9F3M9gMnGQQtuN5v+FiXciyjrmhJQ8Oh/Fyl
         HjE8IocjZSO5sEinc9YTOYkS51OcViD+mHIenUXrx9GuDQzW4A+qMScrQGS2I6ztAoMw
         9bhQun3ebuk6ngtLLgqvTJMiccPh/qPSN59I0uaGIkCWVO5k3YOzAOGsL3jG46S1hkLd
         ZQRtBm7VoqY8NSOUqHxgsJR0k5OAjeGcOuzKukEJE1pYbPMkOz6fo/nkkCnFs7R5Tfxm
         DsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LN7qLh71H+QbcGbIetP9xZTs++TQtaYIEV0MJGB09to=;
        b=EvtPttxW3gA4nLpib56njV2d3tTiTiXFgGpj+x8xSIQGEDk0OXLxUavNw76nbLDfCz
         Ezc7lJkUNaovtZdf2rtw1nBsWuppvmcjiLaexWnC1QyziLsECVANBqwP/mVvseyZ6FAh
         mFBEbmLgRedMwgqfCXcwejgbiXjK6cHlnQLp/CSevxGXrv9x0xvvCsanUOc3HDz2DxW/
         MSo692QZFK72bl5e9HZO6pSxb4QDhlgdRufZKHl+XkD7Wt5SqoTCkGtEXJHaTAW+Mw8j
         oEftYKYFg2/B8Pm8Mql0PBSYUn+UIR3LbRYy6L3/V09R0k/gBa8bEDXquPkq32XqXeDc
         /o5w==
X-Gm-Message-State: APjAAAVFu1UiZNa6QjmqmRoHuF+BbQawEnIqNiG88tW5P748p3U+jotB
        FPPUNoq5qWTsCqJCHRem1DXgJjnBfs4nk0cssWvOBRFODec=
X-Google-Smtp-Source: APXvYqzdqV5f498o2136HrswJlrklKYByA31f9OizX1raYNchOUwzZQMH8neudMRG34vNfOMoYR1nl11s1KS/DCCwaA=
X-Received: by 2002:a37:2e43:: with SMTP id u64mr13287493qkh.387.1578959838245;
 Mon, 13 Jan 2020 15:57:18 -0800 (PST)
MIME-Version: 1.0
References: <CAOE4rSyVSfRRc9vFK_EM9SJMPoZD6PAmiA+2LqyFx2C26ht-6A@mail.gmail.com>
 <60f0fed7-43c7-c979-c375-d2ab4c21e141@huawei.com>
In-Reply-To: <60f0fed7-43c7-c979-c375-d2ab4c21e141@huawei.com>
From:   =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date:   Tue, 14 Jan 2020 01:57:06 +0200
Message-ID: <CAOE4rSxb9q565HLScxxWJiJ+ei8U1Fgh4XQvJuL2+VVhvqVhKg@mail.gmail.com>
Subject: Re: How to reset HBA when using libsas/mvsas
To:     John Garry <john.garry@huawei.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pirmd., 2020. g. 13. janv., plkst. 11:51 =E2=80=94 lietot=C4=81js John Garr=
y
(<john.garry@huawei.com>) rakst=C4=ABja:
> If you just want to rest the disk, you can reset the PHY to which the
> disk is attached through sysfs, which is essentially is same as ejecting
> and reinserting the disk:
> 2. Go to PHY sysfs folder and disable+enable the PHY:

Awesome, this works great for me.
Thanks!


> > I have tried:
> > $ echo 1 > /sys/block/sdf/device/delete
> > $ echo '- - -' > /sys/class/scsi_host/host0/scan
> >
> > but it doesn't work as it doesn't detect any new drives.
>
> I'm not sure if this is the correct method.

Searching on internet it's most common suggestion and I didn't saw
anything else.
https://unix.stackexchange.com/a/404408/51019
