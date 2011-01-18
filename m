From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 1/3] scsi: Detailed I/O errors
Date: Tue, 18 Jan 2011 13:01:52 +0100
Message-ID: <4D358130.6040508@suse.de>
References: <cover.1295340405.git.hare@suse.de> <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de> <4D357AA3.5070509@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab1ARLzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 06:55:09 -0500
In-Reply-To: <4D357AA3.5070509@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>

On 01/18/2011 12:33 PM, Douglas Gilbert wrote:
> On 11-01-18 10:13 AM, Hannes Reinecke wrote:
>> Instead of just passing 'EIO' for any I/O error we should be
>> notifying the upper layers with more details about the cause
>> of this error.
>>
>> Update the possible I/O errors to:
>>
>> - ENOLINK: Link failure between host and target
>> - EIO: Retryable I/O error
>> - EREMOTEIO: Non-retryable I/O error
>> - EBADE: I/O error restricted to the I_T_L nexus
>>
>> 'Retryable' in this context means that an I/O error _might_ be
>> restricted to the I_T_L nexus (vulgo: path), so retrying on another
>> nexus / path might succeed.
>>
>> 'Non-retryable' in general refers to a target failure, so this
>> error will always be generated regardless of the I_T_L nexus
>> it was send on.
>>
>> I/O errors restricted to the I_T_L nexus might be retried
>> on another nexus / path, but they should _not_ be queued
>> if no paths are available.
>=20
> Hannes,
> I don't know if it is applicable to this patch but with
> SAS when the uplink from an expander is being stressed
> (i.e. it temporarily doesn't have enough bandwidth) then
> a sense key of ABORTED COMMAND may be generated. In my
> experience retrying such a command succeeds.
>=20
I guess this should be handled by scsi EH, as there
should be some sensible ASC/ASCQ values to go with
it.

This patchset is primarily for fixing up multipathing,
which has the habit of retrying failed I/Os on the
next path. For some errors this is just pointless
(eg MEDIUM ERROR), for some errors this is the desired
behaviour (namely transport errors), and for others
this is positively damaging (persistent reservation
failures).
Just plain EIO simply don't cover the whole range :-)

>=20
> BTW might "vulgo" be "ergo" [Latin: therefore]?
>=20
Nope. Correct etymology is from 'sermo vulgaris',
ie the language of the common people.
But maybe I should remove it for the next
round to avoid confusion.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
