From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v2] scsi: Fix dm-multipath starvation when
 scsi host is busy
Date: Tue, 22 May 2012 15:01:43 +0200
Message-ID: <4FBB8E37.60300@suse.de>
References: <4FBB555B.5060608@ce.jp.nec.com> <1337677994.28492.12.camel@dabdike.int.hansenpartnership.com> <4FBB62FD.5040008@ce.jp.nec.com> <20120522125445.GA26233@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab2EVNBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 09:01:45 -0400
In-Reply-To: <20120522125445.GA26233@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, Alasdair G Kergon <agk@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/22/2012 02:54 PM, Mike Snitzer wrote:
> On Tue, May 22 2012 at  5:57am -0400,
> Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
>=20
>> On 05/22/12 18:13, James Bottomley wrote:
>>> Isn't a more understandable explanation:
>>
>> Thank you. That's quite elegant.
>> I replaced the description with it.
>>
>>> And please put a comment in the code as well otherwise someone will
>>> eventually send a "fix" for this because we're not paying attention=
 to
>>> host busy (and I'll have forgotten about the issue by then and migh=
t
>>> apply it).
>>
>> Added the comment in code.
>>
>>> A final note is that this is more a band aid than a fix because thi=
s is
>>> still a congestion situation dm-mp should be aware of.
>>
>> Yes. To do that, we have to generalize the concept of "host"
>> and share it with block layer.
>>
>> Attached below is the revised patch.
>>
>> ----------------------------------------------------------
>> [PATCH v2] scsi: Fix dm-multipath starvation when scsi host is busy
>>
>> block congestion control doesn't have any concept of fairness across
>> multiple queues.  This means that if SCSI reports the host as busy i=
n
>> the queue congestion control it can result in an unfair starvation
>> situation in dm-mp if there are multiple multipath devices on the sa=
me
>> host.  For example:
>> http://www.redhat.com/archives/dm-devel/2012-May/msg00123.html
>>
>> The fix for this is to report only the sdev busy state (and ignore t=
he
>> host busy state) in the block congestion control call back.
>> The host is still congested, but the SCSI subsystem will sort out th=
e
>> congestion in a fair way because it knows the relation between the
>> queues and the host.
>>
>> Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> Tested-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>=20
> Acked-by: Mike Snitzer <snitzer@redhat.com>
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

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
