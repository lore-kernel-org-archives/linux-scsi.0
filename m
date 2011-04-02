From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Fri, 1 Apr 2011 20:26:13 -0700
Message-ID: <BANLkTinzi=5ACgyU17-xFV+PwvAz+u1bQQ@mail.gmail.com>
References: <1301373398.2590.20.camel@mulgrave.site>
	<4D91BF90.8070909@redhat.com>
	<1301445210.2731.14.camel@mingming-laptop>
	<20110330021742.GL3008@dastard>
	<E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
	<4D9313E2.6080006@gmail.com>
	<20110401151907.GG21075@thunk.org>
	<AANLkTinZCx3gq-iDjPLzkvSFQNqAc1-bGN8xgzRz_=yj@mail.gmail.com>
	<20110401214652.GC25355@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49555 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1DBD0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 23:26:14 -0400
In-Reply-To: <20110401214652.GC25355@noexit>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <jlbec@evilplan.org>
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Yongqiang Yang <xiaoqiangnk@gmail.com>

On Fri, Apr 1, 2011 at 2:46 PM, Joel Becker <jlbec@evilplan.org> wrote:
> On Fri, Apr 01, 2011 at 09:30:04AM -0700, Amir Goldstein wrote:
>> when writing DIO to indirect mapped file holes, we fall back to buff=
ered write
>> (so we won't expose stale data in the case of a crash) concurrent DI=
O reads
>> to that file (before data writeback) can expose stale data. right?
>> do you consider this case mixing buffered and DIO access?
>> do you consider that as a problem?
>
> =A0 =A0 =A0 =A0I do not consider this 'mixing', nor do I consider it =
a problem.
> ocfs2 does exactly this for holes, unwritten extents, and CoW. =A0It =
does
> not violate the user's expectation that the data will be on disk when
> the write(2) returns.
> =A0 =A0 =A0 =A0Falling back to buffered on read(2) is a different sto=
ry; the
> caller wants the current state of the disk block, not five minutes ag=
o.
> So we can't do that. =A0But we also don't need to.

the issue is with DIO read exposing uninitialized data on disk
is a security issue.
it's not about giving the read what is expects to see.

> =A0 =A0 =A0 =A0O_DIRECT users that are worried about any possible spa=
ce usage in
> the page cache have already pre-allocated their disk blocks and don't
> get here.
>
> Joel
>
> --
>
> "Under capitalism, man exploits man. =A0Under Communism, it's just
> =A0 the opposite."
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - Joh=
n Kenneth Galbraith
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0http://www.jlbec.org/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jlbec@evilplan.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
