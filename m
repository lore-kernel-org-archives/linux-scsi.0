From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Tue, 21 Apr 2009 09:04:08 +0200
Message-ID: <49ED6FE8.5090009@suse.de>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de> <49E89866.50205@cs.wisc.edu> <49EC2B65.1050508@suse.de> <49ECC8BB.9020906@cs.wisc.edu> <49ECCCD7.3070200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZDUHEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 03:04:10 -0400
In-Reply-To: <49ECCCD7.3070200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> Mike Christie wrote:
>> Hannes Reinecke wrote:
>>>> Today, instead of #2, the Red Hat multipath tools guy and I were
>>>> talking
>>>> about doing a probe with SG_IO. For example we would send down a p=
ath
>>>> tester IO and then wait for it to be failed with
>>>> DID_TRANSPORT_FAILFAST.
>>>>
>>> No. this is exactly what you cannot do. SG_IO will be stalled when =
the
>>> sdev is BLOCKED and will only return a result _after_ the sdev
>>> transitions
>>> _out_ of the BLOCKED state.
>>> Translated to FC this means that whenever dev_loss_tmo is _active_ =
(!)
>>> no I/O will be send out neither any I/O result will be returned to
>>> userland.
>>>
>>
>> That is not true anymore. When fast io fail fires, the sdev and rpor=
t
>> will be blocked, but the the fc class will call into the LLD to have=
 it=20
>=20
> I miswrote that. The rport will be show blocked state, but when fast =
io
> fail tmo fires, fc_terminate_rport_io will unblock the sdev, and the =
fc
> class chkready will fail any IO sent to it and of course
> terminate_rport_io will fail IO in the driver like I said below. And
> then you do not need a terminate_rport_io callback to have the fast i=
o
> fail tmo now. If you set that timer at least IO in the block queue an=
d
> new IO will be failed.
>=20
Indeed, I didn't look closely enough. Ok, so I/O will be failed after
terminate_rport_io.=20

So that means we can just implement a new netlink message after
terminate_rport_io to inform the multipath daemon about this changes.

And, of course, we _really_ should introduce a new sdev state here.
Having the sdev set to 'RUNNING' but having all I/O failed in the
transport class is just a quirky behaviour which is bound to cause
trouble.

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
