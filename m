From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in release
Date: Thu, 21 Jun 2018 14:51:16 +0200
Message-ID: <CAG48ez3BWeZkW5XG814K4o7p0KWXVm9Gpzh2rTthNei=4fhH-A@mail.gmail.com>
References: <20180615152335.208202-1-jannh@google.com> <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com> <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180621123431.GA558@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621123431.GA558@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, dgilbert@interlog.com, Al Viro <viro@zeniv.linux.org.uk>, fujita.tomonori@lab.ntt.co.jp, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 2:34 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Jun 18, 2018 at 09:37:01AM -0600, Jens Axboe wrote:
> > It was born with that mode, but I don't think anyone ever really used it.
> > So it might feasible to simply yank it. That said, just doing a prune
> > mode at ->release() time doesn't seem like such a hard task.
>
> Let's try to kill it.  It is a significant amount of code, which does
> fishy things and is probably entirely unused:
>
> ---
> From baec733be1b400d73d0fa2bfc07684598c4172e7 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 21 Jun 2018 14:31:32 +0200
> Subject: bsg: remove read/write support
>
> The code poses a security risk due to user memory access in ->release
> and had an API that can't be used reliably.  As far as we know it was
> never used for real, but if that turns out wrong we'll have to revert
> this commit and come up with a band aid.

FWIW, I just had a look through Debian's codesearch (which AFAIK scans
through the source code of all software that Debian packages) for uses
of struct sg_io_v4: https://codesearch.debian.net/search?q=sg_io_v4

Hits that seem to be using read() or write() with struct sg_io_v4 on
bsg devices:

In the package https://packages.debian.org/stretch/tgt:
  https://sources.debian.org/src/tgt/1:1.0.73-1/usr/bs_sg.c/?hl=131#L131
  https://sources.debian.org/src/tgt/1:1.0.73-1/usr/bs_sg.c/?hl=236#L236
In the package https://packages.debian.org/stretch/sg3-utils:
  https://sources.debian.org/src/sg3-utils/1.42-2/examples/bsg_queue_tst.c/?hl=60#L60
