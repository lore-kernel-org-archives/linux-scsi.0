From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Wed, 12 Jun 2013 07:54:34 +0200
Message-ID: <51B80D1A.4080402@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>  <1370850058-27613-4-git-send-email-hare@suse.de>  <20130610082001.GB7816@infradead.org> <1370977067.2286.81.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab3FLFyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 01:54:40 -0400
In-Reply-To: <1370977067.2286.81.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On 06/11/2013 08:57 PM, James Bottomley wrote:
> On Mon, 2013-06-10 at 01:20 -0700, Christoph Hellwig wrote:
>> On Mon, Jun 10, 2013 at 09:40:52AM +0200, Hannes Reinecke wrote:
>>> When a command runs into a timeout we need to send an 'ABORT TASK'
>>> TMF. This is typically done by the 'eh_abort_handler' LLDD callback=
=2E
>>>
>>> Conceptually, however, this function is a normal SCSI command, so
>>> there is no need to enter the error handler.
>>>
>>> This patch implements a new scsi_abort_command() function which
>>> invokes an asynchronous function scsi_eh_abort_handler() to
>>> abort the commands via 'eh_abort_handler'.
>>>
>>> If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
>>> command will be retried if possible. If no retries are allowed
>>> the command will be returned immediately, as we have to assume
>>> the TMF succeeded and the command is completed with the LLDD.
>>> If the TMF fails the command will be pushed back onto the
>>> list of failed commands and the SCSI EH handler will be
>>> called immediately for all timed-out commands.
>>
>> Why can't we use a work item per command?  Linking things into a lis=
t
>> just to queue it up to workqueues missed half of the point of the
>> workqueue infrastructure.
>=20
> Actually, I think we can dump the workqueue altogether.  The only rea=
son
> we need it is because the current abort handlers wait for the command
> and return the completion state.  However, all LLDs are capable of
> emitting TMFs at interrupt level, so if we separated the emit from th=
e
> wait, we could simply do this sequence:
>=20
> on timeout, fire the abort from interrupt and mark the command as hav=
ing
> an abort issued (possibly by adding a pointer to the abort task), ret=
urn
> BLK_EH_RESET_TIMER.
>=20
> Now if the timeout fires again, assume the abort was unsucessful and
> escalate to LUN reset.
>=20
> This is fully asynchronous, fully tracked and doesn't rely on work
> queues.
>=20
Hehe. Been there, done that, doesn't work :-(
That was my original idea, too.

But some LLDDs send TMFs in a non-interrupt-safe way, so the only
way to make it work was to use a workqueue.
(Eg qla2xxx has a parameter to send TMFs async, but this doesn't
work on older firmware).

> The necessary additions for something like this are the from interrup=
t
> issue abort and LUN reset, which could just be additional callbacks i=
n
> the host template.
>=20
However, we could make that optional, so that LLDDs not capable of
sending TMFs in an interrupt-safe manner will continue to use the
original framework.

Ok, let's see whether this flies.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
