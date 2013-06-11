From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Tue, 11 Jun 2013 12:35:40 -0400
Message-ID: <20130611163539.GA25941@logfs.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-4-git-send-email-hare@suse.de>
 <20130610082001.GB7816@infradead.org>
 <51B595C1.8040106@suse.de>
 <20130610151916.GA18076@logfs.org>
 <20130610232446.GD18076@logfs.org>
 <51B6C14B.8010002@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59529 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKSFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jun 2013 14:05:19 -0400
Content-Disposition: inline
In-Reply-To: <51B6C14B.8010002@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On Tue, 11 June 2013 08:18:51 +0200, Hannes Reinecke wrote:
> On 06/11/2013 01:24 AM, J=C3=B6rn Engel wrote:
> > On Mon, 10 June 2013 11:19:16 -0400, J=C3=B6rn Engel wrote:
> >>
> >> I don't care too much whether we use per-command work items or a
> >> single system-global thread.
> >=20
> > Actually, I do care.  We have to abort the commands in parallel, as=
 a
> > fairly large number of abort can queue up and individual aborts can
> > take 20s on hardware I care about.
> >=20
> > 20s for an abort is pretty bad, but given today's reality there is =
no
> > need to make things worse by serializing.
> >=20
> We're only serializing aborts per LUN, so this is a _big_
> improvement as the original, where we would be serializing
> per _host_.

I agree it is a big improvement.  But I also have some evidence
indicating it may not be enough.  So let me change my private patch to
do parallel aborts and see how it fares.

> Also, upon the first abort failure EH will be escalating to
> LUN reset, so we won't have to wait for all aborts to time out.

The case I saw was a successful abort taking 20s.

> More importantly, the current synchronous implementation of
> command aborts does not allow for complete de-serialisation:
> - There is no way to abort a running command abort, so we
>   have to wait for it to complete, with the chance of running
>   into a timeout.
> - We will have to sent command aborts in parallel, and can
>   only stop sending aborts once the first returns an error.
> - After we've received an error we have to wait for the
>   outstanding aborts to complete.
> -> So the max wait-time will be 2 times the abort timeout.
>   Not much of a gain here :-)

I have seen 10 commands get queued for aborts.  Assuming the 20s above
are the worst case, it will make the difference between 200s and 40s.

Granted, 40s is still horrible.  The command in question has just
timed out and the kernel should inform userspace about this asap.  If
a command with a 10s timeout takes 50s to complete, userspace will
have to add another layer of timeouts.  That should never be
necessary.

> The _correct_ way of handling asynchronous aborts would
> be to mandate that the LLDD has to send a command completion
> on the original command once an abort has been issued.
> Then we could just kick off the TMF and rearm the request
> timer. Everything else would then be handled via normal
> I/O paths.
>=20
> However, this would mean to implement new callouts into
> each and every driver. And the actual gain would be
> dubious, as the several IHVs indicated that a command
> abort might be handled lazily, ie the target will return
> a good status, but abort the command only at a later time.
> Other vendors treat a command abort as a best bet, and
> rely on the LUN reset to clear up things.
>=20
> So overall I doubt we'd be gaining much from a fully
> asynchronous command abort. I'd rather concentrate
> on getting the remaining bits like LUN reset working
> correctly.

=46air approach.  Again, let me play with it and don't let this stop yo=
u
from making other improvements.

J=C3=B6rn

--
There's nothing that will change someone's moral outlook quicker
than cash in large sums.
-- Larry Flynt
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
