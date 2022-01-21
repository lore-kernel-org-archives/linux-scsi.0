Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7BEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 17:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379375AbiAURX4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 12:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiAURXz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jan 2022 12:23:55 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B20C06173B
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 09:23:55 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id w7so11603386ioj.5
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 09:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mxaeJ9M0Hl0G3Qnhw1nev7XcupHzpNuCKnxKfCYr2tM=;
        b=h0voPPA0qSeZaJsaTq+Wq4xlfwOVnBqBJFwr3CbdlYHDvE5VH7D38Jrpj1aXSvZzUt
         YquA5d4JVy7ZyYtp1QyiwLdHh95R5gzd9JNZ0T1x04aMALGpHrz7cjhC4f6aaBifw43W
         Rd8eOyrnjmQ7tvDMuLp5C+MdwShLoqK7NRYtEW0wyWqEXn9c4rVqaEVtiTqzU2MbRyfq
         dwVyNF1t2EXwPIySmiPeCcJwqlMY8e45KF5ir9x2mIwNuV8XDge1HhWrC47XHmzExJCx
         g58cI8xna39t9a/RwlIFzZ8aUXAzip2v/RRchC3Vvmi9xK1Y+5+qjzlwGv84JelW6CIa
         qapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxaeJ9M0Hl0G3Qnhw1nev7XcupHzpNuCKnxKfCYr2tM=;
        b=Qknb51ZkIGkknbAe1qRPjIBVg7CJ0w31rgvT8MVEExLbhr/VbMefqH3PVYbC1cHX7c
         36+iBz4SRvFoIiv9/qYGIrnNLhb0/U9cupdQyBAb5JXE1NR+VO5fMIgatYIendclL4Lm
         N7sUaJ1geuQIdTV1tMdjFrIfkPN2TuPShSpmSfxio8vkz9YFK5chzOqhLbikpKWiEpCk
         2CimbayNC8EUbFE9YmA9In4vyPqWvMYvaqZPtLUtos9jPM5AqN7RLu+MSjDpPXmgtvCs
         Ht70rQw7JH1mQ6VDoWigOBZgiZPFW4KtojINpGq7L1T7fovLJRmG4S8lSsUytLV20Z3R
         VyXQ==
X-Gm-Message-State: AOAM530EVcm8/921uHHuMdJDV78W0RIcCUTNHimOrUuRdjWDxR0CUbRa
        0dQwMuCZT5bzix61PUnpMSveFUc6BoC80lxYGQmWzMGDyEA=
X-Google-Smtp-Source: ABdhPJyTotpEF1xPhtQYxE+ZHmxy2J3u/mLHzMsvTMupfgv/adZqEq68B3psSviZ1nzbmn4WfP6d4QxCGFcFPiYOlCc=
X-Received: by 2002:a02:384d:: with SMTP id v13mr2088486jae.202.1642785834402;
 Fri, 21 Jan 2022 09:23:54 -0800 (PST)
MIME-Version: 1.0
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com> <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
 <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com> <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
 <yq1tudzidng.fsf@ca-mkp.ca.oracle.com> <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
 <CAFrqyV4n8r6TwNsETfVTv+F_nn8Hg=HuZ6OHgmG_HxPVcvfPzA@mail.gmail.com> <yq1wnithm6g.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1wnithm6g.fsf@ca-mkp.ca.oracle.com>
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Fri, 21 Jan 2022 18:23:43 +0100
Message-ID: <CAFrqyV5Pd8LY_wbNOiwjehSURHHmwidW11zjDdRHNBenXrNVaw@mail.gmail.com>
Subject: Re: Samsung t5 / t3 problem with ncq trim
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin

I just don't get it, why i get the same problems, as reported with the
850 on the t5...
I mean it's the 2nd t5 i used and i used it on 4 different devices (+
on the school computer).
The t5 i currently have, runs really slow on linux and more or less
without problem on windows, the one i had before behaved really
similar, till it started to corrupt vm's and then also slow down on
windows...
Do you have an idea, what that could be?, or does it sound like i just
got 2 defective disks?

Best regards

Sven Hugi

Am Fr., 21. Jan. 2022 um 03:15 Uhr schrieb Martin K. Petersen
<martin.petersen@oracle.com>:
>
>
> Sven,
>
> >  -> sudo sg_readcap -l sda
> > Read Capacity results:
> >    Protection: prot_en=0, p_type=0, p_i_exponent=0
> >    Logical block provisioning: lbpme=0, lbprz=0
> >    Last LBA=976773167 (0x3a38602f), Number of logical blocks=976773168
> >    Logical block length=512 bytes
>
> > lbpme=0...
> > so, i guess it's not because of trim...
>
> Correct, Linux wouldn't be sending trims to that drive.
>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 
Sven Hugi

github.com/ExtraTNT
