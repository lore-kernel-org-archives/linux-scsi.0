Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D918AC3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 12:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC78C21D80
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 12:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mU2zSBU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfIVMHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Sep 2019 08:07:51 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:33489 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbfIVMHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2019 08:07:51 -0400
Received: by mail-ed1-f42.google.com with SMTP id c4so10283029edl.0
        for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2019 05:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3tFtSfMzzpxXv6HIxV2nKWFy+s5o47+VevTZawxbuvM=;
        b=mU2zSBU3DXWtDOUQoNVtMCzSmHohm3iqCAsWgNqHJL90+iS6SEA4cwFegnl/F3dPmO
         /ZLpRHMZ5WHIKQozJVNYcXyEWYp4Da+HvsLyJ3+fSpikpQzeiTeHPA5EGIH70NESaWfo
         ccYHGIOJQJdGD+Le02YHiLabC+NdtJNI87dSRHCqkF3ieUbTbcHSZsmd/jI310F98vaF
         VEUJjWJ6uE8gml3Ygf8qZFi//uU2EKpDZW1z+jqyehdcXkIwBdTbVFh9o6XBh1vxWbUh
         DRXZri/TT1odfo8h/AvKSH9GAesET3Z3TZGlBzPzRT8tdQz0l5NQO9LhODgRnUE8LcZ6
         5blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3tFtSfMzzpxXv6HIxV2nKWFy+s5o47+VevTZawxbuvM=;
        b=hUYGZqEt+W9vBjG/Hn/GwseYXTFYftPJqny4rGKW/gUyqbWRetJhNnBkvSyEJnVSKC
         XrfU2ymbDnvNgXgWhTFLDfdAoXLOz4ZmZ0rotKDF6J0mrfVbPCe0NJhq9Wz0HkkFu9zL
         chAlEUmb69PAIJi+ZUWL3/fUpu5WRMzgN0rJYEvtLW+9UAlcHejcobekb0/i3FAyCYMD
         LV++eu6EIqwEGUfjwS9P3UAEv19Jkf0oqh3M9rdwd6MtYpt7q2o0Sf909B/47qCeB9i8
         NPMpb9r0YuPKY4iEGtIeii6UQChSmHXj3sQ6tlL9QVbz7APbBNhEI+4m5dSfGQfgm2H7
         Z11w==
X-Gm-Message-State: APjAAAVxZ3bTs//Ru83mugwuBhRX7gGvvSNqwS3wUsKuFlzR4IZyJc6e
        z2L5LOp35G/X8swMgd8BwIX7KR6TxPIeHe8FYf5yGdyZ
X-Google-Smtp-Source: APXvYqwVFr4ejw/HrBj7R5/mZ2wrpI+gXiHRB3BWg69sT+MsZpGvQN30WtRvjq/x1tndmoGoM8if0YPTj8ZTbSFn930=
X-Received: by 2002:a50:eb03:: with SMTP id y3mr8515628edp.194.1569154067803;
 Sun, 22 Sep 2019 05:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
 <8A2392BA-EDD4-4F66-9F76-B43C8F6EA4FB@gmail.com> <CA+PODjpG7NLTH8wp9qw08ACj4=8sUusmkZv6X7QWHtdbNJ1S0Q@mail.gmail.com>
In-Reply-To: <CA+PODjpG7NLTH8wp9qw08ACj4=8sUusmkZv6X7QWHtdbNJ1S0Q@mail.gmail.com>
From:   Li Zhong <lizhongfs@gmail.com>
Date:   Sun, 22 Sep 2019 20:07:36 +0800
Message-ID: <CABKycOXcwMrr=7bF7Mt43zz7JTjZqFTfbJLD=uMqHxXBD7-GPg@mail.gmail.com>
Subject: Re: [RFC,v2] scsi: scan: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT
To:     Andrey Melnikov <temnota.am@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 12, 2019 at 8:37 PM Andrey Melnikov <temnota.am@gmail.com> wrot=
e:
>
> =D1=87=D1=82, 12 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 07:56, Zho=
ng Li <lizhongfs@gmail.com>:
> >
> >
> > > On Aug 29, 2019, at 11:49 PM, Andrey Melnikov <temnota.am@gmail.com> =
wrote:
> > >
> > > Hello.
> > >
> > > This patch break exposing individual RAID disks from adaptec raid
> > > controller. I need access to this disc's for S.M.A.R.T monitoring.
> >
> > Hello Andrey,
> >
> > Do you have any more details about how/why it is broken?
>
> adaptec report hidden luns with PQ=3D1, PDT=3D0 - now it skipped.

It seems to expose these "hidden" disks, we have to revert this patch.
Don't have such raid controller, do these "hidden" disks have any differenc=
es
from the normal ones?

However, from the spec,
Qualifier 001b
An addressed logical unit having the indicated device type is not accessibl=
e,
at this time, to the task router (see SAM-5) contained in the SCSI target p=
ort
that received this INQUIRY command.
However, the task router is capable of accessing the addressed logical unit
from this SCSI target port.

I still think it makes more sense to skip adding the device at the
time of the scan.

And for disks behind the RAID controller, does it make more sense to access
their information through the controller, than exposing it directly to the =
OS?

Thanks, Zhong

>
> [   32.609143] scsi host6: aacraid
> [   32.609566] scsi 6:0:0:0: Direct-Access     Adaptec  srv
>   V1.0 PQ: 0 ANSI: 2
> [   32.609881] scsi 6:0:1:0: Direct-Access     Adaptec  zbx
>   V1.0 PQ: 0 ANSI: 2
> [   32.639942] scsi 6:1:4:0: Direct-Access     ATA      WDC
> WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
> [   32.640810] scsi 6:1:5:0: Direct-Access     ATA      WDC
> WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
> [   32.641559] scsi 6:1:6:0: Direct-Access     ATA      WDC
> WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
> [   32.642266] scsi 6:1:7:0: Direct-Access     ATA      WDC
> WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
>
>
> > > Please find other way to workaround bugs in IBM/2145 controller.
> >
