From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 17:53:34 +0200
Message-ID: <519CE9FE.2030007@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130522150335.GC2777@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 22/05/2013 17:03, Theodore Ts'o ha scritto:
> Paolo,
> 
> I'll probably regret butting my head into this, but it might be
> helpful if you talk about your particular use case which is driving
> your desire to make these changes.

Ted,

thank you very much.  I understand that my discussion with Tejun is
leading nowhere, and any outside help can only improve the situation.  I
hope you won't regret it. :)

> For example, what do you think the
> SG_IO whitelist _should_ be used, and why should it be made more
> general?  What's the use case that is being impaired by the current
> state of how sg_io whitelists are being handled?

Thanks for writing the questions down.  I hope you don't mind the
verbosity; perhaps we can use the opportunity to rewind the discussion.

First of all, I'll note that SG_IO and block-device-specific ioctls both
have their place.  My usecase for SG_IO is virtualization, where I need
to pass information from the LUN to the virtual machine with as much
fidelity as possible if I choose to virtualize at the SCSI level.  In
that case, I'll use SG_IO.  If people are okay with virtualizing at a
higher-level, I'll use ioctls(BLK*) or fallocate (it depends on whether
my target is a block device or a file).  It depends on the application,
the user, the context,...  But in general, a program that cares about
things like sense data must use SG_IO, a program that only cares about
high-level concepts will use the ioctl.

Now, SG_IO whitelist started so that you could "burn CDs without being
root".  But that can be extended to other device types; the SG_IO
whitelist provides a way to allow low-level operations on devices while
ensuring: a) respect of file permissions and no need for special
privileges; b) no disruption of the devices or the storage fabric (for
disks, no disruption beyond what would be possible anyway with
read/write or other ioctls).

There are some non-disk devices that (like CD-ROMs) have their own set
of commands and can only be accessed via /dev/sg, for example media
changers.  Tapes also have some functionality that is not accessible via
/dev/st.  It would be useful (for virt, but I'm sure there are other
usecases) to make the common uses of these devices possible without
privileges, just by granting the appropriate permissions to the uids who
will operate on them.  This is why the SG_IO whitelist should be widened
for these devices.

But even for block devices, it should be made more general because the
limitations in the current list are not really justified, except as an
artifact of how the whitelist developed (again, "burn CDs without being
root").  I think that there's no reason to forbid unprivileged programs
from doing with SG_IO what they could do with other ioctls.  By
extension, if it makes sense to add an unprivileged ioctl in the future
(e.g. for atomic compare and write) it should also be available from now
via SG_IO.

> Secondly, when you are trying to get a security vulnerability fixed,
> it's helpful if you give the precise nature of the problem, and what
> the an attacker can do with it.  I think you are worried that if an
> attacker has read-only access, they can still send the UNMAP command
> which may (since it is advisory) result in a block no longer
> containing valid data, such that a read will return zero's or some
> other undefined garbage.   Yes?

Yes.

> Now consider that if this is a high-priority fix, it's important to
> make the patch as small as possible, since distributions (like your
> employer) may want to backport the patch to older kernels.  And
> distribution release engineers will appreciate things if the patch is
> as small as possible, making the _minimum_ necessary changes to fix
> said security exposure.  Generally, a series of 14 patches is __not__
> the minimum necessary patch.

It is not a high-priority fix, or Red Hat would have agreed on an
embargo date with other distros, and done all the security stuff that
they routinely do.  Still, it is a fix that I would like to get in, if
only because Red Hat's policy is to get things upstream as much as possible.

In fact, I would have very much preferred to get things upstream first.
 Unfortunately, this was not really possible in this case; FWIW, the
RHEL kernel already has something very similar to the first 4 patches in
v1 of this series.

The reason for posting it all together, it's that frankly getting
patches into block/ is an absolute pain.  I know it's not a good reason,
and I have certainly compounded my own mistakes.  But guys, you have a
review problem if things are allowed to sit in the mailing list for two
months without a single reply.

It's really the first time (and I've been working on free software for a
_long_ time, as both volunteer and employee, maintainer and contributor)
that I felt the helpless because I was not in the frequent contributors
"clique".  I know that's just an impression and doesn't match reality,
but emotions do count and they make it really hard for one to keep his
temper.  I deleted many f-words from my replies (I should have deleted
more).

In fact, the (low) level of this discussion is also a first for me.
Maybe I didn't know myself well enough, because even I wouldn't have
expected it.  I'm likely more surprised of this than anyone else.

> Finally, please consider that your attitude is not going to win
> friends and influence people.

I do listen to review feedback, but I also expect the other side to
listen to me, ask me what is not clear, and possess some knowledge of
the domain that he's reviewing patches for.  All of which, quite
frankly, I have not seen in this case.

> I don't know if the capability to work
> well with upstream developers (people which ***other*** Red Hat
> engineers have had no problems work with, and which I can attest,
> through personal experience, are very reasonable engineers who are
> easy to work with), is something which is a part of your performance
> review process.  But if it isn't, it probably should be,

It is, as it should be.

Paolo
