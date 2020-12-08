Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F4AC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 18:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC8B23B03
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 18:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgLHSc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 13:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgLHSc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 13:32:59 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB92FC061793
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 10:32:12 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id d20so25291328lfe.11
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 10:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZM54iolf0NIBnlTpIg0weCrnfZMFH7sMy0/zmKYmnyA=;
        b=QFhzyPFNVmpiYok59DOMe1RBLDV0yzug03dRhZq76ksgefRCx3kA341Zk8/3xGwIru
         K+IgYfuLNFelin6TjpWW3fCsVBAe1X86PXvlpDEQHaWL+8wxFnjEygGMMGKfelINjfUO
         D6P0IcQbV2pd7q/lgx+48CJvFgkkpVAdyekk0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZM54iolf0NIBnlTpIg0weCrnfZMFH7sMy0/zmKYmnyA=;
        b=q0S/35XzGcvPxn+V1ue+gsCh1e+Pt+UezlFEIxN7PQSQsRf4DJiocz+xBCSbFTYn/u
         K3qoNEUL5BoRwiB2FBCxnCAHTxzVUQ/qyLt9aPn1lS7rXv/GsrBQczlJBIWeOVhF3UuF
         unlfWT4Rwfg73xRwBX3ALZZb7JGvwk/MObBS5tl1KKuebwEBYOPp8Q0TWQRdDMJy2eBX
         V5SMBuVwSrmdJa3eitONjFIVE2Ds83WGdQd62evhc14GWykFoXyyTBI7p0cMfAyzybe/
         h2z2B5DeK2o4DbEdbs2Rvp3fU4hPqk5IeNQrtmox9keksCtjNHIl/nAssd8wvUSvrbrI
         PXXg==
X-Gm-Message-State: AOAM532ks3l+7l4Vse2kPqJFHI3405D/bilGoItPPqcGvEQh8L3fBXAT
        DPAnV+ZyHkUbIjoZ//VQx9P0+FC9xCB7ew==
X-Google-Smtp-Source: ABdhPJxgonTNneDS+8iY3YMEpldaWd7VeN3rlxlC2p/KzciWW38P08ylZg3411cE1MEvylk5BMn+dg==
X-Received: by 2002:ac2:504e:: with SMTP id a14mr7511352lfm.285.1607452328953;
        Tue, 08 Dec 2020 10:32:08 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id w4sm860433lfk.56.2020.12.08.10.32.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 10:32:08 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id 23so12306768lfg.10
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 10:32:08 -0800 (PST)
X-Received: by 2002:ac2:4987:: with SMTP id f7mr4141572lfl.41.1607452325575;
 Tue, 08 Dec 2020 10:32:05 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
In-Reply-To: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 10:31:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
Message-ID: <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     Julia Lawall <julia.lawall@inria.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2020 at 9:37 AM Julia Lawall <julia.lawall@inria.fr> wrote:
>
> We have not succeeded to boot 5.10 on our Intel(R) Xeon(R) CPU E7-8870 v4 @
> 2.10GHz server.  Previous versions (eg 4.19 - 5.9) boot fine.  We have
> tried various rcs.

So the problem started with rc1?

Could you try bisecting - even partially? If you do only six
bisections, the number of suspect commits drops from 15k to about 230
- which likely pinpoints the suspect area.

That said, your traces certainly makes me go "Hmm. Some thing broke in
SCSI device scanning", with the primary one being the
wait_for_completion() one - the rest of the stuck processes seem to be
stuck in async_synchronize_cookie_domain() and are presumably waiting
for this kthread that is waiting for the scan to finish.

So I'm adding SCSI people to the cc, just in case they go "Hmm..".

Martin & co - in the next email Julia also quotes

> [   51.355655][    T7] scsi 0:0:14:0: Direct-Access     ATA      ST2000LM015-2E81 SDM1 PQ: 0 ANSI: 6
> Gave up waiting for root file system device.  Common problems:[..]

which seems to be more of the same pattern with the SCSI scanning failure.

Of course, it could be some non-scsi patch that causes this, but.. A
bisect would hopefully clarify.

Leaving the (simplified) backtrace quoted below.

                   Linus

>The backtrace for rc7 is shown below.
>
> [  253.207171][  T979] INFO: task kworker/u321:2:1278 blocked for more than 120 seconds.
> [  253.224089][  T979]       Tainted: G            E     5.10.0-rc7 #3
> [  253.239209][  T979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  253.256990][  T979] task:kworker/u321:2  state:D stack:    0 pid: 1278 ppid:     2 flags:0x00004000
> [  253.275552][  T979] Workqueue: events_unbound async_run_entry_fn
> [  253.290687][  T979] Call Trace:
> [  253.302491][  T979]  __schedule+0x31e/0x890
> [  253.315353][  T979]  schedule+0x3c/0xa0
> [  253.327688][  T979]  schedule_timeout+0x274/0x310
> [  253.379283][  T979]  wait_for_completion+0x8a/0xf0
> [  253.392327][  T979]  scsi_complete_async_scans+0x107/0x170
> [  253.406115][  T979]  __scsi_add_device+0xf7/0x130
> [  253.418974][  T979]  ata_scsi_scan_host+0x98/0x1c0
> [  253.431948][  T979]  async_run_entry_fn+0x39/0x160
> [  253.444853][  T979]  process_one_work+0x24c/0x490
