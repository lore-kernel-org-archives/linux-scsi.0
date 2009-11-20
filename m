From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] multipath: Evaluate request result and sense
 code
Date: Fri, 20 Nov 2009 08:48:49 +0100
Message-ID: <4B0649E1.10106@suse.de>
References: <20091119122503.413AD3A174@ochil.suse.de> <4B05A36C.2030409@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbZKTHsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 02:48:43 -0500
In-Reply-To: <4B05A36C.2030409@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Hannes Reinecke wrote:
>> As we now see the result for every command we
>> can use it to make some more elaborate choices
>> if we should retry the request on another path.
>>
>> This solves a potential data corruption when
>> a request is being terminated with RESERVATION
>> CONFLICT and queue_if_no_path is active; the
>> request will be queued until the reservation
>> status changes and then transmitted.
>=20
>=20
> I had the same bz. To handle it I just converted the error to some ot=
her
> -EXYZ value. But like I said in my patch that I sent to the list I di=
d
> not like it much.
>=20
Yeah, that was my thought, too.
The scsi result codes simply don't fit on the -EXXX values.

> I thought of going the route you did in this patch, but thought it wa=
s
> too scsi specific. Does dasd want advanced error handling? If not, th=
en
> I am fine since for hw handlers we assume they are always scsi_dh mod=
ules.
Well, DASD has it's own sort of problems; basically DASD will _always_
try to do it's own internal recovery by waiting for the storage array
to respond. So with DASD we basically only ever have three states:
- GOOD
- Failure as being evaluated by the _storage array_
- Don't know (if failfast is set)
And any advanced checking won't give us much here, as either the link
is on-line and we have details about the error or the link is severed
and we don't know anything.

But there's a good point, we should be doing some sort of
cross-check to determine if it really is a SCSI error.
Just to prevent any accidental spill-overs in the future.

I'll be sending a patch.

Cheers,

Hannes
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
