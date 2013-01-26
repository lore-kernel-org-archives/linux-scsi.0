From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Sat, 26 Jan 2013 11:18:01 +0100
Message-ID: <5103AD59.2050509@redhat.com>
References: <20130125170434.GC3081@htj.dyndns.org> <5102BDD4.2020501@redhat.com> <20130125172805.GG3081@htj.dyndns.org> <5102C780.3090402@redhat.com> <20130125181326.GK3081@htj.dyndns.org> <5102D353.8010305@redhat.com> <20130125190154.GM3081@htj.dyndns.org> <5103080A.4090803@redhat.com> <20130125224159.GQ3081@htj.dyndns.org> <51031614.8000609@redhat.com> <20130125234714.GR3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125234714.GR3081@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 26/01/2013 00:47, Tejun Heo ha scritto:
>> > If I make a whitelist with all the commands that Linux sends, I'll have
>> > many new commands in the whitelist and no old commands.  The new
>> > commands didn't exist when old drives were sold, so they are "dangerous"
>> > in your opinion.  At that point I might as well keep the whitelist
>> > empty, no?
> Let's not go to extremes.  It's not about theoretic correctness.

Once you start looking at what is already in the list, you'll see that
your problem is entirely theoretical, and any choice is going to be arbitrary.
There are already plenty of enabled commands that are not implemented by
most SCSI devices (not just cheap USB enclosures), and I don't see what
the difference should be between say "LOG SELECT" and "ORWRITE".

> It's about how to appraoch a possibly messy practical problem. To me,
> it seems natural to be conservative on this and add what's being
> acitvely used, which as a bonus will also give us at least some
> chance of evaluating what we have and why later on if it ever needs
> to be changed.
> 
> I'm just not comfortable with adding a bunch of commands by simply
> scanning the specs.  Let's at least have some backing data and
> justification for exposing new ones.  I really don't think that's too
> much to ask.  Start with minimal set.  Grow it as needed.  We can
> always grow but the other direction is much harder.

Ok, so I looked at the list.  The vast majority of the commands are
added because Linux itself is using them.

Considering only commands that have a "D" (i.e. are supported by
"normal" disks), these maybe can be removed from patch 9.  Probably
no one would notice:

+       sgio_bitmap_set(0x07, D|      W|  O                  , write); // REASSIGN BLOCKS
+       sgio_bitmap_set(0x29, D|      W|R|O                  , read);  // READ GENERATION
+       sgio_bitmap_set(0x2C, D|        R|O                  , write); // ERASE(10)
+       sgio_bitmap_set(0x8B, D                              , write); // ORWRITE

These two are no-ops so I won't cry too much for them:

+       sgio_bitmap_set(0x34, D|      W|  O|        K        , read);  // PRE-FETCH(10)
+       sgio_bitmap_set(0x90, D|      W|  O|      B          , read);  // PRE-FETCH(16)

Everything else has to stay.

For tapes and media changers, all of the commands have to stay.

Paolo
