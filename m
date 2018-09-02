From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Recent removal of bsg read/write support
Date: Sun, 2 Sep 2018 10:55:21 -0700
Message-ID: <CA+55aFyLC8PhjZ+iV7MucSZ1aGKMT=S9=EkEAQ6T1=ZRqD-xLA@mail.gmail.com>
References: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
 <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: drorl@infinidat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 2, 2018 at 4:44 AM Richard Weinberger
<richard.weinberger@gmail.com> wrote:
>
> CC'ing relevant people. Otherwise your mail might get lost.

Indeed.

> On Sun, Sep 2, 2018 at 1:37 PM Dror Levin <drorl@infinidat.com> wrote:
> >
> > We have an internal tool that uses the bsg read/write interface to
> > issue SCSI commands as part of a test suite for a storage device.
> >
> > After recently reading on LWN that this interface is to be removed we
> > tried porting our code to use sg instead. However, that raises new
> > issues - mainly getting ENOMEM over iSCSI for unknown reasons.

Is there any chance that you can make more data available?

I'd rather fix the sg interface (which while also broken garbage, we
can't get rid of) than re-surrect the bsg interface.

That said, the removed bsg code looks a hell of a lot prettier than
the nasty sg interface code does, although it also lacks ansolutely
_any_ kind of security checking.

> > Because of this we would like to continue using the bsg interface,
> > even if some changes are required to meet security concerns.

I wonder if we could at least try to unify the bsg/sg code - possibly
by making sg use the prettier bsg code (but definitely have to add all
the security measures).

And dammit, the SCSI people need to get their heads out of their
arses. This whole "stream random commands over read/write" needs to go
the f*ck away.

Could we perhaps extend the SG_IO interace to have an async mode?
Instead of "read/write", have "SG_IOSUBMIT" and "SG_IORECEIVE" and
have the SG_IO ioctl just be a shorthand of "both".

And have a model that actually checks that "yeah, this command is ok
for a normal user", so that it's actually useful for things like CD
burning etc, without making it a huge gaping security hole that is
only useful for crazy special cases?

Maybe that - otherwise reasonably pretty - block/bsg.c code could be
joined with the SG_IO code that actually understands security issues?

                 Linus
