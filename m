From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi: make scsi_eh_scmd_add() always succeed
Date: Wed, 05 Nov 2014 08:44:53 +0100
Message-ID: <5459D575.4000203@suse.de>
References: <1415103073-90276-1-git-send-email-hare@suse.de> <1415103073-90276-2-git-send-email-hare@suse.de> <20141104183648.GA29621@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbaKEHo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 02:44:56 -0500
In-Reply-To: <20141104183648.GA29621@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On 11/04/2014 07:36 PM, Christoph Hellwig wrote:
> On Tue, Nov 04, 2014 at 01:11:11PM +0100, Hannes Reinecke wrote:
>> BLK_EH_HANDLED does not work with scsi commands, as we need
>> to release the associated buffers correctly.
>=20
> Which particular error do you see?  The ->eh_timed_out routines can
> return BLK_EH_HANDLED, and libata, iscsi and fc actually do, so we'll
> need to fix these issues either way.
>=20
Hmm. Looking closer it seem that you are correct.
However, the main point still stands; there is no way
scsi_eh_scmd_add() can legitimately fail.

>> And scsi_eh_scmd_add() currently only will fail if no
>> error handler thread is started (which will never be the
>> case)=20
>=20
> Yes.
>=20
>> or if the state machine encounters an illegal transition.
>> As state machine transitions don't have any real meaning
>> we can also force setting of the new state and
>> make scsi_dh_scmd_add() a void function.
>> With that we'll never have to resort to return
>> BLK_EH_HANDLED.
>=20
> Which kind of transition did you see rejected?  Neither a CREATED or
> DEL_(RECOVERY) state should be possible when invoking the error handl=
er,
> so I'd rather see asserts here than overriding the state machine.
> te RECOVERY state from a RUNNING or existing RECOVERY state, which
> leaves CREATED, CANCEL, DEL, CANCEL_RECOVERY or DEL_RECOVERY.
>=20
I did not see any rejection so far.
However, we're calling scsi_host_set_state(), which _might_ fail.
And we need to have a way of either
a) make sure that it cannot fail prior to calling it
or
b) handling the failure.
So I'm fine with using asserts here.

I'll be updating the patch (and description)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
