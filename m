Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD84C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF1461955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhC3HoM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231220AbhC3HoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 03:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6639E61957;
        Tue, 30 Mar 2021 07:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617090250;
        bh=tuMGzEMv8DSrmgTdqm0/YinviAWM2a09nAJJdrKRX88=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U6fJ/Wgp1s3ZH2+DS+6Wah2CgwXCHCi7nNaT1V0QSWr6dC9UeafEzM8COrxLNNRmx
         KXLTUe6G6eQNe/SGQb0Yuo8ahHmGKiuXTcXmNH5PWpWxTiS+4U+48OAu3x57QiY329
         8HZNixeTXfWfmx9odz/RtwxTa5zqMDFEUQjYgeGmUSWQnSNcE6LL/aCRew8eYBaizg
         SBQs0QPhM+P3ea048ubUzW3cd1DoLeDmOUPIUCe23uRcaK3rZx0PXfwwxLiv82ZMx5
         7ZCjRBPIf9Wi16qSrttzS59dmumsBnE/bJrK+rQeZeeaxdDU4g0NGC/lyn+Yd1Fh/G
         wz6zUbXaXBMNw==
Received: by mail-ot1-f52.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so14781623ote.6;
        Tue, 30 Mar 2021 00:44:10 -0700 (PDT)
X-Gm-Message-State: AOAM530NCixjoFlJ0u12R8E71mL3QXgiA/IBIwDptRx5zjfKU/kzs1Kh
        F/nY4Zx2l2jzCIUVQi7rxqayHoZD5nwmURvXyH4=
X-Google-Smtp-Source: ABdhPJxFSvyboP83ILebShzRu/XyB+MdJQHNfp6a/45qpxrGIx0+zuMmMI569QuAzXVtIBvs/M1/ofM1P2O31K6mVm8=
X-Received: by 2002:a9d:758b:: with SMTP id s11mr2694577otk.305.1617090249299;
 Tue, 30 Mar 2021 00:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com> <20210330071958.3788214-1-slyfox@gentoo.org>
 <CAK8P3a32frskYgoXi2ncOcLfhqcMDssSBp79p7WSRg3VPhmSdA@mail.gmail.com>
In-Reply-To: <CAK8P3a32frskYgoXi2ncOcLfhqcMDssSBp79p7WSRg3VPhmSdA@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 30 Mar 2021 09:43:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2AgboydhpHLMNBzdoHKULtZ5HTH2bjh2tBUGdDiVKCEA@mail.gmail.com>
Message-ID: <CAK8P3a2AgboydhpHLMNBzdoHKULtZ5HTH2bjh2tBUGdDiVKCEA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hpsa: use __packed on individual structs, not header-wide
To:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Don Brace <don.brace@microchip.com>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>, thenzl@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 30, 2021 at 9:30 AM Arnd Bergmann <arnd@kernel.org> wrote:
> On Tue, Mar 30, 2021 at 9:22 AM Sergei Trofimovich <slyfox@gentoo.org> wrote:
>
> > @@ -451,7 +452,7 @@ struct CommandList {
> >         bool retry_pending;
> >         struct hpsa_scsi_dev_t *device;
> >         atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
> > -} __aligned(COMMANDLIST_ALIGNMENT);
> > +} __packed __aligned(COMMANDLIST_ALIGNMENT);
>
> You are still marking CommandList as __packed here, which is
> what caused the original problem. Please don't mark this one
> as __packed at all. If there are individual members that you want
> to be misaligned inside of the structure, you could mark those
> explicitly.

Nevermind, I just got patch 2/3, splitting up the patches like this seems
fine to me.

Whole series

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
