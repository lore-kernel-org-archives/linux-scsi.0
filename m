From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Tue, 24 Nov 2015 16:29:55 +0100
Message-ID: <56548273.1080000@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de> <20151120104710.GA24871@lst.de> <564EFB65.6050603@suse.de> <564FA58A.8040006@sandisk.com> <56533A86.2090109@suse.de> <56533C45.4040505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbbKXP34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 10:29:56 -0500
In-Reply-To: <56533C45.4040505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

On 11/23/2015 05:18 PM, Bart Van Assche wrote:
>=20
>=20
> On 11/23/2015 08:10 AM, Hannes Reinecke wrote:
>> On 11/20/2015 11:58 PM, Bart Van Assche wrote:
[ .. ]
>>> BTW, not all storage arrays need STPG retries. Some arrays are able
>>> to process an STPG command quickly (this means within a few
>>> seconds).
>>>
>>> A previous discussion about this topic is available e.g. at
>>> http://thread.gmane.org/gmane.linux.scsi/105340/focus=3D105601.
>>>
>> Well, one could argue that the whole point of this patchset is to
>> allow you to serialize STPGs :-)
>>
>> We definitely need to serialize STPGs for the same target port
>> group; the current implementation is far too limited to take that
>> into account.
>>
>> But the main problem I'm facing with the current implementation is
>> that we cannot handle retries. An RTPG or an STPG might fail, at
>> which point we need to re-run RTPG to figure out the current status.
>> (We also need to send RTPGs when we receive an "ALUA state changed"
>>   UA, but that's slightly beside the point).
>> The retry cannot be send directly, as we're evaluating the status
>> from end_io context. So to instantiate a retry we need to move it
>> over to a workqueue.
>>
>> Or, at least, that's the solution I'm able to come up with.
>> If you have other ideas it'd be most welcome.
>=20
> Hello Hannes,
>=20
> I agree that retries have to be handled from workqueue context
> instead of end_io context. But in workqueue context we can choose
> whether to submit the retry synchronously or asynchronously. Unless
> I overlooked something I don't see why the retry should be submitted
> synchronously.
>=20
Good point. Sure we can do this; the primary difference would be
whether the workqueue is ordered or not.
An unordered workqueue would be resulting in not serializing
retries, hence achieving pretty much what you asked.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
