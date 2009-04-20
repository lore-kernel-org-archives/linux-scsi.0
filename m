From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 10:19:28 +0200
Message-ID: <49EC3010.5050502@suse.de>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de> <49E89866.50205@cs.wisc.edu> <49E89E92.7070709@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51012 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZDTITa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 04:19:30 -0400
In-Reply-To: <49E89E92.7070709@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> Oops, I mashed two topics together. See below.
>=20
> Mike Christie wrote:
>> Hannes Reinecke wrote:
>>>
>>> FC Transport already maintains an attribute for the path state, and=
 even
>>> sends netlink events if and when this attribute changes. For iSCSI =
I
>>> have
>>
>> Are you referring to fc_host_post_event? Is the same thing we talked
>> about last year, where you wanted events? Is this in multipath tools
>> now or just in the SLES ones?
>>
>> For something like FCH_EVT_LINKDOWN, are you going to fail the path =
at
>> that time or when would the multipath path be marked failed?
>>
>=20
> I was asking this because it seems we have people always making
> bugzillas saying they did not want the path to be marked failed for
> short problems.
>=20
> There was the problem where we might get DID_ERROR for temporary drop=
ped
> frame. That would be fixed by just listening to transport events like
> you explained.
>=20
> But then I thought there was the case where if we get a linkdown then
> linkup within a couple seconds, we would not want to transition the
> multipath path state.
>=20
> So below while you were talking about when to remove the device, I wa=
s
> talking about when to mark the path failed.
>=20
>=20
I have the same bugzillas, too :-)

My proposal is to handle this in several stages:

- path fails
-> Send out netlink event
-> start dev_loss_tmo and fast_fail_io timer
-> fast_fail_io timer triggers: Abort all oustanding I/O with
   DID_TRANSPORT_DISRUPTED, return DID_TRANSPORT_FAILFAST for
   any future I/O, and send out netlink event.
-> dev_loss_tmo timer triggers: Remove sdev and cleanup rport.
   netlink event is sent implicitely by removing the sdev.

Multipath would then interact with this sequence by:

- Upon receiving 'path failed' event: mark path as 'ghost' or 'blocked'=
,
  ie no I/O is currently possible and will be queued (no path switch ye=
t).
- Upon receiving 'fast_fail_io' event: switch paths and resubmit queued=
 I/Os
- Upon receiving 'path removed' event: remove path from internal struct=
ures,
  update multipath maps etc.

The time between 'path failed' and 'fast_fail_io triggers' would then b=
e
able to capture any jitter / intermittent failures. Between=20
'fast_fail_io triggers' and 'path removed' the path would be held in so=
me
sort of 'limbo' in case it comes back again, eg for maintenance/SP upda=
te
etc. And we can even increase this one to rather long timespans (eg hou=
rs)
to give the admin enough time for a manual intervention.

I still like this proposal as it makes multipath interaction far cleane=
r.
And we can do away with path checkers completely here.

>=20
>>
>> You got my hopes up for a solution in the the long explanation, then
>> you destroyed them :)
>>
>>
>> Was the reason people did not like this because of the scsi device
>> lifetime issue?
>>
>>
>> I think we still want someone to set the fast io fail tmo for users
>> when multipath is being used, because we want IO out of the queues a=
nd
>> drivers and sent to the multipath layer before dev_loss_tmo if
>> dev_loss_tmo is still going to be a lot longer. fast io fail tmo is
>> usually less than 10 or 5 and for dev_loss_tmo seems like we still
>> have user setting that to minutes.
>>
>>
>> Can't the transport layers just send two events?
>> 1. On the initial link down when the port/session is blocked.
>> 2. When there fast io fail tmos fire.
>=20
>=20
> So for #2, I just want a way to figure out when the transport is givi=
ng
> up on executing IO and is going to fail everything. At that time, I w=
as
> thinking we want to mark the path failed.
>=20
See above. Exactly my proposal.

> I guess if multipiath tools is going to set fast io fail, it could al=
so
> use that as its down timer to decide when to fail the path and not ha=
ve
> to send SG IO or a bsg transport command.
>=20
But that's a bit of out-guessing the midlayer, no?
We're instructing the midlayer to fail all I/O at one point; so it make=
s
far more sense to me to have the midlayer telling us when this is going
to happen instead of trying to figure this one out ourselves.

=46or starters we just should send a netlink event when fast_fail_io ha=
s
fired. We could easily integrate that one in multipathd and would gain
an instant benefit from that as we can switch paths in advance.
Next step would be to implement an additional sdev state which would
return 'DID_TRANSPORT_FASTFAIL' for any 'normal' I/O; it would be
inserted between 'RUNNING' and 'CANCEL'.
Transition would be possible between 'RUNNING' and 'FASTFAIL', but
it would only be possible to transition into 'CANCEL' from 'FASTFAIL'.

Oh, and of course we have to persuade Eric Moore et al to implement
fast_fail_io into mptfc ...

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
