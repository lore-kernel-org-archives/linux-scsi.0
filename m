Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72167C34026
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 19:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52BC321D56
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 19:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgBRTq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:46:26 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:41545 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 14:46:25 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mf0Ru-1jgCOr3uFm-00gUpW; Tue, 18 Feb 2020 20:46:24 +0100
Received: by mail-qk1-f171.google.com with SMTP id z19so20724522qkj.5;
        Tue, 18 Feb 2020 11:46:23 -0800 (PST)
X-Gm-Message-State: APjAAAVleWDKBpsKauGzFJUng0hNlbvSXSN6mq010crjfboXjuJX7rSj
        a8K1irKTGvdesZ9o9nvIFy3cH7nq8cnU9O7NbMg=
X-Google-Smtp-Source: APXvYqwbGAiF9aYwjYIhgGpL3VhU9zK7RzM5d/6ac5f3o4RZ+gVHUq6O605zQM06x48IvNYRRM8jFMYaGqcoVE+OpMY=
X-Received: by 2002:a37:e409:: with SMTP id y9mr20733359qkf.352.1582055182723;
 Tue, 18 Feb 2020 11:46:22 -0800 (PST)
MIME-Version: 1.0
References: <20200218143918.30267-1-merlijn@archive.org> <20200218171259.GA6724@infradead.org>
 <1582046428.16681.7.camel@linux.ibm.com> <20200218172347.GA3020@infradead.org>
 <1582046914.16681.11.camel@linux.ibm.com> <20200218173158.GA18386@infradead.org>
 <33da5f81-ad37-05fd-d765-8bd997995dd2@archive.org>
In-Reply-To: <33da5f81-ad37-05fd-d765-8bd997995dd2@archive.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Feb 2020 20:46:06 +0100
X-Gmail-Original-Message-ID: <CAK8P3a23WXG5SbdrgMeq9OYpbeHBxnEdNijeE67iCbd4O_wB6g@mail.gmail.com>
Message-ID: <CAK8P3a23WXG5SbdrgMeq9OYpbeHBxnEdNijeE67iCbd4O_wB6g@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: sr: get rid of sr global mutex
To:     "Merlijn B.W. Wajer" <merlijn@archive.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:LFNHau7HbkPE44X4nILiWXTfftWClqCfqZxgquFFVcGl1Z39qCW
 4dHfTxZGmFOxGmFFGiF8tbBQY0Fat1tZZd2GkW8gKlR776mtjYtXuQ5VbihgfNf45FdMyIh
 u7DTE0OgZmw/GXMuvaR1gzWmf9qNglQMTCRPGWqZrD8B8XLo8vHmmNFq/gtdeeUmH383LZC
 ezQXXjhxXsRMNQ/sObOCQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:It2ll/FtP0w=:3bUh8RVv4VWeQoaltn2hA9
 FhTs+z2z4H0MPq6tvzekF6Z/CJVC/+5tb/C5tmWPbXCjtQKkDcEUNx/4Y28/Mkl/VnlbjQ/MV
 bOm+YyiAuF10OyqikDiQJQyRhUfzT1hLjqnhue3T8UequSQLU5Df58TreNVcgLwr01fRx7SBN
 NqE1OYjeOcJ+8F+MuenokfWOKsVUDMSwfi3RxWNqmNZo9R/MlR1WPSV+nVQXWygVbIDbwf2sc
 pa8PVxULBuVAFN8MR2QzJOyYhJsf7hpp4IsalCO+LifyLMEMDvfyOnIAnL+gHl2fw5PwDwfwq
 2qRFoTZTywOjzZC0eqBLa84Ni5xGKEEe23IYhBVYPzZNVajhPZBHJQzqxu6VnG6sipJodOZCz
 AlIwY6gMQwjCxkgK+IyMj2OQT5z2d51h4Ko9iQYAjV5/m0fXfxir1Tk++7Jo1r5wxEFS0aJ0E
 4O6yAbE7vaeLcJVO0bxlO/sO9U3XC3p6uQGUsyBL2iai4+N+K7yF0hvNFIHgb7eyRZnaWqDLj
 6AexRZyXInWwtNHGImwxsv1mKDq5nYQAPSAM9ta9PrvBtlmON13Foy8dxEfkkqA7s+nA2iuSW
 f0Svd9gQMTGdIQNQoYV1Fho/5Ja6Le53Zm5A8H9GkHhlCcbrBfsMDpcgZsqNogxnpMuCbAP8j
 FrLhT/4Ii+i2penMCqaWnK0snLAjaR/s8OZe7AauNi8HlQfp5zdapK60vUGMZBY0FgKUL92sU
 8TI99BqWpk/16/4jrbRdehjHfJHtzQtG3k+XfmiFfV2MSrUPubmp1V7n38/a27ONEtpZKK8ru
 MmcCTWeXcbeLn401LtoqjakN0onC02vTQWc6IKJRFi351qaOME=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 18, 2020 at 8:20 PM Merlijn B.W. Wajer <merlijn@archive.org> wrote:
> On 18/02/2020 18:31, Christoph Hellwig wrote:
> > On Tue, Feb 18, 2020 at 09:28:34AM -0800, James Bottomley wrote:
> >> On Tue, 2020-02-18 at 09:23 -0800, Christoph Hellwig wrote:
> >>> On Tue, Feb 18, 2020 at 09:20:28AM -0800, James Bottomley wrote:
> >>>>>> Replace the global mutex with per-sr-device mutex.
> >>>>>
> >>>>> Do we actually need the lock at all?  What is protected by it?
> >>>>
> >>>> We do at least for cdrom_open.  It modifies the cdi structure with
> >>>> no other protection and concurrent modification would at least
> >>>> screw up the use counter which is not atomic.  Same reasoning for
> >>>> cdrom_release.
> >>>
> >>> Wouldn't the right fix to add locking to cdrom_open/release instead
> >>> of having an undocumented requirement for the callers?
> >>
> >> Yes ... but that's somewhat of a bigger patch because you now have to
> >> reason about the callbacks within cdrom.  There's also the question of
> >> whether you can assume ops->generic_packet() has its own concurrency
> >> protections ... it's certainly true for SCSI, but is it for anything
> >> else?  Although I suppose you can just not care and run the internal
> >> lock over it anyway.
> >
> > We have 4 instances of struct cdrom_device_ops in the kernel, one of
> > which has a no-op generic_packet.  So I don't think this should be a
> > huge project.
>
> The are two reasons I decided to make minor changes to fix the
> performance regression.
>
> First, being able to send the patch to the various stable branches once
> merged. For people working with many CD drives attached to one station,
> this is a pretty big deal, so I tried to keep the patch simple. It fixes
> the regression introduced in another commit.
>
> Secondly, I don't have the hardware to test sophisticated or old setups,
> like some of the issues linked from my patch. I have SATA CD drives with
> USB->SATA bridges, no IDE, no PATA, etc. So the testing I can do is
> relatively limited.
>
> Perhaps I or someone else can work on removing the usage of the locks,
> but as it stands I think this addresses the performance issue present in
> the current kernel, and removing locks and the associated testing
> required with that is something I am not entirely comfortable doing.

I think this is entirely reasonable. There is a good chance that the
per-device lock is not needed, but there is an even higher chance
that there is never any contention, because the normal use case
is for a CDROM driver is to only have one process working on it at
a time using ioctl.

        Arnd
