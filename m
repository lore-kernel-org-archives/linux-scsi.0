Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646E6C77B6C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 09:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjDMJvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 05:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjDMJvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 05:51:15 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9106D903D
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 02:51:05 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id a9so13312260vsh.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 02:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681379464; x=1683971464;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5/1cCA7ARMmBDMVmrz4hr0FRe4hg+/OHyteC+tHS04g=;
        b=EfKmzk5B4ODNxPx+xdp/ob3uZ7O1n47kiT0o7olkIk4CX7pZ5HBZSimgUzFf/HquBA
         3g628x3Rpp3Am+SaHS1LLbJ4Jhlarvi6nhGllSOqMelnC2/IMpnO0NLSzTKeqbq04bJp
         IVLxRIo/ERVcNW6mFiR+uuHEtD0oH702xr7OP69Cxkj6r5mvBubaamcEkFaDJIeNmNnf
         QdU+uFnxgLWR6c1ni9FnDE9/yDVQLTxJIBH30fA1PmEoxT8eOUW1HZ8hyVFRiLS9pFNS
         N//oEsgAvv38iZ8j0rYHU1tQHJy/PNxy13MdVLEy+Kwzm2tmmNupdOJRjyGeyKeU7g8Y
         KDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681379464; x=1683971464;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5/1cCA7ARMmBDMVmrz4hr0FRe4hg+/OHyteC+tHS04g=;
        b=D4HWOaJ34sab5c4cDbc+xj52yCuniJi3vJlmZRjX1XIsiNkEHLbDYW2mjnslvrM91j
         TMRgZrF+pqrk+XjnTR+T5w5bagoRKqHa6kYkCzD+2sxL0NUpXCZHbGgXGPHiCObOgrsG
         jupP0zD0KCSRhSCsPykujCn6kCoJCXEapVshJVLAPJgknMfflOqS02Lyh2AcPxbqZP3h
         QxQYvFkYF5T8QbuHF7flsKD5o7e1TGicDVrguKm4VCtOaUe0mg2xsjT1daiRKSDOjLzf
         M60UV0hxZHT6yMenOzdJ82X/HqVw/JNJSTJZNUAHECCplQ2Y7viwXyTj8LipEO+Bvfxw
         1MKA==
X-Gm-Message-State: AAQBX9ff4sHMJuOpc4EgNeOSLaGv6Q/vG3G6z41vh5QLaYIynfXKMhN4
        n8038x9D4+lkm12QIiq8ym7vB8fLafCIrOYa4Z0eNw==
X-Google-Smtp-Source: AKy350aPWg8QPSOy/2PHkhrh6sAkwuh8+NOSRnErraPKD6xHUPGtdIg/0oa13IGXGEwruNWS6Z0XHf1YhCtKpgAgMbc=
X-Received: by 2002:a67:c30c:0:b0:42c:9c6e:a5d2 with SMTP id
 r12-20020a67c30c000000b0042c9c6ea5d2mr913874vsj.1.1681379464384; Thu, 13 Apr
 2023 02:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230412093617.285177-1-naresh.kamboju@linaro.org> <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
 <e85746b2-9736-9041-9327-1ad1299aa155@oracle.com>
In-Reply-To: <e85746b2-9736-9041-9327-1ad1299aa155@oracle.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 Apr 2023 15:20:53 +0530
Message-ID: <CA+G9fYu5T3HwXzcU4ouNhYY0zOZhJgbc6AXFS0q1wHgV65AEDA@mail.gmail.com>
Subject: Re: [PATCH v6 00/18] Use block pr_ops in LIO
To:     Mike Christie <michael.christie@oracle.com>
Cc:     axboe@kernel.dk, bvanassche@acm.org, chaitanyak@nvidia.com,
        dm-devel@redhat.com, hch@lst.de,
        james.bottomley@hansenpartnership.com, kbusch@kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        snitzer@kernel.org, target-devel@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, halbuer@sra.uni-hannover.de,
        keescook@chromium.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        mkoutny@suse.com, roman.gushchin@linux.dev, ryan.roberts@arm.com,
        shy828301@gmail.com, yuzhao@google.com, zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 12 Apr 2023 at 23:59, Mike Christie <michael.christie@oracle.com> wrote:
>
> On 4/12/23 5:25 AM, Naresh Kamboju wrote:
> > On Wed, 12 Apr 2023 at 15:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >>
> >> [sorry for the adding you in CC]
> >>
> >> While running LTP controllers test suite on this patch set applied on top of
> >> the next-20230406 and the following kernel panic noticed on qemu-i386.
> >
> > Also noticed on qemu-x86_64.
> >
> > Crash log link,
> > ------------------
> > - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/test/check-kernel-panic/log
> > - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/tests/
>
> Can you point me to the original report? I don't think my patches are the cause of
> the failure, or if they are there is a crazy bug.
>
> Above, I think you pointed me to the wrong link above because it looks like that's
> for a different patchset. Or did I misunderstand the testing and that link has my
> patches included?
>
> I did see my patches tested:
>
> https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/
>
> but they seem to fail in similar places as other failures that day, and the
> failures don't seem related to my patches. It doesn't look like you are doing
> anything nvme or block pr ioctl related and just failing on forks and OOM.
> It looks like you are booting from a scsi device but I only touched the scsi
> layer's code for persistent reservations and the tests don't seem to be
> using that code.

Thanks for the analysis on these reports.
Since it is based on top of Linux next-20230306, I will re-validate the base
and get back to you with my findings.

- Naresh


>
>
>
> >
> > lore link,
> > https://lore.kernel.org/linux-block/20230407200551.12660-1-michael.christie@oracle.com/
> >
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
>
