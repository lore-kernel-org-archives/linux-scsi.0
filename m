From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Tue, 19 Nov 2002 12:55:20 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3DDA7B08.7010101@pobox.com>
References: <20021119055636.94C182C088@lists.samba.org> <20021119160622.GA8738@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021119055636.94C182C088@lists.samba.org>
To: Doug Ledford <dledford@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alexander Viro <viro@math.psu.edu>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>
List-Id: linux-scsi@vger.kernel.org

Doug Ledford wrote:

> On Tue, Nov 19, 2002 at 04:52:25PM +1100, Rusty Russell wrote:
>
> >>right).  Or you can run a notifier on "enlivening" a module: I'd hoped
> >>to avoid that.
> >
> >Actually, after some thought, this seems to clearly be the Right
> >Thing, because it solves another existing race.  Consider a module
> >which does:
> >
> >	if (!register_foo(&my_foo))
> >		goto cleanup;
> >	if (!create_proc_entry(&my_entry))
> >		goto cleanup_foo;
>
>
> There is *NO* module that does this right now and can be considered even
> close to working.  The rule always has been "register yourself when you
> are ready for use".  You're trying to add this new "You can fail after
> registering yourself" semantic for brain dead coders that can't write an
> init function to save thier ass.  My position is that in doing so, you
> fuck all of us that do write a reasonable init sequence and handle our
> error conditions.  Plus, since this is a changes in semantics, you have
> possibly 50 or 100 modules that rely on the old behaviour, and maybe a 
> few
> that are broken in regards to registration ordering.  I think you are
> trying to fix the wrong group of modules here.
>
> So, to me, the answer is clear.  The rule is hard and fast, you don't 
> hand
> out your function pointers to other modules or the core kernel until you
> are ready for them to be used.  Don't muck with the module loader to 
> solve
> the problem, fix the maybe 4 or 5 modules that might violate this rule.



violently agreed.  This has the potential for requiring an update of 
almost every driver in the kernel, does it not?

	Jeff
