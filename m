From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: scsi: BUG in scsi_init_io
Date: Sun, 19 Feb 2017 09:38:26 -0800
Message-ID: <CA+55aFxRdbQ5_PVfDQBM3Yz2K0QG3NX26DBiAdKi575+-SfxHA@mail.gmail.com>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
 <20170131092048.GB3687@linux-x5ow.site> <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
 <1485877311.3199.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485877311.3199.4.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 31, 2017 at 7:41 AM, James Bottomley
<jejb@linux.vnet.ibm.com> wrote:
>
> It is a kernel bug and it should not be user triggerable, so it should
> have a warn_on or bug_on.

Hell NO.

Christ, James, listen to yourself. What you are basically saying when
you say it should be a BUG_ON() is

 "This shouldn't happen, but if it ever does happen, let's just turn
our mistaken assumptions into a dead machine that is really hard to
debug".

Because a BUG_ON() effectively kills the machine if the call chain has
some locks held. In the SCSI layer, that generally means that there
will be no logged oops either, because any locks held likely just
killed your filesystem or disk subsystem, so now that oops is
basically not even likely to be reported by most normal users.

So stop this "should have a bug_on". In fact, since this apparently
_is_ easily user-triggerable, it damn well shouldn't have a warn_on
either. At most, a WARN_ON_ONCE(), so that we might get reports of
_what_ the bad call chain is, but we will never kill the machine and
we will *not* give people the ability to randomly spam the system
logs.

BUG_ON() needs to die. People need to realize that it is a _problem_,
and that it makes any bugs _worse_. Don't do it.

The only valid reason for BUG_ON() is when some very core data
structure is _so_ corrupt that you can't even continue, because you
simply can't even return an error and there's no way for you to just
say "log it once and continue".

And by that I don't mean some random value you have in a request. I
mean literally "this is a really core data structure, and I simply
_cannot_ continue" (where that "cannot" is about an actual physical
impossibility, not a "I could continue but I think this is serious").

Anything else is a "return error, possibly with a WARN_ON() to let
people know that bad things are going on".

Basically, BUG_ON() should be in core kernel code. Not in drivers. And
even in core kernel code, it's likely wrong.

             Linus
