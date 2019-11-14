Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91884C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 08:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED7020723
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 08:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oiT2RC/b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfKNI47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 03:56:59 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40043 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKNI46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 03:56:58 -0500
Received: by mail-io1-f66.google.com with SMTP id p6so5927163iod.7;
        Thu, 14 Nov 2019 00:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NbXXK6bu0dg2zI7R5KEkk9IUJJ7xkv0jNGRocMeqp54=;
        b=oiT2RC/bejWLycuxKkNmrXLshuKJkpQ8QbbCzp5sZf7uCmkjcLVlsqufYaB76kVLEp
         td9Wkb5yZErKpFF7Q3iWppBkvWx91gbXE5ErUKPMMEKvDqkOOuMLfcWATWNjxc0t23Sb
         4oZXa5Bpvo0cLB8oKsz+NNEEvftslGUdU/L+4vMvvDxNyQ71XNXefomOoHPgbzVmjVa6
         3GaKNTRCALTkfi1LWgbSLHqR+z6u3NMduZDEAj6utVvKx2rWvdFPI+4v57+4k4e3FuSC
         /3HfVUjcY1QV4wW2t7T3XhaxkcBmzFiS2JGp83MiyMOzOiBEFqFn5RPTyuHMZSFvlWF+
         9ZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NbXXK6bu0dg2zI7R5KEkk9IUJJ7xkv0jNGRocMeqp54=;
        b=k5UNgxnoI85bEuTUZhLxGRh6eREez/Xtk44zo3ip878Tpo18+wUMjbVXmB355GpEHz
         rxAG1PdyYqMuVGiXKnCXSVbpGGMmkQOr2jUDnJUqyR5XaqLexAHRgLmWpkni4UX2sgpM
         uAx31b8jHP7JzD0M258ge+MdeLsP0lCbIzIHoHTLSgxDl3PEOFKdT2mgEIEdk5YuTn4l
         vhpuH5qg66+B7mQk04yDg0GwBmO7hwC4J1gJcqE8v7mgeQfyaeUQuUrg5Q/nwKSRTyqt
         JAneLqr9UdWE9AgmanDI9nLCCH3HqYj5FbWDzlN3mx260M2OJsPSAq+7CH6QysAMk40d
         y/VA==
X-Gm-Message-State: APjAAAWO5mubqH8cMNgA0afJIvnRa1K5Sy/PuoEKKJCVuzv5BajTcgIG
        T6/a9EOgOdq4ilqhZZbYqKK4a5lrxhs2JdCspBg=
X-Google-Smtp-Source: APXvYqwHjWoyL1J5Jrs+HHYpGKOUUX6fk2rrVcjRpaxLwOQPHCz3m1260WX/UfjMbtX9LCjy6k3m6aYtWim4Smtjre0=
X-Received: by 2002:a02:ac0a:: with SMTP id a10mr7105329jao.53.1573721816302;
 Thu, 14 Nov 2019 00:56:56 -0800 (PST)
MIME-Version: 1.0
References: <1559161113902-328168114-2-diffsplit-thomas@m3y3r.de> <07841ae4-03d2-1fdd-1c32-85c55688bb2a@web.de>
In-Reply-To: <07841ae4-03d2-1fdd-1c32-85c55688bb2a@web.de>
From:   "Gomonovych, Vasyl" <gomonovych@gmail.com>
Date:   Thu, 14 Nov 2019 09:56:45 +0100
Message-ID: <CAHYXAn+hzzysj6uW6ghLDtjZ7UxEDXXzvLDW46VkJyVwBD78Lw@mail.gmail.com>
Subject: Re: scsi: pmcraid: Use *_pool_zalloc rather than *_pool_alloc
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Thomas Meyer <thomas@m3y3r.de>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Yes, maybe you are right better to use the full name, sorry.

Regards Vasyl

On Sun, Nov 3, 2019 at 5:05 PM Markus Elfring <Markus.Elfring@web.de> wrote=
:
>
> > Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
>
> Do you find a commit message nicer from a similar change suggestion?
> scsi: pmcraid: Use dma_pool_zalloc rather than dma_pool_alloc
> https://lore.kernel.org/linux-scsi/20190718181051.22882-1-gomonovych@gmai=
l.com/
> https://lore.kernel.org/patchwork/patch/1102040/
>
> Regards,
> Markus



--=20
=D0=94=D0=BE=D0=B1=D1=80=D0=BE=D1=97 =D0=B2=D0=B0=D0=BC =D0=BF=D0=BE=D1=80=
=D0=B8 =D0=B4=D0=BD=D1=8F.
