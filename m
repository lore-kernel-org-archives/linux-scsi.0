Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F4DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 08:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiBWIT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 03:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiBWIT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 03:19:56 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F6F3B019
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 00:19:27 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id y5so2307705ill.13
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 00:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rWF249HDw3OSkuca4KRUS0PYLBsXXiRbkPdqsbcD0wQ=;
        b=OlfIJaepoMaoJdYH69P4QZsBwBVi6yFAFklYp97MukvJ4sziPFlcobU4eYkOZCEk8z
         3E7JQ7BmaAH2259d201t30ZwScQIuUsxiglUJ3ID7EsmY5hOYdOZOYIZDiWLaa/lKxin
         WpyG3i8nu2dA7N/WpavNuuiHlTC1Vvod4WqjQz+ds/jyVdVy26Aizz5xyVqkxYQNqNZn
         zISHHYND4ac9IK+gxX1gTBjDz4Oz6lmkhR2ntazG+ohskUzH0G+zwDlHXOxknrrH9sHy
         L6XSfiriRKhytRaD8U2eDpF9jiNXGKuv3+aj0yPRfkbwORRDR32WnmVgZ+u8aJHgq99/
         mI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rWF249HDw3OSkuca4KRUS0PYLBsXXiRbkPdqsbcD0wQ=;
        b=MW8EOunqs6oEG1myDLdwNNAxLGMMV8mnXBHwiit/Ox3FDViFsCR5GShWk4TQ5Hr7bg
         e7BiGCtvf/XSxMwk7mou1bzmFPWixFaC/hXG6obv92nmoQv3dGfEcW7GuDZm+uglIezv
         E7CPHWfnI8gD6G1bpdZ6Bj+EFbQgoV8akcBPr7/W4JBwyWTetBGA0AnN+ycysn3Vn8A3
         uaPJEPfDLZoGrnkWSfQG3O1Xo/q6XlrDcWnpUbnVKIiQB0WJVxoWUXH8Kr/SmdDqizd3
         N0Fj020aadMU5FC3IM0m0giYxdreGrCrukai4MwCbyQ8pBFt2RddPYOKlBrWQc3QDcnt
         +27w==
X-Gm-Message-State: AOAM533fsNCr8gcSohKGbJNp3JrbBKf1dn0me1QzKGN39GUN/LhEiV09
        RwqT979mM7s4rRmJfi9x4dwAtyBWPJJ3PaHiUD4=
X-Google-Smtp-Source: ABdhPJxuNdq10wGLR+JpWVcMhXrVwFV8s5FFrZexOm7pnIeP4Nlgb1zfmeuX792YfdMbMAiZLVNLPBDRI3WUrcWhx7s=
X-Received: by 2002:a05:6e02:1b0a:b0:2bf:4cbb:4ff4 with SMTP id
 i10-20020a056e021b0a00b002bf4cbb4ff4mr23749284ilv.266.1645604367006; Wed, 23
 Feb 2022 00:19:27 -0800 (PST)
MIME-Version: 1.0
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com> <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
 <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com> <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
 <yq1tudzidng.fsf@ca-mkp.ca.oracle.com> <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
 <CAFrqyV4n8r6TwNsETfVTv+F_nn8Hg=HuZ6OHgmG_HxPVcvfPzA@mail.gmail.com>
 <yq1wnithm6g.fsf@ca-mkp.ca.oracle.com> <CAFrqyV5Pd8LY_wbNOiwjehSURHHmwidW11zjDdRHNBenXrNVaw@mail.gmail.com>
 <b10a0396-8f38-d388-f914-b36178408953@opensource.wdc.com>
In-Reply-To: <b10a0396-8f38-d388-f914-b36178408953@opensource.wdc.com>
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Wed, 23 Feb 2022 09:19:15 +0100
Message-ID: <CAFrqyV4PPDwVhbwyT7mo-QswQmruzVXYNRrTL9APQ_j2O36COQ@mail.gmail.com>
Subject: Re: Samsung t5 / t3 problem with ncq trim
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thx for the tip.
I was finally able to test it.
The disk seems to work now correctly.

So, i guess i slap the person, who told me, that the disks have new
firmware on it... xD

Am Sa., 22. Jan. 2022 um 02:05 Uhr schrieb Damien Le Moal
<damien.lemoal@opensource.wdc.com>:
>
> On 1/22/22 02:23, Sven Hugi wrote:
> > Hello Martin
> >
> > I just don't get it, why i get the same problems, as reported with the
> > 850 on the t5...
> > I mean it's the 2nd t5 i used and i used it on 4 different devices (+
> > on the school computer).
> > The t5 i currently have, runs really slow on linux and more or less
> > without problem on windows, the one i had before behaved really
> > similar, till it started to corrupt vm's and then also slow down on
> > windows...
> > Do you have an idea, what that could be?, or does it sound like i just
> > got 2 defective disks?
>
> It may be a drive firmware bug. Note that this article:
>
> https://www.tomshardware.com/reviews/samsung-t5-portable-ssd,5163-3.html
>
> mentions a similar performance problems with older versions of the T5
> that do not have TRIM support. It is mentioned that newer versions have
> TRIM support though.
>
> So it may be worthwhile to check if a firmware update is available for
> your drive.
>
>
> >
> > Best regards
> >
> > Sven Hugi
> >
> > Am Fr., 21. Jan. 2022 um 03:15 Uhr schrieb Martin K. Petersen
> > <martin.petersen@oracle.com>:
> >>
> >>
> >> Sven,
> >>
> >>>  -> sudo sg_readcap -l sda
> >>> Read Capacity results:
> >>>    Protection: prot_en=0, p_type=0, p_i_exponent=0
> >>>    Logical block provisioning: lbpme=0, lbprz=0
> >>>    Last LBA=976773167 (0x3a38602f), Number of logical blocks=976773168
> >>>    Logical block length=512 bytes
> >>
> >>> lbpme=0...
> >>> so, i guess it's not because of trim...
> >>
> >> Correct, Linux wouldn't be sending trims to that drive.
> >>
> >> --
> >> Martin K. Petersen      Oracle Linux Engineering
> >
> >
> >
>
>
> --
> Damien Le Moal
> Western Digital Research



-- 
Sven Hugi

github.com/ExtraTNT
