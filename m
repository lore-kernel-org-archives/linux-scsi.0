From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 07:46:45 +0200
Message-ID: <51907E45.7010409@suse.de>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain> <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain> <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com> <518D55FA.4080302@suse.de> <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3EMFqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 01:46:48 -0400
In-Reply-To: <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: emilne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On 05/10/2013 09:27 PM, Baruch Even wrote:
> On Fri, May 10, 2013 at 11:18 PM, Hannes Reinecke <hare@suse.de> wrot=
e:
>> On 05/10/2013 07:51 PM, Baruch Even wrote:
>>>
>>> The error handling I have in mind (admittedly, not fully thought ou=
t)
>>> should work for both FC and SAS. Currently the error recovery
>>> progresses at the host level regardless of if the errors are on one
>>> device or all of them, it also stops the IOs on all devices and LUN=
s.
>>> It would be nice if that was taken into account. My ideas may be mo=
re
>>> suitable to the environment I work in (enterprise storage devices
>>> rather than hosts) but I believe the same approach would benefit th=
e
>>> hosts as well.
>>>
>>> It would be interesting to see what approach the new error handling=
 will
>>> take.
>>>
>> So, my general idea is this:
>>
>> 1) Send command aborts from scsi_times_out(). There is no requiremen=
t
>>    on stopping I/O on the host simply because a single command times
>>    out. And as scsi_times_out() is run from a separate thread anyway
>>    we should be able to send ABORT TASK TMFs without a problem
>> 2) Modify recovery sequence.
>>    One of the major pitfalls of the current scsi_eh is that it
>>    spills over onto unrelated LUNs for higher levels. So for the
>>    new EH we should be using a sequence of
>>    - ABORT TASK
>>    - ABORT TASK SET
>>    - (Terminate I_T nexus)
>>    - (Host reset)
>>    'Terminate I_T nexus' for FibreChannel is equivalent to a LOGO.
>>    'Host reset' is the current host reset function.
>> 3) Finegrained recovery setting.
>>    There is no need to stop the entire host when doing a recovery;
>>    it should be sufficient to stop I/O to the unit
>>    (LUN, I_T nexus, host) when the error recovery is at the
>>    respective level.
>=20
> This looks great and much in line with what I'm thinking.
>=20
> What about not going to the higher level if not everything at that
> level had failed?
> I mean that if at the target not all LUNs failed it will be quite
> troublesome to other LUNs if I-T-Nexus is terminated and that at the
> host level if there are still targets that are functioning it will
> kill them too to reset the host.
>=20

True. But and the end of the day, we _do_ want to recover the failed
LUN. If we were to disable that faulty LUN and continue running with
the others we won't have a chance of _ever_ recovering that one LUN.

Plus we have to keep in mind that the attempted error recovery did
not succeed for totally unrelated issues (ie sending a ABORT TASK
SET when the link is down). So we basically _have_ to escalate it
to the next level. Even though that will mean to stop I/O to other,
hitherto unaffected instances.

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
