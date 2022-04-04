Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E235C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 08:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377922AbiDDION (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 04:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377920AbiDDIOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 04:14:12 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485422FFDC
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 01:12:17 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b15so10059242edn.4
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 01:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=t4pHkr3Fy3D8Gbg4I8ddBm6gN3AAVtS40j90Mskm7ls=;
        b=FvoEyLh3lNEffdg6i292Tdvwsc9tJTcZX5yC2TD3aET52poi9cu/A2R1nNJkOtaY6M
         y0CxEDw/LMKQwDTRGcY+nIxgP2jAbASy57LfCtjpIUJ1tiUYvpB2HXzlF4tr9rRSrwTF
         /hvhki+9vb0cN2bmIqS/aiXbDvmCrFOhnRjOf1Q8VxNKpfUHL8AHY6mn5R/efzR2/lZ9
         +56K3iNqClAoqoyRw3ib+8ab2NSgU/E8Oo/v/MYsbfPalt28VgLYeG47JZwWUAC4pVRJ
         XyCUqcUrzaDVQBnESus7NWN6+NLtsFVPvrcgP9kVoLk9ghS+vcDCX4vc9QjB/fptiLyI
         EAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=t4pHkr3Fy3D8Gbg4I8ddBm6gN3AAVtS40j90Mskm7ls=;
        b=6PDKPL0zVKcIU3paMtcK4c9VPr6xHpQ8NXPdcoNm5SI8AVjH4Q4YNfr8krh/XXzclv
         SEYLv9rZXbVdhrswwISseQSYI3nBN+t4ZhmzkDar/Sfth/htUB8MTyxvMWO8c0i9k0F3
         5nDSEXvF87JKRackK3PiU4iWe5ZBuiwWlAdatC1qWgZaTUlcwzNpyQngSMbKvOqVue37
         rMWpefDzqvPbe/ZbatZuF84STdRzrb5RT9BSKQmaTtVlEdkE0LxZZvPNDEf4YJvCsBqH
         fJXmKywDLYPhjJQFjvtbu4NyU4YiB/0WWHmVAX3QhVbYaUnc5BHGn71G2KIxccyoAi3G
         NW6A==
X-Gm-Message-State: AOAM533u0QUN3/O3TNuv4T5KgXD4iH3heKOPl+Hx8NbscHkXSWDfWqDd
        UkttZPEs1R5fStqonVaWw+U=
X-Google-Smtp-Source: ABdhPJxPsITJCCvAQIcJw2t5n5+Q9G4ZsAqcHRCfkfr4DE00TpoSj+dfW4VeDJw5qmr8gDHWoLVcLA==
X-Received: by 2002:a05:6402:184c:b0:41c:dad5:72a5 with SMTP id v12-20020a056402184c00b0041cdad572a5mr1041118edy.254.1649059935795;
        Mon, 04 Apr 2022 01:12:15 -0700 (PDT)
Received: from p200300c587018436671532b804c21788.dip0.t-ipconnect.de (p200300c587018436671532b804c21788.dip0.t-ipconnect.de. [2003:c5:8701:8436:6715:32b8:4c2:1788])
        by smtp.googlemail.com with ESMTPSA id y8-20020a50d8c8000000b0041c80bb88c7sm4392226edj.8.2022.04.04.01.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 01:12:15 -0700 (PDT)
Message-ID: <94902f1e26a18ff7774dc429502bef7d54f23b5d.camel@gmail.com>
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        quic_cang@quicinc.com
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Mon, 04 Apr 2022 10:12:13 +0200
In-Reply-To: <ebf3cc31-9cd1-3615-b033-06bfc7d25b9a@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
         <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
         <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
         <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
         <ebf3cc31-9cd1-3615-b033-06bfc7d25b9a@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2022-04-03 at 14:54 -0700, Bart Van Assche wrote:
> On 4/3/22 14:36, Bean Huo wrote:
> > Yes, I reviewed the entire series of patches and there are no
> > significant structural changes. Still want to squeeze ufs driver
> > under
> > driver/scsi/ufs/. No major conflict with pending submissions. Go
> > ahead.
>=20
> Hi Bean,
>=20
> It has been suggested to move the UFS driver code into the following
> two=20
> directories to keep paths short:
> * drivers/ufs/core
> * drivers/ufs/host
>=20
Bart,

Very interested in this design. I'm assuming you're still going to
continue parsing SCSI commands. Can we also shorten the UFS command
path?

Meaning we convert block requests directly to UFS UPIU commands?
instead of like the current one: block request -> CDB -> UPIU.

> That approach is similar to the approach followed for the MMC and
> NVMe=20
> drivers.
>=20
> Additionally, some other SCSI drivers already occur outside the=20
> drivers/scsi directory, e.g. the drivers/infiniband/ulp/srp/ib_srp.c
> driver.

I'll take a look at its design, it seems to give us hope that we can
make the UFS stack more vertical.

Kind regards,
Bean




>=20
> Thanks,
>=20
> Bart.

