Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A5CC010A2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 10:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3FCA217F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 10:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzTtTwtg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388319AbfKEKUj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 05:20:39 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41810 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388022AbfKEKUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 05:20:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id p4so20629940wrm.8;
        Tue, 05 Nov 2019 02:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U7rVx6gqyBAf8/Ix0rAHegGvn59AhNGRQobMkf7SosQ=;
        b=bzTtTwtgX5SNoprXTuL3uJvNqg+rVVN6QiEEl3vLtO2OA5ja3rtlJxNhH8T45Q55Hk
         v3XWKTYxeFDxyegsUAXHU5jMvZNHU02o6JtDh0nkGMOGFkL0FRS3hhkvzP3Vqsnpd0Bt
         NpGNCvSx9LMmH07fWqN5CCbQfk7twqlTQhgnHm5Rbt4KwE/DjRYQgKe0vTe4DinmBTs5
         uIiQ/LTogvZuw3fJW7T188+zOFtN9V5fJddUzMhh9WQPk132HJLyNq7JwvY0iiaPFaUB
         N+oxqVBG8nv94B3vvOFg8Hv68TIQh4LSdAkfWtGFEGU3w77gqtwIcJ+bnJpRe+WDmv2C
         Nn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U7rVx6gqyBAf8/Ix0rAHegGvn59AhNGRQobMkf7SosQ=;
        b=ECgofoW7RxA3L0b3JScq2fbNXcFFWAtukl6l+Nj3usgyVbhUojrNBHXuinnPY17nZb
         fj/ELSCRPPHemgQ7HoYhoch4TxnJyioz8va0qUkO+Z32vD5gLlZrk2olJkQcybP5EyeU
         s3yOLBzMdMi1HTEKgGKi9uwZYeX7382SgaT4sijVAgfd/ff4hdDErNHeNX4pZTyvaB1s
         EZdMsMe2qdUjMdVBYJuk4MQP8PBSG89zbyiCrkxJ6yt1qylG42dV5vLXVIkdY9WUa4En
         DQG0/fGnXdqjW9+5/NwUJSsQk7vutjvmi1JYDMAG8z97THV+tp0m8GoEXa/AQqmLG+Ww
         werQ==
X-Gm-Message-State: APjAAAX4G+kaZODNfD+LfL7Q4UfIqzwTGF3h1bvsldnlDpfHwTZ0KvjO
        jnrk6PDlr+97AR5pVHvMj5cR/Mu4Ue+ohFidWGQ=
X-Google-Smtp-Source: APXvYqyWKbdqV5y+fX/GlmvSFNbw7CIaOg7O75M1f/C35mhY/KY/3EDtUrS9+Q26Hy7PZ3+eHf9KeSFGTCo8vlnS3Ig=
X-Received: by 2002:a5d:490c:: with SMTP id x12mr25443865wrq.301.1572949236565;
 Tue, 05 Nov 2019 02:20:36 -0800 (PST)
MIME-Version: 1.0
References: <d5c12f05-5a07-b698-ae60-2728330dd378@web.de> <CAL2rwxrdOVeO3RT_Y3mk3p-076eMMWm6VVF0C4yiYEWJ0TO5DQ@mail.gmail.com>
 <20191105093641.GE10409@kadam>
In-Reply-To: <20191105093641.GE10409@kadam>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Nov 2019 21:20:25 +1100
Message-ID: <CAGRGNgU9=Ng60QE_-f8fs5HzDTFQ_8R3taidERAocBc1nQwbXg@mail.gmail.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Use common error handling code in megasas_mgmt_ioctl_fw()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Tue, Nov 5, 2019 at 8:41 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Tue, Nov 05, 2019 at 02:58:35PM +0530, Sumit Saxena wrote:
> > On Fri, Nov 1, 2019 at 3:06 AM Markus Elfring <Markus.Elfring@web.de> wrote:
> > >
> > > From: Markus Elfring <elfring@users.sourceforge.net>
> > > Date: Thu, 31 Oct 2019 22:23:02 +0100
> > >
> > > Move the same error code assignments so that such exception handling
> > > can be better reused at the end of this function.
> > >
> > > This issue was detected by using the Coccinelle software.
> > >
> > > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> >
> > Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
> >
>
> The code was a lot better originally...  :(

Agreed, this is a lot of stuffing around to save 3 lines.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
