From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2][RESEND] scsi_transport_fc: LUN masking
Date: Wed, 2 Mar 2016 14:35:11 +0800
Message-ID: <56D6899F.9020905@suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
 <DDB9C85B850785449757F9914A034FCB44535951@G4W3219.americas.hpqcorp.net>
 <56CC3298.2080001@suse.de> <1456862087.16707.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcCBGfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 01:35:24 -0500
In-Reply-To: <1456862087.16707.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/02/2016 03:54 AM, Ewan Milne wrote:
> On Tue, 2016-02-23 at 18:21 +0800, Hannes Reinecke wrote:
>> On 02/22/2016 07:39 PM, Seymour, Shane M wrote:
>>> Hi Hannes,
>>>
>>> How do you know that a request for an async scan is complete (I'm a=
ssuming
>>> that you get add or change udev events)? Assuming that someone has
manually
>>> started a scan on something (e.g. some newly presented devices afte=
r
boot)
>>> and all scans are going to be async how do you know when it is comp=
lete
>>> rather than waiting in a work queue? An example may be a sysfs
>>> file that contains unscanned, pending, scanning, scanned so you kno=
w
>>> when it's complete at the appropriate level in sysfs (the hba and t=
he rports)
>>> so you know when can continue if you're polling the status (e.g.
checking
>>> as part of system admin work with newly
>>> presented rports so you can then do something with them).
>>>
>> Thing is, I don't.
>>
>> We have had a similar discussion with the IBM zfcp folks, that it wo=
uld
>> be desirable to have a marker in sysfs telling us that the rport is
>> stable (ie no scanning in progress).
>> However, this cannot be at the rport level (as the rport itself migh=
t be
>> going away), but rather at some higher level (eg fc_host).
>=20
> I am not sure this really helps.  If another process initiates a scan
> then sysfs might report that the scanning was still in progress.  If
> scans are initiated often enough, you might never observe a stable st=
ate.
>=20
True.

Which is one of the reasons why this particular item hasn't made any
progress yet.

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
