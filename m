Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51379C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 22:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CF1D61057
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 22:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhEFWXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 18:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhEFWXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 18:23:42 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702D7C061574;
        Thu,  6 May 2021 15:22:42 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id c3so6892056oic.8;
        Thu, 06 May 2021 15:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBgk8yqlIg3aMfwvIL6xIju1SKVrlJ8W/h8goDlzw+w=;
        b=PteqmwL1ZA/U9XK4buyKHhVROutI8sOtPf1Dvn0NOhqk/J28TzmHYoGTSagN1LTTUS
         +UuzP78bZNf4e0XhippGxpoIZLxdh/UKRys2IT3mabviS22WlknhAgg4yLabWFt/Lnfq
         v2Ws1Z4YjDbRu1S7eB5S/oKQw3u/qY/u067rvC+bUDH481ayQMfifsCKRMK9b3I9bDWK
         sv13pHuJASixfS3pE92bc2f2lO4LmV+7JuORYXahjgWlYm2s78lkdYcI4u4rxfhtyG7G
         Vakn4LuCjE6Ema6vFqSK0laS09IOPNAShMu4qON41VZDXfTkFcXpOOno3mPQ9w52QNGD
         n+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBgk8yqlIg3aMfwvIL6xIju1SKVrlJ8W/h8goDlzw+w=;
        b=qBPCBxzh/8l9v6/xFVLY93xvgon5eI3yvw3IbJrysvh/v3xQbDpK+/i10/JIpDi8Dp
         c1RKEQvvWcbhITAwr6/0Lun/UZfpMrN883cuJiyqSJWoYBQa+yxPswE2EuGgzxQpAvRk
         ZFrLLegLEAZijX5ezb2iLH3heCTTOKj8m5U+pNNRnAqdJi8f0Ki2M39phwA4cnlAoP5f
         6M04uHGlaFABgHD9u4Ebphw7zJbAEnvbtBspSGUA3QAuGKdV40Y9pf5wrOcmDCdIAgsF
         /Guaf0Ei5oYF1bYx1hu9cMiqY+nnvXWVy4zVX3sbAoZci10PEyD/t8CBoz67zw/hSU45
         AQ8g==
X-Gm-Message-State: AOAM530QIiWAcTeyBRCTVWYNIRIpJj7wL/2/mL0ZE5plyRtexNHMChCF
        N6LSFwWFJpjF5LwTnuGwIkS1k7wWRkq2HR171vQ=
X-Google-Smtp-Source: ABdhPJxrqWZKuFtZ3qVlKxkiI+NpgeAmbcoEp2hAmAOXWszgB5IahgxKxxYepTlJX6FqpCxAZ4YUNXMeFH9S4BsHRGA=
X-Received: by 2002:aca:f5c7:: with SMTP id t190mr12073481oih.67.1620339761766;
 Thu, 06 May 2021 15:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <yq15zo86nvk.fsf@oracle.com> <20190819163546.915-1-khorenko@virtuozzo.com>
In-Reply-To: <20190819163546.915-1-khorenko@virtuozzo.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Thu, 6 May 2021 16:22:30 -0600
Message-ID: <CADvTj4rVS-wJy1B=dgEO1AOADNYgL3XkZ01Aq=RTfPGEZC+VMA@mail.gmail.com>
Subject: Re: [PATCH v3 0/1] aacraid: Host adapter Adaptec 6405 constantly
 resets under high io load
To:     Konstantin Khorenko <khorenko@virtuozzo.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 19, 2019 at 10:35 AM Konstantin Khorenko
<khorenko@virtuozzo.com> wrote:
>
> Problem description:
> ====================
> A node with Adaptec 6405 controller, latest BIOS V5.3-0[19204]
Hitting this on a Adaptec RAID 71605 as well with BIOS V7.5.0[32118]
> A lot of disks attached to the controller.
> Simple test: running mkfs.ext4 on many disks on the same controller in
> parallel (mkfs is not important here, any serious io load triggers controller
> aborts)
I saw a zfs resilver trigger this.
>
>
> Results:
> * no problems (controller resets) with kernels prior to
>   395e5df79a95 ("scsi: aacraid: Remove reference to Series-9")
>
> * latest ms kernel v5.2-rc6-15-g249155c20f9b - mkfs processes are in D state,
>   lot of complains in logs like:
>
>   [  654.894633] aacraid: Host adapter abort request.
>   aacraid: Outstanding commands on (0,1,43,0):
>   [  699.441034] aacraid: Host adapter abort request.
>   aacraid: Outstanding commands on (0,1,40,0):
>   [  699.442950] aacraid: Host adapter reset request. SCSI hang ?
>   [  714.457428] aacraid: Host adapter reset request. SCSI hang ?
>   ...
>   [  759.514759] aacraid: Host adapter reset request. SCSI hang ?
>   [  759.514869] aacraid 0000:03:00.0: outstanding cmd: midlevel-0
>   [  759.514870] aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
>   [  759.514872] aacraid 0000:03:00.0: outstanding cmd: error handler-498
>   [  759.514873] aacraid 0000:03:00.0: outstanding cmd: firmware-471
>   [  759.514875] aacraid 0000:03:00.0: outstanding cmd: kernel-60
>   [  759.514912] aacraid 0000:03:00.0: Controller reset type is 3
>   [  759.515013] aacraid 0000:03:00.0: Issuing IOP reset
>   [  850.296705] aacraid 0000:03:00.0: IOP reset succeeded
>
> Same complains on Ubuntu kernel 4.15.0-50-generic:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1777586
It's popping up in proxmox as well looks like:
https://forum.proxmox.com/threads/aacraid-host-adapter-abort-request-errors.86903/

When I tested this patch it appears to reduce the frequency of the
issue although I did
still hit an abort request:
aacraid: Host adapter abort request.
aacraid: Outstanding commands on (0,1,47,0):
>
>
>
> Controller:
> ===========
> 03:00.0 RAID bus controller: Adaptec Series 6 - 6G SAS/PCIe 2 (rev 01)
>          Subsystem: Adaptec Series 6 - ASR-6405 - 4 internal 6G SAS ports
>
> Test:
> =====
> # cat dev.list
> /dev/sdq1
> /dev/sde1
> /dev/sds1
> /dev/sdb1
> /dev/sdk1
> /dev/sdaj1
> /dev/sdaf1
> /dev/sdd1
> /dev/sdac1
> /dev/sdai1
> /dev/sdz1
> /dev/sdj1
> /dev/sdy1
> /dev/sdn1
> /dev/sdae1
> /dev/sdg1
> /dev/sdi1
> /dev/sdc1
> /dev/sdf1
> /dev/sdl1
> /dev/sda1
> /dev/sdab1
> /dev/sdr1
> /dev/sdo1
> /dev/sdah1
> /dev/sdm1
> /dev/sdt1
> /dev/sdp1
> /dev/sdad1
> /dev/sdh1
>
> ===========================================
> # cat run_mkfs.sh
> #!/bin/bash
>
> while read i; do
>    mkfs.ext4 $i -q -E lazy_itable_init=1 -O uninit_bg -m 0 &
> done
>
> =================================
> # cat dev.list | ./run_mkfs.sh
>
> The issue is 100% reproducible.
>
> i've bisected to the culprit patch, it's
> 395e5df79a95 ("scsi: aacraid: Remove reference to Series-9")
>
> it changes arc ctrl checks for Series-6 controllers
> and i've checked that resurrection of original logic in arc ctrl checks
> eliminates controller hangs/resets.
>
> Konstantin Khorenko (1):
>   scsi: aacraid: resurrect correct arc ctrl checks for Series-6
>
> --
> v3 changes:
>  * introduced another wrapper to check for devices except for Series 6
>    controllers upon request from Sagar Biradar (Microchip)
>
>  * dropped mentions of private bug ids
>
>
>  drivers/scsi/aacraid/aacraid.h  | 11 +++++++++++
>  drivers/scsi/aacraid/comminit.c |  5 ++---
>  drivers/scsi/aacraid/linit.c    |  2 +-
>  3 files changed, 14 insertions(+), 4 deletions(-)
>
> --
> 2.15.1
>
>
