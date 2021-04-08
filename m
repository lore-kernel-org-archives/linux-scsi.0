Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61DCC43460
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 05:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F436124C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 05:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhDHFVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 01:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhDHFVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 01:21:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E1CC061760
        for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2021 22:21:20 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u21so809524ejo.13
        for <linux-scsi@vger.kernel.org>; Wed, 07 Apr 2021 22:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGWRQqNs4FsH45AetKkDEjtm5WFfnPk7zZ0gqFXvhh8=;
        b=Uw0wyDlDkX20XvZ04T5dHZqo5VGShg0gXBPk8VWktFBqbuh8MEOldhu336XT0Jj8qe
         erW3R8ZVjiVRhajwAiA8SXe+QHfkmsEskKtMV5Ic9ct0qKcfMb0IeGPhFJYoA9qG4PNE
         sFn+c5OONjJuFXY4MEBgDV47slIgQAmqs+Zm/rOlq9/jl4eVtNaCBs5pdB44UiyFa/ur
         48mdaV9f84mfoqmEh37U7uo9aLuBzCzGcoDWMs1H2rYV7dVFf9A7lD4Y1vMrSAc4fzfR
         SOdpisPlDqANC9kxZPy69cDbpdlDm6FPgMVva5v2Rv4QpKGq8YzBBKotytK4HauPnjDf
         bKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGWRQqNs4FsH45AetKkDEjtm5WFfnPk7zZ0gqFXvhh8=;
        b=CH3pyw8e7cJ+33lx6e9QVltJW5xEd958AgnEsQin9ieAsLoGlm+2KefzEqD/aE85RT
         /QckWJddrJwKfgVyYMqWFeVSqKcn6Y2vBAKFacYvc6+cGBbPD/jM58ZZIsaLHGQdQnII
         FjpKwSA5Ok7LqjaLrmWWHMuIsUVykGuBXn3yCUNuz3LGabKcCDS7qyVd72C+anwCBfOC
         HkySSjCAe1lmNMqUhBbRqCU7ftKdS9LYdnkik/wyWr4NdviFIFskSTNmMccTd2xa3UiK
         KHczT6UnxzybMeq3rED+nUglvpQUHJvvUpNFrTh/OcivXDvK38Zb9lKthu0apDzucRxi
         f8xw==
X-Gm-Message-State: AOAM530e/zWOEHWGUVvMrGSruNG5ygAvrpUe2aikkH63Glqtq3sGTtrh
        kBNEl3bqiv8681KX/WMGb5tQY8uaP34ZUuFd7zTqTw==
X-Google-Smtp-Source: ABdhPJwuJvePArsi0X3BVbiNySrXNJpCSX0975uBH+S9j2G7lCMCRLzU27dIjhNhw3Kxzuk9GAjVnHp7xGCcEBJ+Kfo=
X-Received: by 2002:a17:906:8242:: with SMTP id f2mr7851357ejx.478.1617859277448;
 Wed, 07 Apr 2021 22:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210407135840.494747-1-colin.king@canonical.com> <yq1blaq9fyx.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1blaq9fyx.fsf@ca-mkp.ca.oracle.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 8 Apr 2021 07:21:06 +0200
Message-ID: <CAMGffEmFxJduY71sGzXNMoQzq0PZT1dtELfviZf9CZdkRj=nNQ@mail.gmail.com>
Subject: Re: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Colin King <colin.king@canonical.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Viswas G <Viswas.G@microchip.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 7, 2021 at 7:18 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Colin!
>
> > The for-loop iterates with a u8 loop counter i and compares this with
> > the loop upper limit of pm8001_ha->max_q_num which is a u32 type.
> > There is a potential infinite loop if pm8001_ha->max_q_num is larger
> > than the u8 loop counter. Fix this by making the loop counter the same
> > type as pm8001_ha->max_q_num.
>
> No particular objections to the patch for future-proofing. However, as
> far as I can tell max_q_num is capped at 64 (PM8001_MAX_MSIX_VEC).
Exactly.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
