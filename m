From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Tue, 11 Jun 2013 08:18:51 +0200
Message-ID: <51B6C14B.8010002@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de> <1370850058-27613-4-git-send-email-hare@suse.de> <20130610082001.GB7816@infradead.org> <51B595C1.8040106@suse.de> <20130610151916.GA18076@logfs.org> <20130610232446.GD18076@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab3FKGSy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jun 2013 02:18:54 -0400
In-Reply-To: <20130610232446.GD18076@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On 06/11/2013 01:24 AM, J=C3=B6rn Engel wrote:
> On Mon, 10 June 2013 11:19:16 -0400, J=C3=B6rn Engel wrote:
>>
>> I don't care too much whether we use per-command work items or a
>> single system-global thread.
>=20
> Actually, I do care.  We have to abort the commands in parallel, as a
> fairly large number of abort can queue up and individual aborts can
> take 20s on hardware I care about.
>=20
> 20s for an abort is pretty bad, but given today's reality there is no
> need to make things worse by serializing.
>=20
We're only serializing aborts per LUN, so this is a _big_
improvement as the original, where we would be serializing
per _host_.
Also, upon the first abort failure EH will be escalating to
LUN reset, so we won't have to wait for all aborts to time out.

More importantly, the current synchronous implementation of
command aborts does not allow for complete de-serialisation:
- There is no way to abort a running command abort, so we
  have to wait for it to complete, with the chance of running
  into a timeout.
- We will have to sent command aborts in parallel, and can
  only stop sending aborts once the first returns an error.
- After we've received an error we have to wait for the
  outstanding aborts to complete.
-> So the max wait-time will be 2 times the abort timeout.
  Not much of a gain here :-)

The _correct_ way of handling asynchronous aborts would
be to mandate that the LLDD has to send a command completion
on the original command once an abort has been issued.
Then we could just kick off the TMF and rearm the request
timer. Everything else would then be handled via normal
I/O paths.

However, this would mean to implement new callouts into
each and every driver. And the actual gain would be
dubious, as the several IHVs indicated that a command
abort might be handled lazily, ie the target will return
a good status, but abort the command only at a later time.
Other vendors treat a command abort as a best bet, and
rely on the LUN reset to clear up things.

So overall I doubt we'd be gaining much from a fully
asynchronous command abort. I'd rather concentrate
on getting the remaining bits like LUN reset working
correctly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
