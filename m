From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at iscsi_tcp_segment_done+0x20d/0x2e0
Date: Wed, 21 Dec 2016 21:46:37 -0800
Message-ID: <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
References: <20161214222411.GH4326@dastard> <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard> <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org> <20161222051322.GF4758@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36393 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750697AbcLVFqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 00:46:39 -0500
In-Reply-To: <20161222051322.GF4758@dastard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> There may be deeper issues. I just started running scalability tests
> (e.g. 16-way fsmark create tests) and about a minute in I got a
> directory corruption reported - something I hadn't seen in the dev
> cycle at all.

By "in the dev cycle", do you mean your XFS changes, or have you been
tracking the merge cycle at least for some testing?

> I unmounted the fs, mkfs'd it again, ran the
> workload again and about a minute in this fired:
>
> [628867.607417] ------------[ cut here ]------------
> [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220

Well, part of the changes during the merge window were the shadow
entry tracking changes that came in through Andrew's tree. Adding
Johannes Weiner to the participants.

> Now, this workload does not touch the page cache at all - it's
> entirely an XFS metadata workload, so it should not really be
> affecting the working set code.

Well, I suspect that anything that creates memory pressure will end up
triggering the working set code, so ..

That said, obviously memory corruption could be involved and result in
random issues too, but I wouldn't really expect that in this code.

It would probably be really useful to get more data points - is the
problem reliably in this area, or is it going to be random and all
over the place.

That said:

> And worse, on that last error, the /host/ is now going into meltdown
> (running 4.7.5) with 32 CPUs all burning down in ACPI code:

The obvious question here is how much you trust the environment if the
host ends up also showing problems. Maybe you do end up having hw
issues pop up too.

The primary suspect would presumably be the development kernel you're
testing triggering something, but it has to be asked..

                     Linus
