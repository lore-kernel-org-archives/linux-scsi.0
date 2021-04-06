Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88396C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 19:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D305613BE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 19:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhDFTBm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 15:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhDFTBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 15:01:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2338C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 12:01:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w23so6592318edx.7
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 12:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxu2hVW4vDsJ/zyUkCOOPjFczaHMxU9ZwZUTupO/aYM=;
        b=pj/D/hn6fX86bGAwBhbDZOoKgp5kercSfhhebkX0qpAk3644GUSkcU7eYOWqHiG45d
         2QwG3pOK2C4xwehho3Qeekktb6K6QWyzcBIiHJHQOx3kuS++1+Q97bswkTXMZEOXjNki
         Sg5BykrIWzAUeLH7fHrdpAp1r+N8xXobmyJj+mEvxhhA7nwQZk9qNdpSeqJtYj4GpKZb
         XKlgmIsCB6KjAsncfzxSCOV0VMHrfBsRfncMMKbz44qP/TumnPKKtNiZ7w6EXLWNLFtL
         ThlEfWR/6CyTWQnElcEQQGKG2pCyPZfo35EQWu+ya7a3lxRIm1Nrz8hsPUlfVZHV/ydO
         QZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxu2hVW4vDsJ/zyUkCOOPjFczaHMxU9ZwZUTupO/aYM=;
        b=Nl9UMr2dS9GurVSLPThYavxbyFDNkyOnem1D1oX1PpKu5cs2SVPXscCkOzh51D4Cgi
         l/gXtZf0Nehm6qKEYXVPqxD/l8Gty3ODflNzVF/FfmIY9e+x0UXwwCGrIkqWxiYzRPKU
         lA7e6ofnmFZxYzcYI6crY2r6QNUab5yzD8T4Q5U0e9BBi3LfTRdkWChi8tTldNQW+H4e
         SGrCqdLlQ5zdF/YM+W6cUlx5nqIeWoBwbs/i1rW+rkpbNnJykjol5gHMBXPKLtGmcQ0j
         YdfvBsr0RsqJHObBiZhV8vYh5LHoJjHpDdsgs3E+9VHf3GB2CgorNf21tFTOvgV6kO9u
         wifw==
X-Gm-Message-State: AOAM5330bUukadvyU73/S3w9VtHuZLnDQeHDOS/WGaU15AOasbwEPUm5
        IiOtEcLzVL/oiA+DX22l/JFI7izLxGAreUgHGxg=
X-Google-Smtp-Source: ABdhPJzQxQY6wxaSLRv34hsTb7553hOyc4qj7GjPBEYNlmWxox+01xleODcqAzq4iSuWsB1cSEn5BTcepT/BWFbChUc=
X-Received: by 2002:a05:6402:1cc1:: with SMTP id ds1mr30751204edb.135.1617735690360;
 Tue, 06 Apr 2021 12:01:30 -0700 (PDT)
MIME-Version: 1.0
References: <1616701889-77537-1-git-send-email-ice799@gmail.com> <yq1eefocbf6.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1eefocbf6.fsf@ca-mkp.ca.oracle.com>
From:   Joe Damato <ice799@gmail.com>
Date:   Tue, 6 Apr 2021 12:01:03 -0700
Message-ID: <CADk91pOtAibFQ-fac4xjEm3FqOOvwVvw_e=4ed=YSaQs8+Zh7Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: disable ASPM for mpt3sas / SAS3.0
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 5, 2021 at 9:00 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Joe,
>
> > Noticed commit ffdadd68af5a ("scsi: mpt3sas: disable ASPM for MPI2
> > controllers") disables ASPM for SAS-2.0 HBAs, but this change was not
> > replicated for SAS-3.0 HBAs. This change replicates this behavior.
>
> Do you have a system that exhibits problems with ASPM enabled?

I am not sure.

I get intermittent messages in dmesg as seen below and stumbled upon
commit ffdadd68af5a while researching, which looked similar.

I haven't found a way to easily or reliably reproduce this issue, but
it surfaces as dmesg reporting an unknown NMI, and all the disks
suddenly going offline. There is some sort of controller fault
occurring because of the dmesg line which says "mpt3sas_cm0:
_base_fault_reset_work: Running mpt3sas_dead_ioc thread success."

My naive thought process was that:

- A message from Sreekanth back in ~2016 suggested that it should be
disabled explicitly for SAS-2.0 [1] - perhaps this is also true for
SAS-3.0 ?
- Not sure, but disabling ASPM for SAS-3.0 probably wouldn't
negatively impact users
- Disabling ASPM explicitly in the driver only has an impact if the
BIOS has given kernel control of ASPM, but could be a good safeguard.
- It may (or may not) reduce the incidence of this event I sporadically see.

Is there a way to induce ASPM events so that I could test this? Or
perhaps can I tweak the fault handler to get more information about
the specific type of fault?

All in all I figured the change was relatively harmless and could
reduce the incidence of this sporadic NMI I see.

Thanks,
Joe

[1]: https://patchwork.kernel.org/project/linux-scsi/patch/20161228110524.7516-1-ojab@ojab.ru/#20106435

1513141.713575] Uhhuh. NMI received for unknown reason 30 on CPU 0.
[1513141.713576] Do you have a strange power saving mode enabled?
[1513141.713577] Dazed and confused, but trying to continue
[1513141.839140] mpt3sas_cm0: SAS host is non-operational !!!!
[1513142.867056] mpt3sas_cm0: SAS host is non-operational !!!!
[1513143.890996] mpt3sas_cm0: SAS host is non-operational !!!!
[1513144.914887] mpt3sas_cm0: SAS host is non-operational !!!!
[1513145.934806] mpt3sas_cm0: SAS host is non-operational !!!!
[1513146.958724] mpt3sas_cm0: SAS host is non-operational !!!!
[1513146.965053] mpt3sas_cm0: _base_fault_reset_work: Running
mpt3sas_dead_ioc thread success !!!!
[1513146.965423] sd 0:0:7:0: [sdh] tag#0 FAILED Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[1513146.973762] sd 0:0:7:0: [sdh] tag#0 CDB: Read(10) 28 00 d7 72 30
b0 00 00 10 00
[1513146.973764] print_req_error: I/O error, dev sdh, sector 3614585008
[1513146.978754] sd 0:0:6:0: [sdg] tag#29 FAILED Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[1513146.978756] sd 0:0:6:0: [sdg] tag#9 FAILED Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[1513146.978757] sd 0:0:6:0: [sdg] tag#33 FAILED Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[1513146.978759] sd 0:0:6:0: [sdg] tag#33 CDB: Read(10) 28 00 d8 47 30
68 00 00 30 00
[1513146.978760] sd 0:0:6:0: [sdg] tag#9 CDB: Write(10) 2a 00 61 d1 ae
20 00 04 00 00
