From: Hannes Reinecke <hare@suse.de>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Fri, 30 Oct 2015 16:00:55 +0100
Message-ID: <56338627.8080601@suse.de>
References: <D256A425.229C0%chad.dupuis@qlogic.com> <56331FFB.9010703@suse.de>
 <alpine.OSX.2.00.1510300919390.2511@administrators-macbook-pro.local>
 <563372CB.9050206@suse.de>
 <alpine.OSX.2.00.1510301010550.4888@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbbJ3PA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 11:00:58 -0400
In-Reply-To: <alpine.OSX.2.00.1510301010550.4888@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>, Lee Duncan <lduncan@suse.com>, Mike Christie <michaelc@cs.wisc.edu>

On 10/30/2015 03:12 PM, Chad Dupuis wrote:
>=20
>=20
> On Fri, 30 Oct 2015, Hannes Reinecke wrote:
>=20
>> On 10/30/2015 02:25 PM, Chad Dupuis wrote:
>>>
>>>
>>> On Fri, 30 Oct 2015, Hannes Reinecke wrote:
>>>
>>>> On 10/28/2015 09:11 PM, Chad Dupuis wrote:
>>>>> Hi Folks,
>>>>>
>>>>> We=B9ve begun to explore blk-mq and scsi-mq and wanted to know if=
 there
>>>>> were
>>>>> any best practices in terms of block layer settings.  We=B9re loo=
king
>>>>> specifically at the FCoE and iSCSI protocols.
>>>>>
>>>>> A little background on the queues in our hardware first: we have =
a per
>>>>> connection transmit queue and multiple, global receive queues.  T=
he
>>>>> transmit queues are not pegged to a particular CPU.  The receive
>>>>> queues
>>>>> are pegged to the first N CPUs where N is the number of receive
>>>>> queues.
>>>>> We set the nr_hw_queues in the scsi_host_template to N as well.
>>>>>
>>>> Weelll ... I think you'll run into issues here.
>>>> The whole point of the multiqueue implementation is that you can t=
ag
>>>> the
>>>> submission _and_ completion queue to a single CPU, thereby elimina=
ting
>>>> locking.
>>>> If you only peg the completion queue to a CPU you'll still have
>>>> contention on the submission queue, needing to take locks etc.
>>>>
>>>> Plus you will _inevitably_ incur cache misses, as the completion w=
ill
>>>> basically never occur on the same CPU which did the submissoin.
>>>> Hence the context needs to be bounced to the CPU holding the compl=
etion
>>>> queue, or you'll need to do a IPI to inform the submitting CPU.
>>>> But if you do that you're essentially doing single-queue submissio=
n,
>>>> so I doubt we're seeing that great improvements.
>>>
>>> This was why I was asking if there was a blk-mq API to be able to s=
et
>>> CPU affinity for the hardware context queues so I could steer the
>>> submissions to the CPUs that my receive queues are on (even if they=
 are
>>> allowed to float).
>>>
>> But what would that achieve?
>> Each of the hardware context queues would still having to use the
>> same submission queue, so you'd have to have some serialisation
>> with spinlocks et.al. during submission. Which is what blk-mq
>> tries to avoid.
>> Am I wrong?
>=20
> Sadly, no I believe you're correct. So essentially the upshot seems t=
o
> be if you can have a 1x1 request:response queue then sticking with th=
e
> older queuecommand method is better?
>=20
Hmm; you might be getting some performance improvements as the
submission path from the blocklayer down is more efficient, but in
your case the positive effects might be eliminated by reducing the
number of receive queues.
But then you never know until you try :-)

The alternative would indeed be to move to MC/S with block-mq; that
should give you some benefits as you'd be able to utilize several queue=
s.
I have actually discussed that with Emulex; moving to MC/S in the iSCSI
stack might indeed be viable when using blk-mq. It would be a rather
good match with the existing blk-mq implementation, and most of the
implementation would be in the iSCSI stack, reducing the burden on the
driver vendors :-)

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
