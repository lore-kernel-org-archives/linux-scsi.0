Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C341C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 18:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245483AbiASS7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 13:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiASS7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 13:59:23 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0B3C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 10:59:23 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h23so4003252iol.11
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 10:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5AzVM6VtGii7q82xtigwOvPNAxcyaC7Kp7lN2P/Wg6M=;
        b=a6rwBa6crfagChy8iKIRYIVhQRMeNwjn7DMHDkf9BgI1yL6smfISVzZ/MU8bDOIGTL
         IB5YQ76/kljOCu4xaPrN1WlfynVuXebSNqaT8ZQrvnLdbLXCI5nCeLGugFEtc/xk93bE
         Fg1kORLGG8A4xTYZ7vY4OnyXJbhZutZFRC7QNTHCILswuZo7d4/Il7qmRbPgxcmNPrQn
         eWOdpP4Oi+K/g9GDUap+qYuoCTHXDobsIp05b7mbaGl3EE0y303/Z/R7uemFy2N4WXjy
         4h9d12Jn9Akok4odZ8enQmoXPYhRF156k8f8h4QgXHewGh7VRxmD68m+H0Aj99asZURY
         qY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5AzVM6VtGii7q82xtigwOvPNAxcyaC7Kp7lN2P/Wg6M=;
        b=pKzi9QigCNVq99R0117XW9T8liXnki0QPLA8pfS9Xp0sJJmkYB4hpdSiF8cXHVOnnx
         RHN7Xu/lS2IjFkSs5TYMm1v4tE1YhE1w1L8pyy83Ch7a6LSJOSBS6F1N5CtLdAWuBiyH
         dB6nEGqaqXT54kgSu2IUbPkI6ysqBNyt0ZFPh5Qqsl842+GAFH25g5iRskk9Or/f6th3
         baHTrwHHs7UcvT53JHUnWYLSARyjQ8qiBsjalfUd36IeFoKpSYM2eq5UiFBJEWu0zwA1
         kfEPtrWN3mtB6zigetYXhNRkNDt9RUQi2DxtjrCZ6TSPZH1y2XgQkdx4EOV6IDP+Uv2T
         z/hg==
X-Gm-Message-State: AOAM5338oN7GhCHKWyxCxqAlp2t2nYvpgZdm4ulSksPVbTmciNs7Tvht
        EUlhUB0Wc7ZcFcDh9mAFwZkCX6FPLbTUMlMeD/f39acAkGc=
X-Google-Smtp-Source: ABdhPJw48Zz+TPhOj8dWrkGyns4Mtc0KbZcxDaVr7Ywnwv/Ye0+5cDAeZV3ysb6klabIF9yTWu8hdsEh6vNWLy2eYW0=
X-Received: by 2002:a5d:9155:: with SMTP id y21mr15776852ioq.112.1642618762815;
 Wed, 19 Jan 2022 10:59:22 -0800 (PST)
MIME-Version: 1.0
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com> <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
 <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com>
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Wed, 19 Jan 2022 19:59:12 +0100
Message-ID: <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
Subject: Re: Samsung t5 / t3 problem with ncq trim
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin

so, there was no error, only death and misery...
ok, storytime
I used a t5 for school (because we needed to use a t5, because the
school sold it for double the price)
So, my ssd got really slow over the time, we were not allowed to use a
other filesystem than ntfs, so i thought that it was simply because of
this.
But it go down to about 500 kbs. Had a talk with a teacher, he told
me, something like fuck the rules, reformate it to exfat, ntfs is just
shit...
So, it didn't do a lot. Initialy the problem was only while using
gnu/linux, but later also while using windows (school computer).
This went on a few weeks, till the vm's on the disk got corrupted, the
first 2 weeks or so was after runing them a few times, after that just
by copying them on the disk.
Speed was low af... So, i contacted the support, this was like: "we
are legally required to support you, but no"
So i got back to my teacher, he sended me a new disk. I got the disk,
tested the speed on my gaming pc (windows), that was good.
Got on my working machine, copyed the vm's to the disk and the speed
just droped... had a call with the teacher on 2am, we did some
research on this ssd and figured out, that the t5 (and also t3) are
just samsung 850 with an usb-c adapter.
The 850 had a problem with ncq trim, disks randomly died and got slow
af with linux.
So, i took a look at the ata drivers and found the
ata_device_blacklist in libata-core.c.
My idea was to just add those 2 ssds to it:
{ "Samsung Portable SSD T5",    NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
                                        ATA_HORKAGE_ZERO_AFTER_TRIM, },
{ "Samsung Portable SSD T3",    NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
                                        ATA_HORKAGE_ZERO_AFTER_TRIM, },
Sent a mail to linux-ide, Damien Le Moal respondet, that it's probably
the usb-c adapter causing the problem and that i should contact the
maintainer of uas.c...
And here we are...

So, that's the short version of the storry, i hope, that this helps...

Best regards

Sven Hugi

Am Mi., 19. Jan. 2022 um 17:31 Uhr schrieb Martin K. Petersen
<martin.petersen@oracle.com>:
>
>
> Sven,
>
> > It seams, that those 2 ssds do not like ncq trim
>
> Please be specific wrt. the type of error you are seeing.
>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 
Sven Hugi

github.com/ExtraTNT
