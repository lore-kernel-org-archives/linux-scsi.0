Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA76DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 14:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F0761964
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 14:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhC2OXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhC2OWu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 10:22:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C06461959;
        Mon, 29 Mar 2021 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617027770;
        bh=eP9MIKqjehCXRNlGSxV0irL0Log68aEfdh7EXXA/ijs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GxEbgamBHWRR3iHoGd7xzPc0PPf6QZsq+5ogtKes9szV2/AzXOvBXNkYtq0pyPQLg
         OgMquuzLXpqrQLHljzYKCEoGOBLKOt0ONJICgAMfsJtRtNb5oA9RwIBzEuZoFOvp0+
         4bduiifH8USZh/+Sz3eWHqSTwem73l6zHt1ktaBfIUD55HjI4BDEpSJ9/QbUQytDem
         wX/XXdfGKLOwXkrPX5MeilYW1+zZoAtCYhFJFaS3Cq2/MGlhOqlGJoWnz2KnOEqYSU
         iFjtihAtZ1f/S/1SbbThLZ8XGcI2SqGOsev3smPakSmW6AUqk6gXdRemQcUwilAWzJ
         fGrsa2gnLfA7A==
Received: by mail-oi1-f178.google.com with SMTP id i3so13217229oik.7;
        Mon, 29 Mar 2021 07:22:50 -0700 (PDT)
X-Gm-Message-State: AOAM531rDybl6NBkMkBddw3kBX98M87bSDCxhc/YIJBReeoXw8W1D6Pt
        eUmxH1JliA6+84h6AYy3Q64CiO1ZdZACQ5RJMx8=
X-Google-Smtp-Source: ABdhPJx+qC+SimgkOgyf/WqXhg9c0OWfR23sYGynpODVXOAwvmswzSV3YyeW+6fvfCftwlo4MoN16qc8Mc0ivHyzAEQ=
X-Received: by 2002:a05:6808:3d9:: with SMTP id o25mr18928093oie.4.1617027769604;
 Mon, 29 Mar 2021 07:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
 <20210312222718.4117508-1-slyfox@gentoo.org> <SN6PR11MB2848C136F6CB4EA66D42FFAEE1639@SN6PR11MB2848.namprd11.prod.outlook.com>
 <ea49071d-d1e1-97b7-6468-501be0b9b195@physik.fu-berlin.de>
In-Reply-To: <ea49071d-d1e1-97b7-6468-501be0b9b195@physik.fu-berlin.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 29 Mar 2021 16:22:35 +0200
X-Gmail-Original-Message-ID: <CAK8P3a15jo_qup0W4itY2Fkm=SZ-NuQjmUTpDBPigSCvrF_+Yg@mail.gmail.com>
Message-ID: <CAK8P3a15jo_qup0W4itY2Fkm=SZ-NuQjmUTpDBPigSCvrF_+Yg@mail.gmail.com>
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Don.Brace@microchip.com, Sergei Trofimovich <slyfox@gentoo.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott.Benesh@microchip.com, Scott.Teel@microchip.com,
        thenzl@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 29, 2021 at 1:28 PM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On 3/24/21 7:37 PM, Don.Brace@microchip.com wrote:
> >
> > Acked-by: Don Brace <don.brace@microchip.com>
> >
> > Thanks for your patch and extra effort.
>
> Apologies for being so persistent, but has this patch been queued anywhere?
>
> This should be included for 5.12 if possible as it unbreaks the kernel on alot
> of Itanium servers (and potentially other machines with the HPSA controller).
>
> If no one wants to pick the patch up, it could go through Andrew Morton's tree (-mm).
>

I think Martin is still waiting for a fixed version of the patch, as
the proposed patch from
March 12 only solves the immediate symptom, but not the underlying problem
of the CommandList structure being marked as unaligned. If it gets fixed, the
new version should work on all architectures.

         Arnd
