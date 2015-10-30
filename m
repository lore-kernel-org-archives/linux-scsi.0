From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Fri, 30 Oct 2015 15:15:07 -0500
Message-ID: <5633CFCB.9050608@cs.wisc.edu>
References: <D256A425.229C0%chad.dupuis@qlogic.com> <56331FFB.9010703@suse.de> <alpine.OSX.2.00.1510300919390.2511@administrators-macbook-pro.local> <563372CB.9050206@suse.de> <alpine.OSX.2.00.1510301010550.4888@administrators-macbook-pro.local> <56338627.8080601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42975 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759546AbbJ3UPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 16:15:35 -0400
In-Reply-To: <56338627.8080601@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>, Lee Duncan <lduncan@suse.com>

On 10/30/2015 10:00 AM, Hannes Reinecke wrote:
> On 10/30/2015 03:12 PM, Chad Dupuis wrote:
>>
>>
>> On Fri, 30 Oct 2015, Hannes Reinecke wrote:
>>
>>> On 10/30/2015 02:25 PM, Chad Dupuis wrote:
>>>>
>>>>
>>>> On Fri, 30 Oct 2015, Hannes Reinecke wrote:
>>>>
>>>>> On 10/28/2015 09:11 PM, Chad Dupuis wrote:
>>>>>> Hi Folks,
>>>>>>
>>>>>> We=B9ve begun to explore blk-mq and scsi-mq and wanted to know i=
f there
>>>>>> were
>>>>>> any best practices in terms of block layer settings.  We=B9re lo=
oking
>>>>>> specifically at the FCoE and iSCSI protocols.
>>>>>>
>>>>>> A little background on the queues in our hardware first: we have=
 a per
>>>>>> connection transmit queue and multiple, global receive queues.  =
The
>>>>>> transmit queues are not pegged to a particular CPU.  The receive
>>>>>> queues
>>>>>> are pegged to the first N CPUs where N is the number of receive
>>>>>> queues.
>>>>>> We set the nr_hw_queues in the scsi_host_template to N as well.
>>>>>>
>>>>> Weelll ... I think you'll run into issues here.
>>>>> The whole point of the multiqueue implementation is that you can =
tag
>>>>> the
>>>>> submission _and_ completion queue to a single CPU, thereby elimin=
ating
>>>>> locking.
>>>>> If you only peg the completion queue to a CPU you'll still have
>>>>> contention on the submission queue, needing to take locks etc.
>>>>>
>>>>> Plus you will _inevitably_ incur cache misses, as the completion =
will
>>>>> basically never occur on the same CPU which did the submissoin.
>>>>> Hence the context needs to be bounced to the CPU holding the comp=
letion
>>>>> queue, or you'll need to do a IPI to inform the submitting CPU.
>>>>> But if you do that you're essentially doing single-queue submissi=
on,
>>>>> so I doubt we're seeing that great improvements.
>>>>
>>>> This was why I was asking if there was a blk-mq API to be able to =
set
>>>> CPU affinity for the hardware context queues so I could steer the
>>>> submissions to the CPUs that my receive queues are on (even if the=
y are
>>>> allowed to float).
>>>>
>>> But what would that achieve?
>>> Each of the hardware context queues would still having to use the
>>> same submission queue, so you'd have to have some serialisation
>>> with spinlocks et.al. during submission. Which is what blk-mq
>>> tries to avoid.
>>> Am I wrong?
>>
>> Sadly, no I believe you're correct. So essentially the upshot seems =
to
>> be if you can have a 1x1 request:response queue then sticking with t=
he
>> older queuecommand method is better?
>>
> Hmm; you might be getting some performance improvements as the
> submission path from the blocklayer down is more efficient, but in
> your case the positive effects might be eliminated by reducing the
> number of receive queues.
> But then you never know until you try :-)
>=20
> The alternative would indeed be to move to MC/S with block-mq; that
> should give you some benefits as you'd be able to utilize several que=
ues.
> I have actually discussed that with Emulex; moving to MC/S in the iSC=
SI
> stack might indeed be viable when using blk-mq. It would be a rather
> good match with the existing blk-mq implementation, and most of the
> implementation would be in the iSCSI stack, reducing the burden on th=
e
> driver vendors :-)
>=20

I think the mulit session mq stuff would actually just work too. It was
done with hw iscsi in mind.

MC/s might be nicer in their case though. For qla4xxx type of cards,
would all the MC/S stuff be done in firmware, so all you need is a
common interface to expose the connection details and then some common
code to map them to hw queues?

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
