From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 11:00:49 +0200
Message-ID: <51B595C1.8040106@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de> <1370850058-27613-4-git-send-email-hare@suse.de> <20130610082001.GB7816@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab3FJJAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 05:00:54 -0400
In-Reply-To: <20130610082001.GB7816@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On 06/10/2013 10:20 AM, Christoph Hellwig wrote:
> On Mon, Jun 10, 2013 at 09:40:52AM +0200, Hannes Reinecke wrote:
>> When a command runs into a timeout we need to send an 'ABORT TASK'
>> TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
>>
>> Conceptually, however, this function is a normal SCSI command, so
>> there is no need to enter the error handler.
>>
>> This patch implements a new scsi_abort_command() function which
>> invokes an asynchronous function scsi_eh_abort_handler() to
>> abort the commands via 'eh_abort_handler'.
>>
>> If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
>> command will be retried if possible. If no retries are allowed
>> the command will be returned immediately, as we have to assume
>> the TMF succeeded and the command is completed with the LLDD.
>> If the TMF fails the command will be pushed back onto the
>> list of failed commands and the SCSI EH handler will be
>> called immediately for all timed-out commands.
>=20
> Why can't we use a work item per command?  Linking things into a list
> just to queue it up to workqueues missed half of the point of the
> workqueue infrastructure.
>=20
Hmm. I felt that using a per command workqueue might be a bit excessive=
=2E
Also the current semantics call for a synchronous command abort.
So even using a per command workqueue won't buy us anything as the
workqueue item would have to wait for the command abort to complete,
which again is quite a waste.
And concurrency would be hell; you'd have to flush the workqueue
items for all outstanding if a device reset should attempted.
And hope that no completion arrives at the time you're attempting to
flush them. etc.

I've been planning for asynchronous command aborts eventually, where
using a per-command workqueue item comes in useful. Gut for now
using existing callbacks makes life so much easier. And per-command
workqueues will just complicate matters.

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
