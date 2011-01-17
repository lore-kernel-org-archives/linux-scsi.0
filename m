From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/3] scsi: Detailed I/O errors
Date: Mon, 17 Jan 2011 16:52:24 +0100
Message-ID: <4D3465B8.1040108@suse.de>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com> <1295020736-27699-2-git-send-email-snitzer@redhat.com> <20110114161048.GK5727@earth.li> <20110114171614.GA27852@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1AQPpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2011 10:45:45 -0500
In-Reply-To: <20110114171614.GA27852@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jonathan McDowell <noodles@earth.li>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, michaelc@cs.wisc.edu

On 01/14/2011 06:16 PM, Mike Snitzer wrote:
> On Fri, Jan 14 2011 at 11:10am -0500,
> Jonathan McDowell <noodles@earth.li> wrote:
>=20
>> On Fri, Jan 14, 2011 at 10:58:54AM -0500, Mike Snitzer wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> Instead of just passing 'EIO' for any I/O error we should be
>>> notifying the upper layers with more details about the cause
>>> of this error.
>>>
>>> Update the possible I/O errors to:
>>>
>>> - ENOLINK: Link failure between host and target
>>> - EIO: Retryable I/O error
>>> - EREMOTEIO: Non-retryable I/O error
>>>
>>> 'Retryable' in this context means that an I/O error _might_ be
>>> restricted to the I_T_L nexus (vulgo: path), so retrying on another
>>> nexus / path might succeed.
>> ...
>>> @@ -1486,6 +1495,7 @@ int scsi_decide_disposition(struct scsi_cmnd =
*scmd)
>>>  	case RESERVATION_CONFLICT:
>>>  		sdev_printk(KERN_INFO, scmd->device,
>>>  			    "reservation conflict\n");
>>> +		scmd->result |=3D (DID_TARGET_FAILURE << 16);
>>>  		return SUCCESS; /* causes immediate i/o error */
>>>  	default:
>>>  		return FAILED;
>> ...
>>> +#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do no=
t retry on
>>> +				 * other paths */
>>
>> I'd have viewed a reservation conflict as being tied to a particular
>> path, rather than the entire target. I've seen multipath setups wher=
e
>> there are reservation issues on some of the paths but others are fin=
e
>> and this is expected (eg use of reservations to fence off particular
>> paths).
>=20
> Very good point (as I think you're correct).  Technically a reservati=
on
> conflict is retryable across _different_ paths but (relative to the
> error path as it relates to multipath) it appears Hannes elected to g=
o
> with the conservative approach of always failing the IO upward given =
the
> potential for data corruption when queue_if_no_path is used.
>=20
> Hannes previously touched on this here:
> https://www.redhat.com/archives/dm-devel/2009-November/msg00190.html
>=20
> "This also solves a potential data corruption with multipathing
> and persistent reservations. When queue_if_no_path is active
> multipath will queue any I/O failure (including those failed
> with RESERVATION CONFLICT) until the reservation status changes.
> But by then I/O might have been ongoing on the other paths,
> thus the delayed submission will severely corrupt your data."
>=20
> Even in the context of that older SCSI sense-based mpath patchset a
> reservation conflict would always fail upward (regardless of path cou=
nt
> and/or queue_if_no_path).
>=20
> All said, the above doesn't excuse what seems to be a mis-categorizat=
ion
> of reservation conflict as a pure non-retryable TARGET_FAILURE
> (EREMOTEIO).
>=20
Ho-hum.

Yes, and no.

Yes, it is correct that persistent reservations are in fact per
ITL nexus, and hence might yield different responses if retried on
another path.

And no, it is not entirely correct to return the standard EIO error
here as then the no_path_retry mechanism might kick in and we're
back to square one.

That said we probably need to invent another error code with
meaning 'Retry on other ITL nexus if present, but ignore no_path_retry'=
=2E

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
