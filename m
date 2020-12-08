Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F90C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD50B23B23
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgLHVYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHVYp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:24:45 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ED7C0613CF
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 13:23:58 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m12so276890lfo.7
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 13:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VtI8aWS2XBU6E+db2R347MjtIB/R2TuW+JI08/V//xI=;
        b=IX2+1eiVYs54WNPTx865dRN+VfZEy8FmzNHCJlr0nkTBrazPeMBbK0B6P6Bc0Ervo7
         lIQc7C4G9hlb8+jo8nZ+kr4AsXv0jKoBgIWW3f6NhLMOMd9YdtBoiG/YKxnS/zUjisqP
         OoeDeTYj7iX17QGH19mdD+qa/PRj0zIINeozQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VtI8aWS2XBU6E+db2R347MjtIB/R2TuW+JI08/V//xI=;
        b=HTAqKqYjMAZBSPKogvOOJcHCXJLVSGZF08WGsP21zkMBqbjS32sGMMe3hl7pz2657b
         8Gp9CoupD/LGmwd4ghFVVp3JMd6USrwaD45uPYC7pOYz2ocOL/G+sdbhGd3wNAVNXVTp
         iCywjQbfSspDhVafPNzLVh6FEXBuhrJI5exJHkZ0xj2BbeC+lnSCrQaY/g+F3dB+FsXQ
         8vy2AHnFWqbh/Prp1cVQD5ubUKhxYJD41uNpMvuPMiturr4dHeitgYaEJWAtPQwrSZyB
         gZsid+eOgHpTRLkpOY/D1uAwXQUcAvJzVU7WHd2JwZMs14mcchE9LShnjV2e9VM6E9wN
         QEEA==
X-Gm-Message-State: AOAM532qC2/kKMnue5+7OwKhtDLyzI6XwYdXtkVUyhXi0O6U7P2rCO11
        F7+yKMhSPZuqM997cE8b4fKeSRWUc0VtYw==
X-Google-Smtp-Source: ABdhPJwNJcFzf0pJ4pSwdEi/MCCTgs5fVJpoe+LezOI9cXQcUtyIF/bK3jdmGiA4EaJzwRAwSx3qng==
X-Received: by 2002:ac2:5383:: with SMTP id g3mr10606004lfh.184.1607462636134;
        Tue, 08 Dec 2020 13:23:56 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id a4sm1293467ljp.14.2020.12.08.13.23.53
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:23:53 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id j10so22070741lja.5
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 13:23:53 -0800 (PST)
X-Received: by 2002:a2e:90cb:: with SMTP id o11mr11822819ljg.465.1607462632951;
 Tue, 08 Dec 2020 13:23:52 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
In-Reply-To: <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 13:23:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
Message-ID: <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2020 at 1:14 PM John Garry <john.garry@huawei.com> wrote:
>
> JFYI, About "scsi: megaraid_sas: Added support for shared host tagset
> for cpuhotplug", we did have an issue reported here already from Qian
> about a boot hang:

Hmm. That does sound like it might be it.

At this point, the patches from Ming Lei seem to be a riskier approach
than perhaps just reverting the megaraid_sas change?

It looks like those patches are queued up for 5.11, and we could
re-apply the megaraid_sas change then?

Jens, comments?

And Julia - if it's that thing, then a

    git revert 103fbf8e4020

would be the thing to test.

           Linus
