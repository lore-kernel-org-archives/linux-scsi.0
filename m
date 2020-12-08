Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F02BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38AD23AC8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgLHWl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:41:27 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:63770 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730517AbgLHWl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:41:26 -0500
X-IronPort-AV: E=Sophos;i="5.78,404,1599516000"; 
   d="scan'208";a="481863343"
Received: from 173.121.68.85.rev.sfr.net (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 23:40:44 +0100
Date:   Tue, 8 Dec 2020 23:40:44 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: problem booting 5.10
In-Reply-To: <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien> <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com> <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com> <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Tue, 8 Dec 2020, Linus Torvalds wrote:

> On Tue, Dec 8, 2020 at 1:14 PM John Garry <john.garry@huawei.com> wrote:
> >
> > JFYI, About "scsi: megaraid_sas: Added support for shared host tagset
> > for cpuhotplug", we did have an issue reported here already from Qian
> > about a boot hang:
>
> Hmm. That does sound like it might be it.
>
> At this point, the patches from Ming Lei seem to be a riskier approach
> than perhaps just reverting the megaraid_sas change?
>
> It looks like those patches are queued up for 5.11, and we could
> re-apply the megaraid_sas change then?
>
> Jens, comments?
>
> And Julia - if it's that thing, then a
>
>     git revert 103fbf8e4020
>
> would be the thing to test.

This solves the problem.  Starting from 5.10-rc7 and doing this revert, I
get a kernel that boots.

thanks,
julia
