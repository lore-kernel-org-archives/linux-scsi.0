From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 10:07:07 -0400 (EDT)
Message-ID: <519430357.5931281.1369231627092.JavaMail.root@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <1369224435.1811.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46476 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3EVOHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 May 2013 10:07:16 -0400
In-Reply-To: <1369224435.1811.22.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> OK, let me try.  I did draw straws with Jens at LSF to see who would
> look at this and he lost, but the complexity of the patch set probably
> makes it hard for him to find the time.

Thanks.

> The first problem, which Tejun already pointed out is that you've
> combined a "bug fix" with a large feature set in such a way that they
> can't be separated, so saying the first four patches fix a bug isn't
> helpful.

Fair enough.  Though to be precise, this is a combined patchset also
because previous attempts to get similar patches reviewed proceeded with
glacial pace.

For example, the unpriv_sgio patch had been sent in November 2012
(https://patchwork.kernel.org/patch/1735871/).  It got two acks from
Tejun, and was never applied despite two pings.

My attempt to include UNMAP and WRITE SAME into the whitelist (even before
I found out by chance the overlap) dates back to July 2012, and was only
reviewed two months after.

> The second problem is that it's not at all clear what the bug actually
> is.  You have to wade through tons of red hat bugzillas before you come
> up with the fact that there's one command which we allow users to send
> which is ambiguous: GPCMD_READ_SUBCHANNEL which has the same opcode as
> UNMAP on a disk.

No, you don't need to.  Just read the commit message of patch 4.

> Once you finally work this out, you wonder what all
> the fuss is about because UNMAP is advisory ... even if an unprivileged
> user can now send the command, it can't be used to damage any data or
> even get access to any data, so there doesn't seem to be an actual bug
> to fix at all.

This doesn't look advisory to me:

$ sudo chmod 444 /dev/sdb
$ sha1sum /dev/sdb
e15720aa0d26856f0486867634b6737c30ea7346  /dev/sdb
$ echo -n $'%\x16%\x10%%%%%%%%%%%%%%\x40%%%%%' | tr % \\0 | \
     sg_raw  --readonly /dev/sdb -s24 42 00 00 00 00 00 00 00 18 00
$ sha1sum /dev/sdb
aab335ccc669bbbc85d727870b5941dc3581f025  /dev/sdb

It doesn't look readonly, either.

> The various committees do try hard to ensure there's no opcode
> overlap ... although they don't always succeed as you see with the UNMAP
> above, so I'm not at all sure we need the huge complexity of per scsi
> device type command filter lists, which is what the rest of the feature
> additions is about.

That was introduced because Tejun didn't want to enable more than the bare
minimum for MMC devices.  He was worried about hypothetical scenarios with
vendors recycling opcodes in a way that is not suitable for exposing to
unprivileged userland (he reinforced this, for example, here:
http://article.gmane.org/gmane.linux.kernel/1429863).

> The third problem is that in order to verify that all the code motion
> doesn't actually introduce a bug, you have to wade through about seven
> patches ... the patch split really isn't at all conducive to reviewing
> this critical piece.

Not true.  Each patch can be reviewed independently.  The big and hard-to-
review movement is all in patch 2.

The next patches can be tedious to review, but that does not meen hard.  Just
do "grep ^[-+].*sgio_bitmap_set patchNN | sort -k2 -k1" for example

> Finally, the patch for the feature I think you actually want, which is
> 13/14, could have been implemented fairly simply as a single patch and
> doesn't have to be part of this series.

It was, and it was ignored.  I sent it together because of the common
dependency on the first patch.

However, it is not the only feature I need; that patch should be just for things
like reservations or vendor-specific commands.  I also need that SG_IO works
well without any privileges, neither CAP_SYS_RAWIO (needed for a process to
bypass the whitelist) neither CAP_SYS_ADMIN (needed for a process to disable
the whitelist for others as in patch 13/14).  I need that at least for disks,
tapes and media changers.

Paolo
