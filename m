From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 23:18:05 +0200
Message-ID: <519D360D.4050309@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org> <519CDDA4.2050100@redhat.com> <20130522193009.GA23845@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:60201 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3EVVSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 May 2013 17:18:15 -0400
In-Reply-To: <20130522193009.GA23845@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 22/05/2013 21:30, Tejun Heo ha scritto:
> The thing is that the behavior change is now implemented in an
> inactive form by #2 and then flipped on by #3.  #2 both change the
> format and the content of the table.  This should have been like the
> following.
> 
> #2: Convert to the new table for mat but set all bits for all commands
>     as that's what the old table looks like in the new format.

Ok, that's easy.  I will still need a bulk change like
s/__set_bit/sgio_bitmap_set/g, but it should still be relatively trivial.

> #3: Implement per-type filtering.  Now this wouldn't change any
>     behavior as the new table is the same as the old one.  This can be
>     rolled into #2.

Ok, I prefer to keep it separate though.

> #4: Update the filtering table to fix the security issue and *just*
>     the identified security issue with UNMAP.  This way, the behavior
>     change is limited to the identified security issue and distros can
>     backport upto this to address the security issue.
> 
> #5: Update the filtering table further so that commands which don't
>     make sense for the class are not allowed.  Note that this has some
>     possibility of breaking existing users and we do want this in a
>     separate patch from #4.

Sure, I can do that.  Compared to the way I split the patches, it
would have "patch 3" and "patch 4" reversed.

> Anyways, my point was that you wanna
> put that right after the security fix, not at the end of the series
> with contentious changes in the middle.  That way, the security fix
> and the part that your use case requires can be picked up separately.
> In fact, at this point, it chould be helpful to make them separate
> patchset.

I would just make it a separate series, since it isn't contentious.

> So, as I've said multiple times, let's *please* do this case-by-base -
> build the command table gradually with explicit use cases at each
> stage because SG_IO is very easy to get wrong for both the users and
> the hardware devices and the kernel isn't policing the content of
> what's being issued, because it is very nice to be able to know
> exactly the intents behind such table contents later, and because we
> wanna debate whether we even want to support specific use cases.  It's
> one thing to allow WRITE SAME passthrough and it's a different thing
> to try to allow all commands which may be issued by udev.

Ok, so I can split it in 10 patches one per command, but at some point I
wonder if it is overkill.  For example, for disks:

- WRITE AND VERIFY(16) is needed to support >2TB disks, and the
corresponding 12-byte CDB is whitelisted already.  I didn't get reports
about _these_ command but I do get bug reports about >2TB disks.
SYNCHRONIZE CACHE(16) is similarly the 16-byte extension of another
10-byte command.

- I added ATA PASS-THROUGH(16) because ATA PASS-THROUGH(12) is present;
using the (16) version is preferrable because (12) conflicts with the
destructive MMC command BLANK, see the sg_sat_identify man page.

- WRITE SAME(16), WRITE SAME(10), UNMAP are needed for discard.

- COMPARE AND WRITE is used by cluster software.

Should this be four separate patches?  Or is it enough to write this in
the commit message?  I honestly find this level of detail to be way way
higher than the normal requirement of kernel patches, but I'm happy to
comply.

>>>   Why do you need this at all if
>>>   you have the "count me out" knob in the first place?
>>
>> Because the "count me out" knob needs privileges.  It opens up way, way
> 
> So does giving out access to the device node itself.

No, it doesn't.  You can use SCM_RIGHTS, and pass a file descriptor for
the device node to an unprivileged program.  You can choose the
users/groups that are allowed to access the device.  In either case, the
privileged action is limited in time or in scope.

The count-me-out knob affects all processes that use the device node,
and won't be cleaned up properly if you SIGKILL the (privileged)
process that sets it.  So if you can avoid it, you should.

> While it could be cumbersome, requiring privileges there for arbitration
> isn't a new thing.
> 
>> more than what these patches do.
> 
> So, your use case wouldn't work with this?

There are many use cases, I listed some in my reply to Martin.
Sometimes you have trust over the guest and can use count-me-out.  But
in some cases you don't, and yet the current whitelist is not enough
(e.g. tapes).

> I did read.  Here's the patch description from patch 5.
> 
>  Start cleaning up the table, moving out of the way four rare &
>  obsolete device types: printers, communication devices (network
>  cards) and scanners (both TYPE_PROCESSOR and TYPE_SCANNER).  Add
>  missing commands for these four device types.
> 
> No real discussion or justifications for those "missing commands".

For scanners, the justification is in the patch: I actually looked at
SANE and listed each single command that is used.

For the printer commands, there is exactly one additional command, and
since the devices are obsolete anyway (but you can't block the whole
class, it would be a regression) there is no justification except
sanity.  I want to keep the per-class lists separate, and I would have
no justification for leaving out a single printer command which was
already present in the 1994 SCSI-2 standard ("SLEW AND PRINT").

Please accept that leaving something "out" of the list is as arbitrary
as putting it "in".  The list anyway has plenty, plenty of commands
that will not be implemented in the large majority of SCSI hardware in
existence such as USB enclosures or pendrives.  If they could brick
some hardware, we'd have known by now.  Erroneous input to valid
commands is much, much more likely to crash the firmware.

At some point you have to admit that if these commands are in the
standard it is because "someone" pushed for them.  Since arbitrary
applications are going to run in the VM, singling which commands go in
makes little sense, no matter how many time you ask for it.  Especially
since, anyway, it's not going to be a particularly fine net.

In some cases, leaving commands out would amount to this:

   /*
    * SYNCHRONIZE CACHE(16) and WRITE AND VERIFY(16) are not whitelisted
    * because of some not-better-specified worry that badness will
    * happen.
    */

and I would have a harder time justifying that comment, than anything
that is in these patches.

> Similar deal for other patches.  If I argue about command X to make a
> general point, what I get is "all - X".  Build from ground up, not the
> other way around.

Ok, I'll drop patch 10 which covers obsolete commands.  I know that
some of these are used because users submitted patches to QEMU to
recognize them, but I can leave this patch out and treat them the same
way as vendor-specific commands (i.e., just ask users to opt out of the
whitelist).

The rest is tape stuff, for which I really added everything that is in
the standard.  The reason is that the current whitelist is totally
inapplicable to those devices, because the command set is completely
different from that of disks.  The standards are relatively small and
do not really have the kitchen sink in them.  Media changers only have
half a dozen commands, for example.  You can google the command names
and you'll get many references from hardware manuals.

Paolo
